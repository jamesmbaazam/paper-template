# .Rprofile for paper-template
# This file is run when R starts up

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
