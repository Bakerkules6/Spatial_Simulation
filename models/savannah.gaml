/**
 * Name: Savannah
 * Description: Step 2 - Adding zebra species with movement and grazing behavior.
 * Step: 2 - Zebras & Grazing
 */

model Savannah

global {
    file zebra_icon <- file_exists("../includes/zebra.png") ? file("../includes/zebra.png") : (file_exists("includes/zebra.png") ? file("includes/zebra.png") : nil);

    init {
        create zebra number: 20 {
            speed <- 1.0;
        }
    }
}

species zebra skills: [moving] {
    reflex zebra_move {
        do wander amplitude: 35.0;
    }

    action eat_biomass {
        my_CA current_cell <- my_CA(location);
        if (current_cell != nil and current_cell.biomass > 0.0) {
            float eaten <- min([current_cell.biomass, 1.0]);
            current_cell.biomass <- current_cell.biomass - eaten;
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
            species zebra aspect: default;
        }
    }
}
