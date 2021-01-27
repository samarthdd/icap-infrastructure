{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "icap-file-drop.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "icap-file-drop.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create unified labels for icap-file-drop components
*/}}
{{- define "icap-file-drop.common.matchLabels" -}}
app: {{ template "icap-file-drop.name" . }}
release: {{ .Release.Name }}
{{- end -}}

{{- define "icap-file-drop.common.metaLabels" -}}
chart: {{ template "icap-file-drop.chart" . }}
heritage: {{ .Release.Service }}
{{- end -}}

{{- define "policy-management-api.labels" -}}
{{ include "policy-management-api.matchLabels" . }}
{{ include "icap-file-drop.common.metaLabels" . }}
{{- end -}}

{{- define "policy-management-api.matchLabels" -}}
component: {{ .Values.policymanagementapi.name | quote }}
{{ include "icap-file-drop.common.matchLabels" . }}
{{- end -}}

{{- define "transactionqueryaggregator.labels" -}}
{{ include "transactionqueryaggregator.matchLabels" . }}
{{ include "icap-file-drop.common.metaLabels" . }}
{{- end -}}

{{- define "transactionqueryaggregator.matchLabels" -}}
component: {{ .Values.transactionqueryaggregator.name | quote }}
{{ include "icap-file-drop.common.matchLabels" . }}
{{- end -}}

{{- define "nginx.labels" -}}
{{ include "nginx.matchLabels" . }}
{{ include "icap-file-drop.common.metaLabels" . }}
{{- end -}}

{{- define "nginx.matchLabels" -}}
component: {{ .Values.nginx.name | quote }}
{{ include "icap-file-drop.common.matchLabels" . }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "icap-file-drop.fullname" -}}
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
Create a fully qualified policy-management-api name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{- define "policy-management-api.fullname" -}}
{{- if .Values.policymanagementapi.fullnameOverride -}}
{{- .Values.policymanagementapi.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.policymanagementapi.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.policymanagementapi.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified transactionqueryaggregator name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{- define "transactionqueryaggregator.fullname" -}}
{{- if .Values.transactionqueryaggregator.fullnameOverride -}}
{{- .Values.transactionqueryaggregator.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.transactionqueryaggregator.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.transactionqueryaggregator.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Create a fully qualified nginx name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{- define "nginx.fullname" -}}
{{- if .Values.nginx.fullnameOverride -}}
{{- .Values.nginx.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.nginx.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.nginx.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}