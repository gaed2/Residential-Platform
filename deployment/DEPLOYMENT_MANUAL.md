# P2P Deployment on Kubernetes

## Prerequisites

Before the setup, you should have following prerequisites ready

- You should have `kubectl` and `helm` installed
- Your local machine should point to thte created cluster. You can do it by command:

```
gcloud container clusters get-credentials <YOUR_CLUSTER_NAME> --zone <YOUR_ZONE> --project <YOUR_PROJECT>
```

## Initial Setup

### Step 1: Create Namesapce
- All the components should be made in a separate namespace in our cluster

```
kubectl create namespace p2p
```

### Step 2: Create DB Instance secret
```
kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=<PATH_TO_DB_SERVICE_JSON_KEY> --namespace=p2p
```

### Step 3: Ready cluster to fire Helm commands
```
# Create Tiller service account
kubectl create serviceaccount --namespace kube-system tiller

# Create cluster role binding for the created Tiller Service Account
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

# Patch the Tiller deployment
gcloud container clusters describe <CLUSTER_NAME> | grep password
kubectl config set-credentials cluster-admin --username=admin --password=<FROM_ABOVE_COMMAND>
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

# Initialize helm
helm init
```

### Step 4: Setup the rails ecosystem

- *IMPORTANT:* Keep the  environment specific `values.yaml` file in `deployment` folder

- Create the helm release

```
helm install ./deployment --name=p2p-exchange --namespace=p2p
```

## Deploying Changes

### Step 1: Update the docker image

- Create an updated image: `sudo docker build --build-arg devise-secret=<DEVISE-SECRET> .`

- Tag the newly created image: `sudo docker tag <IMAGE_ID> asia.gcr.io/p2pdev-217021/p2p-exchange:<NEW_TAG>`
*NOTE* You can also update the `latest` tag by not passing any NEW_TAG in above command

- Push the image: `sudo docker push asia.gcr.io/p2pdev-217021/p2p-exchange`

### Step 2: Update the helm chart release

- In `values.yaml` file, set `image.tag` value to the image tag pushed in previous step

- update the helm release by command
```
helm upgrade p2p-exchange ./deployment
```
