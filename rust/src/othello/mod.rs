// (othello) mod.rs
#![allow(clippy::ptr_arg)]

pub mod algorithms;
pub mod bot;
pub mod evaluate;
pub mod moves;
pub mod player;
pub mod types;

use std::io;

use crate::util::{procs::*, values::*};

// use algorithms::*;
use moves::*;
use player::*;

#[derive(Clone, Debug)]
pub struct Board {
    player: Player,
    bot: Player,
    board: [i8; BOARD_SIZE],
    game_over: bool,
}

impl Default for Board {
    fn default() -> Self {
        Board {
            player: Player::new(),
            bot: Player::new(),
            board: [NONE; BOARD_SIZE],
            game_over: false,
        }
    }
}

impl Board {
    pub fn new() -> Board {
        Board::default()
    } // generate new, default board

    pub fn setup(&mut self, color: i8, debug: bool) {
        self.player = Player::init(color, true);
        self.bot = Player::init(-color, false);

        if debug {
            println!(
                "player set up as {}; bot set up as {}",
                get_color(self.player.color),
                get_color(self.bot.color)
            );
        }

        self.board[27] = WHITE;
        self.board[28] = BLACK;
        self.board[35] = BLACK;
        self.board[36] = WHITE;
    } // setup board via modifying variables

    pub fn apply(&mut self, color: i8, cell: usize, debug: bool) {
        if self.board[cell] == NONE {
            if debug {
                dbg!("applying move at cell: {}", cell);
                dbg!("cell is currently: {}", self.board[cell]);
            }

            self.board[cell] = color;

            if debug {
                dbg!("cell is now: {}", self.board[cell]);
            }
        }
    } // apply a move at a given cell

    pub fn flip_discs(&mut self, color: i8, cell: usize, dir: isize, debug: bool) {
        let mut temp = cell as isize;

        while temp >= 0 && temp < BOARD_SIZE as isize {
            temp += dir;

            if debug {
                println!("cell is: {}", temp);
            }

            if temp < 64 {
                if self.board[temp as usize] == color {
                    break;
                } else {
                    self.board[temp as usize] = color;
                }
            }
        }
    } // flips discs on the board

    // this is for printing out the board *with* all the available moves on it.
    // #[cfg(feature = "ascii")]
    pub fn display(&self, moveset: &Vec<Move>) {
        let cells = get_cells(&moveset);

        println!(
            "bot is {} | player is {}",
            get_color(self.bot.color),
            get_color(self.player.color)
        );
        println!("  ._a_b_c_d_e_f_g_h_");
        for (index, cell) in self.board.iter().enumerate() {
            if index % 8 == 0 {
                print!(" {}|", get_row(index));
            }
            if cells.contains(&index) {
                print_char(index, *cell, "+");
                continue;
            } else {
                print_char(index, *cell, get_color(*cell));
            }
        }
    } // shows board with moves for reference

    // this one is a printing function that just shows the board, without any moves on it.
    // #[cfg(feature = "ascii")]
    pub fn show(&self) {
        println!(
            "bot is {} | player is {}",
            get_color(self.bot.color),
            get_color(self.player.color)
        );
        println!("  ._a_b_c_d_e_f_g_h_");
        for (index, cell) in self.board.iter().enumerate() {
            if index % 8 == 0 {
                print!(" {}|", get_row(index));
                print_char(index, *cell, get_color(*cell));
                continue;
            } else {
                print_char(index, *cell, get_color(*cell));
            }
        }
    } // shows board as is - with no moves

    pub fn is_game_over(&self) -> bool {
        self.player.passing && self.bot.passing
    } // check if the game is over

    // getters / setters (may or may not need these)
    // immutables
    pub fn player(&self) -> &Player {
        &self.player
    }

    pub fn bot(&self) -> &Player {
        &self.bot
    }

    pub fn board(&self) -> &[i8; BOARD_SIZE] {
        &self.board
    }
    // mutables
    pub fn player_mut(&mut self) -> &mut Player {
        &mut self.player
    }

    pub fn bot_mut(&mut self) -> &mut Player {
        &mut self.bot
    }

    pub fn board_mut(&mut self) -> &mut [i8; BOARD_SIZE] {
        &mut self.board
    }

    pub fn game_over_mut(&mut self) -> &mut bool {
        &mut self.game_over
    }
}

impl Movelist for Board {
    fn get_legal_move(&self, mut index: isize, dir: isize, color: i8) -> Move {
        let mut flips = 0;
        let mut wall = false;
        let mut result = Move::default();

        while index >= 0 && index < BOARD_SIZE as isize && !wall {
            wall = check_wall(index as usize, dir);

            index += dir;

            if index >= 0 && index < BOARD_SIZE as isize {
                if self.board[index as usize] != -color {
                    break;
                } else {
                    flips += 1;
                }
            } else {
                flips = 0;
                break;
            }
        }

        if index >= 0
            && index < BOARD_SIZE as isize
            && self.board[index as usize] == NONE
            && flips != 0
        {
            result.cell = index as usize;
            result.num_flips = flips;
            result.direction = dir;
        }

        result
    } // gets a legal move from the board

    fn generate_moves(&self, color: i8) -> Vec<Move> {
        let mut movelist: Vec<Move> = Vec::new();

        for (i, val) in self.board.iter().enumerate() {
            if val == &color {
                for dir in &DIRECTIONS {
                    let mv = self.get_legal_move(i as isize, *dir, color);

                    if mv.num_flips != 0 && !mv.is_border() {
                        movelist.push(mv);
                    }
                }
            }
        }
        movelist
    } // generates a vector of legal moves on the board
}

impl Passing for Board {
    fn get_pass_input(&mut self) {
        let mut input = String::new();
        io::stdin()
            .read_line(&mut input)
            .expect("unable to read user input");

        match input.trim() {
            "B" | "b" => self.handle_skip_black(*self.bot()),
            "W" | "w" => self.handle_skip_white(*self.bot()),
            _ => {
                println!("invalid option found; please re-enter.");
                self.get_pass_input();
            }
        }
    }

    fn handle_skip_black(&mut self, mut opponent: Player) {
        if self.player.color != BLACK && self.player.human {
            println!("player has no valid moves and must pass; please re-enter:");
            self.get_pass_input();
        } else {
            match self.player.passing {
                true => opponent.passing = true,
                false => self.player.passing = true,
            }
        }
    }

    fn handle_skip_white(&mut self, mut opponent: Player) {
        if self.player.color != WHITE && self.player.human {
            println!("player has no valid moves and must pass; please re-enter:");
            self.get_pass_input();
        } else {
            match self.player.passing {
                true => opponent.passing = true,
                false => self.player.passing = true,
            }
        }
    }
}
