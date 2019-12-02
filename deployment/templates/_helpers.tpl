{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "rails-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rails-app.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rails-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{/*
Create a default fully qualified app name.
We truncate at  63 | trimSuffix "-" chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc  63 | trimSuffix "-" -}}
{{- end -}}

{{- define "cloudsql.proxy" }}
- name: cloudsql-proxy
  image: gcr.io/cloudsql-docker/gce-proxy:1.11
  command: ["/cloud_sql_proxy",
            "-instances={{ .Values.db.instance }}=tcp:5432",
            "-credential_file=/secrets/cloudsql/credentials.json"]
  securityContext:
    runAsUser: 2  # non-root user
    allowPrivilegeEscalation: false
  volumeMounts:
    - name: {{ .Values.secret.dbInstance }}
      mountPath: /secrets/cloudsql
      readOnly: true
{{- end }}

{{- define "helpers.list-env-variables"}}
{{- range $key, $val := .Values.env.secret }}
- name: {{ $key }}
  valueFrom:
    secretKeyRef:
      name: app-env-secret
      key: {{ $key }}
{{- end}}
{{- range $key, $val := .Values.env.normal }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end}}
{{- end }}