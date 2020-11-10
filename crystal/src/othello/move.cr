# move.cr
class Move
  property cell : Int32
  property num_flips : Int32
  property direction : Direction

  def initialize
    @cell = -1
    @num_flips = 0
    @direction = Direction::Null
  end

  def is_border?
    if Util::LEFT_BORDER.includes? self.cell
      if self.direction == Direction::West.invert ||
         self.direction == Direction::NWest.invert ||
         self.direction == Direction::SWest.invert
        return true
      end
    elsif Util::RIGHT_BORDER.includes? self.cell
      if self.direction == Direction::East.invert ||
         self.direction == Direction::NEast.invert ||
         self.direction == Direction::SEast.invert
        return true
      end
    else
      return false
    end
  end

  def weight
    Util::WEIGHTS[self.cell]
  end

  def check_border
    if Util::LEFT_BORDER.includes? self.cell
      if self.direction == Direction::West.invert ||
         self.direction == Direction::NWest.invert ||
         self.direction == Direction::SWest.invert
        return true
      end
    elsif Util::RIGHT_BORDER.includes? self.cell
      if self.direction == Direction::East.invert ||
         self.direction == Direction::NEast.invert ||
         self.direction == Direction::SEast.invert
        return true
      end
    else
      return false
    end
  end

  def display(color)
    # self.format(stdout)
    print "#{Util.shorten(color)} #{Util.get_col(@cell)} #{Util.get_row(@cell)} (#{@cell})| "
    print "num flips: #{@num_flips} | "
    puts "direction: #{@direction}"
  end
end

module Movelist
  # this gets included in Board, thus making the `self` work properly

  def get_legal_move(index, dir, color) : Move
    flips = 0
    m = Move.new
    wall = false

    while index >= 0 && index < Util::BOARD_SIZE && !wall
      wall = Moves.check_wall(index, dir)
      index += dir.value

      if index >= 0 && index < Util::BOARD_SIZE
        if self.field[index] != color.invert
          break
        else
          flips += 1
        end
      else
        flips = 0
        break
      end
    end

    if index >= 0 &&
       index < Util::BOARD_SIZE &&
       self.field[index] == Color::None &&
       flips != 0
      m.cell = index
      m.num_flips = flips
      m.direction = dir
    end

    return m
  end

  def generate_moves(color) : Array(Move)
    result = Array(Move).new

    self.field.each_with_index do |val, index|
      if val == color
        Util::DIRECTIONS.each do |d|
          m = self.get_legal_move(index, d, color)

          if m.num_flips != 0 && !m.check_border
            result << m
          end
        end
      end
    end

    return result
  end
end

module Moves
  extend self # important to extend self

  def check_wall(cell, direction)
    case direction
    when Direction::East
      if Util::RIGHT_BORDER.includes? cell
        return true
      end
    when Direction::West
      if Util::LEFT_BORDER.includes? cell
        return true
      end
    when Direction::NEast
      if Util::RIGHT_BORDER.includes? cell || Util::TOP_BORDER.includes? cell
        return true
      end
    when Direction::NWest
      if Util::LEFT_BORDER.includes? cell || Util::BOTTOM_BORDER.includes? cell
        return true
      end
    when Direction::SEast
      if Util::RIGHT_BORDER.includes? cell || Util::TOP_BORDER.includes? cell
        return true
      end
    when Direction::SWest
      if Util::LEFT_BORDER.includes? cell || Util::BOTTOM_BORDER.includes? cell
        return true
      end
    else
      return false
    end
  end

  def get_cells(moveset)
    result = Array(Int32).new
    moveset.each do |mv|
      result << mv.cell
    end
    return result
  end
end
