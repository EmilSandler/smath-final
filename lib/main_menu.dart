import 'package:flutter/material.dart';

import 'level_menu.dart';

class MainMenu extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                    'S-Math',
                    style: TextStyle(
                      fontFamily: 'SnakeFont',
                      fontSize: width * 0.1,
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
              SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                child: ElevatedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    // Push and replace current screen (i.e MainMenu) with
                    // SelectSpaceship(), so that player can select a spaceship.
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LevelMenu('add'),
                      ),
                    );
                  },
                  child: Text('Play Addition'),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                child: ElevatedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    // Push and replace current screen (i.e MainMenu) with
                    // SelectSpaceship(), so that player can select a spaceship.
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LevelMenu('mult'),
                      ),
                    );
                  },
                  child: Text('Play Multiplication'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}