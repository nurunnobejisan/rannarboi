import 'package:cookbook/GamePage1/game4/game.dart';
import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const game4(title: 'Game of Colors'),
    );
  }
}

class game4 extends StatefulWidget {
  const game4({Key? key, required this.title}) : super(key: key);

  // always marked "final".

  final String title;

  @override
  State<game4> createState() => _game4State();
}

class _game4State extends State<game4> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Press to Start',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Game();
                    },
                  ),
                );
              },
              child: Text('Start', style: TextStyle(fontSize: 20.0)),
            )
          ],
        ),
      ),
    );
  }
}