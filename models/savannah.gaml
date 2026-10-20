/**
* Name: Savannah
* Description: Savannah ABM – lions, zebras, and grass on a grid.
* Tags: grid, abm
*/

model Savannah

global {
    // world size matches the grid dimensions
    int grid_size <- 100;
}

grid savannah_cell width: 100 height: 100 {
}

experiment Main type: gui {
    output {
    }
}
