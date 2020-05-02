import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:whackavirus/models/score.dart';

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadScores();
    });
  }

  void _loadScores() async {
    var box = await Hive.openBox('score');

    for (int i = 0; i < box.length; i++) {
      Score score = box.getAt(i);
      print(score.score);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Score List"),
      ),
      body: _scoreList(),
    );
  }

  Widget _scoreList() {
    return Container();
  }
}
