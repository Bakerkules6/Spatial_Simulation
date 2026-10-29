/**
 * Name: Savannah
 * Description: Savannah ABM with dynamic energy tracking, metabolism, configurable predation kill distance, and monitoring charts.
 */

model Savannah

global {
    // Population parameters
    int initial_nb_zebras <- 20;
    int initial_nb_lions <- 20;
    list<int> age_list <- [];

    // Metabolic and predation parameters
    float lion_initial_energy <- 10.0;
    float lion_move_energy_loss <- 0.2;
    float lion_kill_energy_gain <- 5.0;
    float kill_distance <- 2.0;

    float zebra_initial_energy <- 10.0;
    float zebra_move_energy_loss <- 0.1;
    float bite_size <- 1.0;

    // Asset icons
    image zebra_image <- image("../includes/zebra.png");
    image lion_image <- image("../includes/lion.png");

    init {
        create zebra number: initial_nb_zebras {
            speed <- 1.0;
            energy <- zebra_initial_energy;
        }
        create lion number: initial_nb_lions {
            speed <- 1.2;
            energy <- lion_initial_energy;
            add age to: age_list;
        }
    }

    reflex report_ages {
        int nb_ages <- length(age_list);
        int min_age <- empty(age_list) ? 0 : min(age_list);
        float mean_age <- empty(age_list) ? 0.0 : mean(age_list);
        int max_age <- empty(age_list) ? 0 : max(age_list);
        write "Cycle " + cycle + " | Age list count: " + nb_ages + " | Min: " + min_age + " | Mean: " + (mean_age with_precision 2) + " | Max: " + max_age;
    }
}

species lion skills: [moving] {
    float energy;
    int age <- rnd(0, 60);

    reflex aging {
        remove age from: age_list;
        age <- age + 1;
        add age to: age_list;
    }

    reflex lion_move {
        do wander amplitude: 60.0;
        energy <- energy - lion_move_energy_loss;
        
        // Scan for prey within configurable kill distance
        list<zebra> nearby <- (zebra at_distance kill_distance) where (!dead(each));
        if (!empty(nearby)) {
            ask one_of(nearby) {
                do die;
            }
            energy <- energy + lion_kill_energy_gain;
        }

        // Starvation condition
        if (energy <= 0.0) {
            remove age from: age_list;
            do die;
        }
    }

    aspect default {
        draw lion_image size: 5;
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
        draw zebra_image size: 5;
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
    parameter "Initial Zebras" var: initial_nb_zebras min: 1 max: 100;
    parameter "Initial Lions" var: initial_nb_lions min: 1 max: 100;
    parameter "Lion Kill Distance" var: kill_distance min: 0.5 max: 10.0;
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

        display "Population Dynamics" type: 2d refresh: every(1 #cycle) {
            chart "Population Over Time" type: series {
                data "Zebras" value: length(zebra) color: #blue;
                data "Lions" value: length(lion) color: #orange;
            }
        }

        display "Energy Dynamics" type: 2d refresh: every(1 #cycle) {
            chart "Mean Energy Over Time" type: series {
                data "Mean Lion Energy" value: empty(lion) ? 0.0 : mean(lion collect each.energy) color: #orange;
                data "Mean Zebra Energy" value: empty(zebra) ? 0.0 : mean(zebra collect each.energy) color: #green;
            }
        }

        monitor "Zebras Alive" value: length(zebra);
        monitor "Lions Alive" value: length(lion);
        monitor "Age List Count" value: length(age_list);
        monitor "Min Lion Age" value: empty(age_list) ? 0 : min(age_list);
        monitor "Mean Lion Age" value: empty(age_list) ? 0.0 : (mean(age_list) with_precision 2);
        monitor "Max Lion Age" value: empty(age_list) ? 0 : max(age_list);
        monitor "Mean Lion Energy" value: empty(lion) ? 0.0 : (mean(lion collect each.energy) with_precision 2);
        monitor "Mean Zebra Energy" value: empty(zebra) ? 0.0 : (mean(zebra collect each.energy) with_precision 2);
        monitor "Mean Biomass" value: mean(my_CA collect each.biomass) with_precision 2;
    }
}
