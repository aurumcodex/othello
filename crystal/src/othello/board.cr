# board.cr
require "./algorithm"
require "./evaluate"
require "./move"

class Board
  def_clone

  include Algorithm
  include Evaluation
  include Movelist

  @@black_discs = 2
  @@white_discs = 2

  def self.black_discs
    @@black_discs
  end

  def self.white_discs
    @@white_discs
  end

  property field : Array(Color)
  property player : Player
  property bot : Player
  property game_over : Bool

  def initialize
    @field = Array(Color).new(64, Color::None)
    @player = Player.new
    @bot = Player.new
    @game_over = false
  end # end initializer

  protected def initialize(player, bot, field, state)
    @field = field
    @player = player
    @bot = bot
    @game_over = state
  end

  def setup(color)
    @field[27] = Color::White
    @field[28] = Color::Black
    @field[35] = Color::Black
    @field[36] = Color::White

    @player = Player.setup(color, true)
    @bot = Player.setup(color.invert, false)
  end

  def apply(color, cell, debug)
    if self.field[cell] == Color::None
      if debug
        puts "applying move at cell: #{cell}"
        puts "cell was originally: #{self.field[cell]}"
      end

      self.field[cell] = color

      if debug
        puts "cell is now: #{self.field[cell]}"
      end
    end
  end

  def flip_discs(color, dir, cell, debug)
    temp = cell

    while temp >= 0 && temp < 64
      temp = temp + dir.value

      if debug
        puts "current cell: #{temp}"
        self.display(Util::NO_MOVES, true)
      end

      if temp < 64
        # puts "temp = #{temp} | #{self.field[temp]}"
        if self.field[temp] == color
          # puts "temp = #{temp} | #{self.field[temp]} | should break"
          break
          # exit
        else
          self.field[temp] = color
          # puts "temp = #{temp} | #{self.field[temp]} | shouldn't break"
        end
      else
      end
    end
  end

  def display(moveset, colorize?)
    cells = Moves.get_cells(moveset)

    puts "bot is #{Util.shorten(self.bot.color)} | player is #{Util.shorten(self.player.color)}"
    puts "  ._a_b_c_d_e_f_g_h_"

    self.field.each_with_index do |cell, index|
      if index % 8 == 0
        print " #{Util.get_row(index)}|"
      end

      if cells.includes? index
        Util.print_char(index, cell, "+", colorize?)
        next
      else
        Util.print_char(index, cell, Util.shorten(cell), colorize?)
      end
    end
  end

  def is_game_over?
    return @player.passing && @bot.passing
  end

  # def clone
  #   # need to make a perfect bitwise copy of board for algorithms
  #   player = @player
  #   bot = @bot
  #   field = @field
  #   state = @game_over

  #   return Board.new(player, bot, field, state)
  # end
end
