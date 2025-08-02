// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SmsMessageAdapter extends TypeAdapter<SmsMessage> {
  @override
  final int typeId = 3;

  @override
  SmsMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmsMessage(
      text: fields[0] as String,
      timestamp: fields[1] as String?,
      sender: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SmsMessage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.sender);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmsMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
