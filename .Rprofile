# .Rprofile for paper-template
# This file is run when R starts up

# Check R version for reproducibility
if (file.exists(".Rversion")) {
  required_version <- trimws(readLines(".Rversion", n = 1))
  current_version <- paste(R.version$major, R.version$minor, sep = ".")

  if (current_version != required_version) {
    warning(
      sprintf(
        "R version mismatch!\n  Required: %s\n  Current:  %s\n  This may affect reproducibility.",
        required_version, current_version
      ),
      immediate. = TRUE
    )
  }
}

# Activate renv for dependency management (if initialized)
if (file.exists("renv/activate.R")) {
  source("renv/activate.R")
}

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Set number of cores for parallel processing
options(mc.cores = max(1L, parallel::detectCores(logical = FALSE) - 1L, na.rm = TRUE))

# Set default ggplot2 theme (if using ggplot2)
# options(ggplot2.discrete.colour = "viridis")
# options(ggplot2.discrete.fill = "viridis")

# Display startup message
if (interactive()) {
  message("Paper template project loaded")
  message("R version: ", R.version.string)
  if (requireNamespace("renv", quietly = TRUE)) {
    message("renv version: ", packageVersion("renv"))
  }
}
