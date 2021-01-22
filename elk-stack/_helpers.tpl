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