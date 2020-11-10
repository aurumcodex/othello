# bot.cr

enum MoveType : Int8
  RNG
  AlphaBeta
  Negamax
end

# Module to grant bot functionality to any Player objects
module Bot
  # included in Player class

  def make_move(moveset, board, debug)
    best_move = -1
    depth = 0
    maxing = true
    alpha = Int32::MIN
    beta = Int32::MAX
    color = self.color

    moveType = MoveType::AlphaBeta

    case moveType
    when MoveType::RNG
      puts "bot is using an rng move"
      best_move = board.rng_move(moveset)
    when MoveType::AlphaBeta
      puts "bot is using a move generated from alpha_beta"
      ab_hash = Hash(Int32, Int32).new(moveset.size)

      moveset.each do |m|
        temp = board.clone
        temp.apply(color, m.cell, debug)
        temp.flip_discs(color, m.direction.invert, m.cell, debug)

        ab_score = temp.alpha_beta(alpha, beta, color.invert, depth, !maxing, debug)
        puts "alpha_beta output at cell #{m.cell} :: #{ab_score}"
        ab_hash[m.cell] = ab_score
      end

      puts "alpha_beta output: #{ab_hash}"

      max = 0
      ab_hash.each do |key, val|
        if val > max
          max = val
          best_move = key
        end
      end
    when MoveType::Negamax
      puts "bot is using a move generated from negamax"
      nm_hash = Hash(Int32, Int32).new(moveset.size)

      moveset.each do |m|
        temp = board.clone
        temp.apply(color, m.cell, debug)
        temp.flip_discs(color, m.direction.invert, m.cell, debug)

        nm_score = temp.negamax(alpha, beta, color.invert, depth, debug)
        puts "alpha_beta output at cell #{m.cell} :: #{nm_score}"
        nm_hash[m.cell] = nm_score.as(Int32)
      end

      puts "alpha_beta output: #{nm_hash}"

      max = 0
      nm_hash.each do |key, val|
        if val > max
          max = val
          best_move = key
        end
      end
    else
      puts "(the bot shrugged)"
      best_move = board.rng_move(moveset)
    end

    return best_move
  end
end
