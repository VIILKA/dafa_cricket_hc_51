// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmotionRecordAdapter extends TypeAdapter<EmotionRecord> {
  @override
  final int typeId = 0;

  @override
  EmotionRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmotionRecord(
      emotion: fields[0] as String,
      date: fields[1] as DateTime,
      reasons: (fields[2] as List?)?.cast<String>(),
      comment: fields[3] as String?,
      triggerList: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EmotionRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.emotion)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.reasons)
      ..writeByte(3)
      ..write(obj.comment)
      ..writeByte(4)
      ..write(obj.triggerList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmotionRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
