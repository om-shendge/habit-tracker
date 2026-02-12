// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_metadata_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitMetadataModelAdapter extends TypeAdapter<HabitMetadataModel> {
  @override
  final int typeId = 0;

  @override
  HabitMetadataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitMetadataModel(
      id: fields[0] as String,
      name: fields[1] as String,
      gradientColors: (fields[2] as List?)?.cast<int>(),
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      frequency: fields[5] as HabitFrequency,
      targetCount: fields[6] as int,
      specificDays: (fields[7] as List?)?.cast<int>(),
      isActive: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HabitMetadataModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.gradientColors)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.frequency)
      ..writeByte(6)
      ..write(obj.targetCount)
      ..writeByte(7)
      ..write(obj.specificDays)
      ..writeByte(8)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitMetadataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}



