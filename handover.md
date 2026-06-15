# PROJECT HANDOVER: eikosany

This document serves as a state-transfer for an AI agent taking over this project following a session reset. 

## 📋 Current Status
The **Strategic Exploration & Documentation Phase** is complete. The codebase has been analyzed, and its architectural intent—serving as an "Intelligence API" for algorithmic musical composition using Combination Product Sets (CPS)—has been established.

A comprehensive project summary resides in `./btw.md`. **Read that file first to regain full context on the architecture.**

## 🎯 Immediate Objective: Critical Code Review & Refactor
The project is entering a phase of "critical cleanup." The goal is to move from a working prototype/research implementation to a robust, high-performance tool suitable for AI agents and professional composers.

### Prioritized Task List

#### 1. Legacy Cleanup (Low Effort / High Value)
* **Task:** Scrub all legacy hardware references (e.g., "Korg Minilogue XD", "Dirtywave M8").
* **Location:** Primarily in `R/cps_functions.R` within the documentation and comments for `offset_matrix()` and `keyboard_map()`.
* **Goal:** These functions should be framed as generic cents-deviation tools, not platform-specific scripts.

#### 2. Performance Optimization (Medium Effort / High Value)
* **Target 1: `interval_table()`**
    - **Issue:** Currently uses nested `for` loops to populate vectors. This is an R anti-pattern that will fail on larger scales.
    - **Fix:** Replace with a vectorized cross-join or `data.table` join approach.
* **Target 2: `.period_reduce()`**
    - **Issue:** Uses `while` loops for octave wrapping. 
    - **Fix:** Investigate replacing this with logarithmic/modulo arithmetic for constant-time performance regardless of the ratio's magnitude.

#### 3. Robustness & Fortification (Medium Effort / Medium Value)
* **Input Validation:**
    - Implement guards against `root_divisor = 0` or `NA`.
    - Validate that harmonics provided to `cps_scale_table()` are numeric and positive.
    - Handle cases for empty scale tables or single-note scales in `interval_table()`.
* **Combinatoric Safety:**
    - The use of `combn()` can lead to memory crashes if the harmonic set is too large relative to the "choose" number. Implement reasonable limits or warning thresholds.

#### 4. API Alignment (Low Effort / Medium Value)
* Ensure every public function strictly returns a `data.table` as defined in the project's relational data model.
* Verify that all Roxygen2 documentation tags (`@param`, `@return`) exactly match the current implementation of the functions.

## 🛠️ Recommended First Steps for New Session
1. Read `./btw.md`.
2. Run `R/cps_functions.R` to identify every instance of "Korg" or "Dirtywave".
3. Prototype a vectorized version of `interval_table()` and compare its performance against the original loop-based implementation.
