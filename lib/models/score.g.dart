// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScoreAdapter extends TypeAdapter<Score> {
  @override
  final typeId = 0;

  @override
  Score read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Score(
      fields[0] as int,
      fields[1] as bool,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Score obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.score)
      ..writeByte(1)
      ..write(obj.success)
      ..writeByte(2)
      ..write(obj.date);
  }
}
