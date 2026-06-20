---
client:
  provider: ollama
  model: "gemma4:26b-a4b-it-qat"
  echo: output
  base_url: "http://localhost:11434"
tools:
  - docs
  - env
  - files
  - git
  - github
  - ide
  - search
  - session
  - web
---

## Coding style
Follow these important style rules when writing R code:

* Prefer solutions that use {data.table}
* Always use `<-` for assignment
* Always use the native base-R pipe `|>` for piped expressions
* Use Boostrap 5 Bootswatch `darkly` theme for Shiny dashboards.
* Write the `roxygen` comments as you code!

## Current environment and resources available
1. A Fedora Linux environment with
    a. RStudio Server,
    b. Installed R library packages for package development, AI, and audio analysis / synthesis, and
    c. An Ollama local inference server - do `ollama list` to see the available models.

2. The `ollamar` R package for managing Ollama is installed, and its source code is at
<https://github.com/hauselin/ollama-r>

3. The `btw` R package for building AI interactions is installed, and its source code is at
<https://github.com/posit-dev/btw>.

4. The Posit collection of Claude-compatible skills can be downloaded from
<https://github.com/posit-dev/skills>. The repository has been cloned to `~/Projects/skills`.

5. The `eikosany` R package is installed, and its source code is at
<https://github.com/AlgoCompSynth/eikosany>. `eikosany` provides
    a. functions for manipulating xentonal scales and synthesizing samples from them, and
    b. a function `xen_chat` for interacting with a user of `eikosany` via a `btw` Shiny chat app.
    c. a collection of package-specific skills for `xen_chat` in `inst/btw/skills`.
