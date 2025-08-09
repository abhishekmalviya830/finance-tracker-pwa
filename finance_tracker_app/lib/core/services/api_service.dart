import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_endpoints.dart';
import '../../models/user.dart';
import '../../models/transaction.dart';
import '../../models/sms_message.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        // Accept all status codes and handle them manually
        return true;
      },
    ));

    // Add interceptors
    _dio.interceptors.addAll([
      _AuthInterceptor(_storage),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  // Auth methods
  Future<Map<String, dynamic>> signup(String email, String password, String firstName, String lastName) async {
    try {
      print('Attempting signup for email: $email');
      final response = await _dio.post(ApiEndpoints.signup, data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      });
      print('Signup response status: ${response.statusCode}');
      print('Signup response: ${response.data}');
      
      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      print('Signup error: $e');
      if (e is DioException) {
        print('DioException type: ${e.type}');
        print('DioException message: ${e.message}');
        print('DioException response: ${e.response?.data}');
        print('DioException status code: ${e.response?.statusCode}');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Attempting login for email: $email');
      print('Request URL: ${ApiEndpoints.baseUrl}${ApiEndpoints.login}');
      print('Request data: {"email": "$email", "password": "***"}');
      
      final response = await _dio.post(ApiEndpoints.login, data: {
        'email': email,
        'password': password,
      });
      print('Login response status: ${response.statusCode}');
      print('Login response headers: ${response.headers}');
      print('Login response: ${response.data}');
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Login failed with status: ${response.statusCode}');
        print('Error response: ${response.data}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      print('Login error: $e');
      if (e is DioException) {
        print('DioException type: ${e.type}');
        print('DioException message: ${e.message}');
        print('DioException response: ${e.response?.data}');
        print('DioException status code: ${e.response?.statusCode}');
      }
      rethrow;
    }
  }

  // Transaction methods
  Future<List<Transaction>> getTransactions() async {
    final response = await _dio.get(ApiEndpoints.transactions);
    final List<dynamic> data = response.data;
    return data.map((json) => Transaction.fromJson(json)).toList();
  }

  Future<Transaction> createTransaction(Transaction transaction) async {
    final response = await _dio.post(
      ApiEndpoints.transactions,
      data: transaction.toJson(),
    );
    return Transaction.fromJson(response.data);
  }

  Future<Map<String, dynamic>> processSmsBatch(List<SmsMessage> messages) async {
    final response = await _dio.post(
      ApiEndpoints.smsBatch,
      data: {
        'messages': messages.map((msg) => msg.toJson()).toList(),
      },
    );
    return response.data;
  }

  // Dashboard methods
  Future<Map<String, dynamic>> getMonthlyStats(int year, int month) async {
    final response = await _dio.get(
      ApiEndpoints.monthlyStats,
      queryParameters: {'year': year, 'month': month},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getYearlyStats(int year) async {
    final response = await _dio.get(
      ApiEndpoints.yearlyStats,
      queryParameters: {'year': year},
    );
    return response.data;
  }

  // SMS Upload methods
  Future<Map<String, dynamic>> uploadSmsTextFile(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _dio.post(
      ApiEndpoints.smsUploadText,
      data: formData,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> uploadSmsCsvFile(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _dio.post(
      ApiEndpoints.smsUploadCsv,
      data: formData,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> uploadWhatsAppChat(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _dio.post(
      ApiEndpoints.smsUploadWhatsapp,
      data: formData,
    );
    return response.data;
  }

  // Health check
  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get(ApiEndpoints.health);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

// Interceptors
class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  _AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('AuthInterceptor: Processing request to ${options.path}');
    // Don't add Authorization header for auth endpoints
    if (!options.path.contains('/auth/')) {
      final token = await _storage.read(key: 'auth_token');
      print('AuthInterceptor: Token from storage: ${token != null ? "FOUND" : "NOT FOUND"}');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
        print('AuthInterceptor: Added Authorization header with token: ${token.substring(0, 20)}...');
      } else {
        print('AuthInterceptor: No token found in storage for path: ${options.path}');
      }
    } else {
      print('AuthInterceptor: Skipping Authorization header for auth endpoint: ${options.path}');
    }
    handler.next(options);
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle unauthorized error
      print('Unauthorized access');
    }
    handler.next(err);
  }
} 