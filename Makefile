.PHONY: all clean render install help check-spelling

# Default target
all: render

## help: Show this help message
help:
	@echo "Available targets:"
	@echo "  all             - Render the paper (default)"
	@echo "  render          - Render the Quarto paper to PDF"
	@echo "  install         - Install R and Julia dependencies"
	@echo "  install-r       - Install R dependencies using renv"
	@echo "  install-julia   - Install Julia dependencies"
	@echo "  clean           - Remove generated files"
	@echo "  clean-all       - Remove all generated files including caches"
	@echo "  check-spelling  - Check spelling in paper"
	@echo "  help            - Show this help message"

## render: Render the paper
render:
	quarto render paper/index.qmd

## install: Install all dependencies
install: install-r install-julia

## install-r: Install R dependencies
install-r:
	Rscript -e "if (!requireNamespace('renv', quietly = TRUE)) install.packages('renv')"
	Rscript -e "renv::restore()"

## install-julia: Install Julia dependencies
install-julia:
	julia --project=. -e 'using Pkg; Pkg.instantiate()'

## clean: Remove generated output files
clean:
	rm -rf _output/
	rm -rf output/figures/*
	rm -rf output/tables/*
	rm -rf paper/*.pdf
	rm -rf paper/*.tex
	rm -rf paper/*_files/
	find . -type f -name "*.aux" -delete
	find . -type f -name "*.log" -delete
	find . -type f -name "*.out" -delete
	find . -type f -name "*.synctex.gz" -delete

## clean-all: Remove all generated files including caches
clean-all: clean
	rm -rf .quarto/
	rm -rf _freeze/
	rm -rf *_cache/

## check-spelling: Check spelling in paper
check-spelling:
	@echo "Checking spelling in paper files..."
	@if command -v aspell >/dev/null 2>&1; then \
		aspell --lang=en --mode=tex --personal=./paper/.wordlist.txt list < paper/index.qmd | sort | uniq; \
	else \
		echo "aspell not found. Install with: brew install aspell (macOS) or apt-get install aspell (Linux)"; \
	fi
