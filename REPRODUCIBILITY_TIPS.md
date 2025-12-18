# Reproducibility Guide

This guide provides best practices for ensuring your research is computationally reproducible.

## R Version Control

This template uses `.Rversion` to pin the R version for reproducibility.

**Current R version:** See `.Rversion` file

**What happens:** When you start R in this project, `.Rprofile` automatically checks if your R version matches the required version and warns you if there's a mismatch.

**To update the R version requirement:**

```bash
R --version | head -n 1 | awk '{print $3}' > .Rversion
```

## Dependency Management

This template uses `renv` for R package management.

**Lock your dependencies:**

```r
# After installing new packages
renv::snapshot()

# To restore packages (e.g., on a new machine)
renv::restore()
```

**Check synchronization status:**

```r
renv::status()
```

## Random Number Generation

Always set seeds for reproducible random processes:

```r
#| label: set-seed

# Set seed at the beginning of your analysis
set.seed(12345)  # Use a consistent seed for your project
```

**For parallel processing:**

```r
# Use L'Ecuyer-CMRG for parallel-safe RNG
library(parallel)
RNGkind("L'Ecuyer-CMRG")
set.seed(12345)
mc.cores <- getOption("mc.cores", 1L)
```

## Data Provenance

### Document Your Data

Create a `data/README.md` file documenting:
- Data sources and collection dates
- Processing steps applied
- File checksums for verification

### Verify Data Integrity

Use checksums to ensure data hasn't changed:

```bash
# Generate checksums for raw data
shasum -a 256 data/raw/*.csv > data/raw/checksums.txt

# Verify checksums
shasum -a 256 -c data/raw/checksums.txt
```

### Keep Raw Data Immutable

- Store original data in `data/raw/`
- **Never** modify files in `data/raw/`
- Save processed data to `data/processed/`
- Document all processing steps in scripts

## Function Documentation

### Use Roxygen2 for R Functions

If you write custom R functions, document them using Roxygen2 syntax:

```r
#' Calculate summary statistics for a numeric vector
#'
#' @param x A numeric vector
#' @param na.rm Logical; should missing values be removed? Default is TRUE
#' @return A named vector with mean, median, and standard deviation
#' @examples
#' calculate_stats(c(1, 2, 3, 4, 5))
#' @export
calculate_stats <- function(x, na.rm = TRUE) {
  c(
    mean = mean(x, na.rm = na.rm),
    median = median(x, na.rm = na.rm),
    sd = sd(x, na.rm = na.rm)
  )
}
```

**Benefits:**
- Clear parameter descriptions
- Usage examples included
- Easy to generate documentation with `roxygen2::roxygenise()`
- Helps others (and future you) understand your code

## Package Selection

### Choose Well-Maintained Packages

When selecting R packages, prioritize:

**Indicators of good maintenance:**
- Regular updates (check CRAN submission dates)
- Active GitHub repository with recent commits
- Responsive maintainers (check issue tracker)
- Good documentation and vignettes
- Large user base (downloads, GitHub stars)
- Reverse dependencies (other packages use it)

**Check package health:**

```r
# Check when package was last updated
utils::packageDate("package_name")

# View package dependencies
tools::package_dependencies("package_name")
```

