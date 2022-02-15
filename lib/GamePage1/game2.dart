import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';



class DragScreen extends StatefulWidget {
  const DragScreen({Key? key}) : super(key: key);

  @override
  _DragScreenState createState() => _DragScreenState();
}

class _DragScreenState extends State<DragScreen> {

  final Map<String, bool> score = {};


  final Map choices = {
    '🍏': Colors.green,
    '🍋': Colors.yellow,
    '🍅': Colors.red,
    '🍇': Colors.purple,
    '🥥': Colors.brown,
    '🥕': Colors.orange
  };

  int seed = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("স্কোর ${score.length} / 6"),
            backgroundColor: Colors.pink,
          ),

          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: choices.keys.map((emoji) {
                  return Draggable(
                    data: emoji,
                    child: Emoji(emoji: score[emoji] == true ? '✅' : emoji),
                    feedback: Emoji(emoji: emoji),
                    childWhenDragging: const Emoji(emoji: '🌱'),
                  );
                }).toList(),
                // draggable widgets here
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: choices.keys
                    .map((emoji) => _buildDragTarget(emoji: emoji))
                    .toList()
                  ..shuffle(Random(seed)),
              ),
            ],
          )),
    );
  }

  Widget _buildDragTarget({required String emoji}) {
    return DragTarget<String>(
      builder: (BuildContext context, List incoming, List rejected) {
        if (score[emoji] == true) {
          return Container(
            color: Colors.white,
            child: const Text(
              'সঠিক!',
              style: TextStyle(fontSize: 25),
            ),
            alignment: Alignment.center,
            height: 80,
            width: 200,
          );
        } else {
          return Container(color: choices[emoji], height: 80, width: 200);
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
          plyr.play('success.mp3');
        });
      },
    );
  }
}

class Emoji extends StatelessWidget {
  final String emoji;

  const Emoji({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 100,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: Text(
          emoji,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}

AudioCache plyr = AudioCache();