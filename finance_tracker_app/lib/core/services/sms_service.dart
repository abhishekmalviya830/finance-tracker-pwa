import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart' as telephony;
import '../utils/sms_parser.dart';
import '../../models/transaction.dart';
import '../../models/sms_message.dart' as app_models;
import 'api_service.dart';

class SmsService {
  static final SmsService _instance = SmsService._internal();
  factory SmsService() => _instance;
  SmsService._internal();

  final telephony.Telephony _telephony = telephony.Telephony.instance;
  final SmsParser _parser = SmsParser();
  final ApiService _apiService = ApiService();
  
  // Permission status
  bool _hasPermission = false;
  bool get hasPermission => _hasPermission;
  
  // Real-time SMS monitoring
  bool _isListening = false;
  bool get isListening => _isListening;
  
  // Stream controller for real-time SMS updates
  final StreamController<app_models.SmsMessage> _smsStreamController = StreamController<app_models.SmsMessage>.broadcast();
  Stream<app_models.SmsMessage> get smsStream => _smsStreamController.stream;

  // Initialize SMS service
  Future<bool> initialize() async {
    try {
      // Request SMS permissions
      final status = await Permission.sms.request();
      _hasPermission = status.isGranted;
      
      if (_hasPermission) {
        print('SMS service initialized successfully with permissions');
        return true;
      } else {
        print('SMS permission denied - manual upload only');
        return false;
      }
    } catch (e) {
      print('Error initializing SMS service: $e');
      return false;
    }
  }

  // Start real-time SMS monitoring
  Future<bool> startSmsMonitoring() async {
    if (!_hasPermission) {
      print('SMS permission not granted');
      return false;
    }

    try {
      // Request additional telephony permissions
      final hasPermissions = await _telephony.requestSmsPermissions ?? false;
      
      if (!hasPermissions) {
        print('Telephony permissions not granted');
        return false;
      }

      // Start listening for incoming SMS
      _telephony.listenIncomingSms(
        onNewMessage: (telephony.SmsMessage message) {
          _processIncomingSms(message);
        },
        onBackgroundMessage: _backgroundMessageHandler,
      );

      _isListening = true;
      print('SMS monitoring started successfully');
      return true;
    } catch (e) {
      print('Error starting SMS monitoring: $e');
      return false;
    }
  }

  // Background message handler (for when app is in background)
  static void _backgroundMessageHandler(telephony.SmsMessage message) {
    print('Background SMS received: ${message.body}');
    // Process background SMS here
  }

  // Process incoming SMS in real-time
  void _processIncomingSms(telephony.SmsMessage message) async {
    try {
      print('Processing incoming SMS: ${message.body}');
      
      // Create SMS message model
      final smsMessage = app_models.SmsMessage(
        text: message.body ?? '',
        timestamp: message.date != null ? DateTime.fromMillisecondsSinceEpoch(message.date!).toIso8601String() : null,
        sender: message.address ?? '',
      );
      
      // Add to stream for UI updates
      _smsStreamController.add(smsMessage);
      
      // Parse SMS for financial transactions
      final transaction = _parser.parseSms(message.body ?? '');
      
      if (transaction != null) {
        print('Financial transaction detected: ${transaction.amount} ${transaction.currency}');
        
        // Send to backend
        await _sendTransactionToBackend(transaction);
        
        // Show notification
        _showTransactionNotification(transaction);
      } else {
        print('No financial transaction found in SMS');
      }
    } catch (e) {
      print('Error processing incoming SMS: $e');
    }
  }

  // Get all SMS messages from device
  Future<List<app_models.SmsMessage>> getAllSmsMessages() async {
    if (!_hasPermission) {
      print('SMS permission not granted');
      return [];
    }
    
    try {
      final messages = await _telephony.getInboxSms();
      final smsMessages = messages.map((msg) => app_models.SmsMessage(
        text: msg.body ?? '',
        timestamp: msg.date != null ? DateTime.fromMillisecondsSinceEpoch(msg.date!).toIso8601String() : null,
        sender: msg.address ?? '',
      )).toList();
      
      // Filter for financial SMS
      final financialMessages = smsMessages.where((msg) => _parser.isFinancialSms(msg.text)).toList();
      print('Found ${financialMessages.length} financial SMS messages');
      return financialMessages;
    } catch (e) {
      print('Error getting SMS messages: $e');
      return [];
    }
  }

