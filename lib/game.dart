import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_game/main_menu.dart';
import 'package:flutter_snake_game/problem.dart';
import 'package:flutter_snake_game/sound_manager.dart';
import 'package:confetti/confetti.dart';


import 'control_panel.dart';
import 'direction.dart';
import 'direction_type.dart';
import 'piece.dart';


class GamePage extends StatefulWidget {
  final String type;
  final int level;


  GamePage(this.type, this.level);

  @override
  _GamePageState createState() => _GamePageState();

}

class _GamePageState extends State<GamePage> {
  List<Offset> positions = [];
  int length = 10;
  int step = 40;
  Direction direction = Direction.right;
  ConfettiController _controllerConfetti;


  List<Piece> foods = [];
  List<Offset> foodsPosition = [];

  double screenWidth;
  double screenHeight;
  int lowerBoundX, upperBoundX, lowerBoundY, upperBoundY;

  Timer timer;
  double speed = 1;

  int score = 0;
  List<Problem> problems = [];
  Problem problem;

  bool playMusic = true;
  bool changeColor = false;
  Color shadowColor;
  Color prevFoodColor = Colors.red;

  SoundManager _soundManager = SoundManager();
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  bool isGameOver = false;

  void draw()  {
    if (positions.length == 0) {
      positions.add(Offset(roundToNearestTens(((upperBoundX + lowerBoundX) / 2.0 - step).round().toInt()).toDouble(),
                           roundToNearestTens(((upperBoundY + lowerBoundY) / 2.0 - step).round().toInt()).toDouble()));
      // positions.add(getRandomPositionWithinRange());
    }

    while (length > positions.length) {
      positions.add(positions[positions.length - 1]);
    }

    for (int i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }
    positions[0] = getNextPosition(positions[0]);
  }

  Direction getRandomDirection([DirectionType type]) {
    if (type == DirectionType.horizontal) {
      bool random = Random().nextBool();
      if (random) {
        return Direction.right;
      } else {
        return Direction.left;
      }
    } else if (type == DirectionType.vertical) {
      bool random = Random().nextBool();
      if (random) {
        return Direction.up;
      } else {
        return Direction.down;
      }
    } else {
      int random = Random().nextInt(4);
      return Direction.values[random];
    }
  }

  Offset getRandomPositionWithinRange() {
    int posX = Random().nextInt(upperBoundX) + lowerBoundX - step;
    int posY = Random().nextInt(upperBoundY) + lowerBoundY - step;
    return Offset(roundToNearestTens(posX).toDouble(), roundToNearestTens(posY).toDouble());
  }

  List<Offset> getRandomPositionWithinRangeV2() {
    List<Offset> temp = [];
    while (temp.length < 3) {
      int posX = Random().nextInt(upperBoundX) + lowerBoundX - step;
      if (posX < lowerBoundX) { posX = lowerBoundX; }
      int posY = Random().nextInt(upperBoundY) + lowerBoundY - step;
      if (posY < lowerBoundY) { posY = lowerBoundY; }
      if (isFoodPositionValid(temp, roundToNearestTens(posX).toDouble(), roundToNearestTens(posY).toDouble())) {
        temp.add(Offset(roundToNearestTens(posX).toDouble(), roundToNearestTens(posY).toDouble()));
      }
    }
    return temp;
  }

  bool isFoodPositionValid(List<Offset> positions, double posX, double posY) {
    for (Offset position in positions) {
      if (position.dx == posX && position.dy == posY) {
        return false;
      }
      for (Offset position in this.positions) {
        if (position.dx == posX && position.dy == posY) {
          return false;
        }
      }
    }
    return true;
  }

  bool detectCollision(Offset position) {
    if (position.dx >= upperBoundX && direction == Direction.right) {

      return true;
    } else if (position.dx <= lowerBoundX && direction == Direction.left) {
      return true;
    } else if (position.dy >= upperBoundY && direction == Direction.down) {
      return true;
    } else if (position.dy <= lowerBoundY && direction == Direction.up) {
      return true;
    }

    return false;
  }

