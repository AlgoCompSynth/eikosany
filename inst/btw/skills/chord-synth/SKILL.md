---
name: Chord Synthesizer
description: Guidance for synthesizing audio chords from frequency vectors using `chord_synth`. Use this skill when the user wants to "hear a chord", "synthesize a sound", "create an audio file of these frequencies", or requests specific waveform types (sine, square, etc.) for a set of pitches.
---

# Chord Synthesis

This skill enables Claude to generate audio files representing musical chords based on frequency specifications.

## Workflow

1. **Resolve Frequencies**: 
   - If the user provides absolute frequencies (Hz), use them directly.
   - If the user provides ratios (e.g., "1:5/4:3/2"), ask for a root frequency or suggest a standard one (like $256\text{ Hz}$ or $440\text{ Hz}$) to calculate the absolute frequencies.
2. **Select Waveform**: 
   - Default is `"tria"`.
   - If the user asks for "smooth", "pure", or "whistle" $\rightarrow$ use `"sine"`.
   - If they ask for "harsh", "retro", or "game-like" $\rightarrow$ use `"square"` or `"saw"`.
3. **Set Parameters**: Define `duration_sec` and `velocity` if specified by the user; otherwise, stick to defaults.
4. **Execution**: Call `chord_synth()` with the resolved frequency vector and parameters.
5. **Confirmation**: Inform the user that the audio has been synthesized and provide the output path returned by the function.

## Detailed Reference

For a full list of supported arguments and internal logic, refer to [synth_guide.md](references/synth_guide.md).
