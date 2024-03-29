// Package docsgen for docsgen
package docsgen

import (
	"bytes"
	"embed"
	"fmt"
	"html/template"
	"regexp"
	"strings"

	"go.flow.arcalot.io/pluginsdk/schema"
)

//go:embed templates/markdown/*
var markdownTemplates embed.FS

const placeholderStart = "<!-- Autogenerated documentation by arcaflow-docsgen -->"
const placeholderEnd = "<!-- End of autogenerated documentation -->"

var placeholderRe = regexp.MustCompile("(?s)" + regexp.QuoteMeta(placeholderStart) + ".*" + regexp.QuoteMeta(placeholderEnd))

// Generate takes an input markdown file and replaces the following markers with the auto-generated docs:
//
//	<!-- Autogenerated documentation by arcaflow-docsgen -->
//	...
//	<!-- End of autogenerated documentation -->
func Generate(markdownFile []byte, pluginSchema schema.Schema[schema.Step]) ([]byte, error) { //nolint:funlen
	if !placeholderRe.Match(markdownFile) {
		return nil, fmt.Errorf(
			"your Markdown file does not contain a placeholder line, please see the documentation about adding one",
		)
	}

	tpl := template.New("templates/markdown/plugin.md.tpl")
	tpl = tpl.Funcs(template.FuncMap{
		"asObject": func(object any) *schema.ObjectSchema {
			r, ok := object.(*schema.ObjectSchema)
			if !ok {
				p, ok := object.(*schema.PropertySchema)
				if !ok {
					panic(fmt.Errorf("failed to convert %T to ObjectSchema or PropertySchema", object))
				}
				r, ok = p.Type().(*schema.ObjectSchema)
				if !ok {
					panic(fmt.Errorf("failed to convert %T to ObjectSchema or PropertySchema", object))
				}
			}
			return r
		},
		"asScope": func(object any) *schema.ScopeSchema {
			return object.(*schema.ScopeSchema)
		},
		"nl2br": func(input string) string {
			return strings.ReplaceAll(input, "\n", "<br />")
		},
		"prefix": func(input any, prefix string) any {
			switch i := input.(type) {
			case template.HTML:
				return template.HTML(strings.ReplaceAll(string(i), "\n", "\n"+prefix)) //nolint:gosec
			case string:
				return strings.ReplaceAll(i, "\n", "\n"+prefix)
			case *string:
				r := strings.ReplaceAll(*i, "\n", "\n"+prefix)
				return &r
			default:
				panic(fmt.Errorf("invalid input type for 'prefix': %T (%v)", input, input))
			}
		},
		"partial": func(partial string, data any) template.HTML {
			wr := &bytes.Buffer{}
			if err := tpl.ExecuteTemplate(wr, "partials/"+partial+".md.tpl", data); err != nil {
				panic(fmt.Errorf("failed to parse partial %s (%w)", partial, err))
			}
			return template.HTML(wr.String()) //nolint:gosec
		},
		"safeMD": func(input any) any {
			switch i := input.(type) {
			case template.HTML:
				return i
			case string:
				return template.HTML(i) //nolint:gosec
			case *string:
				return template.HTML(*i) //nolint:gosec
			default:
				panic(fmt.Errorf("invalid input type for 'saveMD': %T (%v)", input, input))
			}
		},
	})

	fileContents, err := markdownTemplates.ReadFile("templates/markdown/plugin.md.tpl")
	if err != nil {
		return nil, fmt.Errorf("failed to read base template (%w)", err)
	}
	if tpl, err = tpl.Parse(string(fileContents)); err != nil {
		return nil, fmt.Errorf("failed to parse base template (%w)", err)
	}

	partialFiles, err := markdownTemplates.ReadDir("templates/markdown/partials")
	if err != nil {
		return nil, fmt.Errorf("failed to read built-in partials (%w)", err)
	}
	for _, partial := range partialFiles {
		if partial.IsDir() {
			continue
		}
		fileContents, err := markdownTemplates.ReadFile("templates/markdown/partials/" + partial.Name())
		if err != nil {
			return nil, fmt.Errorf("failed to read partial %s (%w)", partial.Name(), err)
		}
		partialTpl := tpl.New("partials/" + partial.Name())
		if _, err := partialTpl.Parse(string(fileContents)); err != nil {
			return nil, fmt.Errorf("failed to parse partial %s (%w)", partial.Name(), err)
		}
	}

	buf := &bytes.Buffer{}
	if err := tpl.ExecuteTemplate(buf, "templates/markdown/plugin.md.tpl", pluginSchema); err != nil {
		return nil, fmt.Errorf("failed to execute base template (%w)", err)
	}

	return placeholderRe.ReplaceAll(markdownFile, []byte(placeholderStart+"\n"+strings.TrimSpace(buf.String())+"\n"+placeholderEnd)), nil
}
