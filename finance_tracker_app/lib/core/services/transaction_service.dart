import 'package:hive/hive.dart';
import '../../models/transaction.dart';
import '../../models/sms_message.dart' as app_models;
import 'api_service.dart';

class TransactionService {
  static final TransactionService _instance = TransactionService._internal();
  factory TransactionService() => _instance;
  TransactionService._internal();

  final ApiService _apiService = ApiService();
  late Box<Transaction> _transactionBox;
  
  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  // Initialize transaction service
  Future<void> initialize() async {
    _transactionBox = await Hive.openBox<Transaction>('transactions');
    await _loadTransactions();
  }

  // Load transactions from local storage
  Future<void> _loadTransactions() async {
    try {
      _transactions = _transactionBox.values.toList();
      _transactions.sort((a, b) => b.transactionTime.compareTo(a.transactionTime));
    } catch (e) {
      print('Error loading transactions: $e');
      _transactions = [];
    }
  }

  // Get all transactions
  Future<List<Transaction>> getTransactions() async {
    try {
      // Try to fetch from API first
      final apiTransactions = await _apiService.getTransactions();
      if (apiTransactions.isNotEmpty) {
        _transactions = apiTransactions;
        await _saveTransactions();
        return _transactions;
      }
    } catch (e) {
      print('Error fetching from API: $e');
    }
    
    // Fallback to local storage
    await _loadTransactions();
    return _transactions;
  }

  // Get transactions by date range
  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    await _loadTransactions();
    return _transactions.where((transaction) {
      return transaction.transactionTime.isAfter(start) && 
             transaction.transactionTime.isBefore(end);
    }).toList();
  }

  // Get transactions by category
  Future<List<Transaction>> getTransactionsByCategory(String category) async {
    await _loadTransactions();
    return _transactions.where((transaction) {
      return transaction.category.toLowerCase() == category.toLowerCase();
    }).toList();
  }

  // Create new transaction
  Future<Transaction?> createTransaction(Transaction transaction) async {
    try {
      // Add to API
      final createdTransaction = await _apiService.createTransaction(transaction);
      
      // Add to local storage
      _transactions.add(createdTransaction);
      await _transactionBox.add(createdTransaction);
      
      // Sort transactions
      _transactions.sort((a, b) => b.transactionTime.compareTo(a.transactionTime));
      
      return createdTransaction;
    } catch (e) {
      print('Error creating transaction: $e');
      
      // Fallback to local storage only
      _transactions.add(transaction);
      await _transactionBox.add(transaction);
      _transactions.sort((a, b) => b.transactionTime.compareTo(a.transactionTime));
      
      return transaction;
    }
  }

  // Update transaction
  Future<bool> updateTransaction(Transaction transaction) async {
    try {
      // Update in API
      // TODO: Implement API update
      
      // Update in local storage
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
        await _transactionBox.putAt(index, transaction);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating transaction: $e');
      return false;
    }
  }

  // Delete transaction
  Future<bool> deleteTransaction(int transactionId) async {
    try {
      // Delete from API
      // TODO: Implement API delete
      
      // Delete from local storage
      final index = _transactions.indexWhere((t) => t.id == transactionId);
      if (index != -1) {
        _transactions.removeAt(index);
        await _transactionBox.deleteAt(index);
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting transaction: $e');
      return false;
    }
  }

  // Process SMS batch
  Future<Map<String, dynamic>> processSmsBatch(List<app_models.SmsMessage> messages) async {
    try {
      final response = await _apiService.processSmsBatch(messages);
      
      // Update local transactions if new ones were created
      if (response['transactions'] != null) {
        final newTransactions = (response['transactions'] as List)
            .map((t) => Transaction.fromJson(t))
            .toList();
        
        _transactions.addAll(newTransactions);
        await _saveTransactions();
      }
      
      return response;
    } catch (e) {
      print('Error processing SMS batch: $e');
      return {
        'success': false,
        'message': 'Failed to process SMS batch',
        'error': e.toString(),
      };
    }
  }

  // Save transactions to local storage
  Future<void> _saveTransactions() async {
    try {
      await _transactionBox.clear();
      await _transactionBox.addAll(_transactions);
    } catch (e) {
      print('Error saving transactions: $e');
    }
  }

  // Get spending statistics
  Map<String, dynamic> getSpendingStats() {
    if (_transactions.isEmpty) {
      return {
        'totalSpent': 0.0,
        'totalEarned': 0.0,
        'thisMonth': 0.0,
        'balance': 0.0,
      };
    }

    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month, 1);
    
    double totalSpent = 0.0;
    double totalEarned = 0.0;
    double thisMonthSpent = 0.0;

    for (final transaction in _transactions) {
      if (transaction.amount < 0) {
        totalSpent += transaction.amount.abs();
        if (transaction.transactionTime.isAfter(thisMonth)) {
          thisMonthSpent += transaction.amount.abs();
        }
      } else {
        totalEarned += transaction.amount;
      }
    }

    return {
      'totalSpent': totalSpent,
      'totalEarned': totalEarned,
      'thisMonth': thisMonthSpent,
      'balance': totalEarned - totalSpent,
    };
  }

  // Get category breakdown
  Map<String, double> getCategoryBreakdown() {
    final breakdown = <String, double>{};
    
    for (final transaction in _transactions) {
      if (transaction.amount < 0) { // Only spending transactions
        final category = transaction.category;
        breakdown[category] = (breakdown[category] ?? 0.0) + transaction.amount.abs();
      }
    }
    
    return breakdown;
  }

  // Get recent transactions
  List<Transaction> getRecentTransactions({int limit = 10}) {
    return _transactions.take(limit).toList();
  }

  // Search transactions
  List<Transaction> searchTransactions(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _transactions.where((transaction) {
      return transaction.merchant?.toLowerCase().contains(lowercaseQuery) == true ||
             transaction.category.toLowerCase().contains(lowercaseQuery) ||
             transaction.rawText?.toLowerCase().contains(lowercaseQuery) == true;
    }).toList();
  }

  // Sync with backend
  Future<bool> syncWithBackend() async {
    try {
      final apiTransactions = await _apiService.getTransactions();
      
      // Merge with local transactions
      final localIds = _transactions.map((t) => t.id).toSet();
      final newTransactions = apiTransactions.where((t) => !localIds.contains(t.id)).toList();
      
      if (newTransactions.isNotEmpty) {
        _transactions.addAll(newTransactions);
        await _saveTransactions();
      }
      
      return true;
    } catch (e) {
      print('Error syncing with backend: $e');
      return false;
    }
  }

  // Clear all transactions
  Future<void> clearAllTransactions() async {
    try {
      _transactions.clear();
      await _transactionBox.clear();
    } catch (e) {
      print('Error clearing transactions: $e');
    }
  }

  // Export transactions
  Future<String> exportTransactions() async {
    final csvData = StringBuffer();
    csvData.writeln('Date,Amount,Currency,Merchant,Category,Type');
    
    for (final transaction in _transactions) {
      csvData.writeln([
        transaction.transactionTime.toIso8601String(),
        transaction.amount.toString(),
        transaction.currency,
        transaction.merchant ?? '',
        transaction.category,
        transaction.origin.toString().split('.').last,
      ].join(','));
    }
    
    return csvData.toString();
  }

  // Dispose
  void dispose() {
    _transactionBox.close();
  }
} 