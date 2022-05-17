


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'game.dart';
import 'main_menu.dart';

class LevelMenu extends StatelessWidget {
  final String gameType;


  LevelMenu(this.gameType);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/edenGarden.png"),
            fit: BoxFit.fill,
          ),
        ),
        child:
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MainMenu(),
                  ),
                );
              },
              icon: Icon(Icons.home),
              iconSize: width * 0.05,
              hoverColor: Colors.black,
              color: Colors.black87,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: width / 20),
                    child: Text(
                        'Choose Game Level',
                        style: TextStyle(
                          fontFamily: 'TheBite',
                          fontSize: width * 0.04,
                          color: Colors.black54,
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
                    width: width / 6,
                    height: height / 17,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.red),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => GamePage(gameType, 1),
                          ),
                        );
                      },
                      child: Text('Easy', style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  SizedBox(
                    width: width / 6,
                    height: height / 17,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.red),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => GamePage(gameType, 2),
                          ),
                        );
                      },
                      child: Text('Medium', style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  SizedBox(
                    width: width / 6,
                    height: height / 17,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.red),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => GamePage(gameType, 3),
                          ),
                        );
                      },
                      child: Text('Hard', style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}