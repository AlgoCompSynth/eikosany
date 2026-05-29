# Introduction to Combination Product Sets

``` r

library(eikosany)
```

## Alternative Tunings Overview

Unless you’re into alternative tunings, your first question is probably
“Alternative to what?” Of course, that depends on what culture you call
home. But for most Americans and other native English speakers, most
Europeans, and mass-market popular music creators and audiences nearly
everywhere, music is tuned to 12-tone equal temperament, abbreviated as
“*12-TET*”. You will also see this tuning referred to as “*12-EDO*”,
which stands for “twelve equal divisions of the octave.”

So what are the alternatives? There are two main sources of alternative
tunings:

- Other cultures, and

- Music theorists / composers / instrument builders / performers within
  the ancient Greek / Italian / French / German mainstream (with
  nationalist enhancements!) that now uses 12-EDO. For brevity we’ll
  call those “Western theoretical tunings”.

### Other cultures

Notable examples of tunings from other cultures are Indonesian
[*gamelan*](https://en.wikipedia.org/wiki/Gamelan "Gamelan on Wikipedia")
tuning, South Indian [*carnatic*
music](https://en.wikipedia.org/wiki/Carnatic_music "Carnatic music on Wikipedia"),
and various
[*makams*](https://en.wikipedia.org/wiki/List_of_makams "List of makams on Wikipedia")
from [Ottoman
music](https://en.wikipedia.org/wiki/Ottoman_music "Ottoman music on Wikipedia").
You can find detailed analyses of gamelan tunings, as well as Thai
classical tunings and numerous theoretical and practical tunings in
(Sethares 2013). The first edition of this book (Sethares 1998) is the
book that sent me down the alternate tunings rabbit hole in 2001.

### Western theoretical tunings

Numerous tunings and temperaments have derived by theorists, composers,
and performers over time. This happened first as steps along the path
from ancient Greek music to 12-EDO claiming the dominant market share it
has today, and later as a counter to said market share.

In some cases, instrument builders constructed moderately complex
instruments that used these tunings. It was the desire to mass-produce
musical instruments, especially the piano, that led to the widespread
adoption of 12-EDO as the standard.

There are two main types of such alternative tunings in use today:

- Equal divisions of a period, usually the octave, and

- Just intonation.

### Brief guide to tuning and scales

Before moving onward, we need to define some concepts. *Pitches* are
(sort of) the musical name for frequencies. *Frequencies* are the rate
at which some string or air column or reed or membrane or loudspeaker or
other physical object vibrates.

Frequencies are designated in cycles per second, called *Hertz* and
abbreviated *Hz*. The typical range of human hearing is 20 - 20,000
Hertz, but not all of that range is commonly used in music.

A *tuning* describes a set of pitches a composer selects from in writing
a piece, often dictated by the instruments that will be used to play it.
Tunings usually consist of a set of repetitions of a *scale.* A scale is
a set of pitches in ascending order of frequency.

The most common tuning of this type is equal divisions of the octave
with more than twelve notes, generally called “N-TET” or “N-EDO”. For
example, quarter-tone tunings are *24-EDO*. Musicians create tunings of
this kind for a variety of reasons, most often to provide more harmonic
possibilities without giving up the ability to modulate to different
keys.

Two such tunings that have achieved serious usage are
[*19-EDO*](https://en.wikipedia.org/wiki/19_equal_temperament "19 equal temperament on Wikipedia")
and
[*31-EDO*](https://en.wikipedia.org/wiki/31_equal_temperament "31 equal temperament on Wikipedia").
If you’re curious about such tunings, function `et_scale_table` in this
package can create scale tables for them, and function `keyboard_map`
can create a mapping for such a scale to a synthesizer keyboard.

Here’s what the 19-EDO scale table and keyboard map look like:

``` r

data("edo19_names")
edo19_scale_table <- et_scale_table(edo19_names)
print(edo19_scale_table)
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>
#>  1:         C 1.000000          1     0.00000             NA      0
#>  2:        C# 1.037155    977/942    63.15789       63.15789      1
#>  3:        Db 1.075691    739/687   126.31579       63.15789      2
#>  4:         D 1.115658    627/562   189.47368       63.15789      3
#>  5:        D# 1.157110   1009/872   252.63158       63.15789      4
#>  6:        Eb 1.200103  2333/1944   315.78947       63.15789      5
#>  7:         E 1.244693   1114/895   378.94737       63.15789      6
#>  8:     E#|Fb 1.290939  1553/1203   442.10526       63.15789      7
#>  9:         F 1.338904  1442/1077   505.26316       63.15789      8
#> 10:        F# 1.388651   1297/934   568.42105       63.15789      9
#> 11:        Gb 1.440247  1639/1138   631.57895       63.15789     10
#> 12:         G 1.493759   1077/721   694.73684       63.15789     11
#> 13:        G# 1.549260  2406/1553   757.89474       63.15789     12
#> 14:        Ab 1.606822    895/557   821.05263       63.15789     13
#> 15:         A 1.666524  3893/2336   884.21053       63.15789     14
#> 16:        A# 1.728444  1744/1009   947.36842       63.15789     15
#> 17:        Bb 1.792664   1124/627  1010.52632       63.15789     16
#> 18:         B 1.859271   1123/604  1073.68421       63.15789     17
#> 19:     B#|Cb 1.928352   1884/977  1136.84211       63.15789     18
#> 20:        C' 2.000000          2  1200.00000       63.15789     19
#>     note_name    ratio ratio_frac ratio_cents interval_cents degree
#>        <char>    <num> <charFrac>       <num>          <num>  <num>
edo19_keyboard_map <- keyboard_map(edo19_scale_table)
print(edo19_keyboard_map)
#> Key: <note_number>
#>      note_number name_12edo octave_12edo note_name ratio_frac degree
#>            <num>     <char>        <num>    <char>     <char>  <num>
#>   1:           0          C           -1        Bb   1124/627     16
#>   2:           1         C#           -1         B   1123/604     17
#>   3:           2          D           -1     B#|Cb   1884/977     18
#>   4:           3         D#           -1         C          1      0
#>   5:           4          E           -1        C#    977/942      1
#>  ---                                                                
#> 124:         123         D#            9         E   1114/895      6
#> 125:         124          E            9     E#|Fb  1553/1203      7
#> 126:         125          F            9         F  1442/1077      8
#> 127:         126         F#            9        F#   1297/934      9
#> 128:         127          G            9        Gb  1639/1138     10
#>      period_number       freq     cents ref_keyname ref_octave ref_offset
#>              <num>      <num>     <num>      <char>      <num>      <num>
#>   1:            -4   29.31292  2210.526          A#          1         11
#>   2:            -4   30.40205  2273.684           B          1        -26
#>   3:            -4   31.53164  2336.842           B          1         37
#>   4:            -3   32.70320  2400.000           C          2          0
#>   5:            -3   33.91828  2463.158          C#          2        -37
#>  ---                                                                     
#> 124:             3 2605.14722  9978.947           E          8        -21
#> 125:             3 2701.94158 10042.105           E          8         42
#> 126:             3 2802.33234 10105.263           F          8          5
#> 127:             3 2906.45312 10168.421          F#          8        -32
#> 128:             3 3014.44252 10231.579          F#          8         32
```

### Just intonation

The other main class of derived tunings is called [*just
intonation*](https://en.wikipedia.org/wiki/Just_intonation "Just intonation on Wikipedia").
Just intonation attempts to create perfect harmonies by dividing the
octave into unequal intervals using ratios of small integers. For
example, the just perfect fifth is 3/2, the just perfect fourth is 4/3,
and the just major third is 5/4.

If you’ve heard a barbershop quartet, you’ve heard just intonation.
Combination product sets are a form of just intonation.

## Combination Product Sets

Combination product sets (Narushima 2019, chap. 6) are just one of
theoretician Erv Wilson’s tuning constructs. The current release,
v0.5.0, is focused on them, and the ability to play music with them on
synthesizers that can be retuned, such as the [Korg Minilogue
XD](https://www.korg.com/us/products/synthesizers/minilogue_xd/ "Korg Minilogue XD web page"),
the [Aodyo Anyma
Phi](https://aodyo.com/anyma-phi/ "Aodyo Anyma Phi web page"), and the
[Ashun Sound
Machines](https://www.ashunsoundmachines.com/ "Ashun Sound Machines home page")
Hydrasynth.

## References

Narushima, T. 2019. *Microtonality and the Tuning Systems of Erv
Wilson*. Routledge Studies in Music Theory. Taylor & Francis Limited.

Sethares, W. A. 1998. *Tuning, Timbre, Spectrum, Scale*. Springer
London.

Sethares, W. A. 2013. *Tuning, Timbre, Spectrum, Scale, Second Edition*.
Springer London.
