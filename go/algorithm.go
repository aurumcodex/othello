package main

import (
	"fmt"
	"math"
)

//implement search algorithms here

func (b Board) alphaBeta(alpha, beta *float64, player, depth /*turnCount*/ int, maxing, debug bool) int {
	// get fresh copies of alpha and beta (maybe)
	// need to possibly re-write this algorithm
	fmt.Printf("alpha is: %v | beta is: %v\n", *alpha, *beta)

	moveCount := len(b.generateMoves(player))
	score := -1

	if debug {
		fmt.Println("moves available:", moveCount, "| depth =", depth)
	}

	if depth == maxDepth {
		if debug {
			fmt.Println("hit max depth (15)")
		}

		// scores := b.calculateScoresDisc()
		score = b.calculateScoresDisc().Score
		fmt.Printf("score is: %v\n", score)

		if debug {
			b.print(emptyMoves)
		}
	} else if depth < maxDepth {
		if maxing {
			score = minInt
			moveset := b.generateMoves(player)

		Max:
			for _, m := range moveset {
				if debug {
					fmt.Println("Legal Cell =", m.cell)
				}

				temp := b
				temp = temp.apply(player, m.cell, debug)
				temp = temp.flipDiscs(player, -1*m.direction, m.cell, debug)

				val := temp.alphaBeta(alpha, beta, -player, depth+1, !maxing, debug)

				score = int(math.Max(float64(score), float64(val)))
				*alpha = math.Max(*alpha, float64(score))

				if *alpha >= *beta {
					break Max
				}
			}
		} else if !maxing {
			score = maxInt
			moveset := b.generateMoves(player)

		Min:
			for _, m := range moveset {
				if debug {
					fmt.Println("Legal Cell =", m.cell)
				}

				temp := b
				temp.apply(player, m.cell, debug)
				temp.flipDiscs(player, -1*m.direction, m.cell, debug)

				val := temp.alphaBeta(alpha, beta, -player, depth+1, !maxing, debug)
				fmt.Printf("val is = %v\n", val)

				score = int(math.Min(float64(score), float64(val)))
				*beta = math.Min(*beta, float64(score))

				if *beta <= *alpha {
					fmt.Printf("breaking in min loop | alpha = %v | beta = %v | depth = %v\n", *alpha, *beta, depth)
					break Min
				}
			}
		}
	}

	return score
} // end alphaBeta()

// Negamax is a fuction
func (b Board) negamax(alpha, beta *float64, player, depth int, debug bool) int {
	moveset := b.generateMoves(player)
	moveCount := len(moveset)
	bestMove := minInt

	a := *alpha * -1
	bt := *beta * -1

	if debug {
		fmt.Println("moves available:", moveCount, "| depth =", depth)
	}

	if depth == 0 {
		return player * b.calculateScoresWeight().Score
	}

Cycle:
	for _, m := range moveset {
		if debug {
			fmt.Println("Legal Cell =", m.cell)
		}

		temp := b
		temp = temp.apply(player, m.cell, debug)
		temp = temp.flipDiscs(player, -1*m.direction, m.cell, debug)

		bestMove = max(bestMove, -temp.negamax(&bt, &a, -player, depth-1, debug))
		*alpha = math.Max(*alpha, float64(bestMove))

		if *alpha >= *beta {
			break Cycle
		}
	}

	return bestMove
}
