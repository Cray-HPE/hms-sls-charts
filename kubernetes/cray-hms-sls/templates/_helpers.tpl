{{/*
Helper function to get the proper image tag
*/}}
{{- define "cray-sls.imageTag" -}}
{{- default "latest" .Values.global.appVersion -}}
{{- end -}}
