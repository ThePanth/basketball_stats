// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_game_statistic_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerGameStatisticModelAdapter
    extends TypeAdapter<PlayerGameStatisticModel> {
  @override
  final int typeId = 3;

  @override
  PlayerGameStatisticModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerGameStatisticModel(
      id: fields[0] as String,
      playerId: fields[1] as String,
      gameId: fields[2] as String,
      teamId: fields[3] as String,
      statisticItems: (fields[4] as List).cast<StatisticModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, PlayerGameStatisticModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.playerId)
      ..writeByte(2)
      ..write(obj.gameId)
      ..writeByte(3)
      ..write(obj.teamId)
      ..writeByte(4)
      ..write(obj.statisticItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerGameStatisticModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
