# Academic Paper Template - Setup Guide

> **Note:** This file documents the template setup and installation. For research-specific information about a project using this template, see `README.md`.

A focused, user-friendly template for reproducible research using R with Quarto. This template provides a clean starting point for academic papers with strong reproducibility guarantees through R version pinning, dependency locking, and automated workflows.

## Features

- **Simple & Focused**: R-only template (no multi-language complexity)
- **Reproducible**: R version pinning (`.Rversion`) + dependency locking (`renv`)
- **Well-documented**: Includes reproducibility guide and data documentation templates
- **CI/CD Ready**: Automated rendering with package caching (5-10x speedup)
- **Optional Extras**: Pre-commit hooks, Docker support, spell checking
- **Generic Template**: ~100 line starter (vs 435+ line PLOS example)
- **sessionInfo() Included**: Automatic computational environment documentation

## Directory Structure

```text
paper-template/
├── .github/workflows/    # CI/CD pipelines
├── data/
│   ├── raw/             # Original, immutable data
│   └── processed/       # Cleaned and processed data (gitignored)
├── scripts/
│   ├── R/               # R analysis scripts
│   └── julia/           # Julia analysis scripts
├── output/
│   ├── figures/         # Generated figures (gitignored)
│   └── tables/          # Generated tables (gitignored)
├── paper/
│   ├── index.qmd        # Main paper document
│   ├── index.pdf        # Rendered PDF (gitignored)
│   ├── references.bib   # Bibliography
│   └── .wordlist.txt    # Custom spelling dictionary
├── _quarto.yml          # Quarto configuration
├── Project.toml         # Julia project dependencies
├── renv.lock            # R dependencies lockfile
├── Makefile             # Build automation
├── CLAUDE.md            # AI assistant guidance
└── README.md            # This file
```

## Do You Need This Template?

### ✅ Use This Template If:
- Writing an academic paper with R code/analysis
- Need version control and reproducibility
- Want automated PDF rendering
- Working with collaborators

### ❌ Don't Use This If:
- Simple report (use basic Quarto project)
- No R code needed (use LaTeX or Markdown directly)
- Just exploring R (too much infrastructure)

