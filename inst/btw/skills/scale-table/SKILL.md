---
name: Scale Table Creator
description: Comprehensive guidance for creating musical scale tables (Equal Tempered, Combination Product Set, and Product Set). Use this skill when the user wants to "create a scale table", "make an ET/CPS/PS scale", or needs help defining scales using package functions.
---

# Scale Table Creation

This skill enables Claude to generate specialized scale tables using the package's core tuning functions.

## Workflow

1. **Identify Scale Type**: Determine if the user wants an Equal Tempered (ET), Combination Product Set (CPS), or Product Set (PS) scale.
2. **Verify Parameters**: 
   - For ET: Check if `note_names` and `period` are specified; otherwise, use defaults.
   - For CPS: Ensure `harmonics`, `choose`, and especially `root_divisor` are provided.
   - For PS: Ensure `ps_def` and `root_divisor` are provided.
3. **Implementation**: Call the corresponding function in R.
4. **Presentation**: Print the resulting table to provide the user with ratios, cents, and degrees.

## Function Selection Guidance

- If the user mentions "EDO", "equal divisions", or "tempered" $\rightarrow$ use `et_scale_table()`.
- If the user mentions "combination product set", "harmonics combinations", or naming conventions like "Eikosany/Hexany/Dekany" (when based on harmonic sets) $\rightarrow$ use `cps_scale_table()`.
- If the user provides a specific list of products as strings (e.g., "1x3", "5x7") $\rightarrow$ use `ps_scale_table()`.

## Detailed Reference

For full argument specifications and examples, read the reference guide: [scale_tables.md](references/scale_tables.md).
