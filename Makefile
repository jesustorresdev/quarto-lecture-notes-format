BASEDIR = $(PWD)
INPUTDIR = $(BASEDIR)/articles
OUTPUTDIR = $(BASEDIR)/output

HTMLOUTPUTDIR = $(OUTPUTDIR)/html
PDFOUTPUTDIR = $(OUTPUTDIR)/pdf
EPUBOUTPUTDIR = $(OUTPUTDIR)/epub

MEDIAINPUTDIR = $(BASEDIR)/media

INPUTFILES = $(notdir $(wildcard $(INPUTDIR)/*.adoc))
HTMLOUTPUTFILES = $(addprefix $(HTMLOUTPUTDIR)/,$(INPUTFILES:.adoc=.html))
PDFOUTPUTFILES = $(addprefix $(PDFOUTPUTDIR)/,$(INPUTFILES:.adoc=.pdf))
EPUBOUTPUTFILES = $(addprefix $(EPUBOUTPUTDIR)/,$(INPUTFILES:.adoc=.epub))

ASCIIDOCTOR_CMD = asciidoctor
ASCIIDOCTOR_OPTS := --require asciidoctor-diagram
ASCIIDOCTOR_OPTS += --require ./lib/macros.rb

html: prepare-html $(HTMLOUTPUTFILES)
	@echo 'Hecho'

pdf: prepare-pdf $(PDFOUTPUTFILES)
	@echo 'Hecho'

epub: prepare-epub $(EPUBOUTPUTFILES)
	@echo 'Hecho'

$(HTMLOUTPUTDIR)/%.html: $(INPUTDIR)/%.adoc
	$(ASCIIDOCTOR_CMD) $(ASCIIDOCTOR_OPTS) --backend html5 $< -o $@

$(PDFOUTPUTDIR)/%.pdf: $(INPUTDIR)/%.adoc
	$(ASCIIDOCTOR_CMD) $(ASCIIDOCTOR_OPTS) --require asciidoctor-pdf --backend pdf $< -o $@

$(EPUBOUTPUTDIR)/%.epub: $(INPUTDIR)/%.adoc
	$(ASCIIDOCTOR_CMD) $(ASCIIDOCTOR_OPTS) --require asciidoctor-epub3 --backend epub3 $< -o $@

all: html pdf epub

prepare-html:
	@mkdir --parents $(HTMLOUTPUTDIR)
	cp --remove-destination --link --recursive $(MEDIAINPUTDIR) $(OUTPUTDIR)

prepare-pdf:
	@mkdir -p $(PDFOUTPUTDIR)

prepare-epub:
	@mkdir -p $(EPUBOUTPUTDIR)

.PHONY: prepare