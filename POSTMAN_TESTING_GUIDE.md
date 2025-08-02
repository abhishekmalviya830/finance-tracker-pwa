# Postman Testing Guide for Finance Tracker API

## 🚀 Quick Start

1. **Start the Application**
   ```bash
   mvn spring-boot:run
   ```
   Wait for the application to start (you'll see "Started FinanceTrackerApplication" in logs)

2. **Base URL**: `http://localhost:8080`

## 📋 Testing Checklist

### ✅ Authentication Endpoints

#### 1. User Registration
- **Method**: `POST`
- **URL**: `http://localhost:8080/api/auth/signup`
- **Headers**: 
  ```
  Content-Type: application/json
  ```
- **Body** (raw JSON):
  ```json
  {
    "email": "test@example.com",
    "password": "password123"
  }
  ```
- **Expected Response**: 
  ```json
  {
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "type": "Bearer"
  }
  ```
- **Save the token** for subsequent requests

#### 2. User Login
- **Method**: `POST`
- **URL**: `http://localhost:8080/api/auth/login`
- **Headers**: 
  ```
  Content-Type: application/json
  ```
- **Body** (raw JSON):
  ```json
  {
    "email": "test@example.com",
    "password": "password123"
  }
  ```
- **Expected Response**: Same as signup

### ✅ Transaction Management

#### 3. Create Manual Transaction
- **Method**: `POST`
- **URL**: `http://localhost:8080/api/transactions`
- **Headers**: 
  ```
  Content-Type: application/json
  Authorization: Bearer YOUR_TOKEN_HERE
  ```
- **Body** (raw JSON):
  ```json
  {
    "origin": "MANUAL",
    "amount": 150.75,
    "currency": "INR",
    "merchant": "Coffee Shop",
    "category": "Food & Beverages",
    "transactionTime": "2024-07-30T10:30:00"
  }
  ```
- **Expected Response**:
  ```json
  {
    "id": 1,
    "amount": 150.75,
    "currency": "INR",
    "merchant": "Coffee Shop",
    "category": "Food & Beverages",
    "transactionTime": "2024-07-30T10:30:00"
  }
  ```

#### 4. Get All Transactions
- **Method**: `GET`
- **URL**: `http://localhost:8080/api/transactions`
- **Headers**: 
  ```
  Authorization: Bearer YOUR_TOKEN_HERE
  ```
- **Expected Response**:
  ```json
  [
    {
      "id": 1,
      "amount": 150.75,
      "currency": "INR",
      "merchant": "Coffee Shop",
      "category": "Food & Beverages",
      "transactionTime": "2024-07-30T10:30:00"
    }
  ]
  ```

### ✅ SMS Batch Processing

#### 5. Process SMS Batch
- **Method**: `POST`
- **URL**: `http://localhost:8080/api/transactions/sms/batch`
- **Headers**: 
  ```
  Content-Type: application/json
  Authorization: Bearer YOUR_TOKEN_HERE
  ```
- **Body** (raw JSON):
  ```json
  {
    "messages": [
      {
        "text": "Rs.100 debited from A/c XX1234 on 30-07-24 at 10:30 AM. Avl Bal: Rs.5000.00",
        "timestamp": "2024-07-30T10:30:00"
      },
      {
        "text": "Rs.50 credited to A/c XX1234 on 30-07-24 at 11:00 AM. Avl Bal: Rs.5050.00",
        "timestamp": "2024-07-30T11:00:00"
      },
      {
        "text": "Rs.200 debited from A/c XX1234 on 30-07-24 at 12:00 PM. Avl Bal: Rs.4850.00",
        "timestamp": "2024-07-30T12:00:00"
      }
    ]
  }
  ```
- **Expected Response**:
  ```json
  {
    "totalProcessed": 3,
    "successfulTransactions": 3,
    "failedTransactions": 0,
    "results": [
      {
        "index": 0,
        "success": true,
        "message": "Transaction created successfully",
        "transaction": {
          "id": 2,
          "amount": -100.00,
          "currency": "INR",
          "merchant": "Unknown",
          "category": "Uncategorized",
          "transactionTime": "2024-07-30T10:30:00"
        }
      }
    ]
  }
  ```

### ✅ Dashboard Analytics

#### 6. Get Monthly Statistics
- **Method**: `GET`
- **URL**: `http://localhost:8080/api/dashboard/stats/monthly?year=2024&month=7`
- **Headers**: 
  ```
  Authorization: Bearer YOUR_TOKEN_HERE
  ```
- **Expected Response**:
  ```json
  {
    "totalSpending": 450.75,
    "totalIncome": 50.00,
    "netAmount": -400.75,
    "totalTransactions": 5,
    "spendingByCategory": {
      "Food & Beverages": 150.75,
      "Uncategorized": 300.00
    },
    "monthlyTrend": {
      "2024-07": -400.75
    },
    "recentTransactions": [
      {
        "id": 4,
        "amount": -200.00,
        "currency": "INR",
        "merchant": "Unknown",
        "category": "Uncategorized",
        "transactionTime": "2024-07-30T12:00:00"
      }
    ],
    "averageTransactionAmount": -80.15,
    "topSpendingCategory": "Uncategorized",
    "topSpendingAmount": 300.00
  }
  ```

#### 7. Get Yearly Statistics
- **Method**: `GET`
- **URL**: `http://localhost:8080/api/dashboard/stats/yearly?year=2024`
- **Headers**: 
  ```
  Authorization: Bearer YOUR_TOKEN_HERE
  ```
- **Expected Response**: Similar to monthly but for the entire year

### ✅ Category Rules Management

#### 8. Create Category Rule
- **Method**: `POST`
- **URL**: `http://localhost:8080/api/category-rules`
- **Headers**: 
  ```
  Content-Type: application/json
  Authorization: Bearer YOUR_TOKEN_HERE
  ```
- **Body** (raw JSON):
  ```json
  {
    "pattern": "coffee|starbucks|cafe",
    "category": "Food & Beverages"
  }
  ```
- **Expected Response**:
  ```json
  {
    "id": 1,
    "pattern": "coffee|starbucks|cafe",
    "category": "Food & Beverages",
    "createdAt": "2024-07-30T10:30:00",
    "updatedAt": "2024-07-30T10:30:00"
  }
  ```

#### 9. Get Category Rules
- **Method**: `GET`
- **URL**: `http://localhost:8080/api/category-rules`
- **Headers**: 
  ```
  Authorization: Bearer YOUR_TOKEN_HERE
  ```
- **Expected Response**:
  ```json
  [
    {
      "id": 1,
      "pattern": "coffee|starbucks|cafe",
      "category": "Food & Beverages",
      "createdAt": "2024-07-30T10:30:00",
      "updatedAt": "2024-07-30T10:30:00"
    }
  ]
  ```

### ✅ Health Monitoring

#### 10. Health Check
- **Method**: `GET`
- **URL**: `http://localhost:8080/actuator/health`
- **Headers**: None required
- **Expected Response**:
  ```json
  {
    "status": "UP",
    "components": {
      "db": {
        "status": "UP",
        "details": {
          "database": "MySQL",
          "validationQuery": "isValid()"
        }
      },
      "diskSpace": {
        "status": "UP",
        "details": {
          "total": 499963174912,
          "free": 419430400000,
          "threshold": 10485760
        }
      }
    }
  }
  ```

## 🔧 Postman Setup Tips

### 1. Environment Variables
Create a Postman environment with these variables:
- `base_url`: `http://localhost:8080`
- `auth_token`: (will be set after login)

### 2. Pre-request Scripts
For requests requiring authentication, add this pre-request script:
```javascript
pm.request.headers.add({
    key: 'Authorization',
    value: 'Bearer ' + pm.environment.get('auth_token')
});
```

### 3. Tests Scripts
After login/signup, add this test script to automatically save the token:
```javascript
if (pm.response.code === 200) {
    const response = pm.response.json();
    pm.environment.set('auth_token', response.token);
}
```

## 📊 Testing Scenarios

### Scenario 1: Complete User Journey
1. Register a new user
2. Login with the user
3. Create a manual transaction
4. Process SMS batch
5. Check dashboard statistics
6. Create category rules
7. Verify categorization works

### Scenario 2: Error Handling
1. Try to access protected endpoints without token
2. Send invalid JSON in request bodies
3. Test with non-existent user credentials
4. Send malformed SMS messages

### Scenario 3: Data Validation
1. Create transaction with negative amount
2. Create transaction with invalid currency
3. Create category rule with empty pattern
4. Test with very large amounts

## 🚨 Common Issues & Solutions

### Issue: "Port 8080 already in use"
**Solution**: 
```bash
lsof -ti:8080 | xargs kill -9
```

### Issue: "Database connection failed"
**Solution**: Ensure MySQL is running and credentials are correct in `application.properties`

### Issue: "JWT token expired"
**Solution**: Login again to get a new token

### Issue: "Validation failed"
**Solution**: Check request body format and required fields

## 📝 Notes

- All timestamps should be in ISO 8601 format: `YYYY-MM-DDTHH:mm:ss`
- Amounts can be positive (income) or negative (expense)
- The SMS parser will attempt to extract transaction details from SMS text
- Category rules use regex patterns for matching
- Dashboard statistics are calculated in real-time

## 🎯 Success Criteria

✅ Application starts without errors  
✅ All endpoints return expected responses  
✅ Authentication works correctly  
✅ SMS parsing creates transactions  
✅ Dashboard shows accurate statistics  
✅ Category rules are applied correctly  
✅ Health check returns "UP" status  

Your Finance Tracker API is ready for testing! 🚀 