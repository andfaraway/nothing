// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LaunchInfoAdapter extends TypeAdapter<LaunchInfo> {
  @override
  final int typeId = 0;

  @override
  LaunchInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LaunchInfo(
      title: fields[0] as String?,
      image: fields[1] as String?,
      localPath: fields[2] as String?,
      dayStr: fields[3] as String?,
      monthStr: fields[4] as String?,
      dateDetailStr: fields[5] as String?,
      contentStr: fields[6] as String?,
      authorStr: fields[7] as String?,
      codeStr: fields[8] as String?,
      date: fields[9] as String?,
      backgroundImage: fields[10] as String?,
      localBackgroundPath: fields[11] as String?,
      homePage: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LaunchInfo obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.localPath)
      ..writeByte(3)
      ..write(obj.dayStr)
      ..writeByte(4)
      ..write(obj.monthStr)
      ..writeByte(5)
      ..write(obj.dateDetailStr)
      ..writeByte(6)
      ..write(obj.contentStr)
      ..writeByte(7)
      ..write(obj.authorStr)
      ..writeByte(8)
      ..write(obj.codeStr)
      ..writeByte(9)
      ..write(obj.date)
      ..writeByte(10)
      ..write(obj.backgroundImage)
      ..writeByte(11)
      ..write(obj.localBackgroundPath)
      ..writeByte(12)
      ..write(obj.homePage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LaunchInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
