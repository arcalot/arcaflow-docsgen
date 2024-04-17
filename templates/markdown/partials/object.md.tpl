{{- /*gotype: go.flow.arcalot.io/pluginsdk.schema.Object */ -}}
<tr><th>Properties</th><td>
    {{- range $propertyID, $property := .Properties -}}
        <details><summary>{{ $propertyID }} ({{- partial "typename" $property.Type -}})</summary>
        <table style="width:100%"><tbody>
            {{- partial "property" $property -}}
            {{- partial "type" $property.Type -}}
        </tbody></table>
        </details>
    {{- end -}}
</td></tr>
