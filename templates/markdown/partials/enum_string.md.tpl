{{- /*gotype: go.flow.arcalot.io/pluginsdk.schema.StringEnum */ -}}
<tr><td colspan="2">
        <details><summary>Values</summary>
            <ul>
                {{- range $value, $display := .ValidValues -}}
                    {{- if $display -}}
                        <li><strong><code style="white-space: nowrap">{{ $value }}</code>:</strong> {{ $display.Name }}</li>
                    {{- else -}}
                        <li><strong><code style="white-space: nowrap">{{ $value }}</code></strong></li>
                    {{- end -}}
                {{- end -}}
            </ul>
        </details>
    </td>
</tr>