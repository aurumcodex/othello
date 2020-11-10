package main

import (
	"bufio"
	"fmt"
	"math"
	"math/rand"
	"os"
	"strings"
	"time"
)

// Player is a struct to hold data about a player
type Player struct {
	color int
	// numDiscs int
	// score    int
	human   bool
	passing bool
}

func initialize(c int, h bool) Player {
	return Player{
		color:   c,
		human:   h,
		passing: false,
	}
}

// [===== human input logic section =====]

func (p Player) getInput(cells []int, human bool) int {
	empty := func(l []int) bool {
		return len(l) == 0
	}

	move := maxInt
	row := 0
	col := 0

	reader := bufio.NewReader(os.Stdin)

	if !empty(cells) {
		fmt.Println("player has vaild moves available.")
	}

	fmt.Print("Enter a move (color, column, row): ")
	input, err := reader.ReadString('\n')
	if err != nil {
		fmt.Fprintln(os.Stderr, "unable to read user input")
		os.Exit(2)
	}
	input = strings.Replace(input, "\n", "", -1)

	chars := strings.Split(input, " ")

	fmt.Printf("%v >> %T, len = %v\n", chars, chars, len(chars))

	// need to figure out if it's possible to simplify this logic even more
	if (chars[0] == "B" || chars[0] == "b" && p.color == black) && !empty(cells) && len(chars) > 1 {
		fmt.Println()
		fmt.Println()

		fmt.Printf("map rows at %v: %v\n", chars[2], rows[chars[2]])
		fmt.Printf("map rows at %v: %v\n", chars[1], columns[chars[1]])
		// fmt.Println("got valid first char")
		// fmt.Printf("chars[1] = %v (%T), chars[2] = %v (%T)\n", chars[1], chars[1], chars[2], chars[2])
		row, _ = rows[chars[2]]
		col, _ = columns[chars[1]]
		move = (row * 8) + col
		fmt.Printf("row : %v | col : %v | move : %v\n", row, col, move)

		if !sliceContains(move, cells) {
			switch human {
			case true:
				fmt.Println("since a human is playing, re-enter move")
				p.getInput(cells, human)
			case false:
				fmt.Fprintln(os.Stderr, "invalid move entered; (bot)")
				os.Exit(1)
			}
		}
	} else if (chars[0] == "W" || chars[0] == "w" && p.color == white) && !empty(cells) && len(chars) > 1 {
		row = rows[chars[2]]
		col = columns[chars[1]]
		move = (row * 8) + col

		if !sliceContains(move, cells) {
			switch human {
			case true:
				fmt.Println("since a human is playing, re-enter move")
				p.getInput(cells, human)
			case false:
				fmt.Fprintln(os.Stderr, "invalid move entered; (bot)")
				os.Exit(1)
			}
		}
	} else {
		// fmt.Println
		fmt.Fprintln(os.Stderr, "invalid move entered")
		os.Exit(1)
	}

	fmt.Printf("player %v made move at cell: %v\n", color(p.color, fullColor), move)
	return move
}

func (p *Player) getPassInput(opponent Player) {
	reader := bufio.NewReader(os.Stdin)
	input, err := reader.ReadString('\n')
	if err != nil {
		fmt.Fprintln(os.Stderr, "unable to read user input")
		os.Exit(2)
	}
	input = strings.Replace(input, "\n", "", -1)

	// need to clean up boilerplate here
	switch input {
	case "b":
		p.handleInputBlack(opponent)
	case "B":
		p.handleInputBlack(opponent)
	case "w":
		p.handleInputWhite(opponent)
	case "W":
		p.handleInputWhite(opponent)
	default:
		if p.human {
			fmt.Println("invalid option found. please re-enter")
			p.getPassInput(opponent)
		}
	}
}

func (p *Player) handleInputBlack(opponent Player) {
	if p.color != black && p.human {
		fmt.Println("you have no valid moves and need to pass. re-enter input")
		p.getPassInput(opponent)
	}
	switch p.passing {
	case true:
		opponent.passing = true
	case false:
		p.passing = true
	}
}

func (p *Player) handleInputWhite(opponent Player) {
	if p.color != white && p.human {
		fmt.Println("you have no valid moves and need to pass. re-enter input")
		p.getPassInput(opponent)
	}
	switch p.passing {
	case true:
		opponent.passing = true
	case false:
		p.passing = true
	}
}

// [===== bot logic section =====]
func (p Player) makeMoveBot(b Board, moveset []Move, debug bool) int {
	// TODO: add logic
	// moveset := b.generateMoves(p.color)
	// cells := getCells(moveset)

	move := -1
	depth := 0
	maxing := true
	alpha := float64(math.MinInt64)
	beta := float64(math.MaxInt64)
	color := p.color

	moveType := negamax

	switch moveType {
	case rng:
		fmt.Println("bot is using an rng move")
		move = p.genRNGMove(moveset, debug)

	case alphabeta:
		fmt.Println("bot is using a move generated from alphaBeta")
		abTable := make(map[int]int)

		for _, m := range moveset {
			temp := b
			temp.apply(color, m.cell, debug)
			temp.flipDiscs(color, -m.direction, m.cell, debug)

			abTemp := temp.alphaBeta(&alpha, &beta, -color, depth, !maxing, debug)

			fmt.Printf("alphaBeta output at cell %v :: %v\n", m.cell, abTemp)
			abTable[m.cell] = abTemp
		}

		fmt.Printf("alphaBeta output: %v\n", abTable)

		max := 0
		for i, val := range abTable {
			move = i
			fmt.Printf("i: %v | val: %v\n", i, val)
			if val > max {
				max = val
				move = i
			}
		}
		return move

	case negamax:
		fmt.Println("bot is using a move generated from alphaBeta")
		nmTable := make(map[int]int)

		for _, m := range moveset {
			temp := b
			temp.apply(color, m.cell, debug)
			temp.flipDiscs(color, -m.direction, m.cell, debug)

			nmTemp := temp.negamax(&alpha, &beta, -color, depth, debug)

			fmt.Printf("negamax output at cell %v :: %v\n", m.cell, nmTemp)
			nmTable[m.cell] = nmTemp
		}

		fmt.Printf("negamax output: %v\n", nmTable)

		max := 0
		for i, val := range nmTable {
			fmt.Printf("i: %v | val: %v\n", i, val)
			if val > max {
				max = val
				move = i
			}
		}
		return move

	default:
		fmt.Println("(the bot shruged)")
		move = p.genRNGMove(moveset, debug)
	}

	return move // for now
}

func (p Player) genRNGMove(moveset []Move, debug bool) int {
	rand.Seed(time.Now().UnixNano())

	cells := getCells(moveset)
	move := rand.Intn(boardSize)

	if debug {
		fmt.Println("unsorted cell list:", cells)
	}

	for !sliceContains(move, cells) {
		move = rand.Intn(boardSize)
	}

	return move
}

// "enum"s for move decision for bot
const (
	rng int = iota
	alphabeta
	negamax
)
