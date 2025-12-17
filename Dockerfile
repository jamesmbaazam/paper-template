# Dockerfile for reproducible paper rendering
# Based on rocker/verse which includes R, RStudio, tidyverse, and publishing tools

FROM rocker/verse:4.5.1

# Set working directory
WORKDIR /project

# Install Quarto
ARG QUARTO_VERSION=1.6.39
RUN curl -LO https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb && \
    dpkg -i quarto-${QUARTO_VERSION}-linux-amd64.deb && \
    rm quarto-${QUARTO_VERSION}-linux-amd64.deb

# Install additional LaTeX packages
RUN tlmgr install \
    collection-fontsrecommended \
    collection-latexextra \
    collection-bibtexextra

# Install renv for dependency management
RUN R -e "install.packages('renv', repos='https://cloud.r-project.org')"

# Copy renv files first (for Docker layer caching)
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/ renv/

# Restore R package dependencies
RUN R -e "renv::restore()"

# Copy the rest of the project
COPY . .

# Default command: render the paper
CMD ["quarto", "render", "paper/index.qmd"]
