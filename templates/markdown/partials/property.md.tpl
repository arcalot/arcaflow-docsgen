{{- with .Display -}}
    {{- with .Name -}}
        <tr width=600><th>Name:</th><td>{{ . }}</td></tr>
    {{- end -}}
    {{- with .Description -}}
        <tr><th>Description:</th><td width="500">{{ . }}</td></tr>
    {{- end -}}
{{- end -}}
<tr width=600><th>Required:</th><td>{{- if .Required }}Yes{{ else }}No{{ end }}</td></tr>
{{- with .Default }}<tr width=600><th>Default (JSON encoded):</th><td><pre><code>{{ . }}</code></pre></td></tr>{{ end -}}
{{- with .RequiredIf }}<tr width=600><th>Required if the following fields are set:</th><td>
{{- $first := true -}}
{{- range . -}}
    {{- if $first -}}
        {{- $first = false -}}
    {{- else -}}, {{ end -}}
    {{ . -}}
{{- end }}</td></tr>{{ end -}}
{{- with .RequiredIfNot }}<tr width=600><th>Required if the following fields are not set:</th><td>
{{- $first := true -}}
{{- range . -}}
    {{- if $first -}}
        {{- $first = false -}}
    {{- else -}}, {{ end -}}
    {{ . -}}
{{- end }}</td></tr>{{ end -}}
{{- with .Conflicts }}<tr width=600><th>Conflicts the following fields:</th><td>
{{- $first := true -}}
{{- range . -}}
    {{- if $first -}}
        {{- $first = false -}}
    {{- else -}}, {{ end -}}
    {{ . -}}
{{- end }}</td></tr>{{ end -}}
{{- with .Examples }}<tr width=600><th>Examples (JSON encoded):</th><td>
{{ range . }}<pre><code>{{ . }}</code></pre>{{ end }}
</td></tr>{{ end -}}