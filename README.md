
# eikosany - Algorithmic Composition With Erv Wilson’s Combination Product Sets

## Overview

`eikosany` is an R package of tools for algorithmic composition with Erv
Wilson’s Combination Product Sets (Narushima 2019, chap. 6). It’s meant
to ***complement*** other microtonal composition tools, not replace any
of them.

About the name: the *Eikosany* is a 20-note scale derived by Erv Wilson
from the first six odd harmonics in the harmonic series - 1, 3, 5, 7, 9
and 11.

## Other tools

- [Scala](https://www.huygens-fokker.org/scala/). Note: this is
  ***not*** the Scala multi-paradigm programming language that runs on
  the Java Virtual Machine. This is a specialized tool for working with
  musical scales.
- [Wilsonic](https://apps.apple.com/us/app/wilsonic/id848852071). This
  is a free app that runs on iOS devices. I don’t have any iOS devices
  so I’ve never used this.
- [ODDSound
  MTS-ESP](https://oddsound.com/mtsespsuite.phphttps://oddsound.com/mtsespsuite.php).
  This is a plugin for digital audio workstations (DAWs) that
  facilitates production of microtonal music. I own a copy and if you’re
  making microtonal electronic music, you should too. The Eikosany and
  other scales Erv Wilson developed all ship with MTS-ESP, so you don’t
  really need my R package to compose with them.
- [Sevish’s Scale Workshop](https://sevish.com/scaleworkshop/guide.htm).
  This is a web-based tool for working with musical scales.
- [Entonal Studio](https://entonal.studio/). Entonal Studio is a user
  interface package for microtonal composition. It can operate as a
  standalone application, a plugin host or a plugin. I own a copy of
  Entonal Studio and recommend it highly.

## Some history

On February 4, 2001, composer Iannis Xenakis passed away. I’ve been a
fan of experimental music, especially *musique concrète*,
algorithmically composed music, microtonal music, and other
*avant-garde* genres since I was an undergraduate. Xenakis was one of
the major figures in algorithmic composition.

Reading the first edition of *Tuning, Timbre, Spectrum, Scale* [^1]
rekindled my appreciation for the microtonal music of Harry Partch. And
so, armed with copies of Sethares (1998), *Formalized Music* [^2], and
*Genesis of a Music* [^3], I embarked on a path that led to *When Harry
Met Iannis* [^4].

*When Harry Met Iannis* was premiered at a microtonal music festival in
El Paso, Texas in late October, 2001. The [Bandcamp
version](https://algocompsynth.bandcamp.com/album/when-harry-met-iannis)
is essentially identical to that version; the source code is on GitHub
at <https://github.com/AlgoCompSynth/when-harry-met-iannis>.

At the festival, I met a number of composers who were working in
microtonal and just intonation, and one name kept coming up: Erv Wilson.
Wilson was a theoretician who developed keyboards, scales and tuning
systems that several composers were using at the time, and are still
using today. Terumi Narushima’s *Microtonality and the Tuning Systems of
Erv Wilson* [^5] is a comprehensive documentation of Wilson’s work and
is the basis for the code in this package.

## Motivation

I have two main motivations:

1.  There’s an old saying that if you really want to learn something,
    teach a computer to do it. In the case of Erv Wilson’s musical
    constructs, teasing the construction processes out of his and
    others’ writings on the subject is a non-trivial task.

    For example, much of Wilson’s work consists of multi-dimensional
    graph structures drawn on flat paper. He did build physical
    three-dimensional models of some of them, but some can’t even be
    rendered in three dimension. And the graph theory operations that
    generated them and musical ways to traverse them are not at all
    obvious.

2.  The 20th anniversary of Xenakis’ passing and of *When Harry Met
    Iannis* occured in my second year of virtual isolation because of
    COVID-19. During 2021, I acquired two synthesizers that are capable
    of mapping the keyboards to arbitrary microtonal scales: an [Ashun
    Sound Machines Hydrasynth
    Desktop](https://www.ashunsoundmachines.com/hydrasynth-desk), and a
    [Korg Minilogue
    XD](https://www.korg.com/us/products/synthesizers/minilogue_xd/).

    The Hydrasynth ships with the tuning tables for many of Erv Wilson’s
    scales already in the firmware. For the Minilogue XD, the user can
    load up to six custom scales with a software librarian program.

    But I’m not a keyboard player, and even if I were, the remapping
    process for the scales leaves only middle C where a musician would
    normally expect to find it. All the other notes are somewhere else.

    So I need a translator for the music I want to write that doesn’t
    involve a lot of trial and error fumbling around on a remapped
    synthesizer or on-screen keyboard. CPS scales are aimed at harmonic
    musical structures like chords, and finding them on a remapped
    keyboard is tedious and error-prone.

    Music composed using Wilson’s musical structures is mostly played on
    instruments custom-built for them. There are keyboards designed for
    Wilson’s and other microtonal music; indeed, Wilson himself designed
    microtonal keyboards (Narushima 2019, chap. 2). But they’re quite
    expensive and, like the instruments, custom-built. I need tools to
    work with what I have.

## Milestones

The ultimate goal of this package is to compose music using Combination
Product Set (CPS) scales. There are three milestones on that path:

- [v0.5.0](https://github.com/AlgoCompSynth/eikosany/milestone/1):
  synthesizing tones in a CPS scale to WAV files that can be used in a
  sample-based workflow,
- [v0.7.5](https://github.com/AlgoCompSynth/eikosany/milestone/2):
  creating MIDI files that can be imported into a DAW for editing and
  music production, and
- [v0.9.0](https://github.com/AlgoCompSynth/eikosany/milestone/3): tools
  for creating and traversing diagrams of CPS scales and chords, using
  DiagrammeR (Iannone 2022).

## References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-Borasky2021a" class="csl-entry">

Borasky, M. Edward (Ed). 2021. “When Harry Met Iannis.”
<https://algocompsynth.bandcamp.com/album/when-harry-met-iannis>.

</div>

<div id="ref-Iannone2022a" class="csl-entry">

Iannone, Richard. 2022. *DiagrammeR: Graph/Network Visualization*.
<https://CRAN.R-project.org/package=DiagrammeR>.

</div>

<div id="ref-narushima2019microtonality" class="csl-entry">

Narushima, T. 2019. *Microtonality and the Tuning Systems of Erv
Wilson*. Routledge Studies in Music Theory. Taylor & Francis Limited.
<https://books.google.com/books?id=TCBdzAEACAAJ>.

</div>

<div id="ref-partch1979genesis" class="csl-entry">

Partch, H. 1979. *Genesis of a Music: An Account of a Creative Work, Its
Roots, and Its Fulfillments, Second Edition*. Hachette Books.
<https://books.google.com/books?id=8JVQAQAACAAJ>.

</div>

<div id="ref-sethares1998tuning" class="csl-entry">

Sethares, W. A. 1998. *Tuning, Timbre, Spectrum, Scale*. Springer
London. <https://books.google.com/books?id=T8XvAAAAMAAJ>.

</div>

<div id="ref-xenakis1992formalized" class="csl-entry">

Xenakis, I. 1992. *Formalized Music: Thought and Mathematics in
Composition*. Harmonologia Series. Pendragon Press.
<https://books.google.com/books?id=y6lL3I0vmMwC>.

</div>

</div>

[^1]: Sethares (1998)

[^2]: Xenakis (1992)

[^3]: Partch (1979)

[^4]: Borasky (2021)

[^5]: Narushima (2019)