### Alternatives:
- **Journal-specific formats**: [quarto-journals](https://github.com/quarto-journals/)
- **R package for articles**: [rticles](https://github.com/rstudio/rticles)
- **Simple Quarto project**: `quarto create project default my-paper`

## Prerequisites

### Required (Core Functionality)

- [R](https://www.r-project.org/) 4.5.1 (or version in `.Rversion`)
- [Quarto](https://quarto.org/) (latest version)
- [LaTeX](https://www.latex-project.org/) (TeXLive or MacTeX)

### Optional (Enhanced Features)

- [GNU Make](https://www.gnu.org/software/make/) - build automation
- [Docker](https://www.docker.com/) - containerized reproducibility
- [pre-commit](https://pre-commit.com/) - code quality hooks (copy from `.example`)
- [aspell](http://aspell.net/) - spell checking (CI only)

### Installation Commands

**macOS (using Homebrew):**

```bash
brew install r quarto
brew install --cask mactex  # LaTeX distribution
```

**Ubuntu/Debian:**

```bash
sudo apt-get update
sudo apt-get install r-base quarto-cli texlive-full
```

## Getting Started

### 1. Clone or Use This Template

Click "Use this template" on GitHub or clone directly:

```bash
git clone https://github.com/yourusername/paper-template.git my-research-paper
cd my-research-paper
```

### 2. Install R Dependencies

```bash
Rscript -e "install.packages('renv')"
Rscript -e "renv::restore()"
```

### 3. Start Writing

Edit `paper/index.qmd` to write your paper. The template includes example sections, code chunks, and citations to guide you.

## Quick Start (5 Minutes)

For the impatient:

```bash
# Clone and setup
git clone https://github.com/yourusername/paper-template.git my-paper
cd my-paper

# Install R packages
Rscript -e "install.packages('renv'); renv::restore()"

# Render paper
quarto render paper/index.qmd

# View output
open paper/index.pdf  # macOS
# or xdg-open paper/index.pdf  # Linux
```

Done! Your PDF is in `paper/index.pdf`.

## Documentation

This repository includes `CLAUDE.md`, which provides comprehensive guidance for AI assistants (like Claude Code) working with this codebase. It contains:
- High-level architecture and data flow
- Common development commands
- Configuration details and conventions
- CI/CD workflow patterns
- Important non-obvious implementation details

Human developers may also find this useful for understanding the project structure and workflows.

## Usage

### Building the Paper

Render the paper to PDF:

```bash
quarto render paper/index.qmd
```

The rendered PDF will be `paper/index.pdf` (same directory as the source file).

### Running Analyses

1. Place raw data in `data/raw/`
2. Create analysis scripts in `scripts/R/` or `scripts/julia/`
3. Save processed data to `data/processed/`
4. Save figures to `output/figures/`
5. Save tables to `output/tables/`

### Using R and Julia Code in Quarto

**R code chunk:**

```r
#| label: fig-example
#| fig-cap: "Example figure"

library(ggplot2)
ggplot(data, aes(x, y)) + geom_point()
```

**Julia code chunk:**

```julia
#| label: fig-example-julia
#| fig-cap: "Julia figure"

using Plots
plot(x, y)
```

### Managing Dependencies

**R dependencies (using renv):**

```r
# Install a new package
install.packages("package_name")

# Update renv.lock
renv::snapshot()

# Restore packages
renv::restore()
```


### Using Make (Optional)

The template includes a basic Makefile with examples. Customize it for your workflow:

```bash
make        # Show available targets
make help   # Show detailed help
make clean  # Remove generated files (.quarto/, paper/*.pdf, paper/*.tex)
```

See the Makefile for example recipes you can uncomment or customize.

## Bibliography Management

Add references to `paper/references.bib` in BibTeX format:

```bibtex
@article{author2024,
  title = {Article Title},
  author = {Author, Name},
  year = {2024},
  journal = {Journal Name},
  volume = {1},
  pages = {1--10}
}
```

Cite in text: `[@author2024]` or `@author2024`

## Customization

### Changing Citation Style

Edit `_quarto.yml` to use a different CSL style:

```yaml
csl: https://www.zotero.org/styles/nature
```

Browse styles at [Zotero Style Repository](https://www.zotero.org/styles)

### Changing PDF Formatting

Modify the `format.pdf` section in `_quarto.yml`:

```yaml
format:
  pdf:
    documentclass: article
    fontsize: 12pt
    geometry:
      - margin=1.5in
```

### Adding Custom LaTeX Packages

Edit the `include-in-header` section in `_quarto.yml`.

## CI/CD

This template includes GitHub Actions workflows:

### render.yml
Automatically renders the paper when you push changes to:
- Paper content (`paper/`)
- Analysis scripts (`scripts/`)
- Data files (`data/`)
- Configuration (`_quarto.yml`)
- Dependencies (`renv.lock`, `.Rprofile`)

**Performance optimizations:**
- R package caching via `r-lib/actions/setup-renv@v2` (5-10x speedup after first run)
- R version pinning (4.5.1) for reproducibility
- Complete LaTeX support including `texlive-bibtex-extra` for bibliographies

Rendered PDFs are available as artifacts in GitHub Actions. The workflow typically takes 2-3 minutes after caching is established (vs. 10-20 minutes without caching).

### checks.yml
Runs spell checking with aspell using the custom dictionary in `paper/.wordlist.txt`. Generates warnings but doesn't fail the build, with errors saved as artifacts.

## Docker Support (Optional)

For extreme reproducibility, use Docker:

```bash
# Build image
docker build -t my-paper .

# Render paper in container
docker run --rm -v $(pwd):/project my-paper

# Or run interactively
docker run --rm -it -v $(pwd):/project my-paper bash
```

The Docker image guarantees:
- Exact R version (4.5.1)
- Exact system dependencies
- Consistent LaTeX environment
- Same results across all systems

See `Dockerfile` for details.

## Reproducibility

This template emphasizes computational reproducibility:

- **R Version Pinning**: `.Rversion` file + automatic checking in `.Rprofile`
- **Package Locking**: `renv.lock` with exact versions
- **sessionInfo()**: Automatically included in paper appendix
- **Data Documentation**: Template in `data/README.md`
- **Best Practices Guide**: See `REPRODUCIBILITY.md` for detailed guidance

**Quick reproducibility check:**
```bash
# Verify R version matches
cat .Rversion

# Check package synchronization
Rscript -e "renv::status()"

# Test clean render
make clean && quarto render paper/index.qmd
```

## Contributing

When using this template:

1. Create a new branch for your work
2. Make your changes
3. Pre-commit hooks will automatically format your code
4. Push and create a pull request
5. CI/CD will render the paper and run checks

## License

This template is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Troubleshooting

### Quarto not rendering

Ensure all dependencies are installed:

```bash
quarto check install
```

### R package installation fails

Try updating renv:

```bash
Rscript -e "install.packages('renv', repos='https://cloud.r-project.org')"
Rscript -e "renv::restore()"
```

### Julia packages not found

Instantiate the Julia environment:

```bash
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

### LaTeX errors

Install the full TeXLive distribution:

- macOS: `brew install --cask mactex`
- Ubuntu: `sudo apt-get install texlive-full`

## Resources

- [Quarto Documentation](https://quarto.org/docs/guide/)
- [R for Data Science](https://r4ds.had.co.nz/)
- [Julia Documentation](https://docs.julialang.org/)
- [BibTeX Guide](http://www.bibtex.org/Using/)
- [Pre-commit Hooks](https://pre-commit.com/)

## Citation

If you use this template, please consider citing it:

```bibtex
@misc{papertemplate2025,
  title = {Academic Paper Template},
  author = {Azam, James},
  year = {2025},
  url = {https://github.com/yourusername/paper-template}
}
```
