// values.rs

use std::collections::HashMap;

use once_cell::sync::Lazy;

pub const VERSION: &str = "0.1.0";

pub const BOARD_SIZE: usize = 64;
pub const MAX_DEPTH: usize = 11; // anything over 11 is really slow for some reason; too slow, even

pub const WHITE: i8 = -1;
pub const NONE: i8 = 0;
pub const BLACK: i8 = 1;

pub const NORTH: isize = -8;
pub const SOUTH: isize = 8;
pub const EAST: isize = 1;
pub const WEST: isize = -1;
pub const N_EAST: isize = -7;
pub const N_WEST: isize = -9;
pub const S_EAST: isize = 9;
pub const S_WEST: isize = 7;

pub const DIRECTIONS: [isize; 8] = [NORTH, SOUTH, EAST, WEST, N_EAST, N_WEST, S_EAST, S_WEST];

pub const TOP_BORDER: [usize; 8] = [0, 1, 2, 3, 4, 5, 6, 7];
pub const LEFT_BORDER: [usize; 8] = [0, 8, 16, 24, 32, 40, 48, 56];
pub const BOTTOM_BORDER: [usize; 8] = [56, 57, 58, 59, 60, 61, 62, 63];
pub const RIGHT_BORDER: [usize; 8] = [7, 15, 23, 31, 39, 47, 55, 63];

pub const WEIGHTS: [isize; 64] = [
    150, -30, 30, 5, 5, 30, -30, 150, -30, -50, -5, -5, -5, -5, -50, -30, 30, -5, 15, 3, 3, 15, -5,
    30, 5, -5, 3, 3, 3, 3, -5, 5, 5, -5, 3, 3, 3, 3, -5, 5, 30, -5, 15, 3, 3, 15, -5, 30, -30, -50,
    -5, -5, -5, -5, -50, -30, 150, -30, 30, 5, 5, 30, -30, 150,
];

pub static COLUMNS: Lazy<HashMap<&str, usize>> = Lazy::new(|| {
    let mut map = HashMap::new();
    map.insert("a", 0);
    map.insert("b", 1);
    map.insert("c", 2);
    map.insert("d", 3);
    map.insert("e", 4);
    map.insert("f", 5);
    map.insert("g", 6);
    map.insert("h", 7);

    map
});

pub static ROWS: Lazy<HashMap<&str, usize>> = Lazy::new(|| {
    let mut map = HashMap::new();
    map.insert("1", 0);
    map.insert("2", 1);
    map.insert("3", 2);
    map.insert("4", 3);
    map.insert("5", 4);
    map.insert("6", 5);
    map.insert("7", 6);
    map.insert("8", 7);

    map
});

pub static DIR_MAP: Lazy<HashMap<isize, &str>> = Lazy::new(|| {
    let mut map = HashMap::new();
    map.insert(NORTH, "N");
    map.insert(SOUTH, "S");
    map.insert(EAST, "E");
    map.insert(WEST, "W");
    map.insert(N_EAST, "NE");
    map.insert(N_WEST, "NW");
    map.insert(S_EAST, "SE");
    map.insert(S_WEST, "SW");

    map
});
