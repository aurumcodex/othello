package main

import "fmt"

// [===== utility functions =====]

//
func getCells(moveset []Move) []int {
	var cells []int

	for _, c := range moveset {
		cells = append(cells, c.cell)
	}

	return cells
}

// [===== printing functions =====]
func getRow(x int) int {
	return (x / 8) + 1
}

func getCol(x int) string {
	r := ""

	switch x % 8 {
	case 0:
		r = "a"
	case 1:
		r = "b"
	case 2:
		r = "c"
	case 3:
		r = "d"
	case 4:
		r = "e"
	case 5:
		r = "f"
	case 6:
		r = "g"
	case 7:
		r = "h"
	default:
		r = "_"
	}

	return r
}

func getDir(x int) string {
	r := ""

	switch x {
	case north:
		r = "N"
	case south:
		r = "S"
	case east:
		r = "E"
	case west:
		r = "W"
	case northEast:
		r = "NE"
	case northWest:
		r = "NW"
	case southEast:
		r = "SE"
	case southWest:
		r = "SW"
	}

	return r
}

func printChar(i int, s string) {
	if i%8 == 7 {
		fmt.Printf(" %v\n", s)
	} else if i%8 != 7 {
		fmt.Printf(" %v", s)
	}
}

func color(n int, full bool) string {
	switch n {
	case black:
		if !full {
			return "B"
		}
		return "Black"
	case white:
		if !full {
			return "W"
		}
		return "White"
	default:
		return ""
	}
}

func printMove(i int, list []int) {
	if sliceContains(i, list) {
		printChar(i, "+")
	} else {
		printChar(i, "-")
	}
}

func printBlack(i int) {
	printChar(i, "B")
}

func printWhite(i int) {
	printChar(i, "W")
}

// [===== general purpose functions =====]
func max(i, j int) int {
	if j > i {
		return i
	}
	return j
}

func min(i, j int) int {
	if j < i {
		return i
	}
	return j
}

func contains(i int, list [8]int) bool {
	for _, j := range list {
		if j == i {
			return true
		}
	}
	return false
}

func sliceContains(i int, list []int) bool {
	for _, j := range list {
		if j == i {
			return true
		}
	}
	return false
}

func sliceContainsDebug(i int, list []int) bool {
	for n, j := range list {
		fmt.Printf("%v: %v\n", n, j)
		if j == i {
			return true
		}
	}
	return false
}
