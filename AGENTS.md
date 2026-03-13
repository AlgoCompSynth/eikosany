# AGENTS.md - Eikosany Package Development Guidelines

## Table of Contents
1. [Build/Lint/Test Commands](#buildlinttest-commands)
2. [Code Style Guidelines](#code-style-guidelines)
3. [Testing](#testing)
4. [Development Workflow](#development-workflow)
5. [Package-Specific Conventions](#package-specific-conventions)
6. [R Project Configuration](#r-project-configuration)

## Build/Lint/Test Commands

### Build Package
```bash
R CMD build --no-manifest eikosany
```

### Install Package
```bash
R CMD INSTALL eikosany_0.2.0.tar.gz
```

### Build and Install in Development Mode
```bash
Rscript -e "devtools::install()"
```

### Check Package
```bash
R CMD check eikosany_0.2.0.tar.gz
```

### Documentation
```bash
Rscript -e "devtools::document()"
```

### Build Package Documentation (pkgdown)
```bash
Rscript -e "pkgdown::build_site()"
```

### Run Vignettes
```bash
Rscript -e "rmarkdown::render('vignettes/introduction-to-combination-product-sets.Rmd')"
```

### Build and Install Dependencies
```bash
Rscript -e "renv::init()"  # If using renv
Rscript -e "devtools::install(dependencies = TRUE)"
```

## Code Style Guidelines

### General R Style
- Follow the **tidyverse style guide**: https://style.tidyverse.org/
- Use 2 spaces for indentation (as configured in `.Rproj` file)
- Maximum line width: 80 characters
- UTF-8 encoding throughout
- Strip trailing whitespace automatically (as configured in `.Rproj`)

### Imports and Dependencies
- Use explicit `@importFrom` statements with package version requirements
- List all imports at the top of each function
- Use `data.table`, `fractional`, `ggplot2`, `magrittr` as core packages
- Requires R >= 4.2.0

### Function Documentation
- Use roxygen2 documentation format with `@` tags
- Required tags: `@title`, `@name`, `@description`, `@export`, `@param`, `@returns`
- Include `@examples` with `\dontrun{}` wrapper for examples that require user interaction
- Document all parameters with `@param` tags
- Use `@importFrom` for all external dependencies used in the function

### Naming Conventions
- camelCase for function names (e.g., `cps_scale_table`, `keyboard_map`)
- snake_case for variable names (e.g., `scale_table`, `keyboard_map`)
- UPPER_CASE for constants (e.g., `.NN_MIN`, `.EDO_DEGREES`)
- Descriptive names for intermediate variables

### Error Handling
- Use defensive programming: validate inputs at function start
- Use `stop()` for unrecoverable errors with descriptive messages
- Return meaningful error messages with context
- Example pattern:
```r
if (length(keyboard_map$cents) != 128) {
  stop("Keyboard map must have 128 rows!")
}
```

### Constants
- Prefix constants with `.` (e.g., `.NN_MIN`, `.EDO_DEGREES`)
- Define constants at the top of files
- Use constants for magic numbers

### Data Structures
- Use `data.table` for tabular data
- Use `data.table::setkey()` to set keys for fast lookups
- Use list columns for complex nested data

### Mathematical Operations
- Use `data.table::shift()` for accessing previous/next row values
- Use `log2()` and `2 ^` for cent/ratio conversions
- Use `data.table::` prefix for all data.table operations

### Documentation Patterns
- Write detailed `@details` sections explaining complex algorithms
- Use itemized lists for function return values
- Link to related functions with `@seealso`

### Helper Functions
- Prefix helper functions with `.` (e.g., `.ratio2cents`, `.cents2ratio`)
- Keep helper functions in the same file as main functions
- Document helpers with `utils::globalVariables()` if they're not exported

## Testing

### Test Structure
- This package uses manual testing via examples rather than automated testthat
- Test examples are in `@examples` blocks within roxygen comments
- Run examples with `Rscript -e "example(cps_scale_table)"`

### Manuel Testing Workflow
1. Execute function examples in function documentation
2. Verify output matches expected results
3. Test edge cases manually
4. Check forAmy warnings or errors during execution

### Common Test Commands
```bash
# Run examples for a specific function
Rscript -e "example(cps_scale_table)"

# Run all examples in a package
Rscript -e "devtools::run_examples()"

# Check for warnings in all examples
Rscript -e "devtools::check(validate = TRUE)"
```

## Development Workflow

### Step 1: Initial Setup
1. Clone repository
2. Run `Rscript -e "devtools::install()"`
3. Configure IDE with 2-space indentation

### Step 2: Development Cycle
1. Make code changes
2. Run `Rscript -e "devtools::document()"` to update documentation
3. Run `Rscript -e "devtools::install()"` for incremental testing
4. Run examples manually to verify changes

### Step 3: Documentation
- Update vignettes when adding new concepts
- Add examples to function documentation
- Update pkgdown site when API changes occur

### Step 4: Package Building
1. Clean workspace
2. Run `Rscript -e "devtools::document()"`
3. Run `Rscript -e "devtools::build()"`
4. Run `Rscript -e "devtools::check()"` to validate
5. Fix any warnings or errors

## Package-Specific Conventions

### Mathematical Concepts
- Use cents (1/100 semitone) as primary unit for pitches
- MIDI note numbers as primary integer representation
- Scale degrees for theoretical analysis

### Constant Definitions
```r
# MIDI note range
.NN_MIN <- 0
.NN_MAX <- 127
.NN_MIDDLE_C <- 60

# Frequency constants
.FREQ_MIN <- 8.176
.CENTS_MIDDLE_C <- 6000

# Scale constants
.EDO_DEGREES <- 12
```

### Key Terminology
- `note_number`: MIDI note number (0-127)
- `cents`: cents above MIDI note 0
- `freq`: frequency in Hz
- `degree`: scale degree (0-based)
- `ratio`: interval as a ratio of frequencies
- `ratio_frac`: ratio as a string (e.g., "4/3")

### Product Set Representation
- Use colon (`:`) to separate harmonics in chords
- Use tilde (`~`) to indicate subharmonic chords
- Use forward slash (`/`) for mixed harmonic/subharmonic notation

### Vignette Structure
- Use `.Rmd` format for vignettes
- Place in `vignettes/` or `vignettes/articles/`
- Include executable code chunks with results
- Provide mathematical derivations and explanations

## R Project Configuration

The `.Rproj` file contains these key settings:

```yaml
UseSpacesForTab: Yes
NumSpacesForTab: 2
Encoding: UTF-8
StripTrailingWhitespace: Yes
BuildType: Package
PackageUseDevtools: Yes
PackageRoxygenize: rd,collate,namespace,vignette
```

### Roxygen Configuration
- Use markdown mode: `Roxygen: list(markdown = TRUE)`
- RoxygenNote: 7.3.3
- Include `@md` tag for markdown support

### Package Installation Arguments
```bash
--no-multiarch --with-keep.source
```

### Vignette Builder
- Use knitr for vignette rendering
- Set `VignetteBuilder: knitr` in DESCRIPTION

## Dependencies Management

### Core Dependencies
- fractional (>= 0.1.3) - for ratio calculations
- data.table (>= 1.14.8) - for data manipulation
- ggplot2 (>= 3.4.2) - for visualization
- magrittr (>= 2.0.3) - for pipe operator
- gm (>= 1.0.2) - for music generation
- seewave (>= 2.2.1) - for audio processing
- tuneR (>= 1.4.5) - for sound recording

### Suggested Dependencies
- devtools (>= 2.4.5) - for development
- knitr (>= 1.42) - for documentation
- pkgdown (>= 2.0.7) - for website

### Git Submodules
- mikldk/pichor (via Remotes field)

## Documentation Generation

### Roxygen Tags Usage
- `@title`: Function title (1-2 sentence description)
- `@name`: Function name (matches actual function name)
- `@description`: Detailed 1-2 paragraph description
- `@param`: Parameter description (1 sentence)
- `@returns`: Return value description
- `@examples`: Executable examples
- `@seealso`: Related functions
- `@details`: Algorithm explanation
- `@md`: Use markdown formatting

### Example Format
```r
@title
Create CPS Chord Table

@description
Creates a chord table for a combination product set scale based on an 
even number of harmonic factors.

@param scale_table a CPS scale table based on an even number of 
harmonic factors.

@returns a data.table with four columns

@examples
# compute the tetrads of the 1-3-5-7-9-11 Eikosany
eikosany <- cps_scale_table(root_divisor = 33)
print(eikosany_chords <- cps_chord_table(eikosany))

@seealso
[cps_scale_table][cps_scale_table], [keyboard_map][keyboard_map]
```

## Code Organization

### File Structure
- Split code by functionality: `cps_chord_table.R`, `keyboard_map.R`, etc.
- Group related functions in the same file
- Use clear file names

### Function Organization
- Place helper functions before main functions
- Order functions logically: data creation -> transformation -> analysis
- Use `@include` in roxygen for cross-file documentation

### Import Organization
- Group imports by package
- Order imports: R base, then external packages
- Update imports when adding new dependencies

## Error Messages

### Best Practices
- Be specific about what failed
- Include the invalid value when possible
- Suggest fixes when appropriate
- Use conditional logic for different error types

### Examples
```r
# Good: Specific and actionable
if (length(keyboard_map$cents) != 128) {
  stop("Keyboard map must have 128 rows!")
}

# Good: Informs user of invalid input
if (n_harmonics %% 2 == 1) {
  stop("number of harmonic factors must be even!")
}

# Good: Explains the problem and shows valid range
if (degree < 0 || degree >= degrees) {
  stop("degree must be between 0 and", degrees - 1)
}
```

## Vignette Development

### Vignette Structure
1. Theoretical introduction
2. Mathematical derivation
3. Practical example
4. Code demonstration
5. Results visualization

### Common Vignettes
- Introduction to combination product sets
- Tetrads on 37-key synth
- Algorithmic composition examples

### Building Vignettes
```bash
Rscript -e "rmarkdown::render('vignettes/introduction-to-combination-product-sets.Rmd')"
```

### Vignette Validation
1. Render vignette
2. Check for warnings and errors
3. Verify all code chunks execute successfully
4. Confirm outputs are informative

## Version Control

### Commit Messages
- Use clear, descriptive commit messages
- Reference issues when appropriate
- Include "fix:", "feat:", "docs:", etc. prefixes

### Branch Strategy
1. `main` branch: production-ready code
2. Feature branches: for new features
3. Bugfix branches: for issue resolution
4. Documentation branches: for vignette updates

### Changelog Maintenance
- Update NEWS.md with each release
- Include version number, date, and changes
- Categorize by: New features, Bug fixes, Documentation

## Package Documentation Site

### pkgdown Configuration
- Auto-generate API documentation
- Build vignette articles
- Create references
- Generate news page from NEWS.md

### Building Site
```bash
Rscript -e "pkgdown::build_site()"
```

### Deploying Site
- Deploy to GitHub Pages
- Update CNAME record if using custom domain
- Configure GitHub repository settings

## Quality Assurance

### Pre-release Checks
1. Run `R CMD check`
2. Verify all examples execute
3. Check for warnings and notes
4. Test on multiple R versions
5. Confirm dependencies install correctly

### Continuous Integration (if configured)
- Test on R devel, release, oldrel
- Check for package vulnerabilities
- Validate build artifacts
- Run vignette tests

## Resources

### Documentation
- Package website: https://algocompsynth.github.io/eikosany/
- GitHub repository: https://github.com/AlgoCompSynth/eikosany
- Issue tracker: https://github.com/AlgoCompSynth/eikosany/issues

### Mailing Lists
- znmeb@algocompsynth.com (maintainer)

### Related Packages
- fractional: for ratio calculations
- data.table: for data manipulation
- ggplot2: for visualization
- pichor: for musical pitch analysis

This document provides comprehensive guidelines for developing and maintaining the eikosany R package. Follow these conventions to ensure consistency across the codebase.
