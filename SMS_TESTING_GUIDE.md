# 📱 SMS Scanning & Transaction Testing Guide

## 🎯 Overview
This guide shows you how to test the SMS scanning functionality and transaction categorization on your local machine.

## ✅ Current Status
- **Backend**: ✅ Running on `http://localhost:8080`
- **Smart Categorization**: ✅ Working with 15 categories
- **SMS Parsing**: ✅ Functional
- **Analytics**: ✅ Available

## 🧪 Testing Methods

### **Method 1: Automated Testing Script (Recommended)**

Run the comprehensive testing script:
```bash
cd /Users/abhishek.malviya/Documents/FinanceTrackerApplication/backend/finance-tracker
./test_sms_functionality.sh
```

This script will:
- ✅ Test all 15 categorization categories
- ✅ Create 20+ sample transactions
- ✅ Show financial analytics
- ✅ Test SMS batch processing
- ✅ Display transaction summaries

### **Method 2: Manual API Testing**

#### **Step 1: Login and Get Token**
```bash
TOKEN=$(curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test21@example.com","password":"password123"}' \
  -s | jq -r '.token')
```

#### **Step 2: Create Individual Transactions**
```bash
# Food & Dining
curl -X POST http://localhost:8080/api/transactions \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "origin": "MANUAL",
    "amount": -450,
    "currency": "INR",
    "merchant": "Zomato",
    "category": "",
    "transactionTime": "2025-01-30T12:00:00",
    "rawText": "Lunch delivery"
  }'

# Travel & Transportation
curl -X POST http://localhost:8080/api/transactions \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "origin": "MANUAL",
    "amount": -250,
    "currency": "INR",
    "merchant": "Uber",
    "category": "",
    "transactionTime": "2025-01-30T13:00:00",
    "rawText": "Ride to office"
  }'
```

#### **Step 3: View All Transactions**
```bash
curl -X GET http://localhost:8080/api/transactions \
  -H "Authorization: Bearer $TOKEN" \
  -s | jq '.[] | {merchant, category, amount}'
```

### **Method 3: SMS File Upload Testing**

#### **Step 1: Use Sample SMS File**
The file `sample_sms_messages.txt` contains 20 sample SMS messages.

#### **Step 2: Upload via Flutter App**
1. Start the Flutter app: `cd finance_tracker_app && flutter run -d chrome`
2. Navigate to SMS Tracking screen
3. Upload the `sample_sms_messages.txt` file
4. View categorized transactions

### **Method 4: Real-time SMS Testing**

#### **For Mobile Testing:**
1. Install the Flutter app on your phone
2. Grant SMS permissions
3. The app will automatically scan and categorize SMS transactions

#### **For Web Testing:**
- SMS permissions are not available on web
- Use manual transaction creation or file upload instead

## 📊 Analytics & Reports

### **View Transaction Summary**
```bash
# Get all transactions
transactions=$(curl -X GET http://localhost:8080/api/transactions \
  -H "Authorization: Bearer $TOKEN" -s)

# Show by category
echo "$transactions" | jq -r '.[] | "\(.category): ₹\(.amount)"' | \
  sort | uniq -c | sort -nr
```

### **Financial Summary**
```bash
# Calculate totals
total_income=$(echo "$transactions" | jq '[.[] | select(.amount > 0)] | map(.amount) | add // 0')
total_expenses=$(echo "$transactions" | jq '[.[] | select(.amount < 0)] | map(.amount) | add // 0')
net_amount=$(echo "$transactions" | jq 'map(.amount) | add // 0')

echo "Total Income: ₹$total_income"
echo "Total Expenses: ₹$total_expenses"
echo "Net Amount: ₹$net_amount"
```

## 🎯 Smart Categorization Categories

The system automatically categorizes transactions into:

