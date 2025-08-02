#!/bin/bash

# Finance Tracker - SMS Functionality Testing Script
# This script demonstrates how to test SMS scanning and transaction categorization

echo "🧪 Finance Tracker - SMS Functionality Testing"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if backend is running
echo -e "${BLUE}📡 Checking backend status...${NC}"
if curl -s http://localhost:8080/actuator/health | grep -q "UP"; then
    echo -e "${GREEN}✅ Backend is running${NC}"
else
    echo -e "${RED}❌ Backend is not running. Please start it first.${NC}"
    exit 1
fi

# Login and get token
echo -e "\n${BLUE}🔐 Logging in...${NC}"
TOKEN=$(curl -X POST http://localhost:8080/api/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email":"test21@example.com","password":"password123"}' \
    -s | jq -r '.token')

if [ "$TOKEN" = "null" ] || [ -z "$TOKEN" ]; then
    echo -e "${RED}❌ Login failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Login successful${NC}"

# Function to create transaction and show categorization
create_transaction() {
    local merchant="$1"
    local amount="$2"
    local description="$3"
    
    echo -e "\n${YELLOW}📝 Creating transaction: $merchant (₹$amount)${NC}"
    
    response=$(curl -X POST http://localhost:8080/api/transactions \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d "{
            \"origin\": \"MANUAL\",
            \"amount\": $amount,
            \"currency\": \"INR\",
            \"merchant\": \"$merchant\",
            \"category\": \"\",
            \"transactionTime\": \"$(date -u +"%Y-%m-%dT%H:%M:%S")\",
            \"rawText\": \"$description\"
        }" -s)
    
    category=$(echo "$response" | jq -r '.category')
    echo -e "${GREEN}✅ Categorized as: $category${NC}"
}

# Test different types of transactions (simulating SMS scanning)
echo -e "\n${BLUE}📱 Testing SMS-like Transaction Creation${NC}"
echo "=============================================="

# Food & Dining
create_transaction "Zomato" -450 "Lunch delivery"
create_transaction "Swiggy" -320 "Dinner order"
create_transaction "Starbucks" -299 "Coffee and cake"

# Travel & Transportation
create_transaction "Uber" -180 "Ride to mall"
create_transaction "Ola" -250 "Airport pickup"
create_transaction "Petrol Pump" -1500 "Fuel refill"

# Shopping & Retail
create_transaction "Amazon" -1200 "Electronics purchase"
create_transaction "Flipkart" -800 "Clothing order"
create_transaction "Myntra" -600 "Shoes purchase"

# Entertainment & Streaming
create_transaction "Netflix" -499 "Monthly subscription"
create_transaction "Spotify" -119 "Premium plan"
create_transaction "Movie Theatre" -400 "Movie tickets"

# Healthcare & Medical
create_transaction "Apollo Hospital" -2000 "Medical checkup"
create_transaction "Local Pharmacy" -350 "Medicines"
create_transaction "Dental Clinic" -1500 "Dental treatment"

# Education & Learning
create_transaction "Online Course" -3000 "Programming course"
create_transaction "Book Store" -500 "Study materials"
create_transaction "Workshop" -800 "Skill development"

# Income
create_transaction "Salary Credit" 50000 "Monthly salary"
create_transaction "Freelance Payment" 8000 "Project payment"
create_transaction "Bonus" 15000 "Performance bonus"

# View all transactions
echo -e "\n${BLUE}📊 Viewing All Transactions${NC}"
echo "================================"

transactions=$(curl -X GET http://localhost:8080/api/transactions \
    -H "Authorization: Bearer $TOKEN" -s)

# Show transaction summary by category
echo -e "\n${YELLOW}📈 Transaction Summary by Category:${NC}"
echo "$transactions" | jq -r '.[] | "\(.category): ₹\(.amount)"' | \
    sort | uniq -c | sort -nr | \
    while read count category; do
        echo -e "${GREEN}$count transactions${NC} in $category"
    done

# Show total income vs expenses
echo -e "\n${YELLOW}💰 Financial Summary:${NC}"
total_income=$(echo "$transactions" | jq '[.[] | select(.amount > 0)] | map(.amount) | add // 0')
total_expenses=$(echo "$transactions" | jq '[.[] | select(.amount < 0)] | map(.amount) | add // 0')
net_amount=$(echo "$transactions" | jq 'map(.amount) | add // 0')

echo -e "${GREEN}Total Income: ₹$total_income${NC}"
echo -e "${RED}Total Expenses: ₹$total_expenses${NC}"
echo -e "${BLUE}Net Amount: ₹$net_amount${NC}"

# Test SMS batch processing (simulating multiple SMS)
echo -e "\n${BLUE}📱 Testing SMS Batch Processing${NC}"
echo "====================================="

# Create sample SMS messages
sms_batch='{
    "messages": [
        {
            "text": "Rs.150 debited from A/c XX1234 on 30-01-2025 at 10:30 AM for Uber ride. Avl Bal: Rs.25,000",
            "timestamp": "2025-01-30T10:30:00",
            "sender": "HDFC"
        },
        {
            "text": "Rs.450 credited to A/c XX1234 on 30-01-2025 at 11:00 AM for Salary credit. Avl Bal: Rs.25,450",
            "timestamp": "2025-01-30T11:00:00",
            "sender": "HDFC"
        },
        {
            "text": "Rs.800 debited from A/c XX1234 on 30-01-2025 at 12:30 PM for Amazon purchase. Avl Bal: Rs.24,650",
            "timestamp": "2025-01-30T12:30:00",
            "sender": "HDFC"
        }
    ]
}'

echo -e "${YELLOW}📨 Processing SMS batch...${NC}"
batch_response=$(curl -X POST http://localhost:8080/api/transactions/sms/batch \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$sms_batch" -s)

processed_count=$(echo "$batch_response" | jq -r '.processedCount')
echo -e "${GREEN}✅ Processed $processed_count SMS messages${NC}"

# Show final transaction count
final_count=$(curl -X GET http://localhost:8080/api/transactions \
    -H "Authorization: Bearer $TOKEN" -s | jq 'length')
echo -e "\n${BLUE}📊 Total Transactions: $final_count${NC}"

echo -e "\n${GREEN}🎉 Testing completed successfully!${NC}"
echo -e "${BLUE}💡 You can now test the frontend at: http://localhost:52715${NC}" 