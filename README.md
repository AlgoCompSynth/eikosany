# eikosany - Algorithmic Composition with Erv Wilson's Combination Product Sets

[![CRAN](https://www.r-pkg.org/badges/version/eikosany)](https://CRAN.R-project.org/package=eikosany)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![R](https://img.shields.io/badge/R-%3E%3D4.0.0-blue.svg)](https://cran.r-project.org/package=eikosany)

## Overview

`eikosany` is an R package of tools for algorithmic composition with Erv Wilson's Combination Product Sets (CPS). It's meant to complement other microtonal composition tools, not replace any of them.

An *Eikosany* is a 20-note scale derived by Erv Wilson from six harmonic factors. Although any six factors can be used, the most commonly encountered Eikosany uses the first six odd numbers: 1, 3, 5, 7, 9 and 11.

## Installation

Install from CRAN:

```r
install.packages("eikosany")
```

Install the development version from GitHub:

```r
# Install devtools if not already installed
install.packages("devtools")

# Install eikosany
devtools::install_github("AlgoCompSynth/eikosany", dependencies = TRUE)
```

## Quick Start

Create a CPS scale table and generate a keyboard map:

```r
library(eikosany)

# Create the 1-3-5-7-9-11 Eikosany (default)
eikosany <- cps_scale_table(root_divisor = 33)

# Generate a keyboard map for MIDI note numbers 0-127
keyboard_map <- keyboard_map(eikosany, middle_c_octave = 4)

# View the first few entries
head(keyboard_map)
```

## Key Features

### Scale Table Functions

- `cps_scale_table()`: Create Combination Product Set scales from harmonic factors
- `et_scale_table()`: Create equal-tempered scale tables
- `ps_scale_table()`: Create prime scale tables (using prime numbers)

### Keyboard Mapping

- `keyboard_map()`: Map scale degrees to MIDI note numbers
- `offset_matrix()`: Create offset matrices for scales with ≤12 notes per octave

### Output Generation

- `minilogue_xd_scl_file()`: Generate Scala `.scl` files for Korg Minilogue XD
- `chord_plot()`: Visualize chords on a keyboard layout
- `render_cps_chords()`: Render CPS chord progressions as HTML

###是他的音乐结构

- `cps_chord_table()`: Generate chord tables from CPS scales
- `interval_table()`: Create interval tables for analyzing scales

## Package Structure

```
eikosany/
├── R/
│   ├── cps_functions.R       # Core CPS generation functions
│   ├── data.R                 # Data sets (12EDO, 19EDO, 31EDO, Bohlen-Pierce)
│   └── output_functions.R    # Output generation (SCL files, plots)
├── man/                      # Roxygen2 documentation
├── vignettes/
│   └── articles/
│       ├── introduction-to-combination-product-sets.html
│       ├── tuning-the-korg-minilogue-xd-to-the-eikosany.html
│       └── tetrads-on-37-key-synth.html
└── README.md
```

## Supported Equal Temperaments

The package includes pre-configured note names for common equal temperaments:

- **12EDO** (standard equal temperament)
- **19EDO** (19-tone equal temperament)
- **31EDO** (31-tone equal temperament)
- **Bohlen-Pierce** (13-tone equal temperament)

## Citation

If you use this package in your research, please cite:

```r
citation("eikosany")
```

This will display BibTeX citation information for the package.

## Contributing

Contributing to the project is really quite simple:

1. Read the code of conduct at [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
2. Everything starts with an issue. See [Always start with an issue](https://about.gitlab.com/blog/start-with-an-issue/) for the philosophy.
    * Is the documentation unclear? [File an issue](https://github.com/AlgoCompSynth/eikosany/issues/new).
    * Did you find a bug? [File an issue](https://github.com/AlgoCompSynth/eikosany/issues/new).
    * Do you want to request a feature? [File an issue](https://github.com/AlgoCompSynth/eikosany/issues/new).

*Please, don't go through the mechanics of forking / pull requests even for trivial typo changes without filing an issue. [File an issue](https://github.com/AlgoCompSynth/eikosany/issues/new).*

## Project Status

### Roadmap

The project has undergone significant development and is in an active maintenance phase. Key areas of focus include:

1. **Documentation**: Comprehensive vignettes and examples
2. **Testing**: Unit tests for core functions
3. **CRAN Integration**: Full CRAN compliance and package checks

### Developer Notes

- The package uses R 4.0.0+ as a minimum version
- It relies on standard R packages (data.table, ggplot2, magrittr)
- All functions use roxygen2 for documentation generation

## See Also

For more information on microtonal music and CPS theory:

- [Scala](https://www.huygens-fokker.org/scala/) - Musical scale file format and tools
- [Sevish's Scale Workshop](https://sevish.com/scaleworkshop/guide.htm) - Web-based scale tools
- [Narushima (2019)](https://doi.org/10.4324/9780429324189) - *Microtonality and the Tuning Systems of Erv Wilson*
- [Sethares (1998)](https://link.springer.com/book/10.1007/978-1-4612-0705-8) - *Tuning, Timbre, Spectrum, Scale*

## License

MIT License - see [LICENSE](LICENSE) file for details

## Author

[AlgoCompSynth](https://github.com/AlgoCompSynth) - Maintained by [AlgoCompSynth](https://github.com/AlgoCompSynth)

## References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-borasky2021a" class="csl-entry">

Borasky, M. Edward (Ed). 2021. "When Harry Met Iannis."
<https://algocompsynth.bandcamp.com/album/when-harry-met-iannis>.

</div>

<div id="ref-narushima2019microtonality" class="csl-entry">

Narushima, T. 2019. *Microtonality and the Tuning Systems of Erv Wilson*. Routledge Studies in Music Theory. Taylor & Francis Limited.

</div>

<div id="ref-partch1979genesis" class="csl-entry">

Partch, H. 1979. *Genesis of a Music: An Account of a Creative Work, Its Roots, and Its Fulfillments, Second Edition*. Hachette Books.

</div>

<div id="ref-sethares1998tuning" class="csl-entry">

Sethares, W. A. 1998. *Tuning, Timbre, Spectrum, Scale*. Springer London.

</div>

<div id="ref-xenakis1992formalized" class="csl-entry">

Xenakis, I. 1992. *Formalized Music: Thought and Mathematics in Composition*. Harmonologia Series. Pendragon Press.

</div>

</div>