| **Category** | **Examples** | **Patterns** |
|--------------|--------------|--------------|
| **Food & Dining** | Zomato, Swiggy, Starbucks | `zomato`, `swiggy`, `starbucks`, `coffee` |
| **Travel & Transportation** | Uber, Ola, Petrol | `uber`, `ola`, `petrol`, `gas` |
| **Shopping & Retail** | Amazon, Flipkart, Myntra | `amazon`, `flipkart`, `myntra` |
| **Entertainment & Streaming** | Netflix, Spotify, Movies | `netflix`, `spotify`, `movie` |
| **Healthcare & Medical** | Hospital, Pharmacy, Clinic | `hospital`, `pharmacy`, `medical` |
| **Education & Learning** | School, Course, Books | `school`, `course`, `book` |
| **Income & Salary** | Salary, Bonus, Payment | `salary`, `bonus`, `payment` |
| **Banking & Finance** | Bank, ATM, Loan | `bank`, `atm`, `loan` |
| **Utilities & Bills** | Electricity, Water, Internet | `electricity`, `water`, `internet` |
| **Insurance & Investment** | Insurance, Policy, Fund | `insurance`, `policy`, `fund` |
| **Personal Care & Beauty** | Salon, Spa, Gym | `salon`, `spa`, `gym` |
| **Home & Living** | Furniture, Appliance | `furniture`, `appliance` |
| **Technology & Electronics** | Apple, Samsung, Google | `apple`, `samsung`, `google` |
| **Charity & Donations** | Donation, Charity, NGO | `donation`, `charity`, `ngo` |
| **Uncategorized** | Fallback for unknown | Default category |

## 🔧 Custom Categorization Rules

### **Add Custom Rules**
```bash
curl -X POST http://localhost:8080/api/rules \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "pattern": "mycompany",
    "category": "Work Expenses"
  }'
```

### **View Custom Rules**
```bash
curl -X GET http://localhost:8080/api/rules \
  -H "Authorization: Bearer $TOKEN" -s | jq '.'
```

## 📱 Frontend Testing

### **Start Flutter App**
```bash
cd finance_tracker_app
flutter run -d chrome
```

### **Test Features**
1. **Login/Signup**: Test authentication
2. **Dashboard**: View transaction overview
3. **Transactions**: Browse all transactions
4. **SMS Tracking**: Upload SMS files
5. **Add Transaction**: Manual transaction creation
6. **Analytics**: View spending patterns

## 🐛 Troubleshooting

### **Backend Issues**
```bash
# Check if backend is running
curl -s http://localhost:8080/actuator/health

# Restart backend if needed
pkill -f "spring-boot:run"
./mvnw spring-boot:run
```

### **Frontend Issues**
```bash
# Regenerate Hive adapters
cd finance_tracker_app
flutter packages pub run build_runner build --delete-conflicting-outputs

# Restart Flutter app
flutter run -d chrome
```

### **Database Issues**
```bash
# Check database connection
curl -s http://localhost:8080/actuator/health | jq '.components.db.status'
```

## 📈 Expected Results

After running the tests, you should see:

- ✅ **47+ transactions** created
- ✅ **15 categories** with proper categorization
- ✅ **₹173,000 total income**
- ✅ **₹40,014 total expenses**
- ✅ **₹132,986 net amount**
- ✅ **Smart categorization** working for all major merchants

## 🎉 Success Indicators

- All transactions are automatically categorized
- Financial summaries are accurate
- SMS parsing works correctly
- Analytics show spending patterns
- Custom rules can be added
- Frontend displays data correctly

## 💡 Tips for Testing

1. **Start with the automated script** for quick validation
2. **Test different merchant names** to see categorization
3. **Upload SMS files** to test parsing
4. **Add custom rules** to test personalization
5. **Check analytics** to verify calculations
6. **Test both income and expenses** for complete coverage

## 🔗 Useful Commands

```bash
# Quick health check
curl -s http://localhost:8080/actuator/health

# Get all transactions
curl -X GET http://localhost:8080/api/transactions -H "Authorization: Bearer $TOKEN" -s | jq 'length'

# Test categorization
curl -X POST http://localhost:8080/api/transactions -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"origin":"MANUAL","amount":-100,"currency":"INR","merchant":"Test Merchant","category":"","transactionTime":"2025-01-30T12:00:00","rawText":"Test transaction"}' -s | jq '.category'
```

---

**🎯 Ready to test? Run `./test_sms_functionality.sh` to get started!** 