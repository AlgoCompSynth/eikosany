# eikosany - CLAUDE Guide

## Project Overview

`eikosany` is an R package for algorithmic composition using Erv Wilson's Combination Product Sets (CPS) and the Eikosany (a 20-note scale). The package provides tools for generating scale tables, creating keyboard maps, generating output files for synthesizers, and visualizing chords.

**Key Concepts:**
- **CPS (Combination Product Sets)**: Wilson's method for generating scales by multiplying harmonic factors
- **Eikosany**: A 20-note scale using harmonic factors [1, 3, 5, 7, 9, 11]
- **Equal Temperaments**: Support for 12EDO, 19EDO, 31EDO, and Bohlen-Pierce

## Project Structure

```
eikosany/
├── R/
│   ├── cps_functions.R       # Core CPS generation functions
│   ├── data.R                 # Data sets for note names (12EDO, 19EDO, 31EDO, Bohlen-Pierce)
│   └── output_functions.R    # Output generation (SCL files, plots, HTML)
├── data-raw/
│   └── DATASET.R             # Raw data definitions
├── docs/
│   └── articles/             # Vignettes and documentation
├── man/                      # Roxygen2 documentation
└── tests/                    # Unit tests (if present)
```

## Main Modules

### R/cps_functions.R
Contains helper functions and constants for:
- MIDI note to frequency conversion
- Scale table generation (CPS, ET, prime)
- Keyboard mapping functions
- Offset matrix creation for retuning
- Core helper functions (label conversion, period reduction)

### R/data.R
Defines data sets:
- `edo12_names`: Note names for 12-tone equal temperament
- `edo19_names`: Note names for 19-tone equal temperament
- `edo31_names`: Note names for 31-tone equal temperament
- `bohlen_pierce_et_names`: Note names for Bohlen-Pierce scale

### R/output_functions.R
Output generation functions:
- Scala `.scl` file generation (e.g., `minilogue_xd_scl_file()`)
- Chord plotting on keyboards
- HTML rendering of chord progressions

## Development Workflow

### Running Tests
```r
# Install and run devtools
devtools::install()
testthat::test_dir("tests")
```

### Package Checks
```r
# Run CRAN-style checks
devtools::check()
devtools::check(cran = TRUE)
```

### Building Documentation
```r
# Build and preview documentation
devtools::document()
devtools::build_vignettes()
```

## Common Tasks

### Creating a CPS Scale
```r
# Create the default 1-3-5-7-9-11 Eikosany
eikosany <- cps_scale_table(root_divisor = 33)

# Create an ET scale table
et_table <- et_scale_table(edo = 19, root_divisor = 1)
```

### Generating Keyboard Maps
```r
# Map scale to MIDI notes
keyboard_map <- keyboard_map(eikosany, middle_c_octave = 4)
```

### Creating Offset Matrices
```r
# For scales with ≤12 notes per octave
offset_mat <- offset_matrix(eikosany)
```

### Generating Output Files
```r
# Create Scala file for Korg Minilogue XD
minilogue_xd_scl_file(eikosany, "eikosany.scl")

# Plot a chord
chord_plot(chord, keyboard_map)
```

## R Version Requirements
- Minimum: R >= 4.2.0
- Current package tests may expect R 4.4.2

## Key Dependencies
- `fractional` (>= 0.1.3): Fractional arithmetic
- `data.table` (>= 1.14.8): Data manipulation
- `ggplot2` (>= 3.4.2): Visualization
- `magrittr` (>= 2.0.3): Pipe operations
- `gm` (>= 1.0.2): Audio synthesis
- `seewave` (>= 2.2.1): Audio analysis
- `tuneR` (>= 1.4.5): Audio I/O

## Naming Conventions

- Helper functions start with `.` (e.g., `.EDO_DEGREES`, `.nn2freq()`)
- Public functions use descriptive names (e.g., `cps_scale_table()`, `keyboard_map()`)
- Constants are uppercase with underscores (e.g., `.NOTE_SEP`, `.REF_FREQ`)
- Separator characters:
  - `.` (dot): Notes/products (e.g., "1x3x5")
  - `:` (colon): Chords (e.g., "1:3:5")
  - `/` (slash): Sub-chords (e.g., "1:3:5/7:11")

## Important Constants (in R/cps_functions.R)

- `.EDO_DEGREES = 12`: Standard octave divisions
- `.REF_FREQ = 440`: A4 reference frequency
- `.REF_NN = 69`: MIDI note number for A4
- `.NOTE_SEP = "x"`: Product separator
- `.CHORD_SEP = ":"`: Chord separator
- `.SUBCHORD_SEP = ":/"`: Sub-chord separator

## Contributing Guidelines

1. Read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
2. Create an issue before making changes (even for typos)
3. Follow R package conventions (roxygen2 documentation)
4. Run `devtools::check()` before submitting PR
5. Ensure all tests pass

## References

- **Erv Wilson's CPS Theory**: See `docs/articles/introduction-to-combination-product-sets.md`
- **Scala Scale Format**: https://www.huygens-fokker.org/scala/
- **Package Documentation**: https://algocompsynth.github.io/eikosany/

## Additional Resources

- **Narushima (2019)**: *Microtonality and the Tuning Systems of Erv Wilson*
- **Sethares (1998)**: *Tuning, Timbre, Spectrum, Scale*
- **Partch (1979)**: *Genesis of a Music*