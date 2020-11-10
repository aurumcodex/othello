// procs.rs

use colored::*;

use crate::util::values::{BLACK, NONE, WHITE};

// #[cfg(feature = "color")]
// pub trait Printing {
pub fn print_char(i: usize, c: i8, s: &str) {
    // the difference is subtle, but very important
    if i % 8 == 7 {
        match c {
            BLACK => println!(
                "{}{}{}",
                " ".on_green(),
                s.black().on_green().bold(),
                " ".on_green()
            ),
            NONE => println!(
                "{}{}{}",
                " ".on_green(),
                s.red().on_green().bold(),
                " ".on_green()
            ),
            WHITE => println!(
                "{}{}{}",
                " ".on_green(),
                s.white().on_green().bold(),
                " ".on_green()
            ),
            _ => {}
        }
    } else {
        match c {
            BLACK => print!("{}{}", " ".on_green(), s.black().on_green().bold()),
            NONE => print!("{}{}", " ".on_green(), s.red().on_green().bold()),
            WHITE => print!("{}{}", " ".on_green(), s.white().on_green().bold()),
            _ => {}
        }
    }
}
// }

pub fn get_color<'a>(color: i8) -> &'a str {
    match color {
        BLACK => "B",
        WHITE => "W",
        NONE => "-",
        _ => "?",
    }
}

pub fn get_row(x: usize) -> usize {
    (x / 8) + 1
}

pub fn get_col(x: usize) -> String {
    match x % 8 {
        0 => String::from("a"),
        1 => String::from("b"),
        2 => String::from("c"),
        3 => String::from("d"),
        4 => String::from("e"),
        5 => String::from("f"),
        6 => String::from("g"),
        7 => String::from("h"),
        _ => String::from("_"),
    }
}
