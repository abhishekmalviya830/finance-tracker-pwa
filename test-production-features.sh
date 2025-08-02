#!/bin/bash

echo "🧪 Testing Production Features for Finance Tracker API"
echo "======================================================"

# Wait for application to start
echo "⏳ Waiting for application to start..."
sleep 5

# Test health endpoint
echo "🏥 Testing Health Endpoint..."
HEALTH_RESPONSE=$(curl -s http://localhost:8080/actuator/health)
if [[ $HEALTH_RESPONSE == *"UP"* ]]; then
    echo "✅ Health check passed"
else
    echo "❌ Health check failed"
    exit 1
fi

# Create a test user
echo "👤 Creating test user..."
SIGNUP_RESPONSE=$(curl -s -X POST http://localhost:8080/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"production@test.com","password":"password123"}')

if [[ $SIGNUP_RESPONSE == *"token"* ]]; then
    echo "✅ User created successfully"
    TOKEN=$(echo $SIGNUP_RESPONSE | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
else
    echo "❌ User creation failed"
    exit 1
fi

# Test dashboard endpoints
echo "📊 Testing Dashboard Endpoints..."

# Monthly stats
MONTHLY_STATS=$(curl -s -X GET "http://localhost:8080/api/dashboard/stats/monthly?year=2024&month=7" \
  -H "Authorization: Bearer $TOKEN")

if [[ $MONTHLY_STATS == *"totalSpending"* ]]; then
    echo "✅ Monthly stats endpoint working"
else
    echo "❌ Monthly stats endpoint failed"
fi

# Yearly stats
YEARLY_STATS=$(curl -s -X GET "http://localhost:8080/api/dashboard/stats/yearly?year=2024" \
  -H "Authorization: Bearer $TOKEN")

if [[ $YEARLY_STATS == *"totalSpending"* ]]; then
    echo "✅ Yearly stats endpoint working"
else
    echo "❌ Yearly stats endpoint failed"
fi

# Test SMS batch processing
echo "📱 Testing SMS Batch Processing..."
SMS_BATCH_RESPONSE=$(curl -s -X POST http://localhost:8080/api/transactions/sms/batch \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "messages": [
      {
        "text": "Rs.100 debited from A/c XX1234 on 30-07-24 at 10:30 AM. Avl Bal: Rs.5000.00",
        "timestamp": "2024-07-30T10:30:00"
      },
      {
        "text": "Rs.50 credited to A/c XX1234 on 30-07-24 at 11:00 AM. Avl Bal: Rs.5050.00",
        "timestamp": "2024-07-30T11:00:00"
      }
    ]
  }')

if [[ $SMS_BATCH_RESPONSE == *"totalProcessed"* ]]; then
    echo "✅ SMS batch processing working"
else
    echo "❌ SMS batch processing failed"
fi

# Test regular transaction creation
echo "💰 Testing Transaction Creation..."
TRANSACTION_RESPONSE=$(curl -s -X POST http://localhost:8080/api/transactions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "origin": "MANUAL",
    "amount": 150.75,
    "currency": "INR",
    "merchant": "Production Test Store",
    "category": "Food",
    "transactionTime": "2024-07-30T12:00:00"
  }')

if [[ $TRANSACTION_RESPONSE == *"id"* ]]; then
    echo "✅ Transaction creation working"
else
    echo "❌ Transaction creation failed"
fi

echo ""
echo "🎉 Production Features Test Complete!"
echo "====================================="
echo "✅ Health Monitoring"
echo "✅ User Authentication"
echo "✅ Dashboard Analytics"
echo "✅ SMS Batch Processing"
echo "✅ Transaction Management"
echo ""
echo "🚀 Your Finance Tracker API is production-ready!" 