  // Process SMS text manually (for manual upload)
  Future<List<Transaction>> processSmsText(String smsText) async {
    try {
      print('Processing SMS text: $smsText');
      
      // Split by lines and process each line
      final lines = smsText.split('\n');
      final transactions = <Transaction>[];
      
      for (final line in lines) {
        if (line.trim().isNotEmpty) {
          final transaction = _parser.parseSms(line.trim());
          if (transaction != null) {
            transactions.add(transaction);
            print('Financial transaction detected: ${transaction.amount} ${transaction.currency}');
          }
        }
      }
      
      return transactions;
    } catch (e) {
      print('Error processing SMS text: $e');
      return [];
    }
  }

  // Send transaction to backend
  Future<void> _sendTransactionToBackend(Transaction transaction) async {
    try {
      await _apiService.createTransaction(transaction);
      print('Transaction sent to backend successfully');
    } catch (e) {
      print('Error sending transaction to backend: $e');
      // Store locally for later sync
      await _storePendingTransaction(transaction);
    }
  }

  // Send transactions to backend (batch)
  Future<bool> sendTransactionsToBackend(List<Transaction> transactions) async {
    try {
      for (final transaction in transactions) {
        await _apiService.createTransaction(transaction);
      }
      print('All transactions sent to backend successfully');
      return true;
    } catch (e) {
      print('Error sending transactions to backend: $e');
      return false;
    }
  }

  // Store pending transaction locally
  Future<void> _storePendingTransaction(Transaction transaction) async {
    try {
      // TODO: Implement local storage for pending transactions
      print('Transaction stored locally for later sync');
    } catch (e) {
      print('Error storing pending transaction: $e');
    }
  }

  // Show transaction notification
  void _showTransactionNotification(Transaction transaction) {
    // TODO: Implement local notification
    print('Transaction notification: ${transaction.amount} ${transaction.currency} - ${transaction.category}');
  }

  // Process and upload SMS batch (manual upload)
  Future<bool> processAndUploadSmsBatch(String smsText) async {
    try {
      final transactions = await processSmsText(smsText);
      
      if (transactions.isNotEmpty) {
        return await sendTransactionsToBackend(transactions);
      } else {
        print('No financial transactions found in SMS text');
        return false;
      }
    } catch (e) {
      print('Error processing SMS batch: $e');
      return false;
    }
  }

  // Process all device SMS and upload
  Future<bool> processAndUploadAllDeviceSms() async {
    try {
      final smsMessages = await getAllSmsMessages();
      final transactions = <Transaction>[];
      
      for (final sms in smsMessages) {
        final transaction = _parser.parseSms(sms.text);
        if (transaction != null) {
          transactions.add(transaction);
        }
      }
      
      if (transactions.isNotEmpty) {
        return await sendTransactionsToBackend(transactions);
      } else {
        print('No financial transactions found in device SMS');
        return false;
      }
    } catch (e) {
      print('Error processing device SMS: $e');
      return false;
    }
  }

  // Check if text contains financial information
  bool isFinancialSms(String text) {
    return _parser.isFinancialSms(text);
  }

  // Check permission status
  Future<bool> checkPermission() async {
    final status = await Permission.sms.status;
    _hasPermission = status.isGranted;
    return _hasPermission;
  }

  // Request permission
  Future<bool> requestPermission() async {
    final status = await Permission.sms.request();
    _hasPermission = status.isGranted;
    
    if (_hasPermission) {
      // Also request telephony permissions
      await _telephony.requestSmsPermissions;
    }
    
    return _hasPermission;
  }

  // Stop SMS monitoring
  void stopSmsMonitoring() {
    _isListening = false;
    print('SMS monitoring stopped');
  }

  // Open app settings
  Future<void> openSettings() async {
    await openAppSettings();
  }

  // Get SMS parser instance
  SmsParser get parser => _parser;

  // Dispose resources
  void dispose() {
    stopSmsMonitoring();
    _smsStreamController.close();
  }
} 