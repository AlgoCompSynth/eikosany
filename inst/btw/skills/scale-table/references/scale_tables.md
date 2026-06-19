# Scale Table Creation Reference

## 1. Equal Tempered (ET) Scales
**Function**: `et_scale_table()`
**Use Case**: When creating scales with equal divisions of a period (usually an octave).
- `note_names`: Character vector of note names (e.g., `c("C", "C#", ...)`). Default is 12-EDO.
- `period`: The ratio defining the period (default is 2 for octave).

## 2. Combination Product Set (CPS) Scales
**Function**: `cps_scale_table()`
**Use Case**: When generating scales by taking combinations of a set of harmonics.
- `harmonics`: Vector of harmonics to use (e.g., `c(1, 3, 5, 7, 9, 11)`).
- `choose`: Number of harmonics per combination (e.g., 3 for Eikosany).
- `root_divisor`: **Required**. A divisor used to scale one product to 1/1.

## 3. Product Set (PS) Scales
**Function**: `ps_scale_table()`
**Use Case**: When the specific products defining the scale are already known as strings.
- `ps_def`: Character vector of products separated by 'x' (e.g., `c("1x3", "1x5")`).
- `root_divisor`: **Required**. A divisor used to scale one product to 1/1.

### Common Output Format
All functions return a `data.table` with:
- `note_name`: Note identifier.
- `ratio`: Numerical frequency ratio (usually between 1 and period).
- `ratio_frac`: Vulgar fraction representation.
- `ratio_cents`: Value in cents.
- `interval_cents`: Delta from previous note.
- `degree`: Integer index.
