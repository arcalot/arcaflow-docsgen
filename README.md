# Arcaflow plugin documentation generator

This is a documentation generator for your Arcaflow plugins.

## Getting it

Download it from the [Releases section](https://github.com/arcalot/arcaflow-docsgen/releases). It runs on any modern OS.

## Usage

First, run your plugin and dump your schema into a file. With SDK-based plugins you can do this by running:

```
./yourplugin --schema >schema.yaml
```

Next, update a Markdown file to have a section like this:

```markdown
<!-- Autogenerated documentation by arcaflow-docsgen -->
The text here will be replaced by arcaflow-docsgen
<!-- End of autogenerated documentation -->
```

Finally, run `arcaflow-docsgen`:

```
./arcaflow-docsgen -markdown README.md -schema schema.yaml
```

Done! You now have a fancy GitHub-compatible markdown file with your step input and outputs documented.

## GitHub Actions (and other CI)

If you want to make sure your contributors keep running arcaflow-docsgen and keep the docs updated, you can include the following script in your pipeline (assuming you have arcaflow-docsgen installed):

```bash
#!/bin/bash

arcaflow-docsgen -markdown README.md -schema schema.yaml

git diff >/tmp/arcaflow-docsgen.diff
if [ "$(cat /tmp/arcaflow-docsgen.diff | wc -l)" -ne 0 ]; then
    echo "Please run arcaflow-docsgen to update the documentation."
    exit 1
fi
```
