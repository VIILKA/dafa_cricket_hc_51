// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'affirmation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AffirmationRecordAdapter extends TypeAdapter<AffirmationRecord> {
  @override
  final int typeId = 1;

  @override
  AffirmationRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AffirmationRecord(
      id: fields[0] as String,
      text: fields[1] as String,
      isFavorite: fields[2] as bool,
      completionDates: (fields[3] as List).cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, AffirmationRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.isFavorite)
      ..writeByte(3)
      ..write(obj.completionDates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AffirmationRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
