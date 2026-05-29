# Repository Guidelines

## Project Structure & Module Organization

This R package implements tools for algorithmic composition using Erv Wilson's Combination Product Sets (CPS).

```
eikosany/
├── R/
│   ├── cps_functions.R      # Core CPS computation functions
│   ├── output_functions.R   # Audio/visualization output generators
│   └── data.R               # Package data loaders
├── data/                    # Serialized R data objects (.rda)
├── data-raw/                # Data processing scripts
├── man/                     # Generated function documentation
├── vignettes/               # Package tutorials (Rmd format)
└── docs/                    # Built pkgdown website
```

## Build, Test, and Development Commands

| Command | Purpose |
|---------|---------|
| `R CMD build .` | Build the package tarball |
| `R CMD check eikosany_*.tar.gz` | Run full package checks |
| `devtools::load_all()` | Load package in development session |
| `devtools::document()` | Generate roxygen2 documentation |
| `pkgdown::build_site()` | Build package website |
| `quarto render vignettes/*.Rmd` | Render vignette articles |

## Coding Style & Naming Conventions

- **Indentation**: 2 spaces (R default)
- **Function naming**: snake_case with descriptive names (e.g., `cps_scale_table`, `render_cps_chords`)
- **Internal functions**: Prefix with dot (e.g., `.nn2freq`, `.ratio2cents`)
- **Constants**: UPPERCASE with dot prefix for internals (e.g., `.EDO_DEGREES`, `.REF_FREQ`)
- **Documentation**: Use roxygen2 with Markdown (`list(markdown = TRUE)`)
- **Formatting**: Follow tidyverse style guide where applicable

## Testing Guidelines

- Run `devtools::test()` to execute package tests
- Tests should reside in `tests/testthat/` (create if needed)
- Use `testthat` framework for unit tests
- Name test files: `test-<function_group>.R`

## Commit & Pull Request Guidelines

### Commit Messages

Follow the existing pattern: short, imperative lowercase messages.

```
cleanup
rebuild
add analysis results catcher
fix check bugs
doc cleanup
```

### Pull Requests

- Provide a clear description of changes
- Link related issues when applicable
- Ensure `devtools::document()` has been run
- Verify `R CMD check` passes before submitting
- Update vignettes if user-facing behavior changes

## Agent-Specific Instructions

- This is a domain-specific package for microtonal music composition
- Dependencies include `data.table`, `ggplot2`, `fractional`, `gm`, `seewave`, `tuneR`
- The package uses roxygen2 for documentation—always update docs when changing functions
- Vignettes are written in R Markdown and rendered with knitr/quarto
- Data files in `data/` are serialized; source processing scripts are in `data-raw/`
