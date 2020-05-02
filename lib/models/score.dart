import 'package:hive/hive.dart';

part 'score.g.dart';

@HiveType(typeId: 0)
class Score {
  @HiveField(0)
  int score;

  @HiveField(1)
  bool success;

  @HiveField(2)
  String date;

  Score(this.score, this.success, this.date);
}
