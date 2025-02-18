// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistic_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatisticModelAdapter extends TypeAdapter<StatisticModel> {
  @override
  final int typeId = 4;

  @override
  StatisticModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StatisticModel(
      typeIndex: fields[0] as int,
      timestamp: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StatisticModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.typeIndex)
      ..writeByte(1)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatisticModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
