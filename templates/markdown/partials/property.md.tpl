{{- with .Display -}}
    {{- with .Name -}}
        <tr><th>Name:</th><td>{{ . }}</td></tr>
    {{- end -}}
    {{- with .Description -}}
        <tr><th>Description:</th><td>{{ . }}</td></tr>
    {{- end -}}
{{- end -}}
<tr><th>Required:</th><td>{{- if .Required }}Yes{{ else }}No{{ end }}</td></tr>
{{- with .Default }}<tr><th>Default (JSON encoded):</th><td><pre><code style="white-space: nowrap">{{ . }}</code></pre></td></tr>{{ end -}}
{{- with .RequiredIf }}<tr><th>Required if the following fields are set:</th><td>
{{- $first := true -}}
{{- range . -}}
    {{- if $first -}}
        {{- $first = false -}}
    {{- else -}}, {{ end -}}
    {{ . -}}
{{- end }}</td></tr>{{ end -}}
{{- with .RequiredIfNot }}<tr><th>Required if the following fields are not set:</th><td>
{{- $first := true -}}
{{- range . -}}
    {{- if $first -}}
        {{- $first = false -}}
    {{- else -}}, {{ end -}}
    {{ . -}}
{{- end }}</td></tr>{{ end -}}
{{- with .Conflicts }}<tr><th>Conflicts the following fields:</th><td>
{{- $first := true -}}
{{- range . -}}
    {{- if $first -}}
        {{- $first = false -}}
    {{- else -}}, {{ end -}}
    {{ . -}}
{{- end }}</td></tr>{{ end -}}
{{- with .Examples }}<tr><th>Examples (JSON encoded):</th><td>
{{ range . }}<pre><code style="white-space: nowrap">{{ . }}</code></pre>{{ end }}
</td></tr>{{ end -}}
