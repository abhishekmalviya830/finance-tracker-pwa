class ApiEndpoints {
  // Base URL - Update this to your backend URL
  static const String baseUrl = 'http://192.168.1.4:8080/api';
  
  // Auth endpoints
  static const String signup = '/auth/signup';
  static const String login = '/auth/login';
  
  // Transaction endpoints
  static const String transactions = '/transactions';
  static const String transactionById = '/transactions/{id}';
  static const String smsBatch = '/transactions/sms/batch';
  
  // Dashboard endpoints
  static const String monthlyStats = '/dashboard/stats/monthly';
  static const String yearlyStats = '/dashboard/stats/yearly';
  
  // SMS upload endpoints
  static const String smsUploadText = '/sms/upload/text';
  static const String smsUploadCsv = '/sms/upload/csv';
  static const String smsUploadWhatsapp = '/sms/upload/whatsapp';
  
  // Category rules endpoints
  static const String categoryRules = '/category-rules';
  static const String categoryRuleById = '/category-rules/{id}';
  
  // Health check
  static const String health = '/actuator/health';
  
  // Helper method to get full URL
  static String getUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
  
  // Helper method to get full URL with path parameters
  static String getUrlWithParams(String endpoint, Map<String, String> params) {
    String url = endpoint;
    params.forEach((key, value) {
      url = url.replaceAll('{$key}', value);
    });
    return '$baseUrl$url';
  }
} 