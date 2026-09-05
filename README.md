# Filippo Scotti — personal website and CV

Versioned personal website with the full HTML CV at `/cv/` and a downloadable
PDF containing direct contact details.

Live site: <https://fpiped.github.io/>

## Edit

Update the homepage in `index.html` and `styles.css`. The canonical CV source is
`cv/index.html`, with print and screen rules in `cv/styles.css`.

## Preview

Open `index.html` directly in a browser, or run:

```bash
make serve
```

Then visit `http://localhost:8000`.

## Generate PDF

Create the local, untracked contact file once:

```bash
cp .cv-contact.example.json .cv-contact.json
```

Replace the example value with the email to include in the PDF, then run:

```bash
make pdf
```

The default output is `output/filippo-scotti-cv.pdf`.

The PDF script uses a locally installed Chromium-compatible browser. If it is
not installed in a standard location, set `BROWSER`:

```bash
BROWSER="/path/to/browser" ./scripts/build-pdf.sh
```

The default local PDF is written to `output/` and is not committed. To refresh
the public download after editing the CV, run:

```bash
./scripts/build-pdf.sh cv/filippo-scotti-cv.pdf
```

## Publishing

GitHub Pages serves the static site directly from the root of the `main` branch.
The presentation homepage lives at `/`; the HTML CV lives at `/cv/`; and the
homepage downloads `/cv/filippo-scotti-cv.pdf`. The empty `.nojekyll` file
disables Jekyll processing.

## Privacy

The public HTML intentionally contains no direct email. The general location is
public. The downloadable PDF intentionally includes the email injected from the
Git-ignored `.cv-contact.json`; therefore the address is public only inside the
downloadable document, not in the rendered or indexed HTML.
