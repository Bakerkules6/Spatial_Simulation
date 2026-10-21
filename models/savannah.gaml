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

    // amount of biomass a zebra consumes per cycle
    float bite_size <- 0.05;

    // toggle between image icons and simple shapes
    bool use_images <- true;

    // image files – loaded in init only when use_images is true
    file lion_icon;
    file zebra_icon;

    // ── milestone trackers ──
    // wall-clock timestamp at simulation start (ms)
    float start_time;

    // cycle and elapsed time (ms) when all zebras died
    int cycle_all_zebras_dead <- -1;
    float time_all_zebras_dead <- -1.0;

    // cycle and wall-clock time when biomass covers the whole grid
    int cycle_full_biomass <- -1;
    float time_full_biomass <- -1.0;

    init {
        start_time <- machine_time;
        if use_images {
            lion_icon <- file("../includes/lion.png");
            zebra_icon <- file("../includes/zebra.png");
        }
        create lion number: nb_lions;
        create zebra number: nb_zebras;
    }

    // ── milestone reflexes ──
    // record the moment all zebras are dead (fires once)
    reflex record_zebras_dead when: cycle_all_zebras_dead < 0 and empty(zebra) {
        cycle_all_zebras_dead <- cycle;
        time_all_zebras_dead <- machine_time - start_time;
    }

    // record the moment biomass covers the whole grid (fires once)
    reflex record_full_biomass when: cycle_full_biomass < 0 and (savannah_cell min_of each.biomass >= 1.0) {
        cycle_full_biomass <- cycle;
        time_full_biomass <- machine_time - start_time;
    }

    // pause/halt when both milestones have been reached
    reflex stop_sim when: cycle_all_zebras_dead >= 0 and cycle_full_biomass >= 0 {
        do pause;
    }
}

species lion skills: [moving] {
    // random initial position is the default for 'create'

    float size <- 3.0;

    reflex wander {
        // move to a random nearby location each cycle
        do wander amplitude: 90.0 speed: 1.0;
    }

    reflex hunt when: !empty(zebra) {
        // find zebras within kill_distance and kill one
        list<zebra> prey <- zebra at_distance kill_distance;
        if (!empty(prey)) {
            ask one_of(prey) {
                do die;
            }
        }
    }

    aspect default {
        if use_images and lion_icon != nil {
            draw lion_icon size: size;
        } else {
            draw circle(size) color: #orange;
        }
    }
}

species zebra skills: [moving] {
    float size <- 2.0;

    reflex eat {
        savannah_cell current_cell <- savannah_cell(location);
        if (current_cell != nil and current_cell.biomass > 0.0) {
            float eaten <- min(current_cell.biomass, bite_size);
            current_cell.biomass <- current_cell.biomass - eaten;
        }
    }

    reflex move {
        savannah_cell current_cell <- savannah_cell(location);
        if (current_cell != nil) {
            list<savannah_cell> richer_cells <- current_cell.neighbors where (each.biomass > current_cell.biomass);
            if (!empty(richer_cells)) {
                savannah_cell target_cell <- richer_cells with_max_of (each.biomass);
                do goto target: target_cell speed: 1.0;
            } else {
                do wander amplitude: 90.0 speed: 1.0;
            }
        } else {
            do wander amplitude: 90.0 speed: 1.0;
        }
    }

    aspect default {
        if use_images and zebra_icon != nil {
            draw zebra_icon size: size;
        } else {
            draw triangle(size) color: #grey;
        }
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
    parameter "Zebra bite size" var: bite_size min: 0.01 max: 0.5;
    parameter "Use image icons" var: use_images;

    output {
        display "Savannah" {
            grid savannah_cell;
            species lion;
            species zebra;
        }

        display "Charts" refresh: every(1 #cycle) {
            chart "Population & Biomass" type: series {
                data "Zebras alive" value: length(zebra) color: #grey;
                data "Mean biomass" value: mean(savannah_cell collect each.biomass) color: #green;
            }
        }

        monitor "Cycle" value: cycle;
        monitor "Elapsed time (ms)" value: machine_time - start_time;
        monitor "Zebras alive" value: length(zebra);
        monitor "Mean biomass" value: mean(savannah_cell collect each.biomass) with_precision 3;
    }
}


experiment Batch type: batch repeat: 5 until: (cycle_all_zebras_dead >= 0 and cycle_full_biomass >= 0) or cycle > 5000 {
    parameter "Kill distance" var: kill_distance among: [1.0, 2.0];

    // write one row per finished simulation run
    permanent {
        display "Batch results" refresh: every(1 #cycle) {
            chart "Cycles to all zebras dead" type: box_whisker {
                data "kill_distance" value: cycle_all_zebras_dead
                    categorized_by: kill_distance;
            }
        }
    }

    reflex save_results {
        ask simulations {
            save [
                int(self),
                kill_distance,
                cycle_all_zebras_dead,
                time_all_zebras_dead,
                cycle_full_biomass,
                time_full_biomass
            ] to: "../results/batch_results.csv" format: "csv" rewrite: false;
        }
    }
}
