# TODO: Write documentation for `Othello`
require "colorize"

require "./othello/*"

module Othello
  extend self
  VERSION = "0.1.0"

  COLORIZE = true # will make this a local variable later

  def main
    turn_count = 0
    human = true
    debug = false

    puts "what color do you want to play as? (black or white)"
    input = gets.not_nil!.chomp

    game = Board.new
    puts "typeof game: #{typeof (game)}"
    while true
      puts "got \"#{input}\" from you."
      case input
      when "b", "B", "black", "Black", "BLACK"
        game.setup(Color::Black)
        break
      when "w", "W", "white", "White", "WHITE"
        game.setup(Color::White)
        break
      else
        puts "unable to get valid input; please re-enter"
        input = gets.not_nil!.chomp
      end
    end # end input validation loop

    # puts game.player.color
    # puts game.bot.color
    # player = game.player
    # bot = game.bot

    current_player = game.player.color

    while !game.game_over
      movelist = Array(Move).new
      cells = Array(Int32).new

      puts "turn count is: #{turn_count}"

      if current_player.black?
        movelist.clear
        cells.clear
        movelist = game.generate_moves(game.player.color)

        game.display(movelist, COLORIZE)

        puts "legal moves:"
        movelist.each do |m|
          m.display(game.player.color)
          cells << m.cell
        end

        if movelist.size == 0
          puts "player has to pass"
          game.player.get_pass_input(game.bot)
        else
          m = game.player.get_input(cells, human)
          game.apply(game.player.color, m, debug)
          movelist.each do |mv|
            if mv.cell == m
              game.flip_discs(game.player.color, mv.direction.invert, mv.cell, debug)
            end
          end
        end
      elsif current_player.white?
        movelist.clear
        cells.clear
        movelist = game.generate_moves(game.bot.color)

        game.display(movelist, COLORIZE)

        puts "legal moves:"
        movelist.each do |m|
          m.display(game.bot.color)
          cells << m.cell
        end

        if movelist.size == 0
          puts "bot has to pass"
          if game.player.passing == false
            game.player.passing = true
          else
            game.bot.passing = true
          end
        else
          m = game.bot.make_move(movelist, game, debug)
          if !cells.includes? m
            puts "bot made an odd move; using rng fallback"
            m = game.rng_move(movelist)
          end

          puts "bot generated move: #{Util.shorten(game.bot.color)} #{Util.get_col(m)} #{Util.get_row(m)}"
          game.apply(game.bot.color, m, debug)

          movelist.each do |mv|
            if mv.cell == m
              game.flip_discs(game.bot.color, mv.direction.invert, mv.cell, debug)
            end
          end
        end
      end # end branches for player colors

      current_player = current_player.invert
      game.game_over = game.is_game_over?

      turn_count += 1
    end # end main game while loop

    puts "game has ended | turns taken: #{turn_count}"

    # scores = game.calculate_scores_disc
    # print_results(scores)
  end # end def main
end   # end module Othello

# call main game loop here
Othello.main
