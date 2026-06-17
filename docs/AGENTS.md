# eikosany

> An “intelligence API” for algorithmic musical composition using Erv
> Wilson’s Combination Product Sets (CPS).

## Overview

`eikosany` is an R package designed to compute the mathematical
structures of unconventional microtonal tuning systems. Based on the
work of theorists like Erv Wilson, it focuses on **Combination Product
Sets (CPS)**—a method of deriving scales from combinations of harmonic
factors.

Rather than serving as a standalone composition tool, `eikosany` is
intended as a set of primitive functions that can be used within an
R-based analysis workflow or by AI agents to assist composers in
exploring and navigating complex microtonal spaces.

## Design Philosophy & Decisions

- **Musical Data as Relational Data:** The package uses `data.table` for
  all primary outputs (scales, intervals, chords). This allows the
  music’s harmonic structure to be queried, filtered, and joined like a
  database, making it ideal for programmatic analysis by AI agents.
- **Precision-First Computation:** To avoid rounding errors common in
  microtonal work, the package maintains calculations as harmonic
  products and ratios (using the `fractional` package) and only converts
  to cents at the final output stage.
- **Decoupled Logic:** There is a strict separation between the
  *definition* of a scale (its harmonic product set) and its
  *implementation* (the mapping to frequencies or MIDI notes), allowing
  the same scale structure to be applied across different periods (e.g.,
  octaves vs. tritaves).

## Quick Reference

| Fact | Detail |
|:---|:---|
| **Project Type** | R Package |
| **Primary Language** | R |
| **Core Dependencies** | `data.table`, `fractional` |
| **Secondary Deps** | `seewave`, `tuneR` |
| **Main Concepts** | Combination Product Sets (CPS), Just Intonation, Microtonality |

## Architecture & Data Flow

The package operates as a linear transformation pipeline:

### 1. Scale Generation (Entry Points)

A scale is first defined by its harmonic components. This results in a
**Scale Table**. \*
[`cps_scale_table()`](https://algocompsynth.github.io/eikosany/reference/cps_scale_table.md):
Generates a table from a list of harmonics and a “choose” number (how
many harmonics per note). \*
[`ps_scale_table()`](https://algocompsynth.github.io/eikosany/reference/ps_scale_table.md):
Creates a table from an explicit set of product definitions. \*
[`et_scale_table()`](https://algocompsynth.github.io/eikosany/reference/et_scale_table.md):
Creates an equal-tempered scale for comparison or specific EDO needs.

### 2. Harmonic Analysis

The Scale Table is passed to analysis functions to derive deeper
structural data: \*
**[`interval_table()`](https://algocompsynth.github.io/eikosany/reference/interval_table.md)**:
Computes a full matrix of intervals (ratios and cents) between every
note in the scale. \*
**[`cps_chord_table()`](https://algocompsynth.github.io/eikosany/reference/cps_chord_table.md)**:
Identifies symmetric harmonic and sub-harmonic chord structures for
scales with an even number of factors.

### 3. implementation Mapping

To transition from theory to sound, the Scale Table can be mapped to
keyboard layouts: \*
**[`keyboard_map()`](https://algocompsynth.github.io/eikosany/reference/keyboard_map.md)**:
Generates a full MIDI 0-127 map including absolute frequencies and scale
degrees. \*
**[`offset_matrix()`](https://algocompsynth.github.io/eikosany/reference/offset_matrix.md)**:
Calculates the cents-deviation from standard 12-TET keys for use in
cents-offset capable synthesizers.

## Technical Details

### Directory Structure

``` text
.
├── DESCRIPTION           # Package metadata & dependencies
├── R/
│   └── cps_functions.R    # Core algorithmic logic and API functions
├── man/                  # Auto-generated documentation
└── tests/                # Validation suites
```

### Key Components

- **`.period_reduce()`**: The core internal function that wraps ratios
  into a specified period (usually an octave).
- **Scale Tables**: `data.table` objects containing:
  - `note_name`: Harmonic product label.
  - `ratio`/`ratio_frac`: Exact mathematical pitch ratios.
  - `ratio_cents`: The pitch expressed in cents.
  - `degree`: The sequential position in the scale.

## Development Workflow

### Common Tasks

- **Building the Package:** Standard R package build process
  ([`devtools::build()`](https://devtools.r-lib.org/reference/build.html)).

- **Running Tests:** Use
  [`devtools::test()`](https://devtools.r-lib.org/reference/test.html)
  to ensure CPS calculations remain accurate across versions.

- **Generating New Scales:**

  ``` r
  # Example: Create a standard Eikosany (1-3-5-7-9-11) with root divisor 33
  eikosany <- cps_scale_table(root_divisor = 33)
  interval_data <- interval_table(eikosany)
  ```

## Important Notes

- **Legacy Hardware:** Previous versions included specific references to
  the Korg Minilogue XD and Dirtywave M8. These are considered legacy;
  use
  [`offset_matrix()`](https://algocompsynth.github.io/eikosany/reference/offset_matrix.md)
  as a general-purpose tool for any synth that supports cents-per-note
  tuning.
- **Complexity:** The most computationally complex parts of the package
  involve the combinatorics in
  [`cps_chord_table()`](https://algocompsynth.github.io/eikosany/reference/cps_chord_table.md).
  Be mindful of “choose” numbers when working with very large sets of
  harmonics.

## Resources

- [Project GitHub](https://github.com/AlgoCompSynth/eikosany)
- [Official Documentation](https://algocompsynth.github.io/eikosany/)
