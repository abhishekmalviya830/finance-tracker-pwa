# Finance Tracker App - Deployment Guide

This guide covers the complete deployment process for the Finance Tracker app across all platforms.

## 📋 Prerequisites

### Development Environment
- Flutter SDK 3.32.8+
- Dart SDK 3.8.1+
- Android Studio / VS Code
- Xcode (for iOS deployment)
- Git

### Backend Requirements
- Spring Boot backend running and accessible
- MySQL database configured
- SSL certificates for HTTPS
- Domain name (for production)

### Accounts Required
- Google Play Console account
- Apple Developer account
- Firebase project (optional, for analytics)

## 🚀 Pre-Deployment Checklist

### Code Quality
- [ ] All tests passing (`flutter test`)
- [ ] Code analysis clean (`flutter analyze`)
- [ ] No TODOs or debug code remaining
- [ ] Error handling implemented
- [ ] Loading states implemented

### Security
- [ ] API endpoints use HTTPS
- [ ] JWT tokens properly configured
- [ ] Sensitive data encrypted
- [ ] SMS permissions properly documented
- [ ] Privacy policy updated

### Performance
- [ ] App size optimized
- [ ] Images compressed
- [ ] Unused dependencies removed
- [ ] Memory leaks fixed

## 📱 Android Deployment

### 1. Generate Keystore
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. Configure Signing
Create `android/key.properties`:
```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=<path-to-keystore>/upload-keystore.jks
```

### 3. Update Build Configuration
In `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 4. Build App Bundle
```bash
flutter build appbundle --release
```

### 5. Upload to Play Store
1. Go to Google Play Console
2. Create new app
3. Upload app bundle
4. Fill in store listing
5. Set up content rating
6. Configure pricing & distribution
7. Submit for review

### 6. Play Store Requirements
- [ ] Privacy policy URL
- [ ] App content rating
- [ ] Screenshots (phone, tablet)
- [ ] Feature graphic
- [ ] App description
- [ ] Keywords optimization

## 🍎 iOS Deployment

### 1. Apple Developer Account Setup
- Enroll in Apple Developer Program ($99/year)
- Create App ID
- Configure certificates and provisioning profiles

### 2. Configure iOS Project
In `ios/Runner.xcodeproj`:
- Set Bundle Identifier
- Configure Team ID
- Set deployment target (iOS 12.0+)

### 3. Update Info.plist
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>your-backend-domain.com</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <false/>
        </dict>
    </dict>
</dict>
```

### 4. Build for Release
```bash
flutter build ios --release
```

### 5. Archive and Upload
1. Open Xcode
2. Select Product > Archive
3. Upload to App Store Connect
4. Configure app metadata
5. Submit for review

### 6. App Store Requirements
- [ ] App Store Connect setup
- [ ] Screenshots for all device sizes
- [ ] App description and keywords
- [ ] Privacy policy
- [ ] Age rating
- [ ] App review information

## 🌐 Web Deployment

### 1. Build for Web
```bash
flutter build web --release
```

### 2. Deploy to Firebase Hosting
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase project
firebase init hosting

# Deploy
firebase deploy
```

### 3. Alternative: Deploy to Netlify
1. Connect GitHub repository
2. Set build command: `flutter build web`
3. Set publish directory: `build/web`
4. Deploy

### 4. Web Configuration
Update `web/index.html`:
```html
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finance Tracker</title>
    <meta name="description" content="Track your finances automatically with SMS detection">
    <link rel="icon" type="image/png" href="favicon.png">
