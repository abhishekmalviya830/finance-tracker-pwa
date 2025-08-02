import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../../models/transaction.dart';
import '../../models/user.dart';

class ExportService {
  static Future<void> exportTransactionsAsCSV(List<Transaction> transactions, User? user) async {
    if (transactions.isEmpty) {
      throw Exception('No transactions to export');
    }

    final csvData = _generateCSV(transactions);
    final blob = html.Blob([csvData], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'transactions_${DateTime.now().millisecondsSinceEpoch}.csv')
      ..click();
    
    html.Url.revokeObjectUrl(url);
  }

  static Future<void> exportTransactionsAsJSON(List<Transaction> transactions, User? user) async {
    if (transactions.isEmpty) {
      throw Exception('No transactions to export');
    }

    final exportData = {
      'exportDate': DateTime.now().toIso8601String(),
      'user': user?.toJson(),
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'summary': _generateSummary(transactions),
    };

    final jsonData = jsonEncode(exportData);
    final blob = html.Blob([jsonData], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(blob);
    
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'finance_data_${DateTime.now().millisecondsSinceEpoch}.json')
      ..click();
    
    html.Url.revokeObjectUrl(url);
  }

  static Future<void> exportBackup(List<Transaction> transactions, User? user, Map<String, dynamic> settings) async {
    final backupData = {
      'backupDate': DateTime.now().toIso8601String(),
      'version': '1.0.0',
      'user': user?.toJson(),
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'settings': settings,
      'summary': _generateSummary(transactions),
    };

    final jsonData = jsonEncode(backupData);
    final blob = html.Blob([jsonData], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(blob);
    
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'finance_backup_${DateTime.now().millisecondsSinceEpoch}.json')
      ..click();
    
    html.Url.revokeObjectUrl(url);
  }

  static String _generateCSV(List<Transaction> transactions) {
    final buffer = StringBuffer();
    
    // CSV Header
    buffer.writeln('Date,Amount,Currency,Merchant,Category,Type,Description');
    
    // CSV Data
    for (final transaction in transactions) {
      final date = transaction.transactionTime.toIso8601String().split('T')[0];
      final amount = transaction.amount.toStringAsFixed(2);
      final type = transaction.amount >= 0 ? 'Income' : 'Expense';
      final description = transaction.rawText ?? '';
      
      buffer.writeln('$date,$amount,${transaction.currency},${transaction.merchant ?? ""},${transaction.category},$type,"$description"');
    }
    
    return buffer.toString();
  }

  static Map<String, dynamic> _generateSummary(List<Transaction> transactions) {
    double totalIncome = 0;
    double totalExpense = 0;
    final categoryTotals = <String, double>{};
    final monthlyTotals = <String, double>{};

    for (final transaction in transactions) {
      final amount = transaction.amount;
      final category = transaction.category;
      final month = '${transaction.transactionTime.year}-${transaction.transactionTime.month.toString().padLeft(2, '0')}';

      if (amount >= 0) {
        totalIncome += amount;
      } else {
        totalExpense += amount.abs();
      }

      categoryTotals[category] = (categoryTotals[category] ?? 0) + amount.abs();
      monthlyTotals[month] = (monthlyTotals[month] ?? 0) + amount;
    }

    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'netAmount': totalIncome - totalExpense,
      'transactionCount': transactions.length,
      'categoryTotals': categoryTotals,
      'monthlyTotals': monthlyTotals,
      'dateRange': {
        'start': transactions.map((t) => t.transactionTime).reduce((a, b) => a.isBefore(b) ? a : b).toIso8601String(),
        'end': transactions.map((t) => t.transactionTime).reduce((a, b) => a.isAfter(b) ? a : b).toIso8601String(),
      },
    };
  }

  static Future<void> showExportDialog(BuildContext context, List<Transaction> transactions, User? user) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose export format:'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('CSV Format'),
              subtitle: const Text('Spreadsheet compatible'),
              onTap: () async {
                Navigator.of(context).pop();
                try {
                  await exportTransactionsAsCSV(transactions, user);
                  _showSuccessSnackBar(context, 'Data exported as CSV successfully!');
                } catch (e) {
                  _showErrorSnackBar(context, 'Failed to export CSV: ${e.toString()}');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('JSON Format'),
              subtitle: const Text('Complete data with metadata'),
              onTap: () async {
                Navigator.of(context).pop();
                try {
                  await exportTransactionsAsJSON(transactions, user);
                  _showSuccessSnackBar(context, 'Data exported as JSON successfully!');
                } catch (e) {
                  _showErrorSnackBar(context, 'Failed to export JSON: ${e.toString()}');
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  static void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
} 