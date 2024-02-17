https://pypi.org/project/mkdocs-with-pdf/

Better than:
https://github.com/comwes/mkpdfs-mkdocs-plugin

```Dockerfile
FROM squidfunk/mkdocs-material

# Install everything that is needed for mkdocs-with-pdf
ARG weasyprint_version=52.5
RUN apk add -u cairo cairo-gobject pango gdk-pixbuf py3-brotli py3-lxml py3-cffi py3-pillow msttcorefonts-installer fontconfig zopfli py3-pip py3-pillow py3-cffi py3-brotli gcc musl-dev python3-dev pango py3-pip gcc musl-dev python3-dev pango zlib-dev jpeg-dev openjpeg-dev g++ libffi-dev \
	&& update-ms-fonts && fc-cache -f
RUN pip install weasyprint==$weasyprint_version mkdocs-with-pdf

```

Add custom CSS (https://github.com/orzih/mkdocs-with-pdf/issues/119)

```
:root > * {
	--md-primary-fg-color: #e20074;
	--md-primary-fg-color--light: #ecb7b7;
	--md-primary-fg-color--dark: #9e0051;
}

#doc-toc * {
	border-color: var(--md-primary-fg-color) !important;
}

article h1,
article h2,
article h3 {
	border-color: var(--md-primary-fg-color) !important;
}

```

Build the documentation by running the following commands:

```bash
# Development (serving the documentation)
docker-compose up

# Build the docs to ./site
docker-compose run --rm mkdocs build
```

Referenz für Formatierung: https://squidfunk.github.io/mkdocs-material/reference/

```
site_name: My Docs
theme:
  name: material
  logo: assets/logo.png
site_author: Me
extra_css:
  - custom.css
plugins:
  # Using https://github.com/orzih/mkdocs-with-pdf
    - with-pdf:
        author: ''
        cover_title: Tool
        cover_subtitle: Dokumentation für
        cover_logo: docs/assets/logo_claim.png
        # debug_html: true
markdown_extensions:
  - admonition
  - pymdownx.details
  - pymdownx.superfences
  - attr_list
  - md_in_html

copyright: '© 2024 DanielHabenicht'
```

```
version: "3.9"
services:
  mkdocs:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - .:/docs
```
