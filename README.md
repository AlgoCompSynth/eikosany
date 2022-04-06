
# eikosany - Algorithmic Composition With Erv Wilson’s Combination Product Sets

## What is this?

`eikosany` is an R package of tools for algorithmic composition with Erv
Wilson’s Combination Product Sets (Narushima 2019, chap. 6). It’s meant
to ***complement*** other microtonal composition tools, not replace any
of them.

About the name: the *eikosany* is a 20-note scale derived by Erv Wilson
from the first six odd harmonics in the harmonic series - 1, 3, 5, 7, 9
and 11.

## Other tools?

-   [Scala](https://www.huygens-fokker.org/scala/). Note: this is
    ***not*** the Scala multi-paradigm programming language that runs on
    the Java Virtual Machine. This is a specialized tool for working
    with musical scales.
-   [Wilsonic](https://apps.apple.com/us/app/wilsonic/id848852071). This
    is a free app that runs on iOS devices. I don’t have any iOS devices
    so I’ve never used this.
-   [ODDSound
    MTS-ESP](https://oddsound.com/mtsespsuite.phphttps://oddsound.com/mtsespsuite.php).
    This is a plugin for digital audio workstations (DAWs) that
    facilitates production of microtonal music. I own a copy and if
    you’re making microtonal electronic music, you should too. The
    eikosany and other scales Erv Wilson developed all ship with
    MTS-ESP, so you don’t really need my R package to compose with them.
-   [Sevish’s Scale
    Workshop](https://sevish.com/scaleworkshop/guide.htm). This is a
    web-based tool for working with musical scales.

## Why did you build it?

I have two main motivations:

1.  There’s an old saying that if you really want to learn something,
    teach a computer to do it. In the case of Erv Wilson’s musical
    constructs, teasing the construction processes out of his and
    others’ writings on the subject is a non-trivial task.

    For example, much of Wilson’s writing is in the form of
    multi-dimensional graph structures drawn on flat paper. He did build
    physical three-dimensional models of some of them, but some can’t
    even be rendered in three dimensions.

    The graph theory operations that generated them and musical ways to
    traverse them are not at all obvious. One of my long-term goals is
    to write code to draw and traverse these, using DiagrammeR
    (Iannone 2022).

2.  I own two synthesizers that can remap the keyboard and its
    associated MIDI note numbers to arbitrary pitches, an [ASM
    Hydrasynth
    Explorer](https://www.ashunsoundmachines.com/hydrasynth-explorer),
    and a [Korg Minilogue
    XD](https://www.korg.com/us/products/synthesizers/minilogue_xd/).
    The Hydrasynth even has the eikosany and other Combination Product
    Sets built-in!

    But I’m not a keyboard player, and even if I were, the remapping
    process for the scales leaves only middle C where a musician would
    normally expect to find it. All the other notes are somewhere else.

    So I need a translator for the music I want to write that doesn’t
    involve a lot of trial and error fumbling around on a synthesizer or
    on-screen keyboard. In particular, the playing of chords on a
    remapped synthesizer isn’t described in any of the references on
    Wilson’s work that I’ve found.

    Music composed using Wilson’s musical structures is mostly played on
    instruments custom-built for them. There are keyboards designed for
    Wilson’s and other microtonal music; indeed, Wilson himself designed
    microtonal keyboards (Narushima 2019, chap. 2). But they’re quite
    expensive and, like the instruments, custom-built.

## Road map

I’ve got the basic scale and chord generation working. The next steps
are

1.  Verify that the generated scales match all of the Combination
    Product Set scales in Sevish’s [Eikosany
    Pack](https://sevish.com/music-resources/). The eikosany already
    does, but it’s easy to write a test harness to check them all.

2.  Add a MIDI file writing capability. There are some R packages that
    do this but I haven’t been able to test them yet. The goal here is
    to algorithmically create a MIDI file, load it into a DAW and hear
    what it sounds like on the synthesizer hardware. There are some
    [software synthesizers that allow MIDI pitch remapping (look for
    “Full-keyboard
    microtuning”)](https://en.xen.wiki/w/List_of_microtonal_software_plugins),
    so if you want to try this, you don’t need to buy a synthesizer.

That’s pretty much it for release 1.0. Once I have the capability to
write MIDI files programmatically, I can think about long-term goals. As
I noted above, one of them is to develop graph rendering and traversal
tools for all of Wilson’s constructs.

## References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-Iannone2022a" class="csl-entry">

Iannone, Richard. 2022. *DiagrammeR: Graph/Network Visualization*.
<https://CRAN.R-project.org/package=DiagrammeR>.

</div>

<div id="ref-narushima2019microtonality" class="csl-entry">

Narushima, T. 2019. *Microtonality and the Tuning Systems of Erv
Wilson*. Routledge Studies in Music Theory. Taylor & Francis Limited.
<https://books.google.com/books?id=TCBdzAEACAAJ>.

</div>

</div>
