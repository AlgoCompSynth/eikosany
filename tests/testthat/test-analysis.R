test_that("interval_table computes correct intervals", {
  # Simple ET scale for predictable results
  scale <- et_scale_table() # 12EDO

  intervals <- interval_table(scale)

  expect_s3_class(intervals, "data.frame")
  expect_named(intervals, c("from_name", "from_degree", "to_name", "to_degree", "ratio", "ratio_frac", "ratio_cents"))

  # Test a known interval: octave (C0 to C1)
  octave_int <- intervals[from_degree == 0 & to_degree == 12]
  expect_equal(as.numeric(octave_int$ratio), 2)
  expect_equal(as.numeric(octave_int$ratio_cents), 1200)

  # Test a known interval: Tritone (C to F#) in 12EDO
  tritone_int <- intervals[from_degree == 0 & to_degree == 6]
  expect_equal(as.numeric(tritone_int$ratio_cents), 600)
})

test_that("cps_chord_table generates valid chords", {
  # Eikosany based on even number of factors (6)
  eikosany <- cps_scale_table(root_divisor = 33)
  chords <- cps_chord_table(eikosany)

  expect_s3_class(chords, "data.frame")
  expect_named(chords, c("chord", "degrees", "chord_index", "is_subharm"))

  # Based on the implementation: choose = 6 / 2 + 1 = 4 notes per chord
  # Number of chords = 6C4 = 15 harmonic and 15 subharmonic
  expect_equal(nrow(chords), 30)

  # Verify subsets are harmonic (is_subharm=0) and subharmonic (is_subharm=1)
  expect_true(all(range(chords$is_subharm) == c(0, 1)))
})

test_that("cps_chord_table errors on odd harmonics", {
  # Create a scale with odd number of factors: e.g., 5C2 (4-any is even choose but let's check n_harmonics)
  # The function checks length(harmonics), which are the distinct factors in note_name
  bad_scale <- cps_scale_table(harmonics = c(1, 3, 5), choose = 2, root_divisor = 3)

  expect_error(cps_chord_table(bad_scale), "number of harmonic factors must be even!")
})
