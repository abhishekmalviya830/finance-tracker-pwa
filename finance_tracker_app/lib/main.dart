import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/services/api_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/sms_service.dart';
import 'core/services/transaction_service.dart';
import 'core/services/theme_service.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/transactions/screens/transactions_screen.dart';
import 'features/sms_tracking/screens/sms_tracking_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/profile/screens/edit_profile_screen.dart';
import 'features/analytics/screens/analytics_screen.dart';
import 'core/constants/app_constants.dart';
import 'models/transaction.dart';
import 'models/user.dart';
import 'models/sms_message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(SmsMessageAdapter());
  Hive.registerAdapter(TransactionOriginAdapter());
  
  // Initialize services
  final apiService = ApiService();
  apiService.initialize();
  
  final authService = AuthService();
  await authService.initialize();
  
  final smsService = SmsService();
  await smsService.initialize();
  
  final transactionService = TransactionService();
  await transactionService.initialize();
  
  final themeService = ThemeService();
  await themeService.initialize();
  
  runApp(FinanceTrackerApp(
    authService: authService,
    smsService: smsService,
    transactionService: transactionService,
    themeService: themeService,
  ));
}

class FinanceTrackerApp extends StatelessWidget {
  final AuthService authService;
  final SmsService smsService;
  final TransactionService transactionService;
  final ThemeService themeService;

  const FinanceTrackerApp({
    super.key,
    required this.authService,
    required this.smsService,
    required this.transactionService,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: authService),
        Provider<SmsService>.value(value: smsService),
        Provider<TransactionService>.value(value: transactionService),
        ChangeNotifierProvider<ThemeService>.value(value: themeService),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: themeService.currentThemeData,
            home: const AuthWrapper(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/dashboard': (context) => const DashboardScreen(),
              '/transactions': (context) => const TransactionsScreen(),
              '/sms-tracking': (context) => const SmsTrackingScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/edit-profile': (context) => const EditProfileScreen(),
              '/analytics': (context) => const AnalyticsScreen(),
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final isAuthenticated = await authService.checkAuthStatus();
    
    setState(() {
      _isAuthenticated = isAuthenticated;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isAuthenticated) {
      return const DashboardScreen();
    } else {
      return const LoginScreen();
    }
  }
} 