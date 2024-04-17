{{- /*gotype: go.flow.arcalot.io/pluginsdk.schema.String */ -}}
{{- with .Min }}<tr><th>Minimum length:</th><td>{{ . }}</td></tr>{{ end -}}
{{- with .Max }}<tr><th>Maximum length:</th><td>{{ . }}</td></tr>{{ end -}}
{{- with .Pattern }}<tr><th>Must match pattern:</th><td><code style="white-space: nowrap">{{ .String }}</code></td></tr>{{ end -}}
