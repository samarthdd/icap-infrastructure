{{/* vim: set filetype=mustache: */}}

{{/*
Define the elkstack.namespace template if set with forceNamespace or .Release.Namespace is set
*/}}
{{- define "elkstack.namespace" -}}
{{- if .Values.forceNamespace -}}
{{ printf "namespace: %s" .Values.forceNamespace }}
{{- else -}}
{{ printf "namespace: %s" .Release.Namespace }}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "kibana.name" -}}
{{- default .Chart.Name .Values.kibana.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kibana.fullname" -}}
{{- if .Values.kibana.fullnameOverride -}}
{{- .Values.kibana.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Release.Name .Values.kibana.nameOverride -}}
{{- printf "%s-%s" $name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "kibana.labels" -}}
app: {{ .Chart.Name }}
release: {{ .Release.Name | quote }}
heritage: {{ .Release.Service }}
{{- if .Values.kibana.labels }}
{{ toYaml .Values.kibana.labels }}
{{- end }}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "elasticsearch.name" -}}
{{- default .Chart.Name .Values.elasticsearch.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.fullname" -}}
{{- $name := default .Chart.Name .Values.elasticsearch.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "elasticsearch.uname" -}}
{{- if empty .Values.elasticsearch.fullnameOverride -}}
{{- if empty .Values.elasticsearch.nameOverride -}}
{{ .Values.elasticsearch.clusterName }}-{{ .Values.elasticsearch.nodeGroup }}
{{- else -}}
{{ .Values.elasticsearch.nameOverride }}-{{ .Values.elasticsearch.nodeGroup }}
{{- end -}}
{{- else -}}
{{ .Values.elasticsearch.fullnameOverride }}
{{- end -}}
{{- end -}}

{{- define "elasticsearch.masterService" -}}
{{- if empty .Values.elasticsearch.masterService -}}
{{- if empty .Values.elasticsearch.fullnameOverride -}}
{{- if empty .Values.elasticsearch.nameOverride -}}
{{ .Values.elasticsearch.clusterName }}-master
{{- else -}}
{{ .Values.elasticsearch.nameOverride }}-master
{{- end -}}
{{- else -}}
{{ .Values.elasticsearch.fullnameOverride }}
{{- end -}}
{{- else -}}
{{ .Values.elasticsearch.masterService }}
{{- end -}}
{{- end -}}

{{- define "elasticsearch.endpoints" -}}
{{- $replicas := int (toString (.Values.elasticsearch.replicas)) }}
{{- $uname := (include "elasticsearch.uname" .) }}
  {{- range $i, $e := untilStep 0 $replicas 1 -}}
{{ $uname }}-{{ $i }},
  {{- end -}}
{{- end -}}

{{- define "elasticsearch.esMajorVersion" -}}
{{- if .Values.elasticsearch.esMajorVersion -}}
{{ .Values.elasticsearch.esMajorVersion }}
{{- else -}}
{{- $version := int (index (.Values.imagestore.elasticsearch.tag | splitList ".") 0) -}}
  {{- if and (contains "elasticsearch/elasticsearch" .Values.imagestore.elasticsearch.repository) (not (eq $version 0)) -}}
{{ $version }}
  {{- else -}}
8
  {{- end -}}
{{- end -}}
{{- end -}}
