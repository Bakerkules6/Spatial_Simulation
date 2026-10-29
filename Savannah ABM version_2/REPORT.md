# Simulating Tri-Trophic Savannah Dynamics: An Agent-Based Modeling Experiment in GAMA

**Author:** Spatial Simulation & Complex Systems Group  
**Target:** 1-Page Academic Summary (IMRaD Format)

---

## Abstract
This report documents the iterative design, implementation, and evaluation of a tri-trophic predator-prey-vegetation agent-based model (ABM) developed on the GAMA Platform. Through an AI-assisted, prompt-driven engineering workflow with strict version control, a baseline cellular automaton grid was progressively coupled with herbivore grazing (`zebra`) and carnivore predation (`lion`). The addition of explicit metabolic energy dynamics transformed an otherwise guaranteed extinction scenario into a nuanced ecological balance, demonstrating the necessity of bioenergetic constraints and highlighting best practices for agent-assisted simulation modeling.

---

## 1. Introduction
Understanding spatial-temporal self-organization in ecological systems requires explicit representations of individual interactions, local resource heterogeneity, and metabolic constraints. The objective of this study was to simulate a coupled predator-prey-grassland savannah ecosystem using the GAMA Platform. The system explores how local foraging behaviors, spatial predation, and energetic depletion dictate global population stability across three trophic levels: primary producers (vegetation biomass), primary consumers (zebras), and apex predators (lions).

---

## 2. Methods
The simulation was constructed using an incremental, specification-driven approach under Git version control:
- **Environment & Cellular Automaton (`my_CA`):** A 2D continuous space mapped to a discrete raster grid. Each cell holds dynamic biomass $B \in [0.0, 10.0]$ initialized uniformly via $U(0, 10)$, with constant logistic regrowth:
  $$\Delta B = \min(B_t + 0.1, 10.0)$$
- **Herbivore Species (`zebra`):** Agents execute correlated random walks (turn amplitude $35^\circ$, speed $1.0$). At each cycle, agents graze on their current cell (`my_CA(location)`), consuming $\Delta = \min(B, 1.0)$, decrementing local biomass, and incrementing their internal energy pool by $\Delta$. Movement expends $-0.1$ energy/step; agents starve if energy $\le 0$.
- **Predator Species (`lion`):** Agents forage via wider random search (amplitude $60^\circ$, speed $1.2$). When a live zebra is within Euclidean kill distance ($d \le 1.0$, indexed via spatial quadtree), the lion kills the prey (`do die`), gaining $+5.0$ energy units. Wandering expends $-0.2$ energy/step; lions perish upon reaching $\le 0$ energy.
- **Development Workflow:** Development proceeded iteratively across discrete prompt milestones: formal specification $\to$ grid CA environment $\to$ herbivore dynamics $\to$ carnivore predation $\to$ line-by-line semantic auditing $\to$ metabolic energy extensions. Each increment was validated and committed individually.

---

## 3. Results
1. **Baseline Dynamics (Without Energy Depletion):** In the unconstrained baseline model, lions functioned as immortal search-and-destroy automata. Because lion population was strictly preserved while zebras suffered monotonic predation without reproductive replenishment, zebras faced deterministic extinction within $150\text{--}300$ cycles. Following prey eradication, lion agents continued wandering perpetually, while vegetation rapidly saturated the entire grid to $B = 10.0$.
2. **Coupled Energy Dynamics:** Introducing metabolic costs and starvation conditions radically altered trophic trajectories:
   - **Predator Starvation Pressure:** High movement costs ($-0.2$/step) relative to capture rates enforced a finite hunting horizon. Inefficient search paths led to early lion starvation, alleviating grazing pressure on zebras.
   - **Prey-Vegetation Equilibrium:** Zebras that localized near high-biomass clusters maintained positive energy margins through continuous grazing ($+1.0$/step vs. $-0.1$ metabolic loss), surviving significantly longer and creating visible grazing depressions in the vegetation raster.
   - **Trophic Oscillations:** Dynamic monitors confirmed that population survival is governed by an energy trade-off: predator survival requires a critical prey density, while prey survival depends on spatial dispersion away from predator clusters and toward dense biomass patches.

---

## 4. Discussion & Critical Reflection
- **Semantic & Syntactic Divergence:** Comparative inspection between the student baseline (`African_savannah.gaml`) and the agent-generated architecture revealed critical discrepancies. The original script suffered from hardcoded absolute file paths, asymmetrical plural naming (`species lions` vs. `species zebra`), $O(N)$ linear distance scans, and fixed `square(1)` visual rendering. The refined implementation corrected these via relative URI fallbacks, singular OOP nomenclature, GAMA quadtree spatial queries (`at_distance`), and adaptive `draw shape` geometry.
- **Topological Casting:** Verification proved that GAMA’s `my_CA(location)` natively provides an exact, $O(1)$ spatial coordinate-to-grid mapping. However, boundary edge conditions require defensive `nil` checks to avert runtime null-pointer exceptions.
- **AI-Assisted ABM Development:** The step-by-step, prompt-driven paradigm paired with granular version control provided high transparency, preventing hallucinated architectural drift. LLM agents excel at refactoring, syntactic validation, and establishing bioenergetic scaffolds, but domain-specific verification of spatial primitives remains essential to ensure ecological realism.
