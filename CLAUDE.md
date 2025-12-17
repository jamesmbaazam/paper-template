# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a reproducible research template for academic papers that integrates R and Julia for analysis with Quarto for rendering publication-quality PDFs. The project uses renv (R) and Project.toml (Julia) for dependency management, and includes CI/CD workflows for automated rendering and spell checking.

## Architecture

**Data Flow**: Raw data (immutable) → Analysis scripts (R/Julia) → Output (figures/tables) → Quarto document → PDF

**Key Components**:
- `paper/index.qmd`: Main Quarto document (currently PLOS template example)
- `paper/index.pdf`: Rendered output (generated in same directory as .qmd)
- `scripts/`: Analysis code organized by language (R/ and julia/)
- `data/raw/`: Immutable source data
- `data/processed/`: Generated/cleaned data (gitignored)
- `output/figures/` and `output/tables/`: Script outputs (gitignored)

**Execution Model**: Quarto runs from project root (`execute-dir: project`), with auto-freeze caching to prevent re-execution of unchanged code blocks. PDFs are rendered in the same directory as the source .qmd file.

## Common Commands

### Rendering
```bash
quarto render paper/index.qmd          # Render paper to PDF
make clean                              # Remove .quarto/ and other build artifacts
```

Output appears in `paper/index.pdf` (same directory as the source file).

### R Dependencies
```bash
Rscript -e "install.packages('renv')"  # Install renv (first time)
Rscript -e "renv::restore()"           # Restore packages from renv.lock
```

In R console:
```r
renv::snapshot()                        # Update renv.lock after adding packages
renv::status()                          # Check project sync status
```

Note: `.Rprofile` automatically activates renv and configures parallel processing with `mc.cores = detectCores() - 1`.

### Julia Dependencies
```bash
julia --project=. -e 'using Pkg; Pkg.instantiate()'  # Install dependencies
julia --project=. -e 'using Pkg; Pkg.add("PackageName")'  # Add package
julia --project=. -e 'using Pkg; Pkg.resolve()'     # Update Manifest.toml
```

**Important**: Project.toml is configured as a Julia project environment (not a package), so it should NOT contain `name`, `uuid`, `authors`, or `version` fields. Only `[deps]` and `[compat]` sections.

### Pre-commit Hooks
```bash
pip install pre-commit
pre-commit install                      # Set up hooks
pre-commit run --all-files              # Run manually
```

Hooks: R styler, JuliaFormatter, spell check (codespell), YAML linting.

## Configuration Details

### Quarto (_quarto.yml)

**Critical settings**:
- No `output-dir` specified - PDFs render in the same directory as the .qmd file
- `execute-dir: project` - Code chunks execute from project root
- `freeze: auto` - Cache execution results
- `engine: knitr` - Default for R chunks (Julia uses IJulia)
- `daemon: false` - Julia daemon disabled for reproducibility

**Knitr defaults** (all code chunks):
- `echo: false` - Hide code in output
- `fig.path: "output/figures/"` - Save figures here
- `dpi: 300`, `dev: "png"` - High-res PNG figures

**Julia execution flags**:
- `--project=@.` - Use local Project.toml
- `--threads=auto` - Auto-detect thread count

### Paper Format

The template includes PLOS journal extension (in `_extensions/quarto-journals/plos/`). The current `paper/index.qmd` uses `format: plos-pdf` as an example.

To use standard article format, change the YAML header in `paper/index.qmd` to use the settings from `_quarto.yml` instead.

### Bibliography

Two .bib files exist:
- `paper/references.bib` - Main bibliography (used in `_quarto.yml`)
- `paper/bibliography.bib` - PLOS-specific (used in PLOS template example)

Citations use citeproc with APA style. PLOS format uses natbib with numeric citations.

### Spell Checking

Custom dictionary in `paper/.wordlist.txt` includes technical terms (ggplot2, tidyverse, DataFrame, YAML, etc.). Update this file to add project-specific terminology.

## CI/CD Workflows

### render.yml
Triggers on push/PR to main (with path filters). Runs on: `paper/`, `scripts/`, `data/`, `_quarto.yml`, `renv.lock`, `Project.toml`, `.Rprofile`, workflow file changes.

**Key steps**:
1. Setup: Quarto, R (with automatic renv caching), Julia 1.12 (with package caching), LaTeX (texlive packages including bibtex-extra)
2. Render: `quarto render paper/index.qmd`
3. Upload artifacts: PDF at `paper/*.pdf` (fails if missing)

**Performance**: R package caching via `r-lib/actions/setup-renv@v2` significantly speeds up builds (typically 5-10x faster after first run). Julia packages are also cached via `julia-actions/cache@v1`.

The workflow also uploads both PDF and TEX files to the `rendered-paper` artifact (30-day retention) for main branch pushes.

### checks.yml
Spell check using aspell with custom wordlist. Warns but doesn't fail on errors. Generates `spelling_errors.txt` artifact.

## Development Workflow

1. Add raw data to `data/raw/` (committed to git)
2. Create analysis scripts in `scripts/R/` or `scripts/julia/`
3. Scripts save outputs to `output/figures/` or `output/tables/` (gitignored)
4. Reference outputs in `paper/index.qmd` code chunks or using file paths
5. Add citations to `paper/references.bib`
6. Render locally: `quarto render paper/index.qmd`
7. Commit and push (pre-commit hooks run automatically)

## Important Notes

- **Julia Project.toml**: Do not add package metadata (`name`, `uuid`, etc.). Keep only `[deps]` and `[compat]` sections. This is a project environment, not a package.
- **Execution directory**: All code chunks run from project root due to `execute-dir: project`, so use paths relative to root (e.g., `data/raw/file.csv`).
- **Figure output**: Knitr saves figures to `output/figures/` automatically. Don't manually specify paths in chunks unless overriding defaults.
- **LaTeX debugging**: `keep-tex: true` preserves .tex files in `paper/` directory alongside the PDF for troubleshooting.
- **PDF location**: Rendered PDFs appear in `paper/index.pdf` (same directory as source), not in a separate output directory. These are gitignored.
- **Parallel processing**: R is pre-configured for parallel processing via `.Rprofile`.
- **Empty directories**: `scripts/R/`, `scripts/julia/`, and `data/raw/` contain only `.gitkeep` files—ready for your code and data.

## Dependencies

**R**: Managed by renv (see `renv.lock`). Core packages include ggplot2, knitr, rmarkdown.

**Julia**: Julia ≥1.12 required. Only JuliaFormatter currently installed (for pre-commit hooks). Add scientific packages as needed.

**System**: Quarto, LaTeX distribution (TeXLive/MacTeX), GNU Make, optionally aspell and pre-commit.
