BASEDIR = $(PWD)
INPUTDIR = $(BASEDIR)/articles
OUTPUTDIR = $(BASEDIR)/output
INPUTFILES = $(notdir $(wildcard $(INPUTDIR)/*.adoc))

HTMLOUTPUTFILES = $(addprefix $(OUTPUTDIR)/,$(INPUTFILES:.adoc=.html))
PDFOUTPUTFILES = $(addprefix $(OUTPUTDIR)/,$(INPUTFILES:.adoc=.pdf))
XMLOUTPUTFILES = $(addprefix $(OUTPUTDIR)/,$(INPUTFILES:.adoc=.xml))
EPUBOUTPUTFILES = $(addprefix $(OUTPUTDIR)/,$(INPUTFILES:.adoc=.epub))

html: prepare $(HTMLOUTPUTFILES)
	@echo 'Hecho'

pdf: prepare $(PDFOUTPUTFILES)
	@echo 'Hecho'

docbook: prepare $(XMLOUTPUTFILES)
	@echo 'Hecho'

epub: prepare $(EPUBOUTPUTFILES)
	@echo 'Hecho'

$(OUTPUTDIR)/%.html: $(INPUTDIR)/%.adoc
	asciidoctor -b html5 $< -o $@

$(OUTPUTDIR)/%.pdf: $(INPUTDIR)/%.adoc
	asciidoctor -r asciidoctor-pdf -b pdf $< -o $@

$(OUTPUTDIR)/%.xml: $(INPUTDIR)/%.adoc
	asciidoctor -b docbook5 $< -o $@

$(OUTPUTDIR)/%.epub: $(OUTPUTDIR)/%.xml
	pandoc -f docbook -t epub3 $< -o $@

all: html pdf docbook epub

prepare:
	mkdir -p output

.PHONY: prepare