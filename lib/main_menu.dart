import 'package:flutter/material.dart';

import 'level_menu.dart';

class MainMenu extends StatelessWidget {
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'TheBite',
                      fontSize: width * 0.04,
                      color: Colors.black54,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'S-math',
                          style: TextStyle(
                              fontSize: width * 0.1, fontFamily: 'SnakeFont', color: Colors.deepOrangeAccent)),
                      TextSpan(text: '\n Choose Your Game')
                    ],
                  ),
                ),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: height/8),
                  ),
                  Positioned(
                      left: width /2.5, // need to fix responsive?
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                            child: CircleAvatar(
                              radius: width * 0.03,
                              backgroundColor: Colors.deepOrangeAccent,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LevelMenu('add'),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.add),
                                iconSize: width * 0.04,
                                hoverColor: Colors.black,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                            child: CircleAvatar(
                              radius: width * 0.03,
                              backgroundColor: Colors.deepOrangeAccent,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LevelMenu('mult'),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.close_sharp),
                                iconSize: width * 0.04,
                                hoverColor: Colors.black,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
