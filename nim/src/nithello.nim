##[
  nithello.nim
  ============

  main application file; runs othello game.
]##

import strformat, tables

import nithellopkg/player
import nithellopkg/board
import nithellopkg/evaluate
import nithellopkg/moves
import nithellopkg/util


proc nithello(human=true, debug=false) =
  ## Plays a game of Othello - written in Nim
  var 
    game: Board
    turnCount = 0
    m = 0

  echo "what color do you want to play as? (black or white)"
  var input = stdin.readLine

  while true:
    echo fmt"got {input} from you."
    case input:
      of "B", "b", "black":
        echo "player will be set as black"
        game = setup Black
        break
      of "W", "w", "white":
        echo "player will be set as white"
        game = setup White
        break
      else:
        echo "unable to get acceptable input. please re-enter"
        input = stdin.readLine

  # print game
  var currentPlayer = game.player.color

  while not game.gameOver:
    var
      movelist: seq[Move]
      cells: seq[int]
    
    echo fmt"turn count is: {turnCount}"

    if currentPlayer == Black:#
      movelist = @[] # clear movelist
      cells = @[] # clear cellList
      movelist = game.generateMoves(game.player.color)

      print game, movelist

      echo "legal moves:"
      for n in movelist:
        print n, currentPlayer
        cells.add(n.cell)
      
      if movelist.len == 0:
        echo "player has to pass"
        game.player.getPassInput(game.bot)
      else:
        m = game.player.getInput(cells, human)
        game.apply(game.player.color, m, debug)

        for n in movelist:
          if n.cell == m:
            game.flipDiscs(game.player.color, -n.direction, n.cell, debug)

    elif currentPlayer == White:
      movelist = @[]
      cells = @[]
      movelist = game.generateMoves(game.bot.color)

      print game, movelist

      echo "legal moves:"
      for n in movelist:
        print n, currentPlayer
        cells.add(n.cell)

      if movelist.len == 0:
        echo "bot has to pass"
        if game.player.passing == false:
          game.player.passing = true
        else:
          game.bot.passing = true

      else:
        m = game.bot.makeMove(movelist, game, debug)
        if not cells.contains(m):
          echo "bot made a funny move; using rng fallback"
          m = rngMove(movelist, debug)

        echo fmt"bot generated move: {game.bot.color} {getCol(m)} {getRow(m)}"
        game.apply(game.bot.color, m, debug)

        for n in movelist:
          if n.cell == m:
            game.flipDiscs(game.bot.color, -n.direction, n.cell, debug)

    currentPlayer = -currentPlayer
    game.gameOver = game.isGameOver

    ++turnCount

  echo fmt"game has ended | turns taken: {turnCount}"

  let scores = game.calculateScoresDisc
  printResults scores


when isMainModule:
  import cligen
  dispatch nithello
