BASEDIR = $(PWD)
INPUTDIR = $(BASEDIR)/articles
OUTPUTDIR = $(BASEDIR)/output
INPUTFILES = $(notdir $(wildcard $(INPUTDIR)/*.adoc))

HTMLOUTPUTFILES = $(addprefix $(OUTPUTDIR)/,$(INPUTFILES:.adoc=.html))
PDFOUTPUTFILES = $(addprefix $(OUTPUTDIR)/,$(INPUTFILES:.adoc=.pdf))
EPUBOUTPUTFILES = $(addprefix $(OUTPUTDIR)/,$(INPUTFILES:.adoc=.epub))

ASCIIDOCTOR_CMD = "asciidoctor -r asciidoctor-diagram

# TODO: Copiar las imágenes y asegurar los enlaces correctos en output.

html: prepare $(HTMLOUTPUTFILES)
	@echo 'Hecho'

pdf: prepare $(PDFOUTPUTFILES)
	@echo 'Hecho'

epub: prepare $(EPUBOUTPUTFILES)
	@echo 'Hecho'

$(OUTPUTDIR)/%.html: $(INPUTDIR)/%.adoc
	$(ASCIIDOCTOR_CMD) -b html5 $< -o $@

$(OUTPUTDIR)/%.pdf: $(INPUTDIR)/%.adoc
	$(ASCIIDOCTOR_CMD) -r asciidoctor-pdf -b pdf $< -o $@

$(OUTPUTDIR)/%.epub: $(INPUTDIR)/%.adoc
	$(ASCIIDOCTOR_CMD) -r asciidoctor-epub3 -b epub3 $< -o $@

all: html pdf epub

prepare:
	mkdir -p output

.PHONY: prepare