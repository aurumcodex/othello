// lib.rs

// This Othello implementation uses Rust's `i8` data type for its 'Color' representation

pub mod othello;
pub mod util;

use std::any::type_name;
use std::error::Error;
use std::io;

use othello::{algorithms::Algorithm, bot::*, /*evaluate::*,*/ moves::*, player::*, Board};
use util::*;

#[derive(Debug)]
pub struct Opts {
    pub help: bool,
    pub version: bool,
    pub human: bool,
    pub debug: bool,
    pub algorithm: String,
}

// debugging only; will be removed
pub fn type_of<T>(_: T) -> &'static str {
    type_name::<T>()
}

pub fn run(/*mut*/ game: Board, options: Opts) -> Result<(), Box<dyn Error>> {
    // for (element, hash) in values::ROWS.iter() {
    //     println!(
    //         "{}: {}, {}: {}",
    //         type_of(*element),
    //         *element,
    //         type_of(*hash),
    //         *hash
    //     );
    // }

    // if let x = *values::ROWS.get("1").unwrap() {
    //     println!("{} {}", type_of(x), x);
    // }

    if options.help {
        print_help()
    } else if options.version {
        print_verison()
    } else {
        play_othello(game, options.human, options.debug)
    }
}

fn play_othello(mut game: Board, human: bool, debug: bool) -> Result<(), Box<dyn Error>> {
    let mut turn_count = 0_usize;
    let mut _move = 0_usize;
    let mut input = String::from("");

    loop {
        println!("what color do you want to play as? (black or white)");
        io::stdin().read_line(&mut input)?;
        match input.trim() {
            "B" | "b" | "black" => {
                println!("player will be set up as black");
                game.setup(values::BLACK, debug);
                break;
            }
            "W" | "w" | "white" => {
                println!("player will be set up as white");
                game.setup(values::WHITE, debug);
                break;
            }
            "Q" | "q" | "quit" => {
                println!("quitting...");
                std::process::exit(1)
            }
            _ => {
                println!("didn't get a vaild input; please re-enter");
                continue;
            }
        }
    } // end input setup validation loop

    let mut current_player = game.player().color;
    'main: loop {
        let mut movelist: Vec<Move> = Vec::new();
        let mut cells: Vec<usize> = Vec::new();

        println!("turn count is: {}", turn_count);

        if current_player == values::BLACK {
            println!("player black's turn");
            println!(
                "player passing: {}, bot passing: {}",
                game.player().passing,
                game.bot().passing
            );

            movelist.clear();
            cells.clear();
            movelist = game.generate_moves(game.player().color);

            game.display(&movelist);

            println!("legal moves:");
            for mv in &movelist {
                mv.print(current_player);
                cells.push(mv.cell);
            }

            println!("{:?}", cells);

            if movelist.is_empty() {
                println!("player has no moves and must pass");
                game.get_pass_input();
            } else {
                _move = game.player().get_input(cells, human);
                game.apply(game.player().color, _move, debug);

                for mv in movelist {
                    if mv.cell == _move {
                        game.flip_discs(game.player().color, mv.cell, -mv.direction, debug);
                    }
                }
            }
        } else if current_player == values::WHITE {
            println!("player white's turn");

            movelist.clear();
            cells.clear();
            movelist = game.generate_moves(game.bot().color);

            game.display(&movelist);

            println!("legal moves:");
            for mv in &movelist {
                mv.print(current_player);
                cells.push(mv.cell);
            }

            if movelist.is_empty() {
                println!("bot has to pass");
                if !game.player().passing {
                    game.player_mut().passing = true;
                } else {
                    game.bot_mut().passing = true;
                }
            } else {
                _move = game.bot().make_move(
                    &movelist,
                    game.clone(),
                    turn_count,
                    MoveType::AlphaBeta,
                    debug,
                );

                if !cells.contains(&_move) {
                    println!("bot made an odd move; using rng fallback");
                    _move = Board::rng_move(&movelist, debug);
                }

                println!(
                    "bot generated move: {} {} {} | cell: {}",
                    game.bot().color,
                    procs::get_col(_move),
                    procs::get_row(_move),
                    _move
                );
                game.apply(game.bot().color, _move, debug);

                for mv in movelist {
                    if mv.cell == _move {
                        game.flip_discs(game.bot().color, mv.cell, -mv.direction, debug);
                    }
                }
            }
        }

        if game.is_game_over() {
            println!("ending game");
            break 'main;
        } else {
            current_player *= -1;
            turn_count += 1;
        }
    }

    Ok(())
}

fn print_help() -> Result<(), Box<dyn Error>> {
    println!("{}", &HELP);
    std::process::exit(0);
}

fn print_verison() -> Result<(), Box<dyn Error>> {
    println!("othello_rs - version: {}", values::VERSION);
    std::process::exit(0);
}
