##[
  player.nim
  ==========

  module for the data that a player would need for the game.
]##

import strformat, strutils

from tables import `[]`
from util import isEmpty, Rows, Columns, MaxInt


type
  Color* {.pure, size: sizeof(char).} = enum
    White = (-1, "W")
    None  = (0, "-")
    Black = (1, "B")


proc `-`*(c: Color): Color =
  ## Inverts the Color given to the opposite.
  case c:
    of Black:
      result = White
    of White:
      result = Black
    else:
      result = None


proc printColor*(i: int, c: Color) =
  if i mod 8 == 7:
    echo fmt" {c}"
  else:
    stdout.write fmt" {c}"


type
  Player* = object
    color*:    Color
    # numDiscs*: int
    human*:    bool
    passing*:  bool
    # score: int


proc initPlayer*(c: Color, human: bool): Player =
  result = Player(color: c, #[numDiscs: 0,]# human: human, passing: false)


proc getInput*(p: Player, cells: seq[int], human: bool): int =
  var
    m = MaxInt # arbitrary number for now
    row = 0
    col = 0
  # if not cells.empty()
  if not cells.isEmpty:
    echo "player has valid moves available"

  stdout.write "enter a move (color, column, row): "
  var input = readLine stdin 
  # input.stripLineEnd
  var stripInput = input.split(" ")
  echo stripInput
  # input = input.strip
  if stripInput[0] == "B" and p.color == Black and not cells.isEmpty and input.len > 1:
    row = Rows[stripInput[2]]
    col = Columns[stripInput[1]]
    m = (row * 8) + col

    if not cells.contains(m):
      if human:
        echo "since a human is playing, re-enter move"
        discard p.getInput(cells, human)
      if not human:
        echo "invalid move entered"
        quit 1

  elif stripInput[0] == "W" and p.color == White and not cells.isEmpty and input.len > 1:
    row = Rows[stripInput[2]]
    col = Columns[stripInput[1]]
    m = (row * 8) + col

    if not cells.contains(m):
      if human:
        echo "since a human is playing, re-enter move"
        discard p.getInput(cells, human)
      if not human:
        echo "invalid move entered"
        quit 1
  else:
    echo "invalid move entered"
    quit 1

  echo fmt"player ({p.color}) made move at cell: {m}"
  result = m


proc getPassInput*(p, o: var Player) =
  var input = readLine stdin
  input.stripLineEnd

  case input:
    of "b", "B":
      # p.handleSkipBlack(o)
      if p.color != Black and p.human:
        echo "you have no valid moves and need to pass. re-enter input"
        p.getPassInput(o)
      case p.passing:
        of true:
          o.passing = true
        of false:
          p.passing = true

    of "w", "W":
      # p.handleSkipWhite(o)
      if p.color != White and p.human:
        echo "you have no valid moves and need to pass. re-enter input"
        p.getPassInput(o)
      case p.passing:
        of true:
          o.passing = true
        of false:
          p.passing = true

    else:
      if p.human:
        echo "invalid option found; please re-enter"
        p.getPassInput(o)