</head>
```

## 🔧 Production Configuration

### 1. Environment Variables
Create `.env` file:
```env
BACKEND_URL=https://api.financetracker.com
SMS_TRACKING_ENABLED=true
ANALYTICS_ENABLED=true
```

### 2. API Configuration
Update `lib/core/constants/api_endpoints.dart`:
```dart
static const String baseUrl = 'https://api.financetracker.com/api';
```

### 3. SSL Configuration
- Obtain SSL certificates
- Configure HTTPS redirects
- Set up HSTS headers

### 4. Database Configuration
- Use production MySQL instance
- Configure connection pooling
- Set up automated backups
- Monitor performance

## 📊 Analytics and Monitoring

### 1. Firebase Analytics
```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_analytics: ^10.7.4
```

### 2. Crash Reporting
```yaml
dependencies:
  firebase_crashlytics: ^3.4.8
```

### 3. Performance Monitoring
```yaml
dependencies:
  firebase_performance: ^0.9.3+8
```

## 🔒 Security Considerations

### 1. API Security
- Use HTTPS for all API calls
- Implement rate limiting
- Set up API authentication
- Monitor for suspicious activity

### 2. Data Protection
- Encrypt sensitive data at rest
- Use secure storage for tokens
- Implement data retention policies
- Regular security audits

### 3. SMS Permissions
- Document permission usage
- Provide clear user consent
- Allow users to revoke permissions
- Follow platform guidelines

## 📈 Performance Optimization

### 1. App Size
- Remove unused dependencies
- Compress images and assets
- Use ProGuard for Android
- Enable tree shaking

### 2. Loading Times
- Implement lazy loading
- Use caching strategies
- Optimize API calls
- Minimize network requests

### 3. Memory Usage
- Dispose of controllers properly
- Use weak references where appropriate
- Monitor memory leaks
- Optimize image loading

## 🧪 Testing Strategy

### 1. Unit Tests
```bash
flutter test
```

### 2. Integration Tests
```bash
flutter test integration_test/
```

### 3. Widget Tests
```bash
flutter test test/widget_test.dart
```

### 4. Manual Testing
- Test on multiple devices
- Test different screen sizes
- Test offline functionality
- Test SMS permissions

## 📋 Post-Deployment Checklist

### 1. Monitoring
- [ ] Set up error tracking
- [ ] Monitor app performance
- [ ] Track user analytics
- [ ] Monitor API usage

### 2. User Support
- [ ] Set up support email
- [ ] Create FAQ page
- [ ] Prepare support documentation
- [ ] Train support team

### 3. Marketing
- [ ] Create app store optimization
- [ ] Prepare marketing materials
- [ ] Set up social media accounts
- [ ] Plan launch campaign

## 🔄 Continuous Deployment

### 1. GitHub Actions
Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter build web
      - run: firebase deploy
```

### 2. Automated Testing
- Run tests on every commit
- Automated UI testing
- Performance regression testing
- Security scanning

## 📞 Support and Maintenance

### 1. Bug Tracking
- Set up issue tracking system
- Monitor crash reports
- Track user feedback
- Prioritize bug fixes

### 2. Updates
- Regular security updates
- Feature updates
- Performance improvements
- User feedback integration

### 3. Documentation
- Keep documentation updated
- Create user guides
- Maintain API documentation
- Update deployment guides

## 🚨 Emergency Procedures

### 1. Rollback Plan
- Keep previous versions ready
- Document rollback procedures
- Test rollback process
- Have backup configurations

### 2. Incident Response
- Define incident response team
- Create communication plan
- Set up monitoring alerts
- Document escalation procedures

## 📊 Success Metrics

### 1. Technical Metrics
- App crash rate < 1%
- API response time < 2s
- App size < 50MB
- Battery usage optimization

### 2. Business Metrics
- User acquisition rate
- User retention rate
- Feature adoption rate
- User satisfaction score

### 3. Security Metrics
- Security incident rate
- Vulnerability response time
- Compliance audit results
- Data breach prevention

---

## 📞 Contact

For deployment support:
- **Email**: devops@financetracker.com
- **Slack**: #deployment-support
- **Documentation**: https://docs.financetracker.com

---

**Note**: This guide should be updated regularly as the app evolves and new deployment requirements emerge. 