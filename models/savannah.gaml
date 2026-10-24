/**
 * Name: Savannah
 * Description: Savannah ABM with dynamic energy tracking, metabolism, and predation energetics for both lions and zebras.
 * Step: 6 - Energy Dynamics & Population Monitoring
 */

model Savannah

global {
    // Parameter definitions
    int initial_nb_zebras <- 20;
    int initial_nb_lions <- 20;

    float lion_initial_energy <- 10.0;
    float lion_move_energy_loss <- 0.2;
    float lion_kill_energy_gain <- 5.0;

    float zebra_initial_energy <- 10.0;
    float zebra_move_energy_loss <- 0.1;
    float bite_size <- 1.0;

    // Asset icons with safe fallback
    file zebra_icon <- file_exists("../includes/zebra.png") ? file("../includes/zebra.png") : (file_exists("includes/zebra.png") ? file("includes/zebra.png") : nil);
    file lion_icon <- file_exists("../includes/lion.png") ? file("../includes/lion.png") : (file_exists("includes/lion.png") ? file("includes/lion.png") : nil);

    init {
        create zebra number: initial_nb_zebras {
            speed <- 1.0;
            energy <- zebra_initial_energy;
        }
        create lion number: initial_nb_lions {
            speed <- 1.2;
            energy <- lion_initial_energy;
        }
    }
}

species lion skills: [moving] {
    float energy;

    reflex lion_move {
        do wander amplitude: 60.0;
        energy <- energy - lion_move_energy_loss;
        
        // Scan for prey within kill distance
        list<zebra> nearby <- (zebra at_distance 1.0) where (!dead(each));
        if (!empty(nearby)) {
            ask one_of(nearby) {
                do die;
            }
            energy <- energy + lion_kill_energy_gain;
        }

        // Starvation condition
        if (energy <= 0.0) {
            do die;
        }
    }

    aspect default {
        if (lion_icon != nil) {
            draw lion_icon size: 5;
        } else {
            draw circle(2) color: #orange;
        }
    }
}

species zebra skills: [moving] {
    float energy;

    reflex zebra_move {
        do wander amplitude: 35.0;
        energy <- energy - zebra_move_energy_loss;

        // Starvation condition
        if (energy <= 0.0) {
            do die;
        }
    }

    action eat_biomass {
        my_CA current_cell <- my_CA(location);
        if (current_cell != nil and current_cell.biomass > 0.0) {
            float eaten <- min([current_cell.biomass, bite_size]);
            current_cell.biomass <- current_cell.biomass - eaten;
            energy <- energy + eaten;
        }
    }

    reflex graze {
        do eat_biomass;
    }

    aspect default {
        if (zebra_icon != nil) {
            draw zebra_icon size: 5;
        } else {
            draw triangle(2) color: #grey;
        }
    }
}

grid my_CA {
    float biomass <- rnd(0.0, 10.0);

    reflex grass_growth {
        biomass <- min([biomass + 0.1, 10.0]);
    }

    aspect default {
        draw shape color: rgb(
            100 - int(biomass * 7),
            220 - int(biomass * 10),
            80 - int(biomass * 5),
            160
        );
    }
}

experiment main_experiment type: gui {
    parameter "Initial Zebras" var: initial_nb_zebras min: 1 max: 100;
    parameter "Initial Lions" var: initial_nb_lions min: 1 max: 100;
    parameter "Lion Initial Energy" var: lion_initial_energy min: 1.0 max: 50.0;
    parameter "Lion Move Energy Cost" var: lion_move_energy_loss min: 0.05 max: 2.0;
    parameter "Lion Kill Energy Gain" var: lion_kill_energy_gain min: 1.0 max: 20.0;
    parameter "Zebra Initial Energy" var: zebra_initial_energy min: 1.0 max: 50.0;
    parameter "Zebra Move Energy Cost" var: zebra_move_energy_loss min: 0.01 max: 1.0;
    parameter "Zebra Bite Size" var: bite_size min: 0.1 max: 5.0;

    output {
        display "Map" {
            species my_CA aspect: default;
            species zebra aspect: default;
            species lion aspect: default;
        }

        display "Population Dynamics" refresh: every(1 #cycle) {
            chart "Population Over Time" type: series {
                data "Zebras" value: length(zebra) color: #blue;
                data "Lions" value: length(lion) color: #orange;
            }
        }

        display "Energy Dynamics" refresh: every(1 #cycle) {
            chart "Mean Energy Over Time" type: series {
                data "Mean Lion Energy" value: empty(lion) ? 0.0 : mean(lion collect each.energy) color: #orange;
                data "Mean Zebra Energy" value: empty(zebra) ? 0.0 : mean(zebra collect each.energy) color: #green;
            }
        }

        monitor "Zebras Alive" value: length(zebra);
        monitor "Lions Alive" value: length(lion);
        monitor "Mean Lion Energy" value: empty(lion) ? 0.0 : (mean(lion collect each.energy) with_precision 2);
        monitor "Mean Zebra Energy" value: empty(zebra) ? 0.0 : (mean(zebra collect each.energy) with_precision 2);
        monitor "Mean Biomass" value: mean(my_CA collect each.biomass) with_precision 2;
    }
}
