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
