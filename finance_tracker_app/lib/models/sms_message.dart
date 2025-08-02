import 'package:hive/hive.dart';

part 'sms_message.g.dart';

@HiveType(typeId: 3)
class SmsMessage {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final String? timestamp;

  @HiveField(2)
  final String? sender;

  SmsMessage({
    required this.text,
    this.timestamp,
    this.sender,
  });

  factory SmsMessage.fromJson(Map<String, dynamic> json) {
    return SmsMessage(
      text: json['text'],
      timestamp: json['timestamp'],
      sender: json['sender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'timestamp': timestamp,
      'sender': sender,
    };
  }
} 