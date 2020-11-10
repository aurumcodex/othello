// bot.rs
#![allow(clippy::ptr_arg)]

use std::collections::HashMap;

// use rand::prelude::*;

use crate::othello::{algorithms::Algorithm, moves::Move, player::Player, Board};

pub enum MoveType {
    Auto, // automatically decide which move type would be best to use at current state
    RNG,
    AlphaBeta, // fail-soft enabled or disabled (to be determined)
    Negamax,
    // MTDf, // may or may not be added in the future
}

pub trait Bot {
    fn make_move(
        &self,
        moveset: &Vec<Move>,
        game: Board,
        _turn_count: usize,
        move_type: MoveType, // made mutable in implementation(?)
        debug: bool,
    ) -> usize;
}

// #[cfg(feature = "sequential")]
impl Bot for Player {
    fn make_move(
        &self,
        moveset: &Vec<Move>,
        game: Board,
        _turn_count: usize,
        move_type: MoveType,
        debug: bool,
    ) -> usize {
        // let mut rng = rand::
        let mut best_move = usize::MAX;
        let depth = 0;
        let maxing = true;
        let alpha = f64::MIN;
        let beta = f64::MAX;
        let color = self.color;

        // let moveset = game.generate_move()
        let mut _used_move = move_type;

        // match rand::thread_rng().gen_range(0, 20) {
        //     0..=4 => _used_move = MoveType::RNG,
        //     5..=9 => _used_move = MoveType::AlphaBeta,
        //     10..=14 => _used_move = MoveType::Negamax,
        //     _ => _used_move = MoveType::RNG,
        // }

        match _used_move {
            MoveType::Auto => {
                // implement recursive calls?
                unimplemented!();
            }
            MoveType::RNG => {
                println!("bot is using a random move");
                best_move = Board::rng_move(&moveset, debug);
            }
            MoveType::AlphaBeta => {
                println!("bot is using a move generated from alpha_beta");
                let mut ab_hash: HashMap<usize, isize> = HashMap::new();
                let list = &moveset[..];
                // think about making this a while loop for the time being
                // better yet: use iterators directly
                for mv in list.iter() {
                    let mut temp = game.clone();
                    temp.apply(color, mv.cell, debug);
                    temp.flip_discs(color, mv.cell, -mv.direction, debug);

                    let ab_score = temp.alpha_beta(alpha, beta, -color, depth, !maxing, debug);

                    println!("[alpha_beta] output at cell: {} :: {}", mv.cell, ab_score);
                    ab_hash.insert(mv.cell, ab_score);
                }

                // if debug {
                println!("alpha_beta output: {:?}", ab_hash);
                // }

                let mut max = 0;
                for (key, val) in ab_hash {
                    if val > max {
                        max = val;
                        best_move = key;
                    }
                }
            }
            MoveType::Negamax => {
                println!("bot is using a move generated from negamax");
                let mut nm_hash: HashMap<usize, isize> = HashMap::new();

                for mv in moveset {
                    let mut temp = game.clone();
                    temp.apply(color, mv.cell, debug);
                    temp.flip_discs(color, mv.cell, -mv.direction, debug);

                    let nm_score = temp.negamax(alpha, beta, -color, depth, debug);

                    println!("[negamax] output at cell: {} :: {}", mv.cell, nm_score);
                    nm_hash.insert(mv.cell, nm_score);
                }

                // if debug {
                println!("alpha_beta output: {:?}", nm_hash);
                // }

                let mut max = 0;
                for (key, val) in nm_hash {
                    if val > max {
                        max = val;
                        best_move = key;
                    }
                }
            }
        }

        best_move
    }
}

// #[cfg(feature = "parallel")]
// impl Bot for Player {
//     fn make_move(&self, _game: Board, _turn_count: usize, _debug: bool) -> usize {
//         // let mut rng = rand::
//         let mut _best_move = usize::MAX;
//         let _depth = 0;
//         let _maxing = true;
//         let _alpha = f64::MIN;
//         let _beta = f64::MAX;
//         let _color = self.color;

//         let mut _move_type = MoveType::Auto;

//         9999
//     }
// }

// helper functions (these need to be implemented parallel style and sequential)
// dummy functions for now
fn _generate_alpha_beta_move(_game: Board, _alpha: f64, _beta: f64) -> usize {
    999
}
// dummy functions for now
fn _generate_negamax_move(_game: Board, _alpha: f64, _beta: f64) -> usize {
    999
}

// fn generate_mtdf_move(game: Board, alpha: f64, beta: f64) {}
