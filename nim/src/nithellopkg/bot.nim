##[
  bot.nim
  =======

  file to be included into player.nim for bot related functions.
]##

import random, strformat, tables

import board, moves, player

from util import MaxInt, MinInt, MaxDepth, `-`

type
  MoveType {.pure, size: sizeof(char).} = enum
    Rng
    AlphaBeta
    Negamax
    MTDf


proc makeMove*(p: Player, moveset: seq[Move], game: Board, #[turnCount: int,]# debug: bool): int =
  # randomize()
  var
    # rng = rand(20)
    bestMove = -1
    depth = 0
    maxing = true
    alpha = MinInt.float64
    beta = MaxInt.float64
    color = p.color

  # var moveType: MoveType
  let moveType = AlphaBeta
  # case turnCount:
  # case rng:
  #   of 0..4:
  #     moveType = Rng
  #   of 5..9:
  #     moveType = AlphaBeta
  #   of 10..14:
  #     moveType = Negamax
  #   of 15..19:
  #     moveType = MTDf
  #   else:
  #     moveType = Rng
  
  case moveType:
    of Rng:
      echo "bot is using an rng move"
      bestMove = rngMove(moveset, debug)
      
    of AlphaBeta:
      echo "bot is using a move generated from alphaBeta"
      var abTable: Table[int, int]

      for m in moveset:
        var temp = game
        temp.apply(color, m.cell, debug)
        temp.flipDiscs(color, -m.direction, m.cell, debug)

        var abTemp = temp.alphaBeta(alpha, beta, -color, depth, not maxing, debug)

        echo fmt"alphaBeta output at cell {m.cell} :: {abTemp}"
        abTable[m.cell] = abTemp

      echo fmt"alphaBeta output: {abTable}"
      
      var max = 0
      for c, s in abTable:
        if s > max:
          max = s
          bestMove = c

    of Negamax:
      echo "bot is using a move generated from negamax"
      var nmTable: Table[int, int]

      for m in moveset:
        var temp = game
        temp.apply(color, m.cell, debug)
        temp.flipDiscs(color, -m.direction, m.cell, debug)

        var nmTemp = temp.negamax(alpha, beta, -color, depth, debug)

        echo fmt"negamax output at cell {m.cell} :: {nmTemp}"
        nmTable[m.cell] = nmTemp
        
      echo fmt"negamax output: {nmTable}"

      var max = 0
      for c, s in nmTable:
        if s > max:
          max = s
          bestMove = c

    else:
      echo "(the bot shruged)"
      bestMove = rngMove(moveset, debug)

  result = bestMove
