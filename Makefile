MMARK := mmark
TXT := $(patsubst %.md,%.txt,$(wildcard *.md))
XML := $(patsubst %.md,%.xml,$(wildcard *.md))
HTML := $(patsubst %.md,%.html,$(wildcard *.md))
PDF := $(patsubst %.md,%.pdf,$(wildcard *.md))

all: $(TXT) $(HTML)

txt: $(TXT)

%.txt: %.xml
	xml2rfc --verbose --no-network --cache /app/rfc/cache --text --v3 docs/$<

html: $(HTML)

%.html: %.xml
	xml2rfc --verbose --no-network --cache /app/rfc/cache --html --v3 docs/$<

xml: $(XML)

%.xml: %.md
	$(MMARK) $< > docs/$(basename $<).xml

pdf: $(PDF)

%.pdf: %.xml
	xml2rfc --verbose --no-network --cache /app/rfc/cache --pdf --v3 docs/$<

.PHONY: clean
clean:
	rm -f docs/*.txt docs/*.xml docs/*.html docs/*.pdf