  void showGameOverDialog() {
    double width = MediaQuery.of(context).size.width;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.01),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          title: Text(
            "Game Over",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.deepOrangeAccent,
                fontFamily: 'SnakeFont',
                fontSize: width * 0.1,
                letterSpacing: 4),
          ),
          content: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.white70,
                fontSize: width * 0.03, fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(text: 'Score'),
                TextSpan(text: '\n'+score.toString(), style: TextStyle(
                  fontSize: width * 0.05, fontFamily: 'SnakeFont')
                )
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                Navigator.of(context).pop();
                restart();
              },
              icon: Icon(Icons.restart_alt_sharp),
              iconSize: width * 0.04,
              hoverColor: Colors.white10,
              color: Colors.deepOrangeAccent,
            ),
            IconButton(
              onPressed: () async {
                Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MainMenu(),
                ),
                );
              },
              icon: Icon(Icons.home),
              iconSize: width * 0.04,
              hoverColor: Colors.white10,
              color: Colors.deepOrangeAccent,
            ),
          ],
        );
      },
    );
  }

  Offset getNextPosition(Offset position) {
    Offset nextPosition;

    if (detectCollision(position) == true) {
      _soundManager.stopBackgroundMusic();
      if (timer != null && timer.isActive) timer.cancel();
      Future.delayed(Duration(milliseconds: 500), () => showGameOverDialog());
      isGameOver = true;
      return position;
    }

    if (direction == Direction.right) {
      nextPosition = Offset(position.dx + step, position.dy);
    } else if (direction == Direction.left) {
      nextPosition = Offset(position.dx - step, position.dy);
    } else if (direction == Direction.up) {
      nextPosition = Offset(position.dx, position.dy - step);
    } else if (direction == Direction.down) {
      nextPosition = Offset(position.dx, position.dy + step);
    }

    return nextPosition;
  }



  List<Problem> generateNewProblems() {
    List<Problem> tempProblems = [];

    for (int i = 0; i < foodsPosition.length; i++) {
      Problem newProblem = Problem(widget.type).generateProblem((widget.level));
      while (!isProblemValid(tempProblems, newProblem)) {
        newProblem = Problem(widget.type).generateProblem((widget.level));
      }
      tempProblems.add(newProblem);
    }
    return tempProblems;
  }

  bool isProblemValid(List<Problem> problems, Problem newProblem) {
    for (Problem problem in problems) {
      if ((problem.type == 'add' && problem.x + problem.y == newProblem.x + newProblem.y) ||
          (problem.type == 'mult' && problem.x * problem.y == newProblem.x * newProblem.y)) {
        return false;
      }
    }
    return true;
  }
  bool isAnswerCorrect(Piece foodPiece){
    if(widget.type == 'add'){
      if(foodPiece.problem.x + foodPiece.problem.y == problems[0].x + problems[0].y){
        return true;
      }
    }
    else if (widget.type == 'mult'){
      if(foodPiece.problem.x * foodPiece.problem.y == problems[0].x * problems[0].y){
        return true;
      }
    }

    return false;
  }

  Color getShadowColor(){
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }


  void drawFood() {
    if (foodsPosition.isEmpty) {
      foodsPosition = getRandomPositionWithinRangeV2();
      problems = generateNewProblems();
    }
    for(int i = 0; i < foodsPosition.length; i++){
      if (foodsPosition[i] == positions[0]) {
        if(isAnswerCorrect(foods[i])){
          _soundManager.playCorrectAnswerSound();
          _controllerConfetti.play();

          prevFoodColor = foods[i].color;
          shadowColor = getShadowColor();
          changeColor = true;
          length++;
          if(speed<5) {
            speed = speed + 0.25;
          }
          score = score + 1;
          changeSpeed();
          draw();
        }
       else{
         _soundManager.playWrongAnswerSound();
         shadowColor = getShadowColor();
         changeColor = false;
         length--;
         if (length < 2) {
           _soundManager.stopBackgroundMusic();
           if (timer != null && timer.isActive) timer.cancel();
           Future.delayed(Duration(milliseconds: 200), () => showGameOverDialog());
           isGameOver = true;
         }
        }
        foodsPosition = getRandomPositionWithinRangeV2();
        problems = generateNewProblems();
      }
    }

    if(foods.isNotEmpty){
      foods.clear();
    }
    for(int i = 0; i < foodsPosition.length; i++) {
      foods.add(Piece(
        posX: foodsPosition[i].dx.toInt(),
        posY: foodsPosition[i].dy.toInt(),
        size: step,
        color: shadowColor == null ? Colors.purple:shadowColor,
        // isAnimated: true,
        problem: problems[i],
        shadowColor: shadowColor == null ? Colors.purple:shadowColor,
        gameType: widget.type,
        image: 'images/apple.png'
      )
      );
    }
  }


  List<Piece> getPieces() {
    List<Piece> pieces = [];
    draw();
    drawFood();

    for (int i = 0; i < length; i++) {
      if (i >= positions.length) {
        continue;
      }

      pieces.add(
        Piece(
          posX: positions[i].dx.toInt(),
          posY: positions[i].dy.toInt(),
          size: step,
          color: prevFoodColor,
          shadowColor: prevFoodColor,
          gameType: widget.type,
          image: getSnakePiece(i)
        ),
      );
    }

    return pieces;
  }

  Widget getControls() {
    return ControlPanel(
      onTapped: (Direction newDirection) {
        direction = newDirection;
      },
    );
  }



  int roundToNearestTens(int num) {
    int divisor = step;
    int output = (num ~/ divisor) * divisor;
    if (output == 0) {
      output += step;
    }
    return output;
  }

  void changeSpeed() {
    if (timer != null && timer.isActive) timer.cancel();

    // if you want timer to tick at fixed duration.
    timer = Timer.periodic(Duration(milliseconds: 200 ~/ speed), (timer) {
      setState(() {});
    });
  }

  Widget getScore(double screenWidth, double screenHeight) {
    print (1);
    return Positioned(
      left: screenWidth / 2 - 140 ,
      child: Container (
        width: 280,
        height: 130,
        alignment: AlignmentDirectional.topCenter,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/scoreBoard.png'),
              fit: BoxFit.cover,
            )
        ),
        child: Stack(
          children: <Widget>[
            // Stroked text as border.
            Container(
              margin: EdgeInsets.only(top: 17),
              child: Text(
                score.toString(),
                style: TextStyle (
                  fontSize: 50,
                  color: Colors.black54,
                  fontFamily: 'SnakeFont'
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Solid text as fill.

          ],
        ),
      ),
    );
  }

  String getProblemStringByType(){
    if (problems.length <= 0) {
      return '';
    }

    int x,y;

    if(problems[0].x > problems[0].y){
      x = problems[0].x;
      y = problems[0].y;
    }
    else{
      x = problems[0].y;
      y = problems[0].x;
    }


    if(widget.type == 'add'){
      return "$x + $y";
    }
    else if(widget.type == 'mult'){
      return "$x x $y";
    }
    return "$x + $y";
  }

  Widget getProblem() {
    double width = MediaQuery.of(context).size.width;

    return Center(
      child: Stack(
        children: <Widget>[
          // Stroked text as border.
          Text(
            getProblemStringByType(),
            style: TextStyle(
              fontSize: width * 0.1,
              color: Colors.black45.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  void restart() {
    _soundManager.playBackgroundMusic();
    score = 0;
    length = 5;
    positions = [];
    direction = getRandomDirection();
    speed = 1;
    changeSpeed();
    if (isGameOver) {
      foodsPosition = [];
      getPieces();
    }
    isGameOver = false;
  }

  Widget getPlayAreaBorder() {
    return Positioned(
      top: lowerBoundY.toDouble(),
      left: lowerBoundX.toDouble(),
      child: Container(
        width: (upperBoundX - lowerBoundX + step).toDouble(),
        height: (upperBoundY - lowerBoundY + step).toDouble(),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
            style: BorderStyle.solid,
            width: 5.0,
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _soundManager.playBackgroundMusic();
    _controllerConfetti =
        ConfettiController(duration: const Duration(seconds: 1));
    restart();
  }

  Widget getKeyboardControls(BuildContext context){
    return RawKeyboardListener(
      autofocus: true,
        focusNode: FocusNode(),
        onKey: (event){
          if(event.isKeyPressed(LogicalKeyboardKey.arrowUp)){
            direction = Direction.up;
          }
          else if(event.isKeyPressed(LogicalKeyboardKey.arrowDown)){
            direction = Direction.down;
          }
          else if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)){
            direction = Direction.left;
          }
          else if(event.isKeyPressed(LogicalKeyboardKey.arrowRight)){
            direction = Direction.right;
          }
        }, child: Container(),

    );
  }

  String getSnakePiece(int i) {
    if (isGameOver) {
      return '';
    }
    // head
    if (i == 0) {
      if (direction == Direction.right) {
        return 'images/snake-pieces/head-right.png';
      }
      else if (direction == Direction.left) {
        return 'images/snake-pieces/head-left.png';
      }
      else if (direction == Direction.up) {
        return 'images/snake-pieces/head-top.png';
      }
      else if (direction == Direction.down) {
        return 'images/snake-pieces/head-bottom.png';
      }
    }
    // tail
    else if (i == length - 1) {
      if (positions[i].dx > positions[i - 1].dx) {
        return 'images/snake-pieces/tail-left.png';
      }
      if (positions[i].dx < positions[i - 1].dx) {
        return 'images/snake-pieces/tail-right.png';
      }
      if (positions[i].dy > positions[i - 1].dy) {
        return 'images/snake-pieces/tail-top.png';
      }
      if (positions[i].dy < positions[i - 1].dy) {
        return 'images/snake-pieces/tail-bottom.png';
      }
    }
    // corner piece
    else if ((positions[i].dy > positions[i - 1].dy &&
             positions[i].dx > positions[i + 1].dx) ||
            (positions[i].dx > positions[i - 1].dx &&
              positions[i].dy > positions[i + 1].dy)) {
      return 'images/snake-pieces/left-top.png';
    }
    else if ((positions[i].dy > positions[i - 1].dy &&
             positions[i].dx < positions[i + 1].dx) ||
            (positions[i].dx < positions[i - 1].dx &&
                positions[i].dy > positions[i + 1].dy)) {
      return 'images/snake-pieces/right-top.png';
    }
    else if ((positions[i].dy < positions[i - 1].dy &&
        positions[i].dx < positions[i + 1].dx) ||
        (positions[i].dx < positions[i - 1].dx &&
            positions[i].dy < positions[i + 1].dy)) {
      return 'images/snake-pieces/right-bottom.png';
    }
    else if ((positions[i].dy < positions[i - 1].dy &&
        positions[i].dx > positions[i + 1].dx) ||
        (positions[i].dx > positions[i - 1].dx &&
            positions[i].dy < positions[i + 1].dy)) {
      return 'images/snake-pieces/left-bottom.png';
    }
    // straight piece
    else {
      if (positions[i].dy == positions[i - 1].dy) {
        return 'images/snake-pieces/left-right.png';
      }
      else if (positions[i].dx == positions[i - 1].dx) {
        return 'images/snake-pieces/top-bottom.png';
      }
    }

    return '';
  }
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    lowerBoundX = 2*step;
    lowerBoundY = 2*step;
    upperBoundX = roundToNearestTens(screenWidth.toInt() - 3*step);
    upperBoundY = roundToNearestTens(screenHeight.toInt() - 3*step);


    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          )
        ),
        child: Stack(
          children: [
            getPlayAreaBorder(),
            getProblem(),
            Container(
              child: Stack(
                children: getPieces(),
              ),
            ),
            foods[0],
            foods[1],
            foods[2],
            confetti(Alignment.centerRight, pi),
            confetti(Alignment.centerLeft ,0),
            //getControls(),
            getScore(screenWidth, screenHeight),
            getKeyboardControls(context)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerConfetti.dispose();
    super.dispose();
  }

  Widget confetti(Alignment alignment, double direction) {
    return Align(
      alignment: alignment,
      child: ConfettiWidget(
        confettiController: _controllerConfetti,
        blastDirection: direction, // radial value - LEFT
        particleDrag: 0.05, // apply drag to the confetti
        emissionFrequency: 0.05, // how often it should emit
        numberOfParticles: 20, // number of particles to emit
        gravity: 0.05, // gravity - or fall speed
        shouldLoop: false,
        colors: const [
          Colors.yellowAccent,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple
        ],
        createParticlePath: drawStar,// manually specify the colors to be used
        //strokeWidth: 1,
        //strokeColor: Colors.white,
      ),
    );
  }


  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
