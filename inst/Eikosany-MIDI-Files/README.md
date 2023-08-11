# About these files

## How they were generated
1. Compute the 30 tetrads of the 1-3-5-7-9-11 Eikosany.
2. Assume a synthesizer with the keyboard mapped to the "typical" mapping - middle C (MIDI note 60) is 1x3x5, the 19 notes above middle C are generated from the SCL file in the Sevish tuning pack, and the rest of the keyboard is remapped by octaves. My Korg Minilogue XD and ASM Hydrasynth can do this, as can many software synthesizers. The Hydrasynth ships with it in the firmware!
3. Given that, for each tetrad, generate all the inversions of the tetrad between MIDI notes 40 and 80 inclusive - two whole octaves.
4. Export to MIDI files with 60 beats per minute, holding each inversion for one beat (a second).
