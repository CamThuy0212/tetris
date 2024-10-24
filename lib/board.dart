import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/piece.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/values.dart';

// create game board
List<List<Tetromino?>> gameBoard = List.generate(
  colLenght,
  (i) => List.generate(
    rowLenght,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Piece currentPiece = Piece(type: Tetromino.T);

  @override
  void initState() {
    super.initState();

    // start game when app start
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    // frame refresh rate
    Duration frameRate = const Duration(milliseconds: 600);
    gameLoop(frameRate);
  }

  // game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(
      frameRate,
      (timer) {
        setState(() {
          // check landing
          checkLanding();

          //move current piece down
          currentPiece.movePice(Direction.down);
        });
      },
    );
  }

  // check for collison in the future posision
  // return true -> there is a collision
  // return false -> there is no collision
  bool checkCollision(Direction direction) {
    // loop through each position of the current piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      // calculate the row and column of the current position
      int row = (currentPiece.position[i] / rowLenght).floor();
      int col = currentPiece.position[i] % rowLenght;

      // adjust the row and col based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // check if the piece is out of bounds (either too low or too far to the left or right)
      if (row >= colLenght || col < 0 || col >= rowLenght) {
        return true;
      }

      // check for collisions with other landed pieces
      if (row >= 0 && gameBoard[row][col] != null) {
        return true;
      }
    }

    // if no collision is detected, return false
    return false;
  }

  void checkLanding() {
    // if going down is occupied

    if (checkCollision(Direction.down)) {
      // mark position as occupied on the gameboard
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLenght).floor();
        int col = currentPiece.position[i] % rowLenght;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      // once landed create new piece
      createNewPiece();
    }
  }

  void createNewPiece() {
    // create a random object to generate random tetromino types
    Random rand = Random();

    // create a new piece with random types
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();
  }

  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePice(Direction.left);
      });
    }
  }

  void rotatePiece() {}

  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePice(Direction.right);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // GAME GRID
          Expanded(
            child: GridView.builder(
              itemCount: rowLenght * colLenght,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLenght),
              itemBuilder: (context, index) {
                // get row and col of each index
                int row = (index / rowLenght).floor();
                int col = index % rowLenght;

                if (currentPiece.position.contains(index)) {
                  // current piece
                  return Pixel(
                    color: currentPiece.type.color,
                    child: index.toString(),
                  );
                }
                // landed piece
                else if (gameBoard[row][col] != null) {
                  return Pixel(
                    color: gameBoard[row][col]?.color,
                    child: index.toString(),
                  );
                }

                // blank pixel
                else {
                  return Pixel(
                    color: Colors.grey[900],
                    child: index.toString(),
                  );
                }
                return null;
              },
            ),
          ),

          // GAME CONTROLS
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //left
                IconButton(
                  onPressed: moveLeft,
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                ),

                //rotate
                IconButton(
                  onPressed: rotatePiece,
                  icon: const Icon(Icons.rotate_right),
                  color: Colors.white,
                ),

                //right
                IconButton(
                  onPressed: moveRight,
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
