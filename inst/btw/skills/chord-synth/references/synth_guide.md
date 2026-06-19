# Chord Synthesis Reference

## function: `chord_synth()`
Used to synthesize a chord given a vector of frequencies into an audio format.

### Arguments
- **`chord` (Required)**: A numeric vector of frequencies (Hz). 
  - *Note*: If the user provides ratios (e.g., `c(1, 5/4, 3/2)`), you must multiply them by a root frequency (e.g., $256 \text{ Hz}$) to get actual frequencies.
- **`signal`**: The waveform type. Options: `"sine"`, `"tria"` (default), `"square"`, or `"saw"`.
- **`duration_sec`**: Duration of the notes in seconds. Default is `1`.
- **`velocity`**: MIDI velocity (0-127). Default is `100`.
- **`sample_rate_hz`**: Sample rate in Hz. Default is `48000`.
- **`bit_width`**: Bit depth of the samples. Default is `24`.

### Output
Returns a string containing the full path to the output directory where the audio file was created.

### Example Workflow for ratios:
If user says "Synthesize a Just Major 7th chord at 256Hz":
1. Define ratios: `ratios <- c(1, 5/4, 3/2, 7/4)`
2. Calculate frequencies: `freqs <- 256 * ratios`
3. Call function: `chord_synth(chord = freqs)`
