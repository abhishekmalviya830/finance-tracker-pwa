class AppConstants {
  // App Info
  static const String appName = 'Finance Tracker';
  static const String appVersion = '1.0.0';
  
  // Colors
  static const int primaryColor = 0xFF2196F3;
  static const int secondaryColor = 0xFF03DAC6;
  static const int backgroundColor = 0xFFF5F5F5;
  static const int surfaceColor = 0xFFFFFFFF;
  static const int errorColor = 0xFFB00020;
  static const int successColor = 0xFF4CAF50;
  static const int warningColor = 0xFFFF9800;
  
  // Text Styles
  static const String fontFamily = 'Roboto';
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border Radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // API Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  
  // SMS Patterns
  static const List<String> bankPatterns = [
    'HDFC',
    'SBI',
    'ICICI',
    'Axis',
    'Kotak',
    'PNB',
    'Canara',
    'Bank of Baroda',
    'Union Bank',
    'Central Bank',
  ];
  
  // Categories
  static const List<String> defaultCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Healthcare',
    'Education',
    'Utilities',
    'Travel',
    'Insurance',
    'Investment',
    'Salary',
    'Other',
  ];
  
  // Currency
  static const String defaultCurrency = 'INR';
  static const List<String> supportedCurrencies = [
    'INR',
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'CHF',
  ];
} 