# 📱 UI Testing Guide - SMS Scanning & Transaction Features

## 🎯 Overview
This guide shows you how to test the SMS scanning functionality and transaction categorization through the Flutter UI interface.

## ✅ Prerequisites
- **Backend**: Running on `http://localhost:8080` ✅
- **Flutter App**: Running on `http://localhost:52715` (or similar port)
- **Sample Data**: Available in `sample_sms_messages.txt`

## 🚀 Step-by-Step UI Testing

### **Step 1: Access the Application**
1. Open your browser and go to: `http://localhost:52715`
2. You should see the Finance Tracker login screen

### **Step 2: Login/Signup Testing**
1. **Option A: Use Existing Account**
   - Email: `test21@example.com`
   - Password: `password123`

2. **Option B: Create New Account**
   - Click "Sign Up" tab
   - Enter a new email (e.g., `testui@example.com`)
   - Enter password: `password123`
   - Click "Sign Up"

### **Step 3: Dashboard Overview**
After login, you'll see:
- **Welcome Message** with user's name
- **Financial Overview** cards:
  - Total Balance
  - Monthly Income
  - Monthly Expenses
- **Quick Actions**:
  - Add Transaction
  - SMS Tracking
  - Analytics
  - Settings
- **Recent Transactions** list
- **Spending Categories** chart

### **Step 4: Test SMS File Upload**
1. **Navigate to SMS Tracking**
   - Click on "SMS Tracking" in the bottom navigation
   - Or click "SMS Tracking" in Quick Actions

2. **Upload Sample SMS File**
   - Click "Choose File" or "Upload SMS File"
   - Select the `sample_sms_messages.txt` file from your project
   - Click "Process SMS"
   - Watch the transactions being created and categorized

3. **Expected Results**
   - 20 transactions should be created
   - Each transaction should be automatically categorized
   - You should see categories like:
     - Food & Dining (Zomato, Swiggy, Starbucks)
     - Travel & Transportation (Uber, Ola, Petrol)
     - Shopping & Retail (Amazon, Flipkart, Myntra)
     - Entertainment & Streaming (Netflix, Spotify)
     - Healthcare & Medical (Apollo Hospital, Pharmacy)
     - Income & Salary (Salary, Bonus)

### **Step 5: Test Manual Transaction Creation**
1. **Navigate to Add Transaction**
   - Click "Add Transaction" in Quick Actions
   - Or click the "+" button in the Transactions tab

2. **Create Test Transactions**
   - **Food & Dining Test**:
     - Amount: `-450`
     - Merchant: `Zomato`
     - Category: Leave empty (should auto-categorize)
     - Description: `Lunch delivery`
     - Date: Today
     - Type: Expense
   
   - **Travel Test**:
     - Amount: `-250`
     - Merchant: `Uber`
     - Category: Leave empty
     - Description: `Ride to office`
     - Date: Today
     - Type: Expense
   
   - **Income Test**:
     - Amount: `50000`
     - Merchant: `Salary Credit`
     - Category: Leave empty
     - Description: `Monthly salary`
     - Date: Today
     - Type: Income

3. **Verify Auto-Categorization**
   - Zomato should be categorized as "Food & Dining"
   - Uber should be categorized as "Travel & Transportation"
   - Salary should be categorized as "Income & Salary"

### **Step 6: Test Transactions List**
1. **Navigate to Transactions**
   - Click "Transactions" in bottom navigation
   - Or click "View All" in Recent Transactions

2. **Test Search Functionality**
   - Type "Zomato" in search box
   - Should filter to show only Zomato transactions
   - Type "Uber" to see Uber transactions

3. **Test Category Filtering**
   - Select "Food & Dining" from category dropdown
   - Should show only food-related transactions
   - Select "Travel & Transportation" to see travel transactions

4. **Test Transaction Type Filtering**
   - Select "Expense" to see only expenses
   - Select "Income" to see only income
   - Select "All" to see everything

