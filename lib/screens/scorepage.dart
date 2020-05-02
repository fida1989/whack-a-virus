import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:whackavirus/models/score.dart';

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  List<Score> _scoreList = [];
  String _placeHolder = "Loading Scores...";

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      try {
        _loadScores();
      } on Exception catch (e) {
        setState(() {
          _placeHolder = "No Scores Found!";
        });
      }
    });
  }

  void _loadScores() async {
    List<Score> _tempList = [];
    var box = await Hive.openBox('score');
    if (box.length > 0) {
      for (int i = 0; i < box.length; i++) {
        Score score = box.getAt(i);
        _tempList.add(score);
      }

      setState(() {
        _scoreList = List.from(_tempList.reversed);
      });
    } else {
      setState(() {
        _placeHolder = "No Scores Found!";
      });
    }
    await box.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Scoreboard"),
      ),
      body: SafeArea(
        child: _scoreList.length > 0 ? _scoreListView() : _emptyView(),
      ),
    );
  }

  Widget _emptyView() {
    return Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: AutoSizeText(
            _placeHolder,
            minFontSize: 20,
            maxFontSize: 35,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _scoreListView() {
    return ListView.builder(
      itemCount: _scoreList.length,
      itemBuilder: (context, index) {
        Score score = _scoreList[index];
        return Card(
          margin: EdgeInsets.all(5),
          child: ListTile(
            title: Text("You whacked ${score.score} viruses!"),
            subtitle: Text(score.date),
            leading: Image.asset(
                score.success ? "images/success.png" : "images/fail.png"),
          ),
        );
      },
    );
  }
}
