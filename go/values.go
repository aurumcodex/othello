package main

import "math/bits"

const (
	// board size
	boardSize int = 64

	// directions
	north     int = -8
	south     int = 8
	east      int = 1
	west      int = -1
	northEast int = -7
	northWest int = -9
	southEast int = 9
	southWest int = 7

	// colors
	black int = 1
	white int = -1
	none  int = 0

	// max alphaBeta search depth
	maxDepth int = 31

	// disc character/rune
	disc rune = '●'

	// print full color name
	fullColor bool = true

	// max and min ints
	maxInt int = 1<<(bits.UintSize-1) - 1
	minInt int = -maxInt - 1
)

// because golang has no constant arrays/slices
var (
	// direction array
	directions = [...]int{north, south, east, west, northEast, northWest, southEast, southWest}

	// board borders
	topBorder    = [...]int{0, 1, 2, 3, 4, 5, 6, 7}
	leftBorder   = [...]int{0, 8, 16, 24, 32, 40, 48, 56}
	bottomBorder = [...]int{56, 57, 58, 59, 60, 61, 62, 63}
	rightBorder  = [...]int{7, 15, 23, 31, 39, 47, 55, 63}

	// board cell weights
	weights = [...]int{
		150, -30, 30, 5, 5, 30, -30, 150,
		-30, -50, -5, -5, -5, -5, -50, -30,
		30, -5, 15, 3, 3, 15, -5, 30,
		5, -5, 3, 3, 3, 3, -5, 5,
		5, -5, 3, 3, 3, 3, -5, 5,
		30, -5, 15, 3, 3, 15, -5, 30,
		-30, -50, -5, -5, -5, -5, -50, -30,
		150, -30, 30, 5, 5, 30, -30, 150,
	}

	// empty moveset slice
	emptyMoves = make([]Move, 0)

	// maps for user input
	columns = map[string]int{
		"a": 0,
		"b": 1,
		"c": 2,
		"d": 3,
		"e": 4,
		"f": 5,
		"g": 6,
		"h": 7,
	}

	rows = map[string]int{
		"1": 0,
		"2": 1,
		"3": 2,
		"4": 3,
		"5": 4,
		"6": 5,
		"7": 6,
		"8": 7,
	}

	dir = map[int]string{
		north:     "North",
		south:     "South",
		east:      "East",
		west:      "West",
		northEast: "North East",
		northWest: "North West",
		southEast: "South East",
		southWest: "South West",
	}
)
