package main

import (
	"fmt"
)

// Scores A struct to hold the scores of the board
type Scores struct {
	Black int
	White int
	Score int
}

func (b Board) calculateScoresDisc() Scores {
	// this winds up being used for max disc strats
	blackCount := 0
	whiteCount := 0

	for _, c := range b.board {
		switch {
		case c == black:
			blackCount++
		case c == white:
			whiteCount++
		}
	}

	r := blackCount - whiteCount

	return Scores{Black: blackCount, White: whiteCount, Score: r}
}

func (b Board) calculateScoresWeight() Scores {
	blackCount := 0
	whiteCount := 0

	for i, c := range b.board {
		switch {
		case c == black:
			blackCount += weights[i]
		case c == white:
			whiteCount += weights[i]
		}
	}

	r := blackCount - whiteCount

	return Scores{Black: blackCount, White: whiteCount, Score: r}
}

func printResults(s Scores) {
	switch {
	case s.Black > s.White:
		fmt.Println("Player Black wins.")
		fmt.Println("black pieces:", s.Black)
		fmt.Println("white pieces:", s.White)
		// fmt.Println("Player Black wins.")
	case s.Black < s.White:
		fmt.Println("Player White wins.")
		fmt.Println("black pieces:", s.Black)
		fmt.Println("white pieces:", s.White)
	case s.Black == s.White:
		fmt.Println("A tie occurred.")
		fmt.Println("black pieces:", s.Black)
		fmt.Println("white pieces:", s.White)
	}
}
