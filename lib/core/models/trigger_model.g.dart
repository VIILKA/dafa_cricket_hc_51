// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trigger_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TriggerListAdapter extends TypeAdapter<TriggerList> {
  @override
  final int typeId = 3;

  @override
  TriggerList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TriggerList(
      id: fields[0] as String?,
      name: fields[1] as String,
      triggers: (fields[2] as List).cast<String>(),
      comment: fields[3] as String?,
      createdAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TriggerList obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.triggers)
      ..writeByte(3)
      ..write(obj.comment)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TriggerListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
