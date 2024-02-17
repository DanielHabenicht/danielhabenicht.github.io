Most of the time VSCode imports javascript and typescript files with relative paths, for example "../../../module". 

If you don't like that just set these two settings: 

```
"javascript.preferences.importModuleSpecifier": "non-relative",
"typescript.preferences.importModuleSpecifier": "non-relative"

```

It changes the way VSCode handles imports to non relative imports, for example "app/path/to/module"

