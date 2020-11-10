// evaluate.rs

use std::cmp::Ordering;

use crate::othello::Board;
use crate::util::values::*;

pub struct Scores {
    black: isize,
    white: isize,
    score: isize,
}

impl Scores {
    pub fn black(&self) -> &isize {
        &self.black
    }
    pub fn white(&self) -> &isize {
        &self.white
    }
    pub fn score(&self) -> &isize {
        &self.score
    }
}

pub fn calculate_scores_disc(board: Board) -> Scores {
    let mut black_count = 0;
    let mut white_count = 0;

    for cell in board.board.iter() {
        match *cell {
            BLACK => black_count += 1,
            WHITE => white_count += 1,
            _ => {}
        }
    }

    Scores {
        black: black_count,
        white: white_count,
        score: black_count - white_count,
    }
}

pub fn calculate_scores_weight(board: Board) -> Scores {
    let mut black_count = 0;
    let mut white_count = 0;

    for (i, cell) in board.board.iter().enumerate() {
        match *cell {
            BLACK => black_count += WEIGHTS[i],
            WHITE => white_count += WEIGHTS[i],
            _ => {}
        }
    }

    Scores {
        black: black_count,
        white: white_count,
        score: black_count - white_count,
    }
}

pub fn print_results(s: Scores) {
    match s.black.cmp(&s.white) {
        Ordering::Greater => {
            println!("player black wins.");
            println!("black pieces: {}", s.black);
            println!("white pieces: {}", s.white);
        }
        Ordering::Less => {
            println!("player white wins.");
            println!("black pieces: {}", s.black);
            println!("white pieces: {}", s.white);
        }
        Ordering::Equal => {
            println!("a tie occurred.");
            println!("black pieces: {}", s.black);
            println!("white pieces: {}", s.white);
        }
    }
}
