test_that(".ratio2cents and .cents2ratio are inverses", {
  ratios <- c(1, 3/2, 5/4, 1.618)
  cents <- .ratio2cents(ratios)
  expect_equal(.cents2ratio(cents), ratios, tolerance = 1e-7)
})

test_that(".period_reduce normalizes values to [1, period)", {
  period <- 2
  input <- c(0.5, 1.5, 2.5, 4.0, 0.25)
  # 0.5 * 2 = 1.0
  # 1.5 = 1.5
  # 2.5 / 2 = 1.25
  # 4.0 / 2 / 2 = 1.0
  # 0.25 * 2 * 2 = 1.0
  expected <- c(1, 1.5, 1.25, 1, 1)
  expect_equal(.period_reduce(input, period), expected)
})

test_that("ps_scale_table produces correct ratios for Hexany", {
  # 1-3-5-7 Hexany: products are 1x3, 1x5, 1x7, 3x5, 3x7, 5x7
  # root_divisor = 3 (scales 1x3 to 1/1)
  ps_def <- c("1x3", "1x5", "1x7", "3x5", "3x7", "5x7")
  table <- ps_scale_table(ps_def, root_divisor = 3)
  
  # Expected ratios after period reduction (period=2):
  # 3/3 = 1.0
  # 5/3 = 1.666...
  # 7/3 = 2.333 -> 1.1666...
  # 15/3 = 5.0 -> 1.25
  # 21/3 = 7.0 -> 1.75
  # 35/3 = 11.666 -> 1.45833...
  expected_ratios <- c(1, 1.1666667, 1.25, 1.458333, 1.6666667, 1.75)
  expect_equal(table$ratio[1:6], sort(expected_ratios), tolerance = 1e-6)
})

test_that("cps_scale_table produces expected Eikosany size", {
  # Default is 20 notes
  table <- cps_scale_table(root_divisor = 33)
  expect_equal(nrow(table) - 1, 20) # minus the octave row
})

test_that("et_scale_table produces correct ratios for 12EDO", {
  table <- et_scale_table()
  expect_equal(table$ratio[1], 1.0)
  # C# in 12EDO is 2^(1/12)
  expect_equal(table$ratio[2], 2^(1/12), tolerance = 1e-7)
})

test_that("interval_table generates correct number of intervals", {
  table <- et_scale_table() # 12 notes + octave row
  # Only the base scale is used (12 notes). Intervals: 12 * 11 / 2 = 66
  int_table <- interval_table(table[degree < 12]) 
  expect_equal(nrow(int_table), 66)
})

test_that("cps_chord_table errors on odd number of factors", {
  # Create a scale table with 3 harmonics (odd)
  ps_def <- c("1x3", "1x5", "3x5") 
  table <- ps_scale_table(ps_def, root_divisor = 3)
  expect_error(cps_chord_table(table), "number of harmonic factors must be even!")
})

test_that("keyboard_map maps middle C correctly", {
  table <- et_scale_table() # 12EDO
  kmap <- keyboard_map(table)
  # Middle C is MIDI 60. In default settings, it should have degree 0
  middle_c <- kmap[note_number == 60]
  expect_equal(middle_c$degree, 0)
  expect_equal(middle_c$name_12edo, "C")
})
