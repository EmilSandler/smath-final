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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      overlayColor: MaterialStateProperty.all(Color.fromARGB(50, 0, 0, 255)),
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
                      elevation: MaterialStateProperty.all<double>(50)
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
                  child: Tooltip(
                    message: 'ADDITION',
                    child: Text('+',
                      style: TextStyle(fontSize: 60)
                  ),),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      overlayColor: MaterialStateProperty.all(Color.fromARGB(50, 0, 0, 255)),
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
                      elevation: MaterialStateProperty.all<double>(50)
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
                  child: Tooltip(
                    message: 'MULTIPLICATION',
                    child: Text('X',
                        style: TextStyle(fontSize: 60)
                    ),),
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    ));
  }

}