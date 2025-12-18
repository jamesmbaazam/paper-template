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

- [The Turing Way: Guide for Reproducible Research](https://the-turing-way.netlify.app/reproducible-research/reproducible-research.html)
- [renv Documentation](https://rstudio.github.io/renv/)
- [Reproducibility in Science](https://www.nature.com/articles/533452a)
- [Ten Simple Rules for Reproducible Computational Research](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1003285)
