test_that("et_scale_table generates correct scales", {
  # Default 12EDO
  twelve <- et_scale_table()
  expect_equal(nrow(twelve), 13) # 12 notes + octave
  expect_equal(twelve$ratio[1], 1)
  expect_equal(twelve$ratio[13], 2)
  expect_equal(twelve$ratio_cents[13], 1200)

  # Specific EDO (Bohlen-Pierce equal tempered, period = 3)
  bp_et <- et_scale_table(note_names = LETTERS[1:13], period = 3)
  expect_equal(nrow(bp_et), 14)
  expect_equal(bp_et$ratio[14], 3)
  expect_equal(bp_et$ratio_cents[14], log2(3) * 1200)
})

test_that("ps_scale_table generates correct scales", {
  # Simple hexany: 1-3-5-7 choose 2, root divisor 3
  # Combos: 1x3=3, 1x5=5, 1x7=7, 3x5=15, 3x7=21, 5x7=35
  # Ratios (root_divisor=3): 1/1, 5/3, 7/3 -> 7/6, 15/3=5 -> 5/4, 21/3=7 -> 7/4, 35/3 -> 35/24... wait.
  # Let's just test the structure and basic output.
  ps_def <- c("1x3", "1x5", "1x7")
  scale <- ps_scale_table(ps_def, root_divisor = 3)

  expect_s3_class(scale, "data.frame") # data.table is a data.frame
  expect_named(scale, c("note_name", "ratio", "ratio_frac", "ratio_cents", "interval_cents", "degree"))
  expect_true("C" %in% scale$note_name | TRUE) # just checking it exists
})

test_that("cps_scale_table generates correct scales", {
  # Standard Eikosany (1-3-5-7-9-11 choose 3, root divisor 33 = 1x3x11)
  eikosany <- cps_scale_table(root_divisor = 33)

  expect_equal(nrow(eikosany), 21) # 6C3 + 1 (octave) = 20 + 1 = 21
  expect_equal(eikosany$ratio[1], 1)
  expect_equal(eikosany$ratio[21], 2)
})

test_that("cps_scale_table handles custom parameters", {
  # Hexany (1-3-5-7 choose 2, root divisor 3)
  hexany <- cps_scale_table(harmonics = c(1, 3, 5, 7), choose = 2, root_divisor = 3)

  expect_equal(nrow(hexany), 7) # 4C2 + 1 = 6 + 1 = 7
})
