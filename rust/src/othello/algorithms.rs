// algorithms.rs
#![allow(clippy::ptr_arg)]

use std::cmp::Ordering;

use rand::prelude::*;

use crate::othello::{evaluate::*, moves::*, Board};
use crate::util::values::{BOARD_SIZE, MAX_DEPTH};

pub trait Algorithm {
    fn alpha_beta(
        &mut self,
        alpha: f64, // set as mutables in the actual implementation below (could also be ints)
        beta: f64,  // set as mutables in the actual implementation below (could also be ints)
        color: i8,
        depth: usize,
        maxing: bool,
        debug: bool,
    ) -> isize;

    fn negamax(
        &mut self,
        alpha: f64, //set as mutables in the actual implementation below (could also be ints)
        beta: f64,  //set as mutables in the actual implementation below (could also be ints)
        color: i8,
        depth: usize,
        debug: bool,
    ) -> isize;

    // this is a default implementation that doesn't require a `self` call
    fn rng_move(moveset: &Vec<Move>, debug: bool) -> usize {
        let cells = get_cells(&moveset);
        let mut mv = rand::thread_rng().gen_range(0, BOARD_SIZE);

        if debug {
            println!("[rng_move] cell list: {:?}", &cells);
        }

        while !cells.contains(&mv) {
            mv = rand::thread_rng().gen_range(0, BOARD_SIZE);
        }
        mv
    }
}

impl Algorithm for Board {
    fn alpha_beta(
        &mut self,
        mut alpha: f64,
        mut beta: f64,
        color: i8,
        depth: usize,
        maxing: bool,
        debug: bool,
    ) -> isize {
        let mut score: isize; // does not need to be instantiated
        if debug {
            dbg!(
                "[alpha_beta] moves available: {} | depth = {}",
                self.generate_moves(color).len(),
                depth
            );
        }
        match depth.cmp(&MAX_DEPTH) {
            Ordering::Equal => {
                if debug {
                    dbg!("hit max depth ({})", MAX_DEPTH);
                }
                score = *calculate_scores_disc(self.clone()).score();
                if debug {
                    self.show();
                }
            }
            Ordering::Less => {
                match maxing {
                    true => {
                        score = isize::MIN;
                        let moveset = self.generate_moves(color);
                        // let list = &moveset[..];
                        let mut _counter = 0;
                        // for mv in list.iter() {
                        // better yet: use iterators directly
                        while _counter < moveset.len() {
                            let mv = moveset[_counter];
                            if debug {
                                dbg!("legal cell = {}", mv.cell);
                            }
                            let mut temp = self.clone();
                            temp.apply(color, mv.cell, debug);
                            temp.flip_discs(color, mv.cell, -mv.direction, debug);

                            let val =
                                temp.alpha_beta(alpha, beta, -color, depth + 1, !maxing, debug);
                            score = score.max(val);
                            alpha = alpha.max(score as f64);
                            if alpha >= beta {
                                break;
                            }
                            _counter += 1;
                        }
                    }
                    false => {
                        score = isize::MAX;
                        let moveset = self.generate_moves(color);
                        // let list = &moveset[..];
                        let mut _counter = 0;
                        // for mv in list.iter() {
                        // better yet: use iterators directly on the vector, and map the function below
                        while _counter < moveset.len() {
                            let mv = moveset[_counter];
                            if debug {
                                dbg!("legal cell = {}", mv.cell);
                            }
                            let mut temp = self.clone();
                            temp.apply(color, mv.cell, debug);
                            temp.flip_discs(color, mv.cell, -mv.direction, debug);

                            let val =
                                temp.alpha_beta(alpha, beta, -color, depth + 1, !maxing, debug);
                            score = score.min(val);
                            beta = beta.min(val as f64);
                            if alpha >= beta {
                                break;
                            }
                            _counter += 1;
                        }
                    }
                } // end match
            }
            Ordering::Greater => panic!("this should not be possible"),
        }
        score
    }

    fn negamax(
        &mut self,
        mut alpha: f64,
        beta: f64, // beta here does not need to be mutable
        color: i8,
        depth: usize,
        debug: bool,
    ) -> isize {
        let moveset = self.generate_moves(color);
        let mut score: isize = isize::MIN;

        if debug {
            dbg!(
                "[negamax] moves available: {} | depth = {}",
                moveset.len(),
                depth
            );
        }

        if depth == MAX_DEPTH {
            if debug {
                dbg!("hit max depth ({})", MAX_DEPTH);
            }
            score = *calculate_scores_disc(self.clone()).score();
            if debug {
                self.show();
            }
        } else {
            for mv in moveset {
                if debug {
                    dbg!("legal cell = {}", mv.cell);
                }

                let mut temp = self.clone();
                temp.apply(color, mv.cell, debug);
                temp.flip_discs(color, mv.cell, -mv.direction, debug);

                score = score.max(-temp.negamax(-beta, -alpha, -color, depth + 1, debug));
                alpha = alpha.max(score as f64);

                if alpha >= beta {
                    break;
                }
            }
        }

        score
    }
    // rng_move doesn't need to be implemented here
}
