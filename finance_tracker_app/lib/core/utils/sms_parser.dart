import '../../models/transaction.dart';
import '../constants/app_constants.dart';

class SmsParser {
  // Check if SMS contains financial information
  bool isFinancialSms(String smsText) {
    final text = smsText.toLowerCase();
    
    // Check for common financial keywords
    final financialKeywords = [
      'debited',
      'credited',
      'withdrawn',
      'deposited',
      'spent',
      'received',
      'payment',
      'transaction',
      'balance',
      'account',
      'upi',
      'neft',
      'imps',
      'rtgs',
      'card',
      'atm',
      'pos',
      'online',
      'transfer',
      'refund',
    ];
    
    return financialKeywords.any((keyword) => text.contains(keyword));
  }

  // Parse SMS and extract transaction details
  Transaction? parseSms(String smsText) {
    try {
      // Check if it's a financial SMS
      if (!isFinancialSms(smsText)) {
        return null;
      }

      // Extract amount
      final amount = _extractAmount(smsText);
      if (amount == null) {
        return null;
      }

      // Extract currency
      final currency = _extractCurrency(smsText);

      // Extract merchant/bank
      final merchant = _extractMerchant(smsText);

      // Extract category
      final category = _extractCategory(smsText);

      // Extract timestamp
      final timestamp = _extractTimestamp(smsText);

      return Transaction(
        amount: amount,
        currency: currency,
        merchant: merchant,
        category: category,
        transactionTime: timestamp,
        origin: TransactionOrigin.SMS,
        rawText: smsText,
        userId: 1, // This will be set by the service
      );
    } catch (e) {
      print('Error parsing SMS: $e');
      return null;
    }
  }

  // Extract amount from SMS text
  double? _extractAmount(String text) {
    // Common patterns for amount extraction
    final patterns = [
      RegExp(r'rs\.?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'inr\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'₹\s*(\d+(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false),
      RegExp(r'(\d+(?:,\d{3})*(?:\.\d{2})?)\s*rs', caseSensitive: false),
      RegExp(r'(\d+(?:,\d{3})*(?:\.\d{2})?)\s*inr', caseSensitive: false),
      RegExp(r'(\d+(?:,\d{3})*(?:\.\d{2})?)\s*₹', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final amountStr = match.group(1)?.replaceAll(',', '');
        if (amountStr != null) {
          return double.tryParse(amountStr);
        }
      }
    }

    return null;
  }

  // Extract currency from SMS text
  String _extractCurrency(String text) {
    final lowerText = text.toLowerCase();
    
    if (lowerText.contains('rs') || lowerText.contains('inr') || lowerText.contains('₹')) {
      return 'INR';
    } else if (lowerText.contains('\$') || lowerText.contains('usd')) {
      return 'USD';
    } else if (lowerText.contains('€') || lowerText.contains('eur')) {
      return 'EUR';
    } else if (lowerText.contains('£') || lowerText.contains('gbp')) {
      return 'GBP';
    }
    
    return AppConstants.defaultCurrency;
  }

  // Extract merchant/bank name from SMS text
  String? _extractMerchant(String text) {
    // Check for bank names
    for (final bank in AppConstants.bankPatterns) {
      if (text.toLowerCase().contains(bank.toLowerCase())) {
        return bank;
      }
    }

    // Check for common merchants
    final merchantPatterns = [
      RegExp(r'at\s+([a-zA-Z\s]+?)(?:\s+on|\s+via|\s+using|\.|$)', caseSensitive: false),
      RegExp(r'from\s+([a-zA-Z\s]+?)(?:\s+on|\s+via|\s+using|\.|$)', caseSensitive: false),
      RegExp(r'to\s+([a-zA-Z\s]+?)(?:\s+on|\s+via|\s+using|\.|$)', caseSensitive: false),
    ];

    for (final pattern in merchantPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final merchant = match.group(1)?.trim();
        if (merchant != null && merchant.isNotEmpty && merchant.length > 2) {
          return merchant;
        }
      }
    }

    return null;
  }

