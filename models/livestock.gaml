model Livestock

global {
    int nb_cows <- 5;
    int nb_sheep <- 3;
    int nb_goats <- 2;

    init {
        create cow number: nb_cows {
            speed <- 2.0;
        }
        create sheep number: nb_sheep {
            speed <- 1.0;
        }
        create goat number: nb_goats {
            speed <- 0.5;
        }
    }
}

species cow skills: [moving] {
    reflex cow_move {
        do wander speed: speed amplitude: 90.0;
    }

    aspect action_neighbourhood {
        draw circle(speed) intersection cone(int(heading - 45), int(heading + 45)) color: rgb(0, 0, 0, 50) border: #black;
    }

    aspect default {
        draw square(1.5) color: #black;
    }
}

species sheep skills: [moving] {
    reflex sheep_move {
        do move speed: speed heading: 90.0;
    }

    aspect action_neighbourhood {
        draw circle(speed) color: rgb(255, 191, 0, 50) border: rgb(255, 191, 0);
        draw line([location, {location.x, location.y + speed}]) color: rgb(255, 191, 0);
    }

    aspect default {
        draw ellipse(1.0, 0.6) color: rgb(255, 191, 0);
    }
}

species goat skills: [moving] {
    reflex goat_move {
        do goto target: {0, 0} speed: speed;
    }

    aspect action_neighbourhood {
        draw circle(speed) color: rgb(128, 128, 128, 50) border: #grey;
        draw line([location, {0, 0}]) color: #grey;
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
            species cow aspect: action_neighbourhood;
            species sheep aspect: action_neighbourhood;
            species goat aspect: action_neighbourhood;
            species cow aspect: default;
            species sheep aspect: default;
            species goat aspect: default;
        }
    }
}
