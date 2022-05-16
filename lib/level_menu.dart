


import 'dart:html';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'game.dart';

class LevelMenu extends StatelessWidget {
  final String gameType;


  LevelMenu(this.gameType);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    MediaQueryData queryData =  MediaQuery.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/edenGarden.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 50.0),
                child: Text(
                    'Choose Level',
                    style: TextStyle(
                      fontFamily: 'SnakeFont',
                      fontSize: width * 0.07,
                      color: Colors.deepOrangeAccent,
                      shadows: [
                        Shadow(
                          blurRadius: 20.0,
                          color: Colors.white,
                          offset: Offset(0, 0),
                        )
                      ],
                    )
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      overlayColor: MaterialStateProperty.all(Color.fromARGB(50, 0, 0, 255)),
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(50)),
                      elevation: MaterialStateProperty.all<double>(50)
                  ),
                  onPressed: () {
                    // Push and replace current screen (i.e MainMenu) with
                    // SelectSpaceship(), so that player can select a spaceship.
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => GamePage(gameType, 1),
                      ),
                    );
                  },
                  child: Tooltip(
                      message: 'UP TO 10',
                      child: Text('EASY', style: TextStyle(fontSize: width * 0.015))
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      overlayColor: MaterialStateProperty.all(Color.fromARGB(50, 0, 0, 255)),
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(50)),
                      elevation: MaterialStateProperty.all<double>(50)
                  ),
                  onPressed: () {
                    // Push and replace current screen (i.e MainMenu) with
                    // SelectSpaceship(), so that player can select a spaceship.
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => GamePage(gameType, 2),
                      ),
                    );
                  },
                  child: Tooltip(
                      message: 'UP TO 20',
                      child: Text('MEDIUM', style: TextStyle(fontSize: width * 0.015))
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      overlayColor: MaterialStateProperty.all(Color.fromARGB(50, 0, 0, 255)),
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(50)),
                      elevation: MaterialStateProperty.all<double>(50)
                  ),
                  onPressed: () {
                    // Push and replace current screen (i.e MainMenu) with
                    // SelectSpaceship(), so that player can select a spaceship.
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => GamePage(gameType, 3),
                      ),
                    );
                  },
                  child: Tooltip(
                      message: 'UP TO 30',
                      child: Text('HARD', style: TextStyle(fontSize: width * 0.015))
                  ),
                ),
              ),
                  ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}