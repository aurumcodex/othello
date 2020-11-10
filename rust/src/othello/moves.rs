// moves.rs
#![allow(clippy::ptr_arg)]

use crate::util::{procs::*, values::*};

#[derive(Copy, Clone, Debug, Default)]
pub struct Move {
    pub cell: usize,
    pub num_flips: isize,
    pub direction: isize,
}

pub trait Movelist {
    fn get_legal_move(&self, index: isize, dir: isize, color: i8) -> Move;

    fn generate_moves(&self, color: i8) -> Vec<Move>;
}

impl Move {
    pub fn is_border(&self) -> bool {
        if LEFT_BORDER.contains(&self.cell) {
            matches!(-self.direction, WEST | N_WEST | S_WEST)
        } else if RIGHT_BORDER.contains(&self.cell) {
            matches!(-self.direction, EAST | N_EAST | S_EAST)
        } else {
            false
        }
    }

    pub fn get_weight(&self) -> isize {
        WEIGHTS[self.cell]
    }

    pub fn print(&self, color: i8) {
        print!(
            "{} {} {} (cell: {}) | ",
            get_color(color),
            get_col(self.cell),
            get_row(self.cell),
            self.cell
        );
        print!("num flips: {} | ", self.num_flips);
        println!(
            "direction: {}",
            match DIR_MAP.get(&-self.direction) {
                Some(x) => *x,
                None => "",
            }
        );
    }
}

pub fn check_wall(cell: usize, dir: isize) -> bool {
    match dir {
        EAST => match RIGHT_BORDER.contains(&(cell as usize)) {
            true => true,
            false => false,
        },
        WEST => match LEFT_BORDER.contains(&cell) {
            true => true,
            false => false,
        },
        N_EAST => match RIGHT_BORDER.contains(&cell) || TOP_BORDER.contains(&cell) {
            true => true,
            false => false,
        },
        N_WEST => match LEFT_BORDER.contains(&cell) || TOP_BORDER.contains(&cell) {
            true => true,
            false => false,
        },
        S_EAST => match RIGHT_BORDER.contains(&cell) || BOTTOM_BORDER.contains(&cell) {
            true => true,
            false => false,
        },
        S_WEST => match LEFT_BORDER.contains(&cell) || BOTTOM_BORDER.contains(&cell) {
            true => true,
            false => false,
        },
        _ => false,
    }
}

pub fn get_cells(moveset: &Vec<Move>) -> Vec<usize> {
    let mut cells: Vec<usize> = Vec::new();

    for m in moveset {
        cells.push(m.cell);
    }

    cells
}
