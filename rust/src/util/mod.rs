// (util) mod.rs

pub mod procs;
pub mod values;

pub const HELP: &str = "help message goes here";

// move types to consider and parse from cli args
pub const AUTO_MOVE: &str = "auto";
pub const ALPHA_BETA_MOVE: &str = "alpha_beta";
pub const NEGAMAX_MOVE: &str = "negamax";
pub const RAND_MOVE: &str = "rand";
