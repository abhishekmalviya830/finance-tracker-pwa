import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/theme_service.dart';
import '../../../core/services/export_service.dart';
import '../../../core/services/transaction_service.dart';
import '../../../core/constants/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _smsTrackingEnabled = false;
  String _selectedCurrency = 'INR';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final preferences = await authService.getUserPreferences();
    
    setState(() {
      _notificationsEnabled = preferences['notifications'] ?? true;
      _smsTrackingEnabled = preferences['smsTracking'] ?? false;
      _selectedCurrency = preferences['currency'] ?? 'INR';
    });
  }

  Future<void> _saveSettings() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.saveUserPreferences({
      'notifications': _notificationsEnabled,
      'smsTracking': _smsTrackingEnabled,
      'currency': _selectedCurrency,
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final themeService = Provider.of<ThemeService>(context);
    final transactionService = Provider.of<TransactionService>(context);
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        children: [
          // User Profile Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(user?.email ?? 'User'),
                    subtitle: Text('Member since ${user?.createdAt.year ?? DateTime.now().year}'),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      // TODO: Edit profile
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),

          // App Settings Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  
                  // Notifications
                  SwitchListTile(
                    title: const Text('Notifications'),
                    subtitle: const Text('Receive transaction alerts'),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                      _saveSettings();
                    },
                  ),
                  
                  // SMS Tracking
                  SwitchListTile(
                    title: const Text('SMS Tracking'),
                    subtitle: const Text('Automatically track SMS transactions'),
                    value: _smsTrackingEnabled,
                    onChanged: (value) {
                      setState(() {
                        _smsTrackingEnabled = value;
                      });
                      _saveSettings();
                    },
                  ),
                  
                  // Currency
                  ListTile(
                    title: const Text('Currency'),
                    subtitle: Text('Default currency: $_selectedCurrency'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _showCurrencyDialog();
                    },
                  ),
                  
                  // Theme
                  ListTile(
                    title: const Text('Theme'),
                    subtitle: Text('Current theme: ${themeService.currentTheme}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _showThemeDialog(themeService);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),

          // Data & Privacy Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data & Privacy',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  
                  ListTile(
                    leading: const Icon(Icons.download),
                    title: const Text('Export Data'),
                    subtitle: const Text('Download your transaction data'),
                    onTap: () async {
                      final transactions = transactionService.transactions;
                      if (transactions.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No transactions to export'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }
                      await ExportService.showExportDialog(context, transactions, user);
                    },
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.backup),
                    title: const Text('Backup Data'),
                    subtitle: const Text('Create a complete backup'),
                    onTap: () async {
                      final transactions = transactionService.transactions;
                      if (transactions.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No data to backup'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }
                      
                      try {
                        final preferences = await authService.getUserPreferences();
                        await ExportService.exportBackup(transactions, user, preferences);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Backup created successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to create backup: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.delete_forever),
                    title: const Text('Clear All Data'),
                    subtitle: const Text('Delete all local data'),
                    onTap: () {
                      _showClearDataDialog();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),

          // Support Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Support',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help & FAQ'),
                    onTap: () {
                      _showComingSoonDialog('Help & FAQ');
                    },
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.feedback),
                    title: const Text('Send Feedback'),
                    onTap: () {
                      _showComingSoonDialog('Send Feedback');
                    },
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About'),
                    subtitle: Text('Version ${AppConstants.appVersion}'),
                    onTap: () {
                      _showAboutDialog();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showLogoutDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(AppConstants.errorColor),
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppConstants.supportedCurrencies.length,
            itemBuilder: (context, index) {
              final currency = AppConstants.supportedCurrencies[index];
              return ListTile(
                title: Text(currency),
                trailing: _selectedCurrency == currency
                    ? const Icon(Icons.check, color: Color(AppConstants.primaryColor))
                    : null,
                onTap: () {
                  setState(() {
                    _selectedCurrency = currency;
                  });
                  _saveSettings();
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(ThemeService themeService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Light'),
              trailing: themeService.currentTheme == 'light'
                  ? const Icon(Icons.check, color: Color(AppConstants.primaryColor))
                  : null,
              onTap: () async {
                await themeService.setTheme('light');
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Dark'),
              trailing: themeService.currentTheme == 'dark'
                  ? const Icon(Icons.check, color: Color(AppConstants.primaryColor))
                  : null,
              onTap: () async {
                await themeService.setTheme('dark');
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('This will delete all your local data including transactions and settings. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final authService = Provider.of<AuthService>(context, listen: false);
              await authService.clearAllData();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(AppConstants.errorColor),
            ),
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final authService = Provider.of<AuthService>(context, listen: false);
              await authService.logout();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: const Text('This feature will be available in the next update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppConstants.appName} v${AppConstants.appVersion}'),
            const SizedBox(height: 8),
            const Text('A comprehensive finance tracking application with automatic SMS transaction detection.'),
            const SizedBox(height: 16),
            const Text('Features:'),
            const Text('• Automatic SMS transaction tracking'),
            const Text('• Smart categorization'),
            const Text('• Privacy-first approach'),
            const Text('• Cloud synchronization'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} 