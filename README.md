# Filippo Scotti — personal website and CV

Versioned personal website with the full HTML CV at `/cv/` and a private-contact
PDF export workflow.

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

Generated PDFs are written to `output/` and are not committed.

## Publishing

GitHub Pages serves the static site directly from the root of the `main` branch.
The presentation homepage lives at `/`; the complete CV lives at `/cv/`. The
empty `.nojekyll` file disables Jekyll processing.

## Privacy

The public site intentionally contains no direct email. The general location is
public, and professional contact is available through the linked LinkedIn
profile. The PDF builder injects the email from the Git-ignored
`.cv-contact.json` into a temporary HTML file; the email never enters the tracked
GitHub Pages source.
