BASEDIR = $(PWD)
INPUTDIR = $(BASEDIR)/articles
OUTPUTDIR = $(BASEDIR)/output
INPUTFILES = $(notdir $(wildcard $(INPUTDIR)/*.adoc))

HTMLOUTPUTFILES = $(addprefix $(OUTPUTDIR)/,$(INPUTFILES:.adoc=.html))
PDFOUTPUTFILES = $(addprefix $(OUTPUTDIR)/,$(INPUTFILES:.adoc=.pdf))
EPUBOUTPUTFILES = $(addprefix $(OUTPUTDIR)/,$(INPUTFILES:.adoc=.epub))

html: prepare $(HTMLOUTPUTFILES)
	@echo 'Hecho'

pdf: prepare $(PDFOUTPUTFILES)
	@echo 'Hecho'

epub: prepare $(EPUBOUTPUTFILES)
	@echo 'Hecho'

$(OUTPUTDIR)/%.html: $(INPUTDIR)/%.adoc
	asciidoctor -b html5 $< -o $@

$(OUTPUTDIR)/%.pdf: $(INPUTDIR)/%.adoc
	asciidoctor -r asciidoctor-pdf -b pdf $< -o $@

$(OUTPUTDIR)/%.epub: $(INPUTDIR)/%.adoc
	asciidoctor -r asciidoctor-epub3 -b epub3 $< -o $@

all: html pdf epub

prepare:
	mkdir -p output

.PHONY: prepare