// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 1;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      id: fields[0] as int?,
      amount: fields[1] as double,
      currency: fields[2] as String,
      merchant: fields[3] as String?,
      category: fields[4] as String,
      transactionTime: fields[5] as DateTime,
      origin: fields[6] as TransactionOrigin,
      rawText: fields[7] as String?,
      userId: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.currency)
      ..writeByte(3)
      ..write(obj.merchant)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.transactionTime)
      ..writeByte(6)
      ..write(obj.origin)
      ..writeByte(7)
      ..write(obj.rawText)
      ..writeByte(8)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionOriginAdapter extends TypeAdapter<TransactionOrigin> {
  @override
  final int typeId = 4;

  @override
  TransactionOrigin read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionOrigin.MANUAL;
      case 1:
        return TransactionOrigin.SMS;
      default:
        return TransactionOrigin.MANUAL;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionOrigin obj) {
    switch (obj) {
      case TransactionOrigin.MANUAL:
        writer.writeByte(0);
        break;
      case TransactionOrigin.SMS:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionOriginAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
