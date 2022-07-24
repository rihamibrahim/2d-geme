import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myprojects/control.dart';
import 'package:myprojects/direction.dart';
import 'package:myprojects/pice.dart';
import 'dart:math';

class GamePage extends StatefulWidget {
  const GamePage({Key key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int upperBoundX, upperBoundY, lowerBoundX, lowerBoundY;
  double screenWidth, screenHieght;
  int step = 30;
  int length = 5;
  Direction direction = Direction.right;
  List<Offset> positions = [];
  Timer timer;
  Offset foodPosition;

  Piece food;
  int score = 0;
  double speed = 1.0;
  void chanageSpeed() {
    if (timer != null && timer.isActive) {
      timer?.cancel();
    }
    timer = Timer.periodic( Duration(microseconds: 200 ~/speed) , (timer) {
      setState(() {});
    });
  }

  Widget getControls() {
    return ControlPanel(onTapped: (Direction newDirction) {
      direction = newDirction;
    });
  }


  Direction getRandomDirections(){
    int val =Random().nextInt(4);
    direction=Direction.values[val];
    return direction;
  }
  void restart() {
    length=5;
    score=0;
    speed=1;
    positions=[];
    direction=getRandomDirections();
    chanageSpeed();
  }

  @override
  initState() {
    super.initState();
    restart();
  }

  int getNearestTens(int num) {
    int output;
    output = (num ~/ step) *
        step; // ~/ 34an lw 3ans Ra2m double byb2a int n el way de ~/.
    if (output == 0) {
      output += step;
    }
    return output;
  }

  Offset getRandomPosition() {
    Offset position;
    int posX = Random().nextInt(upperBoundX) + lowerBoundX;
    int posy = Random().nextInt(upperBoundY) + lowerBoundY;

    position = Offset(
        getNearestTens(posX).toDouble(), getNearestTens(posy).toDouble());
    return position;
  }

  Future<void> draw() async {
    if (positions.length == 0) {
      positions.add(getRandomPosition());
    }
    while (length > positions.length) {
      positions.add(positions[positions.length - 1]);
    }
    for (var i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }
    positions[0] = await getNextPosition(positions[0]);
  }

  bool detectCollision(Offset position) {
    if (position.dx >= upperBoundX && direction == Direction.right) {
      return true;
    } else if (position.dx >= upperBoundX && direction == Direction.left) {
      return true;
    } else if (position.dy >= upperBoundY && direction == Direction.down) {
      return true;
    } else if (position.dy >= upperBoundY && direction == Direction.up) {
      return true;
    }
    return false;
  }

  void getGameOverDelayed() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.red,
          shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.blue,
                width: 3.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Game Over",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Text(
            "Your game is over but you played well. Your score is : $score",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  restart();
                },
                child: const Text(
                  "Restart",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))
          ],
        );
      },
    );
  }

  Future<Offset> getNextPosition(Offset position) async {
    Offset nextPosition;

    if (direction == Direction.right) {
      nextPosition = Offset(position.dx + step, position.dy);
    } else if (direction == Direction.left) {
      nextPosition = Offset(position.dx - step, position.dy);
    } else if (direction == Direction.up) {
      nextPosition = Offset(position.dx, position.dy - step);
    } else if (direction == Direction.down) {
      nextPosition = Offset(position.dx, position.dy + step);
    }
    if (detectCollision(position) == true) {
      if(timer!=null&& timer.isActive){
        timer.cancel();
      }
      await Future.delayed(
          const Duration(microseconds: 200), () => getGameOverDelayed());
      return position;
    }
    return nextPosition;
  }

  void drawFood() {
    foodPosition ??= getRandomPosition();
    if (foodPosition == positions[0]) {
      length++;
      score = score + 5;
      speed = speed + 0.25;
      foodPosition = getRandomPosition();
    }
    food = Piece(
      posY: foodPosition.dy.toInt(),
      posX: foodPosition.dx.toInt(),
      color: Colors.red,
      size: step,
      isAnimated: true,
    );
  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];
    draw();
    drawFood();
    for (var i = 0; i < length; ++i) {
      if (i >= positions.length) {
        continue;
      }
      pieces.add(Piece(
        color: i.isEven ? Colors.red : Colors.green,
        posY: positions[i].dy.toInt(),
        posX: positions[i].dx.toInt(),
        size: step,
        isAnimated: false,
      ));
    }
    return pieces;
  }

  getScores() {
    return Positioned(
        top: 80.0,
        right: 50.0,
        child: Text(
          "Score :$score",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    screenHieght = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    lowerBoundX = step;
    lowerBoundY = step;

    upperBoundY = getNearestTens(screenHieght.toInt() - step);
    upperBoundX = getNearestTens(screenWidth.toInt() - step);
    return Scaffold(
      body: Container(
        color: Colors.amber,
        child: Stack(
          children: [
            Stack(
              children: getPieces(),
            ),
            getControls(),
            food,
            getScores(),
          ],
        ),
      ),
    );
  }
}
