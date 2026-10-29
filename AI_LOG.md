# AI Interaction & Workflow Log: Savannah ABM Simulation

**Project:** Spatial Simulation (Unit 1, Unit 2 & Age Dynamics Extension) — Savannah ABM  
**Platform:** GAMA Modeling Platform (GAML)  
**Collaborators:** Timotej Gabrijan (Student #12526937) & Jarvis (Antigravity AI Assistant)  
**Date:** 29 October 2026  
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
7. **Lion Age Dynamics, Population Age Statistics, Visual Age Shading & Reproduction**

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

### Phase 7: Lion Age Dynamics, Statistical Reporting, Dynamic Colouring & Reproduction (29 October 2026)

#### Planning Phase
* **User Prompt:** *"Use the `models\savannah.gaml` and prepare the plan of prompts to do step by step: • Declare a list of age values • In the initialisation, add the age of all lions to the list, in a reflex function add current and remove previous age values. • Each time step, report the number of values in the list, their minimum, mean and maximum values. • Update the colour of agents in different shades of red according to the mean age of the population • lions die if they are older than 60 years • just before an old lion dies, a baby lion is born. After each section commit to git after each prompt"*
* **AI Action:** Formulated a structured 5-step prompt execution plan with atomic Git commits after each step.

#### Step 7.1: Declare Age List and Lion Age Attribute
* **User Prompt:** *"Execute step 1"*
* **AI Action:**
  * Declared `list<int> age_list <- [];` in the `global` block of [`models/savannah.gaml`](file:///C:/Users/timig/Desktop/Salzburg%20master/3_SEMESTER/Spatial%20Simulation/Antigravity-Test/models/savannah.gaml).
  * Added `int age <- rnd(0, 60);` to the `lion` species.
* **Git Commit:** `b8f9222` — `Step 1: Declare global age_list and lion age attribute`

#### Step 7.2: Initialise Age List & Update via Reflex Function
* **User Prompt:** *"step 2"*
* **AI Action:**
  * Added `add age to: age_list;` inside the `create lion` block in `global` `init`.
  * Implemented `reflex aging` in `species lion` to remove the previous `age` from `age_list`, increment `age <- age + 1;`, and append the updated `age` to `age_list`.
  * Added cleanup (`remove age from: age_list;`) when a lion dies of starvation so `age_list` remains synchronized with living lions.
* **Git Commit:** `5cad28f` — `Step 2: Initialize lion ages in age_list and update via aging reflex`

#### Step 7.3: Report Count, Minimum, Mean, and Maximum Age Values Each Time Step
* **User Prompt:** *"step 3"*
* **AI Action:**
  * Added `reflex report_ages` to `global` to compute and log `length(age_list)`, `min(age_list)`, `mean(age_list)`, and `max(age_list)` to the console at every simulation cycle.
  * Added real-time GUI monitors (`Age List Count`, `Min Lion Age`, `Mean Lion Age`, `Max Lion Age`) in `experiment main_experiment`.
* **Git Commit:** `3bdcdf6` — `Step 3: Report count, min, mean, and max of age_list each time step`

#### Step 7.4: Dynamic Agent Colour in Shades of Red by Mean Population Age
* **User Prompt:** *"step 4"*
* **AI Action:**
  * Updated `aspect default` in `species lion` to compute `red_shade` dynamically from `mean(age_list)` (`int(min([255, max([50, (mean_age / 60.0) * 255])]))`) and render the agent in `rgb(red_shade, 0, 0)`.
* **Git Commit:** `a1537a7` — `Step 4: Update lion colour in shades of red based on mean population age`

#### Step 7.5: Age Mortality (> 60 Years) & Baby Lion Birth
* **User Prompt:** *"step 5"*
* **AI Action:**
  * Extended `reflex aging` in `species lion` to check `if (age > 60)`.
  * Just before the old lion dies (`do die;`), it spawns a baby lion (`create lion number: 1`) at its location with `age <- 0`, `energy <- lion_initial_energy`, and adds the baby's age (`0`) to `age_list`.
* **Git Commit:** `d06b390` — `Step 5: Lions older than 60 die and spawn a baby lion`

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
| `b8f9222` | Timi | `Step 1: Declare global age_list and lion age attribute` |
| `5cad28f` | Timi | `Step 2: Initialize lion ages in age_list and update via aging reflex` |
| `3bdcdf6` | Timi | `Step 3: Report count, min, mean, and max of age_list each time step` |
| `a1537a7` | Timi | `Step 4: Update lion colour in shades of red based on mean population age` |
| `d06b390` | Timi | `Step 5: Lions older than 60 die and spawn a baby lion` |

---

## 4. Key Learnings & AI Pair Programming Assessment

1. **Granular Modularity:** Prompting by single behavioral units (environment $\to$ prey $\to$ predator $\to$ energetics) prevented compounding syntax errors in GAML and ensured instant testability in GAMA IDE.
2. **Defensive Spatial Programming:** LLMs frequently produce un-indexed spatial filters (`where (distance_to < r)`). Rigorous semantic code reviews caught these bottlenecks and enforced quadtree-indexed operators (`at_distance`) and boundary `nil` safeguards.
3. **Strict Reproducibility:** Immediate atomic commits with conventional commit messages established a transparent audit trail matching the progression of the lab exercises.
