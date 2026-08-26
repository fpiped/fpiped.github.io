# Filippo Scotti CV

Versioned HTML CV with a printable stylesheet and a small PDF export script.

Live site: <https://fpiped.github.io/>

## Edit

Update the content in `index.html` and the visual rules in `styles.css`.

## Preview

Open `index.html` directly in a browser, or run:

```bash
make serve
```

Then visit `http://localhost:8000`.

## Generate PDF

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

GitHub Pages serves the static site directly from the root of the `main`
branch. The empty `.nojekyll` file disables Jekyll processing.

## Privacy

The public site intentionally contains no direct email address or phone number.
Professional contact is available through the linked LinkedIn profile.
