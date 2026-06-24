test_that("offset_matrix generates correct dimensions and values", {
  scale <- et_scale_table() # 12EDO, ratio_cents = 0, 100, ..., 1200
  offsets <- offset_matrix(scale)

  # Scale length is 13, but offset_matrix uses scale_length = nrow - 1 = 12
  expect_equal(nrow(offsets), 12)
  expect_equal(ncol(offsets), 12)
  expect_equal(colnames(offsets), .NAMES_12EDO)

  # The diagonal should be near 0 for a 12EDO scale (Standard tuning)
  diag_vals <- diag(offsets)
  expect_true(all(abs(diag_vals) < 1))
})

test_that("keyboard_map generates correct structure", {
  scale <- et_scale_table() # 12EDO
  kmap <- keyboard_map(scale)

  expect_equal(nrow(kmap), 128) # MIDI notes 0-127
  expect_named(kmap, c(
    "note_number", "name_12edo", "octave_12edo", "note_name",
    "ratio_frac", "degree", "period_number", "freq",
    "cents", "ref_keyname", "ref_octave", "ref_offset"
  ))

  # Middle C (60) should be degree 0 for standard et_scale_table()
  middle_c <- kmap[note_number == 60]
  expect_equal(middle_c$degree, 0)
})

test_that("chord_synth creates a Wave object", {
  # Minimal synth test to avoid long processing or audio output
  freqs <- c(440, 880)
  wave <- chord_synth(freqs, duration_sec = 0.1)

  expect_s4_class(wave, "Wave")
  expect_equal(wave@samp.rate, 44100)
})

test_that("chord_WAVs handles directory creation and output", {
  # Use a temporary directory to avoid polluting the user's home
  temp_dir <- withr::local_tempdir()
  scale <- et_scale_table()
  kmap <- keyboard_map(scale)

  # Create simple chord (C, E, G - degrees 0, 4, 7)
  out_path <- chord_WAVs(
    chord = c(0, 4, 7),
    keyboard_map = kmap,
    lowest_note = 60,
    highest_note = 72,
    output_directory = file.path(temp_dir, "test_wavs"),
    duration_sec = 0.1
  )

  expect_equal(out_path, file.path(temp_dir, "test_wavs"))
  expect_true(dir.exists(out_path))
  expect_gt(length(list.files(out_path)), 0)
})
