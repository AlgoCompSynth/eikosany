# Chatting with the Xentonal Assistant

## Introduction

The `eikosany` package provides a built-in agent, `xen.assist`, designed
to help users explore and synthesize xentonal scales. Instead of
manually calling complex scaling functions, you can interact with the
assistant in plain English.

The assistant is powered by the `btw` package and connects to an
OpenAI-compatible API (such as Ollama) to process queries and execute R
tools automatically.

## Prerequisites

To use the chat functionality, you will need:

1.  **An LLM Server**: The current assistant works with any
    OpenAI-compatible API such as [**Ollama**](https://ollama.com).
    Ensure your server is installed and running locally or remotely.

2.  **A compatible model**: The assistant has no default; you must
    specify the model via the `client` argument. Moreover the assistant
    will ***not*** pull models for you; they need to be present when you
    start the chat. For example:

    ``` bash
    ollama pull gemma4:31b
    ```

3.  **The `btw` package**: This package manages the communication
    between R and the LLM.

    ``` r
    install.packages("btw")
    ```

## Starting the Chat

To start an interactive session, call the
[`xen_chat()`](https://algocompsynth.github.io/eikosany/reference/xen_chat.md)
function with a suitable client configuration.

``` r
# Example: connect to a local Ollama instance running gemma4:31b
ollama_client <- btw::btw_client_ollama(
  model = "gemma4:31b"
)

xen_chat(client = ollama_client)
```

Once called, the assistant will initialize its system prompt and
register a set of xentonal tools, including scale generators and
synthesizers. You can then type your queries in the chat window. To exit
the chat, type `exit` or `quit`.

## What can the assistant do?

The `xen.assist` agent is equipped with specialized tools that allow it
to perform the following tasks on your behalf:

- **Scale Generation**: It can create Equal Tempered (EDO), Combination
  Product Set (CPS), and Product Set scales.
- **Analysis**: It can generate interval tables and MIDI keyboard maps
  for any generated scale.
- **Synthesis**: It can synthesize single notes or chords as WAV files
  using `note_synth()` and
  [`chord_synth()`](https://algocompsynth.github.io/eikosany/reference/chord_synth.md).

## Example Queries

Try asking the assistant: - *“Can you create a 31-EDO scale starting at
440Hz?”* - *“What are the frequency ratios for a Bohlen-Pierce
scale?”* - *“Synthesize a sine wave C# in 19-EDO (approx 466Hz) so I can
hear it.”*

## Troubleshooting

If you encounter an error stating that `btw` is missing, please install
it. If the chat fails to connect, verify that your LLM server is running
and that you have pulled the required model using the command line.
