##[
  board.nim
  =========

  module to hold data about the playing board.
]##

import strformat

import player, moves, util

from util import printChar

type
  Board* = object
    player*: Player
    bot*:    Player
    board*:  array[64, Color]
    gameOver*: bool


proc setup*(c: Color): Board =
  var
    player = initPlayer(c, true)
    bot = initPlayer(-c, false)

  var brd: array[64, Color]
  brd[27] = White
  brd[28] = Black
  brd[35] = Black
  brd[36] = White

  result = Board(
    player: player,
    bot: bot,
    board: brd,
    gameOver: false
  )


proc apply*(b: var Board, color: Color, cell: int, debug: bool) =
  if b.board[cell] == None:
    if debug:
      echo fmt"applying move at cell: {cell}"
      echo fmt"cell was originally: {b.board[cell]}"

    b.board[cell] = color

    if debug:
      echo fmt"cell is now: {b.board[cell]}"


proc flipDiscs*(b: var Board, color: Color, dir: Direction, cell: int, debug: bool) =
  var temp = cell

  while temp >= 0 and cell < 64:
    temp = temp + ord dir

    if debug:
      echo fmt"cell is now: {temp}"
    
    if temp < 64:
      if b.board[temp] == color:
        break
      else:
        b.board[temp] = color


proc getLegalMove*(b: Board, index: var int, dir: Direction, color: Color): Move =
  var
    flips = 0
    # i = index
    # d = dir
    m = Move(cell: 0, numFlips: 0, direction: North)
    wall = false

  # block checking:
  while index >= 0 and index < BoardSize and not wall:
    wall = checkDir(index, dir)
    index += ord dir

    if index >= 0 and index < BoardSize:
      if b.board[index] != -color:
        break #[checking]#
      else:
        inc flips
    else:
      flips = 0
      break #[checking]#

  if index >= 0 and index < BoardSize:
    if b.board[index] == None and flips != 0:
      m.cell = index
      m.numFlips = flips
      m.direction = dir

  result = m


proc generateMoves*(b: Board, c: Color): seq[Move] =
  for i, val in b.board:
    if val == c:
      for d in Directions:
        var
          i = i
          m: Move = getLegalMove(b, i, d, c)
        if m.numFlips != 0 and not checkBorder(m):
          result.add(m)


proc print*(b: Board, moveset: seq[Move]) =
  ## print out the board in an easy to read 2D format (with moves)
  let cells = getCells(moveset)

  echo fmt"bot is {b.bot.color} | player is {b.player.color}"
  echo "  ._a_b_c_d_e_f_g_h_"

  for i, c in b.board:
    if i mod 8 == 0:
      stdout.write fmt"{getRow(i)} |"
    if cells.contains(i):
      printChar i, "+"
      continue
    else:
      printColor i, c


proc print*(b: Board) =
  ## print out the board in an easy to read 2D format (without moves)
  # let cells = getCells(moveset)

  echo fmt"bot is {b.bot.color} | player is {b.player.color}"
  echo "  ._a_b_c_d_e_f_g_h_"

  for i, c in b.board:
    if i mod 8 == 0:
      stdout.write fmt"{getRow(i)} |"
    # # if cells.contains(i):
    #   printChar i, "-"
      printColor i, c
      continue
    else:
      printColor i, c


proc isGameOver*(b: Board): bool =
  result = b.player.passing and b.bot.passing


include formula
include bot # was in player.nim, but due to a recursion in dependency, would fail to compile