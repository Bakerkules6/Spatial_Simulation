# Savannah Agent-Based Model Specification

**Source Baseline:** [`African_savannah.gaml`](file:///C:/Users/timig/Desktop/Salzburg%20master/3_SEMESTER/Spatial%20Simulation/Experiment1/models/African_savannah.gaml)  
**Target Environment:** GAMA Platform (GAML)

---

## 1. Environment & Cellular Automaton (`my_CA`)

### 1.1 State Variables
- `biomass` (float):
  - Range: `[0.0, 10.0]`
  - Initialization: Uniform random distribution `rnd(0.0, 10.0)`.
- `max_biomass` (float, parameter): Fixed ceiling (default: `10.0`).
- `growth_rate` (float, parameter): Biomass increment per cycle (default: `0.1`).

### 1.2 Dynamics & Transitions
- **Regrowth Reflex (`grass_growth`):**
  - Evaluated on every simulation step.
  - State update: $\text{biomass}_{t+1} \leftarrow \min(\text{biomass}_t + \text{growth\_rate}, \text{max\_biomass})$.

### 1.3 Representation & Rendering
- **Grid Geometry:** 2D continuous space mapped to a discrete raster grid.
- **Dynamic Color Gradient:** RGB shading proportional to biomass intensity:
  - $\text{R} = 100 - (\text{biomass} \times 7)$
  - $\text{G} = 220 - (\text{biomass} \times 10)$
  - $\text{B} = 80 - (\text{biomass} \times 5)$
  - Alpha: `160` (semi-transparent overlay).

---

## 2. Agent Entities (`species`)

### 2.1 Herbivore Agent: `zebra`
- **Capabilities & Skills:** `[moving]`
- **Attributes:**
  - `speed` (float): Base displacement rate (default: `1.0`).
  - `bite_size` (float, parameter): Maximum biomass intake per step (default: `1.0`).
- **Behaviors & Reflexes:**
  - **Movement (`zebra_move`):**
    - Correlated random walk using `wander` with turn amplitude restricted to `35.0` degrees.
  - **Grazing (`graze` -> `eat_biomass`):**
    - Identifies current cell: `current_cell <- my_CA(location)`.
    - If `current_cell != nil` and `current_cell.biomass > 0.0`:
      - Intake: $\Delta = \min(\text{current\_cell.biomass}, \text{bite\_size})$.
      - Depletion: $\text{current\_cell.biomass} \leftarrow \text{current\_cell.biomass} - \Delta$.
- **Visualization:**
  - Textured sprite (`zebra.png`) with render size `5.0`.

### 2.2 Predator Agent: `lions`
- **Capabilities & Skills:** `[moving]`
- **Attributes:**
  - `speed` (float): Base displacement rate (default: `1.2`).
  - `kill_range` (float, parameter): Predation proximity threshold (default: `1.0`).
- **Behaviors & Reflexes:**
  - **Movement & Foraging (`lion_move`):**
    - Random search walk via `wander` with wide turn amplitude (`60.0` degrees).
  - **Predation & Kill Interaction:**
    - Proximity scan: Targets in range $N = \{ z \in \text{zebra} \mid \text{distance\_to}(z, \text{self}) < \text{kill\_range} \}$.
    - If $|N| > 0$: selects one target $z^* \in N$ and invokes `ask z* { do die; }`.
- **Visualization:**
  - Textured sprite (`lion.png`) with render size `5.0`.

---

## 3. Global Orchestration & Execution Flow

### 3.1 Step Execution Sequence
Per simulation step ($t \to t+1$), scheduled phases execute in strict order:
1. **Grid Update Phase:** Each `my_CA` cell evaluates `grass_growth`.
2. **Herbivore Phase:**
   - Each `zebra` agent invokes `zebra_move`.
   - Each `zebra` agent invokes `graze` (`eat_biomass`).
3. **Predator Phase:**
   - Each `lion` agent executes `lion_move`.
   - In-range predation checks are evaluated; consumed zebras are purged from the model.
4. **Output & Render Phase:** Display views, monitors, and inspection panels are refreshed.

---

## 4. Experiment & Parameter Configuration

### 4.1 Global Setup (`global`)
- Initial population counts:
  - `nb_lions`: `20`
  - `nb_zebras`: `20`
- Resource assets:
  - Localized relative paths for `lion.png` and `zebra.png` (within `includes/`).

### 4.2 GUI Experiment (`main_experiment`)
- **Type:** `gui`
- **Inspectable Parameters:**
  - Initial population numbers (`nb_lions`, `nb_zebras`).
  - Biomass parameters (`growth_rate`, `bite_size`, `kill_range`).
- **Display Layer Stack (`map`):**
  1. `species my_CA aspect: default;` (Bottom layer: environmental raster)
  2. `species lions aspect: default;` (Top layer: predator agents)
  3. `species zebra aspect: default;` (Middle layer: prey agents)
