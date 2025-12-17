# Academic Paper Template

A comprehensive template repository for reproducible research using R and Julia with Quarto for paper writing. This template provides a structured workflow for data analysis, statistical modeling, and academic paper preparation with version control.

## Features

- Unified project structure supporting both R and Julia
- Academic paper writing with Quarto rendered to PDF via LaTeX
- Dependency management with `renv` (R) and `Project.toml` (Julia)
- Automated build system using GNU Make
- Pre-commit hooks for code formatting and quality checks
- CI/CD workflows with GitHub Actions
- Spell checking with custom dictionary support
- Example paper structure with proper citations and cross-references

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

## Prerequisites

### Required Software

- [R](https://www.r-project.org/) (≥ 4.0.0)
- [Julia](https://julialang.org/) (≥ 1.9)
- [Quarto](https://quarto.org/) (latest version)
- [LaTeX](https://www.latex-project.org/) (for PDF rendering)
- [GNU Make](https://www.gnu.org/software/make/)

### Optional Tools

- [pre-commit](https://pre-commit.com/) - for automated code quality checks
- [aspell](http://aspell.net/) - for spell checking

### Installation Commands

**macOS (using Homebrew):**

```bash
brew install r julia quarto make aspell
```

**Ubuntu/Debian:**

```bash
sudo apt-get update
sudo apt-get install r-base julia quarto-cli texlive-full make aspell
```

## Getting Started

### 1. Clone or Use This Template

Click "Use this template" on GitHub or clone directly:

```bash
git clone https://github.com/yourusername/paper-template.git my-research-paper
cd my-research-paper
```

### 2. Install Dependencies

**R dependencies:**

```bash
Rscript -e "install.packages('renv')"
Rscript -e "renv::restore()"
```

**Julia dependencies:**

```bash
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

### 3. Set Up Pre-commit Hooks (Optional)

```bash
pip install pre-commit
pre-commit install
```

### 4. Start Writing

Edit `paper/index.qmd` to write your paper. The template includes example sections, code chunks, and citations to guide you.

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

**Julia dependencies:**

```bash
# Add a package
julia --project=. -e 'using Pkg; Pkg.add("PackageName")'

# Update Manifest.toml
julia --project=. -e 'using Pkg; Pkg.update()'
```

**Important:** `Project.toml` is configured as a Julia **project environment** (not a package). It should only contain `[deps]` and `[compat]` sections. Do not add package metadata like `name`, `uuid`, `authors`, or `version` fields.

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
- Dependencies (`renv.lock`, `Project.toml`, `.Rprofile`)

**Performance optimizations:**
- R package caching via `r-lib/actions/setup-renv@v2` (5-10x speedup after first run)
- Julia package caching via `julia-actions/cache@v1`
- Complete LaTeX support including `texlive-bibtex-extra` for bibliographies

Rendered PDFs are available as artifacts in GitHub Actions. The workflow typically takes 2-3 minutes after caching is established (vs. 10-20 minutes without caching).

### checks.yml
Runs spell checking with aspell using the custom dictionary in `paper/.wordlist.txt`. Generates warnings but doesn't fail the build, with errors saved as artifacts.

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
