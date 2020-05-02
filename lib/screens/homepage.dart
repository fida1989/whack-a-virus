import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:condition/condition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:whackavirus/models/score.dart';
import 'package:whackavirus/screens/scorepage.dart';
import 'package:whackavirus/screens/settingspage.dart';
import 'package:whackavirus/models/virus.dart';
import 'package:whackavirus/utils/virusstatus.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Virus> _virusList = [];
  bool _timerRunning = false;
  Timer _timer;
  final _random = Random();
  int _total = 0;
  int _whacked = 0;
  int _missed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Whack A Virus"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: _timerRunning ? Icon(Icons.stop) : Icon(Icons.play_arrow),
        label: _timerRunning ? Text('Stop Game') : Text('Start Game'),
        onPressed: () {
          if (_timerRunning) {
            _timer.cancel();
            _showScoreDialog(_total, _whacked, _missed);
            setState(() {
              _timerRunning = false;
              _total = 0;
              _whacked = 0;
              _missed = 0;
            });
            _generateList();
          } else {
            int _previous = 0;
            int _current = 0;
            _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
              _current = _generateRandom(0, 9);
              setState(() {
                if (_virusList[_previous].status == VirusStatus.whacked) {
                  Future.delayed(Duration(milliseconds: 500), () {
                    _virusList[_previous].status = VirusStatus.none;
                  });
                } else {
                  _virusList[_previous].status = VirusStatus.none;
                }
                _virusList[_current].status = VirusStatus.visible;
                _missed = _total - _whacked;
                _total = _total + 1;
              });
              _previous = _current;
            });
            setState(() {
              _timerRunning = true;
            });
            _generateList();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.list,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: ScorePage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.info,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _scoreView(),
            _bodyView(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _generateList();
    });
  }

  Widget _bodyView() {
    return Container(
      child: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 3,
        shrinkWrap: true,
        // Generate 100 widgets that display their index in the List.
        children: _virusList.map((Virus v) {
          return _virusView(v);
        }).toList(),
      ),
    );
  }

  void _generateList() {
    List<Virus> _tempList = [];
    int count = 9;
    for (int i = 0; i < count; i++) {
      _tempList.add(Virus(VirusStatus.none));
    }
    setState(() {
      _virusList = _tempList;
    });
  }

  Widget _virusView(Virus v) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Conditioned(
          cases: [
            Case(
              v.status == VirusStatus.none,
              builder: () => Image.asset("images/virus_white.png"),
            ),
            Case(
              v.status == VirusStatus.visible,
              builder: () => GestureDetector(
                onTap: () {
                  setState(() {
                    v.status = VirusStatus.whacked;
                    _whacked = _whacked + 1;
                  });

                  Future.delayed(Duration(milliseconds: 250), () {
                    setState(() {
                      v.status = VirusStatus.none;
                    });
                  });
                },
                child: Image.asset("images/virus.png"),
              ),
            ),
            Case(
              v.status == VirusStatus.whacked,
              builder: () => Image.asset("images/virus_whacked.png"),
            ),
          ],
          defaultBuilder: () => Container(),
        ),
      ),
    );
  }

  int _generateRandom(int min, int max) => min + _random.nextInt(max - min);

  Widget _scoreView() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Card(
              child: Container(
                margin: EdgeInsets.all(10),
                child: AutoSizeText(
                  "Total: " + _total.toString(),
                  minFontSize: 15,
                  maxFontSize: 25,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Card(
              child: Container(
                margin: EdgeInsets.all(10),
                child: AutoSizeText(
                  "Whacked: " + _whacked.toString(),
                  minFontSize: 15,
                  maxFontSize: 25,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Card(
              child: Container(
                margin: EdgeInsets.all(10),
                child: AutoSizeText(
                  "Missed: " + _missed.toString(),
                  minFontSize: 15,
                  maxFontSize: 25,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showScoreDialog(int total, int whacked, int missed) {
    Alert(
      context: context,
      image: Image.asset(
        whacked > missed ? "images/success.png" : "images/fail.png",
        fit: BoxFit.contain,
        width: MediaQuery.of(context).size.width / 3,
      ),
      title: whacked > missed ? "Mission Success!" : "Mission Fail!",
      desc: "You whacked $whacked viruses!",
      style: AlertStyle(isOverlayTapDismiss: false, isCloseButton: false),
      buttons: [
        DialogButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            "Close",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            var box = await Hive.openBox('score');
            var score = Score(whacked, whacked > missed,
                DateFormat("MMM d 'at' hh:mm a").format(DateTime.now()));
            await box.add(score);
            await box.close();
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }
}
