import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 4)
enum TransactionOrigin { 
  @HiveField(0)
  MANUAL, 
  @HiveField(1)
  SMS 
}

@HiveType(typeId: 1)
class Transaction {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String currency;

  @HiveField(3)
  final String? merchant;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final DateTime transactionTime;

  @HiveField(6)
  final TransactionOrigin origin;

  @HiveField(7)
  final String? rawText;

  @HiveField(8)
  final int userId;

  Transaction({
    this.id,
    required this.amount,
    this.currency = 'INR',
    this.merchant,
    this.category = 'Other',
    required this.transactionTime,
    this.origin = TransactionOrigin.MANUAL,
    this.rawText,
    required this.userId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] is int ? json['id'] : null,
      amount: json['amount'].toDouble(),
      currency: json['currency'] ?? 'INR',
      merchant: json['merchant'],
      category: json['category'] ?? 'Other',
      transactionTime: DateTime.parse(json['transactionTime']),
      origin: TransactionOrigin.values.firstWhere(
        (e) => e.toString().split('.').last == json['origin'],
        orElse: () => TransactionOrigin.MANUAL,
      ),
      rawText: json['rawText'],
      userId: json['userId'] ?? 1, // Default to 1 if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'merchant': merchant,
      'category': category,
      'transactionTime': transactionTime.toIso8601String(),
      'origin': origin.toString().split('.').last,
      'rawText': rawText,
      'userId': userId,
    };
  }

  Transaction copyWith({
    int? id,
    double? amount,
    String? currency,
    String? merchant,
    String? category,
    DateTime? transactionTime,
    TransactionOrigin? origin,
    String? rawText,
    int? userId,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      merchant: merchant ?? this.merchant,
      category: category ?? this.category,
      transactionTime: transactionTime ?? this.transactionTime,
      origin: origin ?? this.origin,
      rawText: rawText ?? this.rawText,
      userId: userId ?? this.userId,
    );
  }
} 