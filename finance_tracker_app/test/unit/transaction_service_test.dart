import 'package:flutter_test/flutter_test.dart';
import 'package:finance_tracker_app/core/services/transaction_service.dart';
import 'package:finance_tracker_app/models/transaction.dart';

void main() {
  group('TransactionService', () {
    late TransactionService transactionService;

    setUp(() {
      transactionService = TransactionService();
    });

    test('should calculate spending stats correctly', () {
      // Given
      final transactions = [
        Transaction(
          amount: -100.0,
          currency: 'INR',
          merchant: 'Restaurant',
          category: 'Food & Dining',
          transactionTime: DateTime.now(),
          origin: TransactionOrigin.MANUAL,
          userId: 1,
        ),
        Transaction(
          amount: 1000.0,
          currency: 'INR',
          merchant: 'Salary',
          category: 'Salary',
          transactionTime: DateTime.now(),
          origin: TransactionOrigin.MANUAL,
          userId: 1,
        ),
        Transaction(
          amount: -50.0,
          currency: 'INR',
          merchant: 'Uber',
          category: 'Transportation',
          transactionTime: DateTime.now(),
          origin: TransactionOrigin.MANUAL,
          userId: 1,
        ),
      ];

      // When
      transactionService.transactions.addAll(transactions);
      final stats = transactionService.getSpendingStats();

      // Then
      expect(stats['totalSpent'], 150.0);
      expect(stats['totalEarned'], 1000.0);
      expect(stats['balance'], 850.0);
    });

    test('should calculate category breakdown correctly', () {
      // Given
      final transactions = [
        Transaction(
          amount: -100.0,
          currency: 'INR',
          merchant: 'Restaurant',
          category: 'Food & Dining',
          transactionTime: DateTime.now(),
          origin: TransactionOrigin.MANUAL,
          userId: 1,
        ),
        Transaction(
          amount: -50.0,
          currency: 'INR',
          merchant: 'Uber',
          category: 'Transportation',
          transactionTime: DateTime.now(),
          origin: TransactionOrigin.MANUAL,
          userId: 1,
        ),
        Transaction(
          amount: -75.0,
          currency: 'INR',
          merchant: 'Restaurant',
          category: 'Food & Dining',
          transactionTime: DateTime.now(),
          origin: TransactionOrigin.MANUAL,
          userId: 1,
        ),
      ];

      // When
      transactionService.transactions.addAll(transactions);
      final breakdown = transactionService.getCategoryBreakdown();

      // Then
      expect(breakdown['Food & Dining'], 175.0);
      expect(breakdown['Transportation'], 50.0);
      expect(breakdown.length, 2);
    });

    test('should get recent transactions with limit', () {
      // Given
      final transactions = [
        Transaction(
          amount: -100.0,
          currency: 'INR',
          merchant: 'Restaurant',
          category: 'Food & Dining',
          transactionTime: DateTime.now().subtract(const Duration(days: 1)),
          origin: TransactionOrigin.MANUAL,
          userId: 1,
        ),
        Transaction(
          amount: -50.0,
          currency: 'INR',
          merchant: 'Uber',
          category: 'Transportation',
          transactionTime: DateTime.now(),
          origin: TransactionOrigin.MANUAL,
          userId: 1,
        ),
        Transaction(
          amount: -75.0,
          currency: 'INR',
          merchant: 'Restaurant',
          category: 'Food & Dining',
          transactionTime: DateTime.now().subtract(const Duration(hours: 2)),
          origin: TransactionOrigin.MANUAL,
          userId: 1,
        ),
      ];

      // When
      transactionService.transactions.addAll(transactions);
      final recentTransactions = transactionService.getRecentTransactions(limit: 2);

      // Then
      expect(recentTransactions.length, 2);
      expect(recentTransactions.first.merchant, 'Uber'); // Most recent
    });

    test('should search transactions correctly', () {
      // Given
      final transactions = [
        Transaction(
          amount: -100.0,
          currency: 'INR',
          merchant: 'Restaurant ABC',
          category: 'Food & Dining',
          transactionTime: DateTime.now(),
          origin: TransactionOrigin.MANUAL,
          userId: 1,
        ),
        Transaction(
          amount: -50.0,
          currency: 'INR',
          merchant: 'Uber',
          category: 'Transportation',
          transactionTime: DateTime.now(),
          origin: TransactionOrigin.MANUAL,
          userId: 1,
        ),
        Transaction(
          amount: -75.0,
          currency: 'INR',
          merchant: 'Restaurant XYZ',
          category: 'Food & Dining',
          transactionTime: DateTime.now(),
          origin: TransactionOrigin.MANUAL,
          userId: 1,
        ),
      ];

      // When
      transactionService.transactions.addAll(transactions);
      final searchResults = transactionService.searchTransactions('restaurant');

      // Then
      expect(searchResults.length, 2);
      expect(searchResults.every((t) => t.merchant!.toLowerCase().contains('restaurant')), true);
    });

    test('should return empty stats when no transactions', () {
      // When
      final stats = transactionService.getSpendingStats();

      // Then
      expect(stats['totalSpent'], 0.0);
      expect(stats['totalEarned'], 0.0);
      expect(stats['thisMonth'], 0.0);
      expect(stats['balance'], 0.0);
    });

    test('should return empty breakdown when no transactions', () {
      // When
      final breakdown = transactionService.getCategoryBreakdown();

      // Then
      expect(breakdown.isEmpty, true);
    });

    test('should return empty list when no recent transactions', () {
      // When
      final recentTransactions = transactionService.getRecentTransactions();

      // Then
      expect(recentTransactions.isEmpty, true);
    });
  });
} 