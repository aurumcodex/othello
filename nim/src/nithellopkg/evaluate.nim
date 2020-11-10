##[
  evaluate.nim
  ============

  module to contain various hueristic procs for the search algorithms.
]##

import strformat

from board import Board
from moves import getWeight
from player import Color
from util import `++`

type
  Scores* = object
    black*: int
    white*: int
    score*: int


proc calculateScoresDisc*(b: Board): Scores =
  var
    blackCount = 0
    whiteCount = 0

  for c in b.board:
    case c:
      of Black:
        ++blackCount
      of White:
        ++whiteCount
      of None:
        discard
  
  let score = blackCount - whiteCount

  result = Scores(black: blackCount, white: whiteCount, score: score)


proc calculateScoresWeight*(b: Board): Scores =
  var
    blackCount = 0
    whiteCount = 0

  for i, c in b.board:
    # var i = i
    case c:
      of Black:
        blackCount += getWeight(i)
      of White:
        whiteCount += getWeight(i)
      of None:
        discard

  let score = blackCount - whiteCount

  result = Scores(black: blackCount, white: whiteCount, score: score)


proc printResults*(s: Scores) =
  if s.black > s.white:
    echo "player black wins."
    echo fmt"black pieces: {s.black}"
    echo fmt"white pieces: {s.white}"
  elif s.white > s.black:
    echo "player white wins."
    echo fmt"black pieces: {s.black}"
    echo fmt"white pieces: {s.white}"
  else:
    echo "a tie occurred."
    echo fmt"black pieces: {s.black}"
    echo fmt"white pieces: {s.white}"
  