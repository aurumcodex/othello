##[
  util.nim
  ========

  module to hold various utility functions and to hold various constants.
]##

import strformat
import tables

type
  Direction* {.pure.} = enum
    NWest = (-9, "NW")
    North = (-8, "N")
    NEast = (-7, "NE")
    West  = (-1, "W")
    East  = (1, "E")
    SWest = (7, "SW")
    South = (8, "S")
    SEast = (9, "SE")


proc `-`*(d: Direction): Direction =
  case d:
    of NWest:
      result = SEast
    of North:
      result = South
    of NEast:
      result = SWest
    of West:
      result = East
    of East:
      result = West
    of SWest:
      result = NEast
    of South:
      result = North
    of SEast:
      result = NWest


# const # need to think about making this an enum
#   North* = -8
#   South* =  8
#   East*  =  1
#   West*  = -1
#   NEast* = -7
#   NWest* = -9
#   SEast* =  9
#   SWest* =  7

const
  BoardSize* = 64
  MaxDepth* = 31
  MaxInt* = 1 shl (sizeof uint) - 1
  MinInt* = -MaxInt - 1


const
  Directions*   = [North, South, East, West, NEast, NWest, SEast, SWest]
  TopBorder*    = [0, 1, 2, 3, 4, 5, 6, 7]
  LeftBorder*   = [0, 8, 16, 24, 32, 40, 48, 56]
  BottomBorder* = [56, 57, 58, 59, 60, 61, 62, 63]
  RightBorder*  = [7, 15, 23, 31, 39, 47, 55, 63]
  CellWeights*  = [
    150, -30,  30,   5,   5,  30,  -30, 150,
    -30, -50,  -5,  -5,  -5,  -5,  -50, -30,
     30,  -5,  15,   3,   3,  15,   -5,  30,
      5,  -5,   3,   3,   3,   3,   -5,   5,
      5,  -5,   3,   3,   3,   3,   -5,   5,
     30,  -5,  15,   3,   3,  15,   -5,  30,
    -30, -50,  -5,  -5,  -5,  -5,  -50, -30,
    150, -30,  30,   5,   5,  30,  -30, 150,
  ]


const Columns* = {
    "a": 0,
    "b": 1,
    "c": 2,
    "d": 3,
    "e": 4,
    "f": 5,
    "g": 6,
    "h": 7,
  }.toOrderedTable


const Rows* = {
    "1": 0,
    "2": 1,
    "3": 2,
    "4": 3,
    "5": 4,
    "6": 5,
    "7": 6,
    "8": 7,
  }.toOrderedTable


const DirMap* = {
    North: "North",
    South: "South",
    East:  "East",
    West:  "West",
    NEast: "North East",
    NWest: "North West",
    SEast: "South East",
    SWest: "South West",
  }.toTable


proc printChar*(i: int, s: string) =
  if i mod 8 == 7:
    echo fmt" {s}"
  else:
    stdout.write fmt" {s}"


proc getCol*(x: int): char =
  case x mod 8:
    of 0:
      result = 'a'
    of 1:
      result = 'b'
    of 2:
      result = 'c'
    of 3:
      result = 'd'
    of 4:
      result = 'e'
    of 5:
      result = 'f'
    of 6:
      result = 'g'
    of 7:
      result = 'h'
    else:
      result = '_'


proc getRow*(x: int): int =
  result = (x div 8) + 1


proc isEmpty*(l: seq[int]): bool =
  result = l.len == 0


proc `++`*(i: var int) =
  inc i