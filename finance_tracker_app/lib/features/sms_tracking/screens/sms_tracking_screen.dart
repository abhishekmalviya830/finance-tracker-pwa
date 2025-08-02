import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/services/sms_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/sms_message.dart' as app_models;

class SmsTrackingScreen extends StatefulWidget {
  const SmsTrackingScreen({super.key});

  @override
  State<SmsTrackingScreen> createState() => _SmsTrackingScreenState();
}

class _SmsTrackingScreenState extends State<SmsTrackingScreen> {
  bool _isLoading = false;
  final TextEditingController _smsTextController = TextEditingController();
  List<app_models.SmsMessage> _recentSmsMessages = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSmsMessages();
  }

  @override
  void dispose() {
    _smsTextController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSmsMessages() async {
    try {
      final smsService = Provider.of<SmsService>(context, listen: false);
      final messages = await smsService.getAllSmsMessages();
      setState(() {
        _recentSmsMessages = messages.take(10).toList(); // Show last 10
      });
    } catch (e) {
      print('Error loading recent SMS messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final smsService = Provider.of<SmsService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showHelpDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          smsService.hasPermission ? Icons.check_circle : Icons.error,
                          color: smsService.hasPermission 
                              ? const Color(AppConstants.successColor)
                              : const Color(AppConstants.errorColor),
                        ),
                        const SizedBox(width: AppConstants.paddingSmall),
                        Text(
                          'SMS Tracking Status',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      smsService.hasPermission
                          ? 'SMS tracking is active. The app will automatically detect and categorize financial transactions from your SMS messages.'
                          : 'SMS tracking is disabled. Grant permission to automatically track your financial transactions.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    if (smsService.hasPermission) ...[
                      const SizedBox(height: AppConstants.paddingMedium),
                      Row(
                        children: [
                          Icon(
                            smsService.isListening ? Icons.play_circle : Icons.pause_circle,
                            color: smsService.isListening 
                                ? const Color(AppConstants.successColor)
                                : const Color(AppConstants.warningColor),
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          Text(
                            smsService.isListening ? 'Real-time monitoring active' : 'Real-time monitoring paused',
                            style: TextStyle(
                              color: smsService.isListening 
                                  ? const Color(AppConstants.successColor)
                                  : const Color(AppConstants.warningColor),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Real-time Monitoring Section
            Text(
              'Real-time Monitoring',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            
            if (!smsService.hasPermission) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.sms,
                        size: 48,
                        color: Color(AppConstants.primaryColor),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      const Text(
                        'Enable SMS Tracking',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      Text(
                        'Allow the app to read SMS messages to automatically track your financial transactions.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () => _requestPermission(),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('Grant Permission'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            smsService.isListening ? Icons.check_circle : Icons.pause_circle,
                            size: 48,
                            color: smsService.isListening 
                                ? const Color(AppConstants.successColor)
                                : const Color(AppConstants.warningColor),
                          ),
                          const SizedBox(width: AppConstants.paddingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  smsService.isListening ? 'Monitoring Active' : 'Monitoring Paused',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: AppConstants.paddingSmall),
                                Text(
                                  smsService.isListening
                                      ? 'The app is monitoring your SMS messages for financial transactions.'
                                      : 'Real-time monitoring is paused. Start monitoring to track new transactions.',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: smsService.isListening 
                                  ? () => _stopMonitoring()
                                  : () => _startMonitoring(),
                              child: Text(smsService.isListening ? 'Stop Monitoring' : 'Start Monitoring'),
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingMedium),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _openSettings(),
                              child: const Text('Settings'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: AppConstants.paddingLarge),

            // Manual Upload Section
            Text(
              'Manual Upload',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upload SMS Text',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      'Paste SMS text or upload SMS files to process financial transactions.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    TextField(
                      controller: _smsTextController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Paste SMS text here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _smsTextController.text.trim().isEmpty ? null : () => _processSmsText(),
                            icon: const Icon(Icons.upload),
                            label: const Text('Process SMS'),
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickSmsFile(),
                            icon: const Icon(Icons.file_upload),
                            label: const Text('Upload File'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            // Device SMS Section
            if (smsService.hasPermission) ...[
              Text(
                'Device SMS Messages',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.phone_android,
                            color: Color(AppConstants.primaryColor),
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          const Text(
                            'Recent Financial SMS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () => _processAllDeviceSms(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Process All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      if (_recentSmsMessages.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppConstants.paddingLarge),
                            child: Text(
                              'No financial SMS messages found',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        )
                      else
                        ...(_recentSmsMessages.map((sms) => _buildSmsMessageTile(sms))),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: AppConstants.paddingLarge),

            // Features Section
            Text(
              'Features',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            
            _buildFeatureCard(
              Icons.auto_awesome,
              'Real-time Monitoring',
              'Automatically detects financial SMS from banks, UPI apps, and other services.',
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            
            _buildFeatureCard(
              Icons.upload,
              'Manual Upload',
              'Upload SMS text or files to process financial transactions manually.',
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            
            _buildFeatureCard(
              Icons.category,
              'Smart Categorization',
              'Intelligently categorizes transactions based on merchant names and keywords.',
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            
            _buildFeatureCard(
              Icons.security,
              'Privacy First',
              'All SMS processing happens locally on your device. No data is sent to servers.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmsMessageTile(app_models.SmsMessage sms) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Color(AppConstants.primaryColor),
        child: Icon(Icons.sms, color: Colors.white),
      ),
      title: Text(
        sms.sender ?? 'Unknown',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sms.text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            sms.timestamp ?? 'Unknown date',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.upload),
        onPressed: () => _processSingleSms(sms),
        tooltip: 'Process this SMS',
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(AppConstants.primaryColor),
              size: 32,
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final smsService = Provider.of<SmsService>(context, listen: false);
      final granted = await smsService.requestPermission();
      
      if (granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('SMS tracking enabled successfully!'),
              backgroundColor: Color(AppConstants.successColor),
            ),
          );
          _loadRecentSmsMessages();
        }
      } else {
        if (mounted) {
          _showPermissionDeniedDialog();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: const Color(AppConstants.errorColor),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _startMonitoring() async {
    try {
      final smsService = Provider.of<SmsService>(context, listen: false);
      final success = await smsService.startSmsMonitoring();
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Real-time SMS monitoring started!'),
            backgroundColor: Color(AppConstants.successColor),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting monitoring: ${e.toString()}'),
            backgroundColor: const Color(AppConstants.errorColor),
          ),
        );
      }
    }
  }

  void _stopMonitoring() {
    final smsService = Provider.of<SmsService>(context, listen: false);
    smsService.stopSmsMonitoring();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Real-time SMS monitoring stopped'),
        backgroundColor: Color(AppConstants.warningColor),
      ),
    );
  }

  Future<void> _processSmsText() async {
    if (_smsTextController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final smsService = Provider.of<SmsService>(context, listen: false);
      final success = await smsService.processAndUploadSmsBatch(_smsTextController.text);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SMS processed successfully!'),
            backgroundColor: Color(AppConstants.successColor),
          ),
        );
        _smsTextController.clear();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No financial transactions found in SMS'),
            backgroundColor: Color(AppConstants.warningColor),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing SMS: ${e.toString()}'),
            backgroundColor: const Color(AppConstants.errorColor),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickSmsFile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'csv'],
      );

      if (result != null) {
        final file = result.files.first;
        
        // Read file content
        final bytes = file.bytes;
        if (bytes != null) {
          final content = String.fromCharCodes(bytes);
          await _processSmsFileContent(content, file.name);
        } else {
          throw Exception('Could not read file content');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing file: ${e.toString()}'),
            backgroundColor: const Color(AppConstants.errorColor),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _processSmsFileContent(String content, String fileName) async {
    try {
      final lines = content.split('\n');
      final smsMessages = <app_models.SmsMessage>[];
      
      for (final line in lines) {
        final trimmedLine = line.trim();
        if (trimmedLine.isNotEmpty && !trimmedLine.startsWith('#')) {
          // Parse line format: timestamp|sender|message_text
          final parts = trimmedLine.split('|');
          if (parts.length >= 3) {
            final timestamp = DateTime.tryParse(parts[0]) ?? DateTime.now();
            final sender = parts[1];
            final text = parts[2];
            
            smsMessages.add(app_models.SmsMessage(
              text: text,
              timestamp: timestamp.toIso8601String(),
              sender: sender,
            ));
          }
        }
      }

      if (smsMessages.isNotEmpty) {
        final smsService = Provider.of<SmsService>(context, listen: false);
        int processedCount = 0;
        
        for (final sms in smsMessages) {
          final transactions = await smsService.processSmsText(sms.text);
          if (transactions.isNotEmpty) {
            final success = await smsService.sendTransactionsToBackend(transactions);
            if (success) {
              processedCount++;
            }
          }
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Processed $processedCount transactions from $fileName'),
              backgroundColor: const Color(AppConstants.successColor),
            ),
          );
          
          // Refresh the recent SMS messages
          await _loadRecentSmsMessages();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No valid SMS messages found in file'),
              backgroundColor: Color(AppConstants.warningColor),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing file content: ${e.toString()}'),
            backgroundColor: const Color(AppConstants.errorColor),
          ),
        );
      }
    }
  }

  Future<void> _processAllDeviceSms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final smsService = Provider.of<SmsService>(context, listen: false);
      final success = await smsService.processAndUploadAllDeviceSms();
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All device SMS processed successfully!'),
            backgroundColor: Color(AppConstants.successColor),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No financial transactions found in device SMS'),
            backgroundColor: Color(AppConstants.warningColor),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing device SMS: ${e.toString()}'),
            backgroundColor: const Color(AppConstants.errorColor),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _processSingleSms(app_models.SmsMessage sms) async {
    try {
      final smsService = Provider.of<SmsService>(context, listen: false);
      final transactions = await smsService.processSmsText(sms.text);
      
      if (transactions.isNotEmpty) {
        final success = await smsService.sendTransactionsToBackend(transactions);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('SMS processed successfully!'),
              backgroundColor: Color(AppConstants.successColor),
            ),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No financial transaction found in this SMS'),
            backgroundColor: Color(AppConstants.warningColor),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing SMS: ${e.toString()}'),
            backgroundColor: const Color(AppConstants.errorColor),
          ),
        );
      }
    }
  }

  void _openSettings() async {
    final smsService = Provider.of<SmsService>(context, listen: false);
    await smsService.openSettings();
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text('SMS permission is required for automatic transaction tracking. Please grant permission in app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SMS Tracking Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Real-time Monitoring:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Automatically monitors incoming SMS messages'),
              Text('• Detects financial transactions in real-time'),
              Text('• Processes and categorizes transactions'),
              SizedBox(height: 16),
              Text(
                'Manual Upload:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Paste SMS text directly'),
              Text('• Upload SMS files (TXT, CSV)'),
              Text('• Process device SMS messages'),
              SizedBox(height: 16),
              Text(
                'Supported formats:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Bank transaction alerts'),
              Text('• UPI payment notifications'),
              Text('• Credit/debit card transactions'),
              Text('• Mobile wallet payments'),
            ],
          ),
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