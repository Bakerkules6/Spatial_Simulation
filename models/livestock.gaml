model Livestock

global {
    int nb_cows <- 5;
    int nb_sheep <- 3;
    int nb_goats <- 2;

    init {
        create cow number: nb_cows;
        create sheep number: nb_sheep;
        create goat number: nb_goats;
    }
}

species cow {
    aspect default {
        draw square(3.0) color: #black;
    }
}

species sheep {
    aspect default {
        draw ellipse(3.0, 1.8) color: #amber;
    }
}

species goat {
    aspect default {
        draw triangle(2.5) color: #grey;
    }
}

experiment main_experiment type: gui {
    parameter "Number of Cows" var: nb_cows min: 1 max: 50;
    parameter "Number of Sheep" var: nb_sheep min: 1 max: 50;
    parameter "Number of Goats" var: nb_goats min: 1 max: 50;

    output {
        display "Livestock Map" type: 2d {
            species cow aspect: default;
            species sheep aspect: default;
            species goat aspect: default;
        }
    }
}
