# player.cr
require "./bot"
require "./util"

class Player
  def_clone

  include Bot

  property color : Color
  property human : Bool
  property passing : Bool

  def initialize
    @color = Color::None
    @human = false
    @passing = false
  end

  def Player.setup(color, human) : Player
    player = Player.new
    player.color = color
    player.human = human
    player.passing = false

    return player
  end

  def get_input(cells, opponent)
    m = Int32::MAX
    row = 0
    col = 0

    if !cells.empty?
      puts "player has valid moves available"
    end

    print "enter a move (color, column, row): "
    input = gets.not_nil!
    puts "typeof input: #{typeof (input)}"
    # chars = [] of String
    chars = input.split(" ")
    puts chars
    puts "typeof chars: #{typeof (chars)}"

    if ((chars[0] == "B" || chars[0] == "b" && @color.black?) && !cells.empty? && chars.size > 1) ||
       ((chars[0] == "W" || chars[0] == "w" && @color.white?) && !cells.empty? && chars.size > 1)
      col = Util::COLUMNS[chars[1]]
      row = Util::ROWS[chars[2]]
      m = (row * 8) + col
      puts "player input: #{m}"
      
      if !cells.includes? m
        if human
          puts "since a human is playing, re-enter move"
          self.get_input(cells, human)
        else
          puts "invalid move entered; not an included cell"
          exit 1
        end
      end
    else
      puts "invalid move entered"
      exit 1
    end

    puts "player (#{@color}) made move at cell: #{m}"
    return m
  end

  def get_pass_input(opponent)
    input = gets
    exit if input.nil?

    begin
      puts "you entered: #{input}"
      case input.chomp
      when "b", "B"
        self.handle_skip_black(opponent)
      when "w", "W"
        self.handle_skip_white(opponent)
      else
        if self.human
          puts "invalid option found; please re-enter"
          self.get_pass_input(opponent)
        end
      end
    rescue ex
      puts "invalid option found (#{ex}); please re-enter"
      self.get_pass_input(opponent)
    end
  end

  private def handle_skip_black(opponent)
    if !self.color.black? && @human
      puts "you have no valid moves and must pass. re-enter input"
      self.get_pass_input(opponent)
    end

    if @passing
      opponent.passing = true
    else
      @passing = true
    end
  end

  private def handle_skip_white(opponent)
    if !self.color.white? && @human
      puts "you have no valid moves and must pass. re-enter input"
      self.get_pass_input(opponent)
    end

    if @passing
      opponent.passing = true
    else
      @passing = true
    end
  end
end
