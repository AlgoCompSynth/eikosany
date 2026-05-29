# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Codebase Overview

The `eikosany` package is an R package for working with the 1-3-5-7-9-11 Eikosany scale and other harmonic scales. It provides tools for:
- Creating scale tables (CPS - Comma-Preserving Scales)
- Generating chord tables
- Creating keyboard mappings for microtonal synthesizers
- Exporting MIDI files and WAV audio files for chords
- Generating Scala `.scl` files for hardware synthesizers

### Key Concepts

1. **CPS (Comma-Preserving Scales)**: Scales built from harmonic ratios that preserve commas (small intervals)
2. **Eikosany**: A 20-note scale using harmonics 1, 3, 5, 7, 9, 11
3. **Keyboard Mapping**: Converts scale degrees to MIDI note numbers and frequencies
4. **Output Formats**: MIDI, WAV, Scala `.scl` files for hardware synths

### Architecture

The package is structured with R files in the `R/` directory:

- **`cps_functions.R`**: Core functions for creating CPS scales and chord tables
  - `cps_scale_table()`: Creates a scale table from harmonic ratios
  - `cps_chord_table()`: Generates chord tables from scale tables
  - `keyboard_map()`: Creates MIDI keyboard mappings
  - `et_scale_table()`: Creates equal-tempered scale tables
  - `offset_matrix()`: Computes offset matrices for tuning synthesizers

- **`output_functions.R`**: Functions for exporting audio and MIDI
  - `minilogue_xd_scl_file()`: Creates Scala `.scl` files for Korg Minilogue XD
  - `chord_plot()`: Creates visual chord plots using ggplot2
  - `chord_music_object()`: Creates GM music objects for chords
  - `export_music_object()`: Exports music objects to MIDI files
  - `scale_multisample()`: Creates multisample WAV files for synthesizers
  - `chord_WAVs()`: Creates WAV files for chord inversions
  - `chord_synth()`: Synthesizes chords as Wave objects
  - `render_cps_chords()`: Batch renders all chords for a CPS scale

- **`data.R`**: Data sets for note names in various equal temperaments

### Development Setup

This is an R package, so development requires R and the devtools package:

```bash
# Install dependencies
R -e "install.packages(c('devtools', 'roxygen2'))"

# Build and install the package
R -e "devtools::install('.')"

# Run tests
R -e "devtools::test()"

# Run a specific test
R -e "devtools::test('eikosany', filter = 'test_cps_functions.R')"
```

### Common Development Tasks

1. **Building the package**:
   ```bash
   R -e "devtools::document()"
   R -e "devtools::install('.')"
   ```

2. **Running tests**:
   ```bash
   R -e "devtools::test()"
   ```

3. **Checking package**:
   ```bash
   R -e "devtools::check()"
   ```

4. **Building documentation**:
   ```bash
   R -e "devtools::document()"
   ```

### Key Dependencies

- `data.table`: For data manipulation
- `ggplot2`: For visualization
- `pichor`: For piano keyboard plots
- `gm`: For MIDI file generation
- `tuneR`: For audio file I/O
- `seewave`: For audio synthesis

### Important Notes

- The package uses **1-based indexing** for scale degrees (degree 1 is the root)
- MIDI note numbers follow standard conventions (0-127)
- Frequencies are calculated based on MIDI note numbers using the formula: `440 * 2^((n-69)/12)`
- The package includes comprehensive documentation with examples in the R files
