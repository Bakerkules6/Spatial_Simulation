model Livestock

global {
    int nb_cows <- 5;
    int nb_sheep <- 3;
    int nb_goats <- 2;

    float fence_min <- 3.5;
    float fence_max <- 96.5;
    point pond_location <- {7.5, 7.5};
    float pond_radius <- 7.5;

    image fence_image <- image("../includes/fence.png");
    image pond_image <- image("../includes/pond.png");

    init {
        create cow number: nb_cows {
            speed <- 2.0;
            location <- {rnd(20.0, 90.0), rnd(20.0, 90.0)};
        }
        create sheep number: nb_sheep {
            speed <- 1.0;
            heading <- 90.0;
            location <- {rnd(20.0, 90.0), rnd(15.0, 90.0)};
        }
        create goat number: nb_goats {
            speed <- 0.5;
            location <- {rnd(25.0, 90.0), rnd(25.0, 90.0)};
        }
    }
}

species cow skills: [moving] {
    bool stopped <- false;

    reflex cow_move when: !stopped {
        if ((location distance_to pond_location) <= pond_radius) {
            stopped <- true;
            speed <- 0.0;
        } else {
            do wander speed: speed amplitude: 90.0;
            if (location.x <= fence_min or location.x >= fence_max or location.y <= fence_min or location.y >= fence_max) {
                location <- {min([fence_max, max([fence_min, location.x])]), min([fence_max, max([fence_min, location.y])])};
                heading <- mod(heading + 180.0, 360.0);
            }
            if ((location distance_to pond_location) <= pond_radius) {
                stopped <- true;
                speed <- 0.0;
            }
        }
    }

    aspect action_neighbourhood {
        if (!stopped) {
            draw circle(speed) intersection cone(int(heading - 45), int(heading + 45)) color: rgb(0, 0, 0, 50) border: #black;
        }
    }

    aspect default {
        draw square(1.5) color: #black;
    }
}

species sheep skills: [moving] {
    reflex sheep_move {
        do move speed: speed heading: heading;
        if (location.y >= fence_max) {
            location <- {location.x, fence_max};
            heading <- 270.0;
        } else if (location.y <= fence_min) {
            location <- {location.x, fence_min};
            heading <- 90.0;
        }
    }

    aspect action_neighbourhood {
        draw line([location, {location.x + speed * cos(heading), location.y + speed * sin(heading)}]) color: rgb(255, 191, 0);
    }

    aspect default {
        draw ellipse(1.0, 0.6) color: rgb(255, 191, 0);
    }
}

species goat skills: [moving] {
    bool stopped <- false;

    reflex goat_move when: !stopped {
        if ((location distance_to pond_location) <= (pond_radius + speed)) {
            stopped <- true;
            speed <- 0.0;
        } else {
            do goto target: {0, 0} speed: speed;
            if ((location distance_to pond_location) <= (pond_radius + speed)) {
                stopped <- true;
                speed <- 0.0;
            }
        }
    }

    aspect action_neighbourhood {
        if (!stopped) {
            float dist <- location distance_to {0, 0};
            point next_step <- (dist > speed) ? {location.x - (location.x / dist) * speed, location.y - (location.y / dist) * speed} : {0, 0};
            draw line([location, next_step]) color: #grey;
        }
    }

    aspect default {
        draw triangle(1.0) color: #grey;
    }
}

experiment main_experiment type: gui {
    parameter "Number of Cows" var: nb_cows min: 1 max: 50;
    parameter "Number of Sheep" var: nb_sheep min: 1 max: 50;
    parameter "Number of Goats" var: nb_goats min: 1 max: 50;

    output {
        display "Livestock Map" type: 2d {
            graphics "Background" transparency: 0.7 {
                draw world.shape color: rgb(144, 238, 144);
            }
            graphics "Environment Assets" {
                draw pond_image size: 15 at: pond_location;
                draw fence_image size: 106 at: {50, 50};
            }
            species cow aspect: action_neighbourhood;
            species sheep aspect: action_neighbourhood;
            species goat aspect: action_neighbourhood;
            species cow aspect: default;
            species sheep aspect: default;
            species goat aspect: default;
        }
    }
}
