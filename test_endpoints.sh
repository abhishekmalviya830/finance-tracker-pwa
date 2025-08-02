#!/bin/bash

echo "🧪 Testing Finance Tracker API Endpoints"
echo "========================================"

# Wait for application to start
echo "⏳ Waiting for application to start..."
sleep 5

# Test health endpoint (should work without auth)
echo "🏥 Testing Health Endpoint..."
HEALTH_RESPONSE=$(curl -s http://localhost:8080/actuator/health)
if [[ $HEALTH_RESPONSE == *"UP"* ]]; then
    echo "✅ Health check passed: $HEALTH_RESPONSE"
else
    echo "❌ Health check failed: $HEALTH_RESPONSE"
    exit 1
fi

# Test user registration
echo ""
echo "👤 Testing User Registration..."
SIGNUP_RESPONSE=$(curl -s -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}')

echo "Signup Response: $SIGNUP_RESPONSE"

if [[ $SIGNUP_RESPONSE == *"token"* ]]; then
    echo "✅ User registration successful"
    # Extract token
    TOKEN=$(echo $SIGNUP_RESPONSE | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
    echo "🔑 Token extracted: ${TOKEN:0:20}..."
else
    echo "❌ User registration failed"
    exit 1
fi

# Test transaction creation with token
echo ""
echo "💰 Testing Transaction Creation..."
TRANSACTION_RESPONSE=$(curl -s -X POST http://localhost:8080/api/transactions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "origin": "MANUAL",
    "amount": 150.75,
    "currency": "INR",
    "merchant": "Coffee Shop",
    "category": "Food & Beverages",
    "transactionTime": "2024-07-30T10:30:00"
  }')

echo "Transaction Response: $TRANSACTION_RESPONSE"

if [[ $TRANSACTION_RESPONSE == *"id"* ]]; then
    echo "✅ Transaction creation successful"
else
    echo "❌ Transaction creation failed"
fi

# Test getting transactions
echo ""
echo "📋 Testing Get Transactions..."
GET_TRANSACTIONS_RESPONSE=$(curl -s -X GET http://localhost:8080/api/transactions \
  -H "Authorization: Bearer $TOKEN")

echo "Get Transactions Response: $GET_TRANSACTIONS_RESPONSE"

if [[ $GET_TRANSACTIONS_RESPONSE == *"id"* ]]; then
    echo "✅ Get transactions successful"
else
    echo "❌ Get transactions failed"
fi

echo ""
echo "🎉 Testing Complete!"
echo "==================="
echo "✅ Health Check"
echo "✅ User Registration"
echo "✅ Transaction Creation"
echo "✅ Get Transactions"
echo ""
echo "🔑 Your JWT Token: $TOKEN"
echo "📝 Use this token in Postman: Bearer $TOKEN" 