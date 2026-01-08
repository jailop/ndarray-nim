# Documentation

This directory contains the generated API documentation for ndarray-c-nim.

## Files

- **[index.html](index.html)** - Main documentation landing page
- **[ndarray.html](ndarray.html)** - Complete module API reference
- **[theindex.html](theindex.html)** - Alphabetical index of all symbols
- **index.md** - Markdown source for documentation
- **nimdoc.out.css** - Styling for documentation
- **dochack.js** - JavaScript for documentation features

## Viewing Documentation

Open `index.html` in your web browser to view the documentation.

Alternatively, you can view the generated documentation online (if published to GitHub Pages).

## Regenerating Documentation

To regenerate the documentation from source:

```bash
nim doc --project --index:on --outdir:docs ndarray.nim
```

This will generate HTML documentation from the docstrings in `ndarray.nim`.

## Documentation Style

The documentation follows the style of the ndarray-c C library documentation:

- Clear, concise descriptions
- Comprehensive examples
- Organized by functional categories
- Type information for all parameters
- Notes on memory management and usage patterns
