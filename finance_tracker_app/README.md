# Finance Tracker App

A comprehensive finance tracking application with automatic SMS transaction detection, built with Flutter and Spring Boot.

## 🚀 Features

### Core Features
- **Automatic SMS Tracking**: Automatically detects and categorizes financial transactions from SMS messages
- **Smart Categorization**: Intelligently categorizes transactions based on merchant names and keywords
- **Real-time Dashboard**: Beautiful dashboard with spending analytics and charts
- **Secure Authentication**: JWT-based authentication with secure token storage
- **Privacy First**: All SMS processing happens locally on your device

### Technical Features
- **Cross-platform**: iOS and Android support
- **Offline Support**: Works without internet connection
- **Cloud Sync**: Synchronizes data with backend server
- **Modern UI**: Material Design 3 with beautiful animations
- **Responsive Design**: Adapts to different screen sizes

## 📱 Screenshots

### Dashboard
- Financial overview with spending cards
- Interactive pie charts for category breakdown
- Recent transactions list
- Quick action buttons

### SMS Tracking
- Permission management
- Real-time SMS monitoring
- Transaction detection status
- Help and documentation

### Settings
- User profile management
- App preferences (currency, theme, notifications)
- Data export and privacy controls
- Support and feedback options

## 🛠 Technology Stack

### Frontend (Flutter)
- **Framework**: Flutter 3.32.8
- **State Management**: Provider + Flutter Bloc
- **HTTP Client**: Dio + Retrofit
- **Local Storage**: Hive + SharedPreferences
- **Charts**: FL Chart
- **Permissions**: Permission Handler
- **SMS**: SMS plugin for Android

### Backend (Spring Boot)
- **Framework**: Spring Boot 3.5.4
- **Database**: MySQL 8.0
- **Authentication**: JWT
- **Security**: Spring Security
- **API Documentation**: OpenAPI/Swagger

## 📋 Prerequisites

- Flutter SDK 3.32.8 or higher
- Dart SDK 3.8.1 or higher
- Android Studio / VS Code
- iOS Simulator (for iOS development)
- Android Emulator (for Android development)
- Chrome (for web development)

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd finance_tracker_app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Backend
Make sure your Spring Boot backend is running on `http://localhost:8080`

### 4. Run the App

#### For Web (Development)
```bash
flutter run -d chrome --web-port=3000
```

#### For Android
```bash
flutter run -d android
```

#### For iOS
```bash
flutter run -d ios
```

## 🔧 Configuration

### Backend URL
Update the backend URL in `lib/core/constants/api_endpoints.dart`:
```dart
static const String baseUrl = 'http://localhost:8080/api';
```

### SMS Permissions
The app requires SMS permissions on Android for automatic transaction tracking:
- `android.permission.RECEIVE_SMS`
- `android.permission.READ_SMS`

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── api_endpoints.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   └── sms_service.dart
│   └── utils/
│       └── sms_parser.dart
├── features/
│   ├── auth/
│   │   └── screens/
│   │       └── login_screen.dart
│   ├── dashboard/
│   │   ├── screens/
│   │   │   └── dashboard_screen.dart
│   │   └── widgets/
│   │       ├── dashboard_overview.dart
│   │       ├── recent_transactions.dart
│   │       └── spending_chart.dart
│   ├── sms_tracking/
│   │   └── screens/
│   │       └── sms_tracking_screen.dart
│   ├── transactions/
│   │   └── screens/
│   │       └── transactions_screen.dart
│   └── settings/
│       └── screens/
│           └── settings_screen.dart
├── models/
│   ├── user.dart
│   ├── transaction.dart
│   └── sms_message.dart
└── main.dart
```

## 🔐 Security Features

### SMS Processing
- **Local Processing**: All SMS parsing happens on device
- **No Data Storage**: SMS content is not stored permanently
- **Encrypted Transmission**: HTTPS + JWT for API communication
- **User Consent**: Explicit permission required for SMS access

### Data Protection
- **Secure Storage**: Flutter Secure Storage for sensitive data
- **Token Management**: Automatic token refresh and secure storage
- **Privacy Controls**: User can disable SMS tracking anytime

## 📊 Supported SMS Formats

The app can detect transactions from various SMS formats:

### Bank Transactions
```
Rs.100 debited from A/c XX1234 on 30-07-24 at 10:30 AM. Avl Bal: Rs.5000.00
Rs.50 credited to A/c XX1234 on 30-07-24 at 11:00 AM. Avl Bal: Rs.5050.00
```

### UPI Transactions
```
UPI: Rs.200 paid to merchant@upi on 30-07-24 at 12:00 PM. Ref: 123456789
```

### Card Transactions
```
Card XX1234: Rs.150.75 spent at AMAZON on 30-07-24 at 01:30 PM
```

## 🎯 Supported Categories

- Food & Dining
- Transportation
- Shopping
- Entertainment
- Healthcare
- Education
- Utilities
- Travel
- Insurance
- Investment
- Salary

## 🔄 API Endpoints

### Authentication
- `POST /api/auth/signup` - User registration
- `POST /api/auth/login` - User login

### Transactions
- `GET /api/transactions` - Get user transactions
- `POST /api/transactions` - Create transaction
- `POST /api/transactions/sms/batch` - Process SMS batch

### SMS Upload
- `POST /api/sms/upload/text` - Upload text file
- `POST /api/sms/upload/csv` - Upload CSV file
- `POST /api/sms/upload/whatsapp` - Upload WhatsApp chat

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

## 📦 Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🚀 Deployment

### App Store Deployment
1. Build the app for production
2. Configure app signing
3. Upload to App Store Connect
4. Submit for review

### Play Store Deployment
1. Build the app bundle
2. Configure app signing
3. Upload to Google Play Console
4. Submit for review

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue on GitHub
- Check the documentation
- Contact the development team

## 🔮 Roadmap

### Phase 1 (Current)
- ✅ Basic authentication
- ✅ SMS tracking setup
- ✅ Dashboard UI
- ✅ Transaction management

### Phase 2 (Next)
- 🔄 Advanced analytics
- 🔄 Budget planning
- 🔄 Export functionality
- 🔄 Push notifications

### Phase 3 (Future)
- 📋 AI-powered insights
- 📋 Multi-currency support
- 📋 Investment tracking
- 📋 Bill reminders

## 📈 Performance

- **App Size**: ~15MB (APK)
- **Memory Usage**: ~50MB average
- **Battery Impact**: Minimal (background processing disabled by default)
- **Network Usage**: ~1MB/month for sync

## 🔧 Troubleshooting

### Common Issues

#### SMS Permissions Not Working
1. Check if SMS permissions are granted
2. Restart the app
3. Check device settings

#### Backend Connection Issues
1. Verify backend is running on correct port
2. Check network connectivity
3. Verify API endpoints in configuration

#### Build Issues
1. Run `flutter clean`
2. Run `flutter pub get`
3. Check Flutter and Dart versions

## 📞 Contact

- **Email**: support@financetracker.com
- **Website**: https://financetracker.com
- **GitHub**: https://github.com/financetracker/app

---

**Note**: This is a development version. For production use, ensure all security measures are properly configured and tested. 