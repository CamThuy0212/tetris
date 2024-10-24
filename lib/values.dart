import 'package:flutter/material.dart';

// grid dimension
int rowLenght = 10;
int colLenght = 15;

enum Direction { left, right, down }

enum Tetromino {
  L(Colors.orange),
  J(Colors.blue),
  I(Colors.pink),
  O(Colors.yellow),
  S(Colors.green),
  Z(Colors.red),
  T(Colors.purple);

  const Tetromino(this.color);
  final Color color;
}
