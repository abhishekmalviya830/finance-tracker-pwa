# 📱 SMS Feature Testing Guide

## 🎯 Overview
This guide will help you test the SMS tracking feature of the Finance Tracker app, both on web and iOS platforms.

## 🌐 Web Testing (Current Setup)

### ✅ What's Working:
- Manual SMS upload feature
- SMS parsing and transaction extraction
- Real-time transaction processing
- Category auto-detection

### 🧪 How to Test on Web:

1. **Start the App**:
   ```bash
   flutter run -d chrome --web-port=3000
   ```

2. **Login/Signup**:
   - Use the enhanced signup form with First Name, Last Name, Email, Password
   - Or login with existing credentials

3. **Test SMS Upload**:
   - Go to "SMS Tracking" section
   - Click "Upload SMS" or "Manual Upload"
   - Copy and paste SMS from `sample_financial_sms.txt`
   - Watch transactions appear in real-time

4. **Sample SMS to Test**:
   ```
   Rs. 1,250.00 debited from A/c XX1234 on 31-07-2025 at 14:30 for SWIGGY. Avl Bal: Rs. 45,678.90
   ```

## 📱 iOS Testing Setup

### 🔧 Prerequisites:

1. **Install Xcode**:
   ```bash
   # Download from App Store or Apple Developer
   # Then run:
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```

2. **Install CocoaPods**:
   ```bash
   sudo gem install cocoapods
   ```

3. **Connect iPhone**:
   - Connect via USB
   - Trust the computer on your iPhone
   - Enable Developer Mode in Settings > Privacy & Security > Developer Mode

### 🚀 Build and Deploy:

1. **Check Connected Devices**:
   ```bash
   flutter devices
   ```

2. **Build for iOS**:
   ```bash
   flutter build ios --release
   ```

3. **Run on iPhone**:
   ```bash
   flutter run -d ios
   ```

4. **Alternative - iOS Simulator**:
   ```bash
   flutter run -d ios --simulator
   ```

## 🔍 SMS Feature Testing Scenarios

### 📊 Test Case 1: Basic Transaction Detection
**Input SMS**:
```
Rs. 1,250.00 debited from A/c XX1234 for SWIGGY. Avl Bal: Rs. 45,678.90
```
**Expected Output**:
- Amount: ₹1,250.00
- Merchant: Swiggy
- Category: Food & Dining
- Type: Debit

### 📊 Test Case 2: UPI Transaction
**Input SMS**:
```
UPI: Rs. 899.00 paid to ZOMATO via UPI Ref: 123456789. A/c XX9012 debited.
```
**Expected Output**:
- Amount: ₹899.00
- Merchant: Zomato
- Category: Food & Dining
- Type: Debit
- Method: UPI

### 📊 Test Case 3: Credit Transaction
**Input SMS**:
```
Rs. 50,000.00 credited to A/c XX2345 via NEFT from COMPANY XYZ.
```
**Expected Output**:
- Amount: ₹50,000.00
- Merchant: Company XYZ
- Category: Income
- Type: Credit
- Method: NEFT

### 📊 Test Case 4: ATM Withdrawal
**Input SMS**:
```
Rs. 2,000.00 withdrawn from A/c XX3456 at HDFC ATM. Avl Bal: Rs. 23,456.78
```
**Expected Output**:
- Amount: ₹2,000.00
- Merchant: HDFC ATM
- Category: ATM Withdrawal
- Type: Debit

## 🛡️ Privacy & Security Testing

### ✅ What Gets Processed:
- Only SMS with financial keywords
- Transaction amounts and merchants
- Timestamps and categories

### ❌ What Does NOT Get Processed:
- Personal messages
- Non-financial SMS
- Raw SMS content storage
- Contact information

### 🔐 Permission Testing:
1. **Grant Permission**: Test with SMS permission granted
2. **Deny Permission**: Test with SMS permission denied
3. **Revoke Permission**: Test permission revocation in Settings

## 📈 Advanced Testing Features

### 🎯 Category Detection:
- Food & Dining: Swiggy, Zomato, Dominos, Starbucks
- Shopping: Amazon, Myntra, Croma
- Transport: Uber, Fuel stations
- Utilities: BSNL, Mobile recharge
- Entertainment: BookMyShow, Spotify, Steam
- Healthcare: Apollo Pharmacy
- Education: Udemy courses

### 🔄 Real-time Processing:
- Test incoming SMS processing
- Verify transaction notifications
- Check dashboard updates

### 📊 Analytics Testing:
- Spending patterns
- Category-wise breakdown
- Monthly/yearly reports

## 🐛 Troubleshooting

### Common Issues:

1. **SMS Permission Denied**:
   - Go to Settings > Privacy & Security > SMS
   - Enable permission for Finance Tracker

2. **No Transactions Detected**:
   - Check if SMS contains financial keywords
   - Verify amount format (Rs., ₹, INR)
   - Ensure proper merchant names

3. **iOS Build Issues**:
   - Install Xcode completely
   - Run `flutter clean && flutter pub get`
   - Check iOS deployment target

4. **Web Blank Screen**:
   - Clear browser cache
   - Check console for errors
   - Restart Flutter server

## 📋 Test Checklist

### ✅ Web Testing:
- [ ] App loads without blank screen
- [ ] Login/Signup works
- [ ] Manual SMS upload works
- [ ] Transactions appear in dashboard
- [ ] Categories are auto-detected
- [ ] Profile editing works

### ✅ iOS Testing:
- [ ] Xcode installed and configured
- [ ] iPhone connected and trusted
- [ ] App builds successfully
- [ ] SMS permission requested
- [ ] Real-time SMS monitoring works
- [ ] Background processing works

### ✅ SMS Parsing:
- [ ] Amount extraction works
- [ ] Merchant detection works
- [ ] Category assignment works
- [ ] Date/time parsing works
- [ ] Multiple SMS formats supported

## 🎉 Success Criteria

The SMS feature is working correctly when:
1. ✅ Financial SMS are automatically detected
2. ✅ Transaction details are accurately extracted
3. ✅ Categories are properly assigned
4. ✅ Real-time updates work
5. ✅ Privacy is maintained (no raw SMS stored)
6. ✅ User controls work (enable/disable)

## 📞 Support

If you encounter issues:
1. Check the troubleshooting section
2. Verify all prerequisites are met
3. Test with sample SMS data
4. Check console logs for errors
5. Ensure backend is running on localhost:8080 