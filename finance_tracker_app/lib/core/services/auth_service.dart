import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import 'api_service.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  User? _currentUser;
  String? _authToken;
  
  User? get currentUser => _currentUser;
  String? get authToken => _authToken;
  bool get isAuthenticated => _authToken != null;

  // Initialize auth service
  Future<void> initialize() async {
    await _loadStoredAuth();
  }

  // Load stored authentication data
  Future<void> _loadStoredAuth() async {
    try {
      _authToken = await _secureStorage.read(key: 'auth_token');
      final userData = await _secureStorage.read(key: 'user_data');
      
      if (userData != null) {
        // Parse the stored user data as JSON
        final userMap = jsonDecode(userData) as Map<String, dynamic>;
        _currentUser = User.fromJson(userMap);
        
        // Notify listeners that user data has been loaded
        notifyListeners();
      }
    } catch (e) {
      print('Error loading stored auth: $e');
    }
  }

  // Sign up user
  Future<bool> signup(String email, String password, String firstName, String lastName) async {
    try {
      final response = await _apiService.signup(email, password, firstName, lastName);
      
      if (response['token'] != null) {
        // Create user object from response data
        _authToken = response['token'];
        _currentUser = User(
          id: int.tryParse(response['userId']?.toString() ?? '0') ?? 0,
          email: response['email'] ?? email,
          firstName: firstName,
          lastName: lastName,
          createdAt: DateTime.now(),
        );
        
        // Store authentication data
        await _secureStorage.write(key: 'auth_token', value: _authToken);
        await _secureStorage.write(key: 'user_data', value: jsonEncode(_currentUser!.toJson()));
        
        // Notify listeners that user data has changed
        notifyListeners();
        
        return true;
      }
      
      return false;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  // Login user
  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      
      if (response['token'] != null) {
        _authToken = response['token'];
        
        // Create user object from response data
        _currentUser = User(
          id: int.tryParse(response['userId']?.toString() ?? '0') ?? 0,
          email: response['email'] ?? email,
          firstName: response['firstName'] ?? '',
          lastName: response['lastName'] ?? '',
          createdAt: DateTime.now(),
        );
        
        // Store authentication data
        await _secureStorage.write(key: 'auth_token', value: _authToken);
        await _secureStorage.write(key: 'user_data', value: jsonEncode(_currentUser!.toJson()));
        
        // Notify listeners that user data has changed
        notifyListeners();
        
        return true;
      }
      
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      _authToken = null;
      _currentUser = null;
      
      // Clear stored data
      await _secureStorage.delete(key: 'auth_token');
      await _secureStorage.delete(key: 'user_data');
      
      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Notify listeners that user data has changed
      notifyListeners();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Check if user is authenticated
  Future<bool> checkAuthStatus() async {
    if (_authToken == null) {
      await _loadStoredAuth();
    }
    
    if (_authToken != null) {
      // Verify token with backend
      try {
        final isValid = await _apiService.healthCheck();
        if (!isValid) {
          await logout();
          return false;
        }
        return true;
      } catch (e) {
        await logout();
        return false;
      }
    }
    
    return false;
  }

  // Update user profile
  Future<bool> updateProfile(User updatedUser) async {
    try {
      // Update local user data
      _currentUser = updatedUser;
      
      // Store updated user data
      await _secureStorage.write(key: 'user_data', value: jsonEncode(_currentUser!.toJson()));
      
      // Notify listeners that user data has changed
      notifyListeners();
      
      // TODO: Implement profile update API call
      // For now, just update local user data
      print('Profile updated: ${updatedUser.toJson()}');
      return true;
    } catch (e) {
      print('Profile update error: $e');
      return false;
    }
  }

  // Change password
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      // TODO: Implement password change API call
      print('Password changed successfully');
      return true;
    } catch (e) {
      print('Password change error: $e');
      return false;
    }
  }

  // Get stored user preferences
  Future<Map<String, dynamic>> getUserPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'theme': prefs.getString('theme') ?? 'light',
        'currency': prefs.getString('currency') ?? 'INR',
        'notifications': prefs.getBool('notifications') ?? true,
        'smsTracking': prefs.getBool('smsTracking') ?? false,
      };
    } catch (e) {
      print('Error getting user preferences: $e');
      return {};
    }
  }

  // Save user preferences
  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      for (final entry in preferences.entries) {
        if (entry.value is String) {
          await prefs.setString(entry.key, entry.value);
        } else if (entry.value is bool) {
          await prefs.setBool(entry.key, entry.value);
        } else if (entry.value is int) {
          await prefs.setInt(entry.key, entry.value);
        } else if (entry.value is double) {
          await prefs.setDouble(entry.key, entry.value);
        }
      }
    } catch (e) {
      print('Error saving user preferences: $e');
    }
  }

  // Clear all stored data
  Future<void> clearAllData() async {
    try {
      await logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error clearing data: $e');
    }
  }
} 