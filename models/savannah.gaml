/**
 * Name: Savannah
 * Description: Savannah ABM baseline model - Refactored for spatial indexing, singular species naming, and adaptive grid rendering.
 * Step: 4 - Refinements & Optimization
 */

model Savannah

global {
    file zebra_icon <- file_exists("../includes/zebra.png") ? file("../includes/zebra.png") : (file_exists("includes/zebra.png") ? file("includes/zebra.png") : nil);
    file lion_icon <- file_exists("../includes/lion.png") ? file("../includes/lion.png") : (file_exists("includes/lion.png") ? file("includes/lion.png") : nil);

    init {
        create zebra number: 20 {
            speed <- 1.0;
        }
        create lion number: 20 {
            speed <- 1.2;
        }
    }
}

species lion skills: [moving] {
    reflex lion_move {
        do wander amplitude: 60.0;
        list<zebra> nearby <- (zebra at_distance 1.0) where (!dead(each));
        if (!empty(nearby)) {
            ask one_of(nearby) {
                do die;
            }
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
        draw shape color: rgb(
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
            species lion aspect: default;
        }
    }
}