  // Extract category from SMS text
  String _extractCategory(String text) {
    final lowerText = text.toLowerCase();
    
    // Define category patterns
    final categoryPatterns = {
      'Food & Dining': ['restaurant', 'food', 'dining', 'meal', 'lunch', 'dinner', 'breakfast', 'cafe', 'pizza', 'burger'],
      'Transportation': ['uber', 'ola', 'taxi', 'metro', 'bus', 'train', 'fuel', 'petrol', 'diesel', 'parking'],
      'Shopping': ['amazon', 'flipkart', 'myntra', 'shopping', 'mall', 'store', 'retail'],
      'Entertainment': ['movie', 'cinema', 'netflix', 'spotify', 'game', 'entertainment'],
      'Healthcare': ['hospital', 'clinic', 'pharmacy', 'medical', 'doctor', 'health'],
      'Education': ['school', 'college', 'university', 'course', 'education', 'tuition'],
      'Utilities': ['electricity', 'water', 'gas', 'internet', 'mobile', 'phone', 'utility'],
      'Travel': ['flight', 'hotel', 'booking', 'travel', 'trip', 'vacation'],
      'Insurance': ['insurance', 'premium', 'policy'],
      'Investment': ['investment', 'mutual fund', 'stocks', 'shares', 'trading'],
      'Salary': ['salary', 'credit', 'credited', 'income', 'earnings'],
    };

    for (final entry in categoryPatterns.entries) {
      for (final keyword in entry.value) {
        if (lowerText.contains(keyword)) {
          return entry.key;
        }
      }
    }

    return 'Other';
  }

  // Extract timestamp from SMS text
  DateTime _extractTimestamp(String text) {
    // Try to extract date and time from SMS
    final datePatterns = [
      RegExp(r'(\d{1,2})[-/](\d{1,2})[-/](\d{2,4})', caseSensitive: false),
      RegExp(r'(\d{1,2})[-/](\d{1,2})[-/](\d{2})', caseSensitive: false),
    ];

    final timePatterns = [
      RegExp(r'(\d{1,2}):(\d{2})\s*(am|pm)', caseSensitive: false),
      RegExp(r'(\d{1,2}):(\d{2})', caseSensitive: false),
    ];

    DateTime? extractedDate;
    DateTime? extractedTime;

    // Extract date
    for (final pattern in datePatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final day = int.tryParse(match.group(1) ?? '');
        final month = int.tryParse(match.group(2) ?? '');
        final year = int.tryParse(match.group(3) ?? '');
        
        if (day != null && month != null && year != null) {
          final fullYear = year < 100 ? 2000 + year : year;
          try {
            extractedDate = DateTime(fullYear, month, day);
            break;
          } catch (e) {
            // Invalid date, continue
          }
        }
      }
    }

    // Extract time
    for (final pattern in timePatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final hour = int.tryParse(match.group(1) ?? '');
        final minute = int.tryParse(match.group(2) ?? '');
        final ampm = match.group(3)?.toLowerCase();
        
        if (hour != null && minute != null) {
          var adjustedHour = hour;
          if (ampm == 'pm' && hour != 12) {
            adjustedHour = hour + 12;
          } else if (ampm == 'am' && hour == 12) {
            adjustedHour = 0;
          }
          
          try {
            final now = DateTime.now();
            extractedTime = DateTime(now.year, now.month, now.day, adjustedHour, minute);
            break;
          } catch (e) {
            // Invalid time, continue
          }
        }
      }
    }

    // Combine date and time, or use current time
    if (extractedDate != null && extractedTime != null) {
      return DateTime(
        extractedDate.year,
        extractedDate.month,
        extractedDate.day,
        extractedTime.hour,
        extractedTime.minute,
      );
    } else if (extractedDate != null) {
      return DateTime(
        extractedDate.year,
        extractedDate.month,
        extractedDate.day,
        DateTime.now().hour,
        DateTime.now().minute,
      );
    }

    return DateTime.now();
  }
} 