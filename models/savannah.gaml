/**
* Name: Savannah
* Description: Savannah ABM – lions, zebras, and grass on a grid.
* Tags: grid, abm
*/

model Savannah

global {
    // world size matches the grid dimensions
    int grid_size <- 100;

    // number of lions to create
    int nb_lions <- 20;

    // number of zebras to create
    int nb_zebras <- 20;

    // distance within which a lion kills a zebra
    float kill_distance <- 2.0;

    // rate at which biomass grows per cycle
    float biomass_growth_rate <- 0.01;

    // fraction of neighbour biomass that spreads each cycle
    float biomass_spread_rate <- 0.05;

    init {
        create lion number: nb_lions;
        create zebra number: nb_zebras;
    }
}

species lion {
    // random initial position is the default for 'create'

    float size <- 3.0;

    reflex wander {
        // move to a random nearby location each cycle
        do wander amplitude: 90.0 speed: 1.0;
    }

    reflex hunt when: !empty(zebra) {
        // find all zebras within kill_distance and kill them
        list<zebra> prey <- zebra at_distance kill_distance;
        ask prey {
            do die;
        }
    }

    aspect default {
        draw circle(size) color: #orange;
    }
}

species zebra {
    float size <- 2.0;

    reflex wander {
        do wander amplitude: 90.0 speed: 1.0;
    }

    aspect default {
        draw triangle(size) color: #grey;
    }
}

grid savannah_cell width: 100 height: 100 neighbors: 8 {
    // biomass value between 0 and 1
    float biomass <- rnd(0.0, 0.2) min: 0.0 max: 1.0;

    // colour from light to dark green based on biomass
    rgb color <- rgb(int(255 * (1 - biomass)), 255, int(255 * (1 - biomass))) update: rgb(int(255 * (1 - biomass)), 255, int(255 * (1 - biomass)));

    reflex grow {
        // intrinsic growth
        biomass <- biomass + biomass_growth_rate;

        // spreading: gain a fraction of the mean neighbour biomass
        float mean_neighbor_biomass <- mean(neighbors collect (each.biomass));
        biomass <- biomass + biomass_spread_rate * (mean_neighbor_biomass - biomass);

        // clamp to [0, 1]
        biomass <- min(1.0, max(0.0, biomass));
    }
}

experiment Main type: gui {
    parameter "Number of lions" var: nb_lions min: 1 max: 100;
    parameter "Number of zebras" var: nb_zebras min: 1 max: 100;
    parameter "Kill distance" var: kill_distance min: 0.5 max: 10.0;
    parameter "Biomass growth rate" var: biomass_growth_rate min: 0.001 max: 0.1;
    parameter "Biomass spread rate" var: biomass_spread_rate min: 0.01 max: 0.2;

    output {
        display "Savannah" {
            grid savannah_cell;
            species lion;
            species zebra;
        }
    }
}
