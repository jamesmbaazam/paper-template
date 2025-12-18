# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

R-based academic paper template using Quarto for reproducible research. Renders to PDF via LaTeX with version-controlled dependencies using renv.

## Quick Commands

### Rendering
```bash
quarto render paper/index.qmd    # Renders to paper/index.pdf
make clean                         # Remove generated files
```

### R Dependencies
```bash
Rscript -e "renv::restore()"      # Install packages from renv.lock
```
In R: `renv::snapshot()` to update renv.lock after adding packages.

### R Version
R version is pinned in `.Rversion` (currently 4.5.1). `.Rprofile` checks version on startup and warns if mismatched.

### Pre-commit Hooks (Optional)
```bash
cp .pre-commit-config.yaml.example .pre-commit-config.yaml
pre-commit install
```

## Architecture

**Data Flow**: `data/raw/` (immutable) → `scripts/R/` → `output/figures|tables/` → `paper/index.qmd` → `paper/index.pdf`

**Key Files**:
- `paper/index.qmd` - Main document (generic article template)
- `paper/references.bib` - Bibliography
- `renv.lock` - R package versions
- `.Rversion` - Required R version
- `_quarto.yml` - Rendering configuration

**Execution**: Quarto runs from project root (`execute-dir: project`). Code chunks use paths relative to project root.

## Configuration

### _quarto.yml
- No `output-dir` - PDFs render alongside source
- `freeze: auto` - Caches execution
- `echo: false` - Hides code by default
- Figures save to `output/figures/`

### .Rprofile
- Checks R version vs `.Rversion`
- Activates renv
- Sets CRAN mirror and parallel cores

## CI/CD

### render.yml
- Triggers on: `paper/`, `scripts/`, `data/`, `_quarto.yml`, `renv.lock`, `.Rprofile` changes
- Uses R 4.5.1 (pinned)
- Automatic renv caching (5-10x speedup)
- Uploads `paper/*.pdf` as artifacts

### checks.yml
- Spell check with `paper/.wordlist.txt`
- Warnings only (non-blocking)

## Important Notes

- **R version**: Must match `.Rversion` for reproducibility
- **Pre-commit**: Optional, copy from `.example` to enable
- **PDF location**: `paper/index.pdf` (gitignored)
- **Figures**: Auto-saved to `output/figures/` via knitr settings
- **LaTeX**: Kept in `paper/` for debugging (`keep-tex: true`)
- **Docker**: Optional `Dockerfile` for extreme reproducibility

## Reproducibility

See `REPRODUCIBILITY.md` for:
- Seed setting guidelines
- Data provenance templates
- Computational environment documentation
- Reproducibility checklist

## Documentation

- `README.md` - Research project documentation (users fill this out for their specific analysis)
- `INSTRUCTIONS.md` - Template setup guide with installation and usage instructions
- `REPRODUCIBILITY.md` - Reproducibility best practices
- `data/README.md` - Data documentation template