### **Step 7: Test Analytics & Reports**
1. **Dashboard Analytics**
   - Check the spending categories chart
   - Verify percentages match your transactions
   - Check total balance calculations

2. **Transaction Details**
   - Click on any transaction to see details
   - Verify category assignment
   - Check transaction origin (SMS vs Manual)

### **Step 8: Test Real-time Features**
1. **SMS Permission (Mobile Only)**
   - On mobile device, grant SMS permissions
   - The app should automatically scan new SMS
   - Transactions should be created in real-time

2. **Web Limitations**
   - SMS permissions not available on web
   - Use file upload instead
   - Manual transaction creation works

## 🧪 Expected Test Results

### **After SMS File Upload:**
- ✅ **20 transactions** created
- ✅ **Automatic categorization** working
- ✅ **Categories visible** in transaction list
- ✅ **Search functionality** working
- ✅ **Filtering** by category and type working

### **After Manual Transactions:**
- ✅ **Auto-categorization** based on merchant name
- ✅ **Transaction details** saved correctly
- ✅ **Real-time updates** in dashboard
- ✅ **Analytics updated** with new data

### **Financial Summary:**
- ✅ **Total Income**: Should show salary and bonus amounts
- ✅ **Total Expenses**: Should show all spending
- ✅ **Net Balance**: Income minus expenses
- ✅ **Category Breakdown**: Pie chart with spending distribution

## 🔍 Troubleshooting UI Issues

### **If App Doesn't Load:**
```bash
# Check if Flutter app is running
cd finance_tracker_app
flutter run -d chrome
```

### **If Login Fails:**
- Check backend is running: `curl http://localhost:8080/actuator/health`
- Try creating a new account
- Check browser console for errors

### **If Transactions Don't Load:**
- Check backend API: `curl http://localhost:8080/api/transactions`
- Refresh the page
- Check browser network tab for API errors

### **If SMS Upload Fails:**
- Ensure file format is correct
- Check file size (should be small)
- Try the sample file provided

## 📊 Sample Test Data

### **Expected Categories After Testing:**
| **Category** | **Count** | **Examples** |
|--------------|-----------|--------------|
| Food & Dining | 3+ | Zomato, Swiggy, Starbucks |
| Travel & Transportation | 3+ | Uber, Ola, Petrol |
| Shopping & Retail | 3+ | Amazon, Flipkart, Myntra |
| Entertainment & Streaming | 2+ | Netflix, Spotify |
| Healthcare & Medical | 3+ | Apollo, Pharmacy, Dental |
| Income & Salary | 3+ | Salary, Bonus, Freelance |
| Education & Learning | 2+ | Course, Workshop |
| Personal Care & Beauty | 1+ | Gym |

### **Expected Financial Summary:**
- **Total Income**: ₹73,000+ (Salary + Bonus + Freelance)
- **Total Expenses**: ₹15,000+ (Various categories)
- **Net Balance**: Positive amount
- **Categories**: 8+ different spending categories

## 🎯 Success Criteria

✅ **Login/Signup**: Works without errors
✅ **Dashboard**: Shows financial overview
✅ **SMS Upload**: Processes file and creates transactions
✅ **Auto-Categorization**: All transactions properly categorized
✅ **Search/Filter**: Works for transactions list
✅ **Manual Transactions**: Can add and categorize
✅ **Analytics**: Shows spending patterns
✅ **Real-time Updates**: Changes reflect immediately

## 💡 Tips for Testing

1. **Start with SMS file upload** to populate data quickly
2. **Test different merchant names** to see categorization
3. **Use search and filters** to verify functionality
4. **Check analytics** to ensure calculations are correct
5. **Test both income and expenses** for complete coverage
6. **Verify real-time updates** when adding transactions

## 🔗 Quick Commands

```bash
# Check backend status
curl -s http://localhost:8080/actuator/health

# Check Flutter app
cd finance_tracker_app && flutter run -d chrome

# View sample SMS file
cat sample_sms_messages.txt
```

---

**🎉 Ready to test? Open http://localhost:52715 and follow the steps above!** 