**Prefer established packages:**
- Tidyverse ecosystem (`dplyr`, `ggplot2`, `tidyr`)
- [Epiverse TRACE](https://epiverse-trace.r-universe.dev/packages)
- [epiforecasts](https://epiforecasts.io/software.html)
- Imperial [mrc-ide](https://github.com/mrc-ide)
- rOpenSci reviewed packages
- Packages published in peer-reviewed journals (e.g., Journal of Statistical Software)

## Workflow Orchestration

### Use Build Tools for Complex Analyses

For multi-step analyses, use orchestration tools to manage dependencies:

#### GNU Make

Create a `Makefile` to define analysis pipeline:

```makefile
# Makefile
all: paper/index.pdf

# Data processing
data/processed/clean_data.rds: data/raw/data.csv scripts/R/01_clean.R
	Rscript scripts/R/01_clean.R

# Generate figures
output/figures/plot1.png: data/processed/clean_data.rds scripts/R/02_visualize.R
	Rscript scripts/R/02_visualize.R

# Render paper
paper/index.pdf: output/figures/plot1.png paper/index.qmd
	quarto render paper/index.qmd

clean:
	rm -rf output/* data/processed/* paper/index.pdf
```

**Benefits:** Only reruns changed components (incremental builds)

#### targets Package

For R-native workflow management using the same pipeline as the Makefile example:

```r
# _targets.R
library(targets)
source("scripts/R/01_clean.R")    # Load cleaning functions
source("scripts/R/02_visualize.R") # Load plotting functions

list(
  # Read raw data
  tar_target(raw_data, read.csv("data/raw/data.csv")),

  # Clean data (calls function from 01_clean.R)
  tar_target(
    clean_data_file,
    {
      clean_data <- clean_raw_data(raw_data)
      saveRDS(clean_data, "data/processed/clean_data.rds")
      "data/processed/clean_data.rds"
    },
    format = "file"
  ),

  # Generate figure (calls function from 02_visualize.R)
  tar_target(
    plot_file,
    {
      data <- readRDS(clean_data_file)
      create_plot(data, "output/figures/plot1.png")
      "output/figures/plot1.png"
    },
    format = "file"
  ),

  # Render paper
  tar_target(
    report,
    {
      quarto::quarto_render("paper/index.qmd")
      "paper/index.pdf"
    },
    format = "file"
  )
)
```

**Run pipeline:**

```r
targets::tar_make()  # Run entire pipeline
targets::tar_visnetwork()  # Visualize dependencies
```

**Benefits:** R-native, automatic dependency tracking, parallel execution, caching

**Note:** The functions `clean_raw_data()` and `create_plot()` referenced above would be defined in your analysis scripts. Alternatively, you can define functions directly in `_targets.R` or use inline code without separate sourcing.

### Choosing an Orchestration Tool

| Tool | Best For | Learning Curve |
|------|----------|----------------|
| **Quarto freeze** | Single-document analyses | Low |
| **GNU make** | Multi-language pipelines | Medium |
| **targets** | Complex R workflows | Medium-High |
| **Snakemake** | Bioinformatics pipelines | High |

**This template uses Quarto's `freeze: auto`** which caches chunk execution—sufficient for many analyses.

## Computational Environment

### Document Your Environment

The paper template includes `sessionInfo()` in the appendix to record:
- R version
- Package versions
- System information

### Manual Documentation

For more detailed documentation, create a manifest:

```r
# Save complete session information
writeLines(capture.output(sessionInfo()), "session-info.txt")

# Save package citations
writeLines(capture.output(citation()), "package-citations.txt")
```

## Testing Reproducibility

### Local Testing

1. Clone your repository to a new location
2. Follow setup instructions from INSTRUCTIONS.md (or README.md if project-specific)
3. Run `quarto render paper/index.qmd`
4. Compare output with previous version

### CI/CD Testing

The GitHub Actions workflow automatically:
- Uses pinned R version (from `.Rversion`)
- Restores exact package versions (from `renv.lock`)
- Renders the paper in a clean environment

Failed CI runs indicate reproducibility issues.

## Docker for Extreme Reproducibility

For maximum reproducibility, use the provided `Dockerfile`:

```bash
# Build image
docker build -t paper-template .

# Render paper in container
docker run --rm -v $(pwd):/project paper-template
```

This guarantees:
- Exact R version
- Exact system dependencies
- Consistent LaTeX environment

## Common Reproducibility Pitfalls

### ❌ Don't Do This

```r
# Using system time or random processes without seeds
Sys.time()  # Changes every run
sample(1:100)  # Different results each time

# Relative paths that depend on working directory
read.csv("../data/file.csv")  # May break

# Installing packages without version control
install.packages("ggplot2")  # Gets latest version
```

### ✅ Do This Instead

```r
# Use fixed dates or document when time matters
analysis_date <- as.Date("2024-01-15")

# Always set seeds before random operations
set.seed(12345)
sample(1:100)

# Use project-relative paths
read.csv(here::here("data/raw/file.csv"))

# Use renv for package management
renv::install("ggplot2@3.5.0")  # Specific version
renv::snapshot()  # Lock all versions
```

## Checklist for Reproducible Research

Before sharing or publishing:

- [ ] R version documented in `.Rversion`
- [ ] All packages locked with `renv::snapshot()`
- [ ] Seeds set for all random processes
- [ ] Data provenance documented in `data/README.md`
- [ ] Raw data checksums calculated
- [ ] `sessionInfo()` included in paper appendix
- [ ] CI/CD workflow passing
- [ ] Setup instructions (INSTRUCTIONS.md) tested on clean machine
- [ ] Output files match across different systems

## Further Reading

### Comprehensive Guides

- [The Turing Way: Guide for Reproducible Research](https://the-turing-way.netlify.app/reproducible-research/reproducible-research.html) - Community handbook for reproducible data science
- [renv Documentation](https://rstudio.github.io/renv/) - R package dependency management
- [targets Manual](https://books.ropensci.org/targets/) - Function-oriented Make-like workflow management for R

### "Ten Simple Rules" Papers (PLOS Computational Biology)

- [Ten Simple Rules for Reproducible Computational Research](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1003285) (Sandve et al., 2013)
- [Ten Simple Rules for Writing and Sharing Computational Analyses in Jupyter Notebooks](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1007007) (Rule et al., 2019)
- [Ten Simple Rules for Taking Advantage of Git and GitHub](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004947) (Perez-Riverol et al., 2016)
- [Ten Simple Rules for Documenting Scientific Software](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1006561) (Lee, 2018)
- [Ten Simple Rules for Making Research Software More Robust](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005412) (Taschuk & Wilson, 2017)
- [Ten Simple Rules for Quick and Dirty Scientific Programming](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1008549) (List et al., 2021)

### Research Papers & Reports

- [Reproducibility in Science](https://www.nature.com/articles/533452a) (Nature Editorial, 2016)
- [Good Enough Practices in Scientific Computing](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005510) (Wilson et al., 2017)
- [Best Practices for Scientific Computing](https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1001745) (Wilson et al., 2014)

### R-Specific Resources

- [R Packages (2nd ed.)](https://r-pkgs.org/) - Hadley Wickham & Jenny Bryan (includes Roxygen2 documentation)
- [What They Forgot to Teach You About R](https://rstats.wtf/) - Workflow and project management tips
- [rOpenSci Packages Guide](https://devguide.ropensci.org/) - Standards for R package development
