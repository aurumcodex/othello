# util.cr
require "colorize"

enum Color : Int8
  Black = -1
  None  =  0
  White =  1

  def black? : Bool
    self == Color::Black
  end

  def none? : Bool
    self == Color::None
  end

  def white? : Bool
    self == Color::White
  end

  def invert : Color
    case self
    when Color::Black
      return Color::White
    when Color::White
      return Color::Black
    else
      return Color::None
    end
  end
end

enum Direction : Int8
  NWest = -9
  North = -8
  NEast = -7
  West  = -1
  Null  =  0
  East  =  1
  SWest =  7
  South =  8
  SEast =  9

  def invert : Direction
    case self
    when Direction::NWest
      return Direction::SEast
    when Direction::North
      return Direction::South
    when Direction::NEast
      return Direction::SWest
    when Direction::West
      return Direction::East
    when Direction::East
      return Direction::West
    when Direction::SWest
      return Direction::NEast
    when Direction::South
      return Direction::North
    when Direction::SEast
      return Direction::NWest
    else
      return Direction::Null
    end
  end
end

module Util
  extend self

  BOARD_SIZE = 64
  MAX_DEPTH  =  9 # 15 plies for now; will see what preformance is like (21's too deep, apparently)

  DIRECTIONS = Array{
    Direction::NWest,
    Direction::North,
    Direction::NEast,
    Direction::West,
    Direction::East,
    Direction::SWest,
    Direction::South,
    Direction::SEast,
  }

  TOP_BORDER    = Array{0, 1, 2, 3, 4, 5, 6, 7}
  LEFT_BORDER   = Array{0, 8, 16, 24, 32, 40, 48, 56}
  BOTTOM_BORDER = Array{56, 57, 58, 59, 60, 61, 62, 63}
  RIGHT_BORDER  = Array{7, 15, 23, 31, 39, 47, 55, 63}
  WEIGHTS       = Array{
    150, -30, 30, 5, 5, 30, -30, 150,
    -30, -50, -5, -5, -5, -5, -50, -30,
    30, -5, 15, 3, 3, 15, -5, 30,
    5, -5, 3, 3, 3, 3, -5, 5,
    5, -5, 3, 3, 3, 3, -5, 5,
    30, -5, 15, 3, 3, 15, -5, 30,
    -30, -50, -5, -5, -5, -5, -50, -30,
    150, -30, 30, 5, 5, 30, -30, 150,
  }

  COLUMNS = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7,
  }

  ROWS = {
    "1" => 0,
    "2" => 1,
    "3" => 2,
    "4" => 3,
    "5" => 4,
    "6" => 5,
    "7" => 6,
    "8" => 7,
  }

  DIR_MAP = {
    North => "North",
    South => "South",
    East  => "East",
    West  => "West",
    NEast => "North East",
    NWest => "North West",
    SEast => "South East",
    SWest => "South West",
  }

  NO_MOVES = Array(Move).new

  def print_char(index, color, str, colorized?)
    if colorized?
      print_char_color(index, color, str)
    else
      print_char_plain(index, str)
    end
  end

  private def print_char_color(index, color, str)
    if index % 8 == 7
      case color
      when Color::Black
        puts " #{str} ".colorize.black.on_green
      when Color::White
        puts " #{str} ".colorize.white.on_green
      when Color::None
        if str == "+"
          puts " #{str} ".colorize.blue.on_green.bold
        else
          puts " #{str} ".colorize.red.on_green
        end
      else
      end
    else
      case color
      when Color::Black
        print " #{str}".colorize.black.on_green
      when Color::White
        print " #{str}".colorize.white.on_green
      when Color::None
        if str == "+"
          print " #{str}".colorize.blue.on_green.bold
        else
          print " #{str}".colorize.red.on_green
        end
      else
      end
    end
  end

  private def print_char_plain(index, str)
    if index % 8 == 7
      puts " #{str}"
    else
      print " #{str}"
    end
  end

  def shorten(color) : String
    case color
    when Color::Black
      return "B"
    when Color::White
      return "W"
    when Color::None
      return "-"
    else
      return "?"
    end
  end

  def get_row(x) : Int32
    (x // 8) + 1
  end

  def get_col(x)
    case x % 8
    when 0 then "a"
    when 1 then "b"
    when 2 then "c"
    when 3 then "d"
    when 4 then "e"
    when 5 then "f"
    when 6 then "g"
    when 7 then "h"
    else        "_"
    end
  end
end
