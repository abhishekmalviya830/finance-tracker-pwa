# 📱 iPhone Deployment Guide - Finance Tracker App

## 🎯 Complete Setup for SMS Tracking on iPhone

### **Step 1: Install Xcode (Required)**

1. **Download Xcode**:
   - Open App Store on your Mac
   - Search for "Xcode"
   - Click "Get" or "Install" (Free, ~15GB download)
   - Wait for download to complete

2. **Configure Xcode**:
   ```bash
   # After Xcode is installed, run these commands:
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```

### **Step 2: Install CocoaPods**

```bash
sudo gem install cocoapods
```

### **Step 3: Prepare Your iPhone**

1. **Connect iPhone** to Mac via USB cable
2. **Trust Computer** on your iPhone when prompted
3. **Enable Developer Mode**:
   - Go to Settings > Privacy & Security > Developer Mode
   - Toggle ON "Developer Mode"
   - Restart iPhone if prompted

### **Step 4: Build and Deploy the App**

1. **Check Connected Devices**:
   ```bash
   flutter devices
   ```

2. **Clean and Get Dependencies**:
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Build for iOS**:
   ```bash
   flutter build ios --release
   ```

4. **Deploy to iPhone**:
   ```bash
   flutter run -d ios
   ```

### **Step 5: Configure App Permissions**

When the app first launches on your iPhone:

1. **SMS Permission**: 
   - App will request SMS access
   - Tap "Allow" for SMS tracking
   - This enables real-time SMS monitoring

2. **Other Permissions**:
   - **Notifications**: Allow for transaction alerts
   - **Camera**: Allow for receipt scanning
   - **Photos**: Allow for document upload
   - **Location**: Allow for merchant insights

### **Step 6: Test SMS Tracking**

1. **Send Test SMS** to your phone:
   ```
   Rs. 1,250.00 debited from A/c XX1234 for SWIGGY. Avl Bal: Rs. 45,678.90
   ```

2. **Check App**:
   - Open Finance Tracker app
   - Go to Dashboard
   - Transaction should appear automatically
   - Check SMS Tracking section

## 🔧 Troubleshooting

### **Issue: Xcode Not Found**
```bash
# Check if Xcode is installed
ls /Applications/Xcode.app

# If not found, install from App Store
open "https://apps.apple.com/us/app/xcode/id497799835"
```

### **Issue: CocoaPods Not Working**
```bash
# Reinstall CocoaPods
sudo gem uninstall cocoapods
sudo gem install cocoapods

# Or use Homebrew
brew install cocoapods
```

### **Issue: iPhone Not Detected**
1. Check USB cable
2. Trust computer on iPhone
3. Enable Developer Mode
4. Restart both devices

### **Issue: Build Fails**
```bash
# Clean everything
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter run -d ios
```

### **Issue: SMS Permission Denied**
1. Go to Settings > Privacy & Security > SMS
2. Find "Finance Tracker App"
3. Toggle ON permission

## 📱 App Features on iPhone

### **✅ Real-time SMS Tracking**:
- Automatically detects financial SMS
- Extracts transaction details
- Categorizes expenses
- Updates dashboard in real-time

### **✅ Smart Filtering**:
- Only processes financial SMS
- Ignores personal messages
- Privacy-focused processing

### **✅ Background Processing**:
- Works even when app is closed
- Processes new SMS automatically
- Sends notifications for transactions

### **✅ Enhanced Features**:
- Face ID/Touch ID login
- Receipt scanning with camera
- Location-based insights
- Export data functionality

## 🔒 Privacy & Security

### **What the App Processes**:
- ✅ Financial SMS only (with keywords)
- ✅ Transaction amounts and merchants
- ✅ Timestamps and categories
- ✅ No raw SMS storage

### **What the App Does NOT Process**:
- ❌ Personal messages
- ❌ Non-financial SMS
- ❌ Contact information
- ❌ Location data (unless permitted)

### **User Controls**:
- Enable/disable SMS tracking
- Revoke permissions anytime
- Delete transaction history
- Export your data

## 📊 Testing Scenarios

### **Test 1: Basic Transaction**
Send SMS: `Rs. 500.00 debited for AMAZON`
Expected: Transaction appears in Food/Shopping category

### **Test 2: UPI Payment**
Send SMS: `UPI: Rs. 200.00 paid to ZOMATO`
Expected: Transaction with UPI method detected

### **Test 3: Credit Transaction**
Send SMS: `Rs. 50,000.00 credited via NEFT`
Expected: Income transaction detected

### **Test 4: ATM Withdrawal**
Send SMS: `Rs. 1,000.00 withdrawn from ATM`
Expected: ATM withdrawal category

## 🚀 Production Deployment

### **For App Store Release**:
1. Create Apple Developer Account ($99/year)
2. Configure app signing
3. Update bundle identifier
4. Submit for review

### **For Personal Use**:
1. Use free Apple Developer account
2. App expires after 7 days
3. Re-deploy weekly
4. Perfect for testing

## 📞 Support Commands

### **Check App Status**:
```bash
flutter doctor
flutter devices
flutter run -d ios
```

### **Debug Issues**:
```bash
flutter logs
flutter run -d ios --verbose
```

### **Clean Build**:
```bash
flutter clean
flutter pub get
flutter run -d ios
```

## 🎉 Success Checklist

- [ ] Xcode installed and configured
- [ ] CocoaPods installed
- [ ] iPhone connected and trusted
- [ ] App builds successfully
- [ ] App installs on iPhone
- [ ] SMS permission granted
- [ ] Test SMS processed correctly
- [ ] Transactions appear in dashboard
- [ ] Real-time updates working
- [ ] Background processing working

## 📱 Next Steps

1. **Test with real SMS** from your bank
2. **Configure categories** for your spending
3. **Set up budgets** and alerts
4. **Export data** for analysis
5. **Share feedback** for improvements

Your Finance Tracker app is now ready for real SMS tracking on iPhone! 🎯 