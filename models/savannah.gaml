/**
 * Name: Savannah
 * Description: Model skeleton with dynamic biomass and regrowth in a cellular automaton grid.
 * Step: 1 - Grid Environment CA
 */

model Savannah

global {
    init {
        // Initialization logic for future agents will be placed here
    }
}

grid my_CA {
    float biomass <- rnd(0.0, 10.0);

    reflex grass_growth {
        biomass <- min([biomass + 0.1, 10.0]);
    }

    aspect default {
        draw square(1) color: rgb(
            100 - int(biomass * 7),
            220 - int(biomass * 10),
            80 - int(biomass * 5),
            160
        );
    }
}

experiment main_experiment type: gui {
    output {
        display map {
            species my_CA aspect: default;
        }
    }
}
