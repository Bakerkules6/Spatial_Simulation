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

grid savannah_cell width: 100 height: 100 {
}

experiment Main type: gui {
    parameter "Number of lions" var: nb_lions min: 1 max: 100;
    parameter "Number of zebras" var: nb_zebras min: 1 max: 100;

    output {
        display "Savannah" {
            grid savannah_cell;
            species lion;
            species zebra;
        }
    }
}
