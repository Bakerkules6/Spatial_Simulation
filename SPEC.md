# Savannah ABM Specification

Purpose: Become familiar with GAMA's object-oriented style and estimate (a) how long lions need to kill all zebras and (b) how long the grass (biomass) needs to cover the whole area.

Environment: A square grid of cells (assumption: 100x100). Each cell has a biomass value between 0 and 1 and a colour from light to dark green. Biomass grows by a fixed rate per cycle and spreads like a cellular automaton from neighbouring cells.

Agents:
- 20 lions, drawn as orange circles of size 3, moving randomly.
- 20 zebras, drawn as grey triangles of size 2, moving randomly.
Both are placed at random positions at initialisation.

Interaction: When a zebra is within a kill distance (parameter, default 3.0 units) of a lion, the lion kills it and the zebra is removed.

Stop condition: The simulation pauses when no zebras remain and the biomass covers the whole grid.

Outputs: Cycle count, elapsed time, number of zebras alive, and mean biomass, shown in a display and a chart.

Parameters to expose: number of lions, number of zebras, kill distance, biomass growth rate.

Extension (Step 4, not for now): Zebras eat grass. Lions gain energy by eating zebras and lose energy when moving.

Acceptance criteria per feature: the model runs without errors, and the behaviour matches the description above.
