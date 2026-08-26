.PHONY: pdf serve

pdf:
	./scripts/build-pdf.sh

serve:
	python3 -m http.server 8000
