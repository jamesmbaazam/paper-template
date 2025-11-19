# Basic Makefile template for paper-template project
# For more on Makefiles: https://www.gnu.org/software/make/manual/make.html

# Phony targets (targets that don't represent files)
.PHONY: all clean help

# Default target - runs when you type 'make' with no arguments
all:
	@echo "Available targets: all, clean, help"
	@echo "Run 'make help' for more information"

# Help - displays available targets and their descriptions
help:
	@echo "Makefile targets:"
	@echo "  make all    - Show this message"
	@echo "  make clean  - Remove generated files"
	@echo "  make help   - Show detailed help"
	@echo ""
	@echo "Add your own recipes below following this pattern:"
	@echo "  target: dependencies"
	@echo "  	command to execute"

# Clean - remove generated files and caches
clean:
	@echo "Cleaning generated files..."
	rm -rf _output/
	rm -rf .quarto/

# ============================================================================
# Add your custom recipes below this line
# ============================================================================

# Example: Render the paper
# render:
# 	quarto render paper/index.qmd

# Example: Install dependencies
# install:
# 	Rscript -e "renv::restore()"
# 	julia --project=. -e 'using Pkg; Pkg.instantiate()'

# Example: Run analysis scripts
# analyze:
# 	Rscript scripts/R/analysis.R
# 	julia --project=. scripts/julia/analysis.jl
