# AI Interaction & Workflow Log: Savannah ABM Simulation

**Project:** Spatial Simulation (Unit 1 & Unit 2 Extension) — Savannah ABM  
**Platform:** GAMA Modeling Platform (GAML)  
**Collaborators:** Timotej Gabrijan (Student #12526937) & Jarvis (Antigravity AI Assistant)  
**Date:** 24 October 2026  
**Repository Branch:** `master`

---

## 1. Executive Summary & Workflow Philosophy
This document records the complete chronological log of interactions, prompt exchanges, architectural decisions, and version control commits during the development of the Savannah Agent-Based Model (ABM). 

The project followed an **incremental, prompt-driven engineering workflow** with **atomic Git commits** per feature step:
1. **Model Specification & Formalization**
2. **Environment & Cellular Automaton Skeleton**
3. **Prey Dynamics (Zebra Wandering & Grazing)**
4. **Predator Dynamics (Lion Wandering & Baseline Predation)**
5. **Code Review, Semantic Verification & Refactoring**
6. **Bioenergetic Dynamics & Starvation Extension**

---

## 2. Chronological Interaction & Commit Log

### Phase 1: Model Specification & Discovery
* **User Prompt:** Requested a formal, concise model specification outlining Environment & Grid (`my_CA`), Agents (`zebra` & `lions`), and Execution order based on baseline code from Unit 1 (`African_savannah.gaml`).
* **AI Action:**
  * Located baseline script at `C:\Users\timig\Desktop\Salzburg master\3_SEMESTER\Spatial Simulation\Experiment1\models\African_savannah.gaml`.
  * Formulated declarative specifications covering agent state variables, CA transition functions, visualization rules, and execution phases.
  * Generated and saved [`SPEC.md`](file:///C:/Users/timig/Desktop/Salzburg%20master/3_SEMESTER/Spatial%20Simulation/Antigravity-Test/SPEC.md).
* **Git Commit:** `af81b38` — `docs: formalize Savannah model specification`

---

### Phase 2: Step 1 — Grid Environment CA
* **User Prompt (Prompt 2):** Implement the GAMA model skeleton with `my_CA` grid cell environment. Each cell initialized with uniform biomass $\in [0.0, 10.0]$, regrowth reflex (+0.1 up to 10.0), dynamic color aspect, and GUI experiment display. No agents yet.
* **AI Action:**
  * Built [`models/savannah.gaml`](file:///C:/Users/timig/Desktop/Salzburg%20master/3_SEMESTER/Spatial%20Simulation/Antigravity-Test/models/savannah.gaml) with `grid my_CA` and `grass_growth` reflex.
  * Configured dynamic RGB gradient: $\text{rgb}(100-7B, 220-10B, 80-5B, 160)$.
  * Configured `experiment main_experiment type: gui` with `display map`.
* **Git Commit:** `237804e` — `feat(step-1): implement grid environment CA with dynamic biomass and regrowth`

---

### Phase 3: Step 2 — Zebras & Grazing
* **User Prompt (Prompt 3):** Add `zebra` species (20 agents, wandering amplitude $35.0^\circ$, speed $1.0$). Implement grazing behavior via `eat_biomass` action (consuming up to $1.0$ biomass from host cell). Add display aspect.
* **AI Action:**
  * Added `species zebra skills: [moving]` with `zebra_move` and `graze` calling `eat_biomass`.
  * Implemented defensive topological cell lookup `my_CA current_cell <- my_CA(location)`.
  * Added robust sprite loader with geometric fallback: checks `file_exists` for `zebra.png` with fallback to `triangle(2)`.
* **Git Commit:** `ebeffa5` — `feat(step-2): add zebra species with wandering movement and biomass grazing`

---

### Phase 4: Step 3 — Lions & Baseline Predation
* **User Prompt (Prompt 4):** Add `lions` species (20 agents, wandering amplitude $60.0^\circ$, speed $1.2$). Implement predation: kill nearby zebra within distance $1.0$ (`do die`). Add display aspect and ensure clean compilation.
* **AI Action:**
  * Implemented `species lions skills: [moving]` with predation check.
  * Added sprite loader for `lion.png` with orange circle fallback.
  * Layered GUI experiment to render `my_CA` $\to$ `zebra` $\to$ `lions`.
* **Git Commit:** `873ef8f` — `feat(step-3): add lions species with movement and predation behavior`

---

### Phase 5: Code Review, Semantic Verification & Refactoring
* **User Prompt (Prompt 5):** Conduct a line-by-line comparison against original `African_savannah.gaml`. Identify naming inconsistencies, potential runtime flaws (hardcoded paths, bounds), and verify `my_CA(location)` spatial casting semantics. User approved recommendations ("yes").
* **Key Findings & Fixes:**
  1. *Naming Inconsistency:* Fixed asymmetrical naming by renaming `species lions` to singular `species lion`.
  2. *Spatial Query Performance:* Replaced brute-force $O(N)$ linear filter `zebra where (each distance_to self < 1.0)` with quadtree-indexed spatial operator `(zebra at_distance 1.0) where (!dead(each))` to protect against concurrency race conditions.
  3. *Adaptive Raster Rendering:* Replaced fixed `draw square(1)` with `draw shape` to dynamically adapt to any grid resolution.
  4. *Spatial Casting Verification:* Confirmed `my_CA(location)` is GAMA's optimized $O(1)$ spatial coordinate-to-grid lookup, while retaining defensive `nil` boundary checks.
* **Git Commit:** `f9444a3` — `refactor: standardize species naming, optimize spatial indexing, and use adaptive cell shapes`

---

### Phase 6: Step 6 — Energetics & Starvation Extension
* **User Prompt (Prompt 6):** Extend the model with dynamic energy tracking:
  * Lions: Initial energy $10.0$, movement deduction $-0.2$/step, predation gain $+5.0$, starvation mortality at $\le 0$.
  * Zebras: Initial energy $10.0$, movement deduction $-0.1$/step, consumption conversion $+(\text{eaten biomass})$, starvation mortality at $\le 0$.
  * GUI: Real-time population charts, mean energy series, and numeric monitors.
* **AI Action:**
  * Updated `models/savannah.gaml` with complete bioenergetics and starvation reflexes.
  * Configured interactive GUI parameter sliders and multi-series charts for population curves and trophic energy levels.
* **Git Commit:** `6fa4b0e` — `feat(step-6): introduce metabolic energy dynamics, starvation, and monitoring charts`

---

## 3. Git Commit History Summary

| Commit Hash | Author | Message |
| :--- | :--- | :--- |
| `af81b38` | Timi | `docs: formalize Savannah model specification` |
| `237804e` | Timi | `feat(step-1): implement grid environment CA with dynamic biomass and regrowth` |
| `ebeffa5` | Timi | `feat(step-2): add zebra species with wandering movement and biomass grazing` |
| `873ef8f` | Timi | `feat(step-3): add lions species with movement and predation behavior` |
| `f9444a3` | Timi | `refactor: standardize species naming, optimize spatial indexing, and use adaptive cell shapes` |
| `6fa4b0e` | Timi | `feat(step-6): introduce metabolic energy dynamics, starvation, and monitoring charts` |

---

## 4. Key Learnings & AI Pair Programming Assessment

1. **Granular Modularity:** Prompting by single behavioral units (environment $\to$ prey $\to$ predator $\to$ energetics) prevented compounding syntax errors in GAML and ensured instant testability in GAMA IDE.
2. **Defensive Spatial Programming:** LLMs frequently produce un-indexed spatial filters (`where (distance_to < r)`). Rigorous semantic code reviews caught these bottlenecks and enforced quadtree-indexed operators (`at_distance`) and boundary `nil` safeguards.
3. **Strict Reproducibility:** Immediate atomic commits with conventional commit messages established a transparent audit trail matching the progression of the lab exercises.
