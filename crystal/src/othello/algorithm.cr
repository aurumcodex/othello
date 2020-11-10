# algorithm.cr
require "./evaluate"

module Algorithm
  # extend self # probably don't need to extend self here

  def alpha_beta(alpha, beta, color, depth, maxing, debug)
    score = 0
    move_count = self.generate_moves(color).size
    moveset = Array(Move).new

    if debug
      puts "[alpha_beta] moves available: #{move_count} | depth = #{depth}"
    end

    if depth == Util::MAX_DEPTH
      if debug
        puts "hit max depth (#{Util::MAX_DEPTH})"
      end

      score = self.calc_score_weight.score
      # exit
    elsif depth < Util::MAX_DEPTH
      if maxing
        score = Int32::MIN
        moveset = self.generate_moves(color)

        moveset.each do |m|
          if debug
            puts "legal cell = #{m.cell}"
          end

          temp = self.clone
          # puts self.field
          # puts temp.field
          # exit
          temp.apply(color, m.cell, debug)
          temp.flip_discs(color, m.direction.invert, m.cell, debug)

          value = temp.alpha_beta(alpha, beta, color.invert, depth + 1, !maxing, debug)

          score = Math.max(score, value)
          alpha = Math.max(alpha, score)

          if alpha >= beta
            break
          end
        end # end each
      elsif !maxing
        score = Int32::MAX
        moveset = self.generate_moves(color)

        moveset.each do |m|
          if debug
            puts "legal cell = #{m.cell} | direction : #{m.direction.invert}"
          end

          temp = self
          temp.apply(color, m.cell, debug)
          temp.flip_discs(color, m.direction.invert, m.cell, debug)

          value = temp.alpha_beta(alpha, beta, color.invert, depth + 1, !maxing, debug)

          score = Math.min(score, value)
          beta = Math.min(beta, score)

          if alpha >= beta
            break
          end
        end
      end
    end
    return score
  end

  def negamax(alpha, beta, color, depth, debug)
    score = 0
    moveset = self.generate_moves(color)
    move_count = moveset.size

    if debug
      puts "[negamax] moves available: #{move_count} | depth = #{depth}"
    end

    if depth == Util::MAX_DEPTH
      return color.value * self.calc_score_weight.score
    else
      moveset.each do |m|
        if debug
          puts "legal cell = #{m.cell}"
        end

        temp = self
        temp.apply(color, m.cell, debug)
        temp.flip_discs(color, m.direction.invert, m.cell, debug)

        value = -temp.negamax(-beta, -alpha, color.invert, depth + 1, debug)

        score = Math.max(score, value)
        alpha = Math.max(alpha, score)

        if alpha >= beta
          break
        end
      end
    end

    return score
  end

  def rng_move(movelist)
    cells = Moves.get_cells(movelist)
    m = rand(Util::BOARD_SIZE)

    while !cells.includes? m
      m = rand(Util::BOARD_SIZE)
    end

    return m
  end
end
