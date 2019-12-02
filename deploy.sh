#!/bin/bash

print_help() {
echo "
\033[1mSynopsis:\033[0m
sh deploy.sh [--help] --repo=REPO --deployment=DEPLOYMENT [--tag=TAG]
      [--values=VALUES_FILE_PATH] [--helm=HELM_CHART_PATH]

\033[1mDescription:\033[0m
This script is used to create the latest docker image and deploy it on kubernetes cluster

\033[1mArguments:\033[0m
  1) --repo       :  \033[0;34m*Required\033[0m Docker container registry where the image is to be pushed
  2) --deployment :  \033[0;34m*Required\033[0m Helm deployment name to be upgraded
  3) --tag        :  Tag of the new docker image (Default: 'latest')
  4) --values     :  Path of values.yaml file for helm deployment (Default: './deployment/values.yaml')
  5) --helm       :  Path of the helm chart to deploy (Default: './deployment')

\033[1mExample:\033[0m
sh deploy.sh --tag=1.0.3 --repo=gcr.io/projectX/image-xyz --deployment=xyz-deployment --values=./staging-values.yaml

"
exit 0
}

# Parse Command Line Arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --tag=*)
      TAG="${1#*=}"
      ;;
    --repo=*)
      REPO="${1#*=}"
      ;;
    --deployment=*)
    HELM_DEPOYMENT="${1#*=}"
      ;;
    --values=*)
    VALUES_FILE="${1#*=}"
      ;;
    --helm=*)
    HELM_CHART="${1#*=}"
      ;;
    --help) print_help;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid arguments.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done


VALUES_FILE="${VALUES_FILE:-./deployment/values.yaml}"
HELM_CHART="${HELM_CHART:-./deployment}"


echo "=== 1/3 BUILDING DOCKER IMAGE ===="
DEVISE_SECRET="$(cat $VALUES_FILE | grep DEVISE_SECRET | awk '{print $2}')"
COMMIT_SHA="$(git rev-parse HEAD)"
COMMIT_MSG="$(git log -1 --pretty=%B)"
sudo docker build --build-arg devise-secret=$DEVISE_SECRET . --label "commit_sha=$COMMIT_SHA" --label "commit_msg=$COMMIT_MSG"
IMAGE_ID="$(sudo docker images -f label=commit_sha=$COMMIT_SHA | head -n 2 | tail -n 1 | awk '{print $3}')"
echo Succesfully built image $IMAGE_ID
sudo docker tag $IMAGE_ID $REPO:$TAG

echo "=== 2/3 PUSHING DOCKER IMAGE ===="
sudo docker push $REPO:$TAG
line_number="$(cat $VALUES_FILE | grep -n tag: | awk '{print $1}' | sed 's/://')"
cmd="${line_number}s/.*/  tag: ${TAG}/"
sed -i "$cmd" "$VALUES_FILE"

echo "=== 3/3 DEPLOYING PUSHED IMAGE ===="
helm upgrade "$HELM_DEPOYMENT" "$HELM_CHART" -f "$VALUES_FILE"

GR='\033[0;32m'
NC='\033[0m'
echo "
${GR}
   _____
  / ____|
 | (___  _   _  ___ ___ ___  ___ ___
  \___ \| | | |/ __/ __/ _ \/ __/ __|
  ____) | |_| | (_| (_|  __/\__ \__ \\
 |_____/ \__,_|\___\___\___||___/___/

==== DEPLOYMENT DONE ====
"

echo "\nCheck the status of pods by command: 'kubectl get po --namespace=NAMESPACE' ${NC}\n"
