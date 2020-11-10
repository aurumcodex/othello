##[
  moves.nim
  =========

  module to contain data about moves in the game and procs for getting moves.
]##

# from board import Board
# from player import Color, `-`

import strformat

import util

from player import Color

type
  Move* = object
    cell*: int
    numFlips*: int
    direction*: Direction


proc checkDir*(id: int, dir: Direction): bool =
  # need to think about refactoring this somehow
  if dir == East and RightBorder.contains(id):
    result = true
  elif dir == West and LeftBorder.contains(id):
    result = true
  elif dir == NEast and (RightBorder.contains(id) or TopBorder.contains(id)):
    result = true
  elif dir == NWest and (LeftBorder.contains(id) or TopBorder.contains(id)):
    result = true
  elif dir == SEast and (RightBorder.contains(id) or BottomBorder.contains(id)):
    result = true
  elif dir == SWest and (LeftBorder.contains(id) or BottomBorder.contains(id)):
    result = true
  else:
    result = false


proc checkBorder*(m: Move): bool =
  if LeftBorder.contains(m.cell):
    if m.direction == -West or m.direction == -NWest or m.direction == -SWest:
      result = true
    else:
      result = false
  elif RightBorder.contains(m.cell):
    if m.direction == -East or m.direction == -NEast or m.direction == -SEast:
      result = true
    else:
      result = false
  else:
    result = false


proc getCells*(moveset: seq[Move]): seq[int] =
  for c in moveset:
    result.add(c.cell)


proc getWeight*(index: int): int =
  result = CellWeights[index]


proc print*(m: Move, c: Color) =
  stdout.write fmt"{c} {getCol(m.cell)} {getRow(m.cell)} | "
  stdout.write fmt"num flips: {m.numFlips} | "
  echo fmt"direction: {m.direction}"