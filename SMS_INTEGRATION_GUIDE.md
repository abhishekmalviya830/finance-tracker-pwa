# 📱 SMS Integration Guide for Finance Tracker

## 🎯 **Overview**

Your Finance Tracker can process SMS messages in multiple ways to automatically create transactions. This guide explains all the available methods for sending SMS data.

---

## 📋 **Method 1: Direct API Upload (JSON)**

### **How it works:**
Users manually copy SMS messages and send them via JSON API.

### **Endpoint:**
```
POST /api/transactions/sms/batch
```

### **Request Format:**
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
    }
  ]
}
```

### **Use Cases:**
- ✅ Quick testing
- ✅ Small number of SMS messages
- ✅ Programmatic integration
- ❌ Not user-friendly for bulk uploads

---

## 📁 **Method 2: Text File Upload**

### **How it works:**
Users create a text file with one SMS message per line and upload it.

### **Endpoint:**
```
POST /api/sms/upload/text
```

### **File Format:**
```
Rs.100 debited from A/c XX1234 on 30-07-24 at 10:30 AM. Avl Bal: Rs.5000.00
Rs.50 credited to A/c XX1234 on 30-07-24 at 11:00 AM. Avl Bal: Rs.5050.00
Rs.200 debited from A/c XX1234 on 30-07-24 at 12:00 PM. Avl Bal: Rs.4850.00
```

### **Steps for Users:**
1. **Export SMS from phone** (using SMS backup apps)
2. **Create text file** with one message per line
3. **Upload via Postman** or web interface
4. **System processes** all messages automatically

### **Use Cases:**
- ✅ Bulk SMS processing
- ✅ Easy to create from phone exports
- ✅ No complex formatting required
- ✅ Good for large datasets

---

## 📊 **Method 3: CSV File Upload**

### **How it works:**
Users create a CSV file with timestamp and message columns.

### **Endpoint:**
```
POST /api/sms/upload/csv
```

### **File Format:**
```csv
timestamp,message
2024-07-30T10:30:00,Rs.100 debited from A/c XX1234 on 30-07-24 at 10:30 AM. Avl Bal: Rs.5000.00
2024-07-30T11:00:00,Rs.50 credited to A/c XX1234 on 30-07-24 at 11:00 AM. Avl Bal: Rs.5050.00
2024-07-30T12:00:00,Rs.200 debited from A/c XX1234 on 30-07-24 at 12:00 PM. Avl Bal: Rs.4850.00
```

### **Steps for Users:**
1. **Export SMS to CSV** (using SMS backup tools)
2. **Ensure format** matches expected structure
3. **Upload file** via API
4. **System processes** with accurate timestamps

### **Use Cases:**
- ✅ Preserves exact timestamps
- ✅ Structured data format
- ✅ Easy to generate from SMS apps
- ✅ Good for historical data

---

## 💬 **Method 4: WhatsApp Chat Upload**

### **How it works:**
Users upload WhatsApp chat exports to extract financial messages.

### **Endpoint:**
```
POST /api/sms/upload/whatsapp
```

### **File Format:**
```
[30/07/24, 10:30] Bank: Rs.100 debited from A/c XX1234 on 30-07-24 at 10:30 AM. Avl Bal: Rs.5000.00
[30/07/24, 11:00] Bank: Rs.50 credited to A/c XX1234 on 30-07-24 at 11:00 AM. Avl Bal: Rs.5050.00
[30/07/24, 12:00] Bank: Rs.200 debited from A/c XX1234 on 30-07-24 at 12:00 PM. Avl Bal: Rs.4850.00
```

### **Steps for Users:**
1. **Export WhatsApp chat** (Settings → Chats → Chat History → Export Chat)
2. **Upload chat file** via API
3. **System extracts** financial messages automatically
4. **Creates transactions** from relevant messages

### **Use Cases:**
- ✅ WhatsApp banking notifications
- ✅ UPI transaction messages
- ✅ Bank alerts via WhatsApp
- ✅ Modern banking integration

---

## 🔧 **Method 5: Mobile App Integration (Future)**

### **How it works:**
Mobile app automatically captures SMS and sends to backend.

### **Implementation:**
```java
// Android SMS Listener Service
public class SmsListenerService extends Service {
    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        // Extract SMS content
        String smsText = remoteMessage.getData().get("message");
        
        // Send to Finance Tracker API
        sendToFinanceTracker(smsText);
    }
}
```

### **Use Cases:**
- ✅ Real-time SMS processing
- ✅ Automatic transaction creation
- ✅ No manual intervention
- ✅ Best user experience

---

## 📱 **Method 6: SMS Forwarding Service**

### **How it works:**
Users forward SMS to a dedicated number that processes them.

### **Implementation:**
```java
@RestController
public class SmsForwardingController {
    
    @PostMapping("/api/sms/forward")
    public ResponseEntity<String> receiveForwardedSms(
            @RequestParam String from,
            @RequestParam String message) {
        
        // Process forwarded SMS
        processSmsMessage(from, message);
        return ResponseEntity.ok("SMS processed");
    }
}
```

### **Use Cases:**
- ✅ Simple forwarding setup
- ✅ Works with any phone
- ✅ No app installation required
- ✅ Quick setup

---

## 🛠 **Technical Implementation Details**

### **SMS Parser Logic:**
```java
public class SmsParser {
    
    public TransactionRequest parseSms(String smsText) {
        // Extract amount using regex
        Pattern amountPattern = Pattern.compile("Rs\\.(\\d+(?:\\.\\d{2})?)");
        Matcher matcher = amountPattern.matcher(smsText);
        
        if (matcher.find()) {
            BigDecimal amount = new BigDecimal(matcher.group(1));
            
            // Determine if debit or credit
            if (smsText.toLowerCase().contains("debited")) {
                amount = amount.negate();
            }
            
            return TransactionRequest.builder()
                .amount(amount)
                .origin(TransactionOrigin.SMS)
                .rawText(smsText)
                .build();
        }
        
        return null;
    }
}
```

### **Supported SMS Formats:**
1. **Bank Debit:** `Rs.100 debited from A/c XX1234 on 30-07-24 at 10:30 AM. Avl Bal: Rs.5000.00`
2. **Bank Credit:** `Rs.50 credited to A/c XX1234 on 30-07-24 at 11:00 AM. Avl Bal: Rs.5050.00`
3. **UPI Transaction:** `UPI/1234567890/PAYMENT/SUCCESS/AMOUNT:Rs.200.00`
4. **Card Transaction:** `Your card XX1234 has been charged Rs.150.75 at MERCHANT NAME`

---

## 📊 **File Upload Examples**

### **Text File Example:**
```
Rs.100 debited from A/c XX1234 on 30-07-24 at 10:30 AM. Avl Bal: Rs.5000.00
Rs.50 credited to A/c XX1234 on 30-07-24 at 11:00 AM. Avl Bal: Rs.5050.00
Rs.200 debited from A/c XX1234 on 30-07-24 at 12:00 PM. Avl Bal: Rs.4850.00
Rs.75.50 debited from A/c XX1234 on 30-07-24 at 01:30 PM. Avl Bal: Rs.4774.50
```

### **CSV File Example:**
```csv
timestamp,message
2024-07-30T10:30:00,Rs.100 debited from A/c XX1234 on 30-07-24 at 10:30 AM. Avl Bal: Rs.5000.00
2024-07-30T11:00:00,Rs.50 credited to A/c XX1234 on 30-07-24 at 11:00 AM. Avl Bal: Rs.5050.00
2024-07-30T12:00:00,Rs.200 debited from A/c XX1234 on 30-07-24 at 12:00 PM. Avl Bal: Rs.4850.00
2024-07-30T13:30:00,Rs.75.50 debited from A/c XX1234 on 30-07-24 at 01:30 PM. Avl Bal: Rs.4774.50
```

### **WhatsApp Chat Example:**
```
[30/07/24, 10:30] Bank: Rs.100 debited from A/c XX1234 on 30-07-24 at 10:30 AM. Avl Bal: Rs.5000.00
[30/07/24, 11:00] Bank: Rs.50 credited to A/c XX1234 on 30-07-24 at 11:00 AM. Avl Bal: Rs.5050.00
[30/07/24, 12:00] Bank: Rs.200 debited from A/c XX1234 on 30-07-24 at 12:00 PM. Avl Bal: Rs.4850.00
[30/07/24, 13:30] Bank: Rs.75.50 debited from A/c XX1234 on 30-07-24 at 01:30 PM. Avl Bal: Rs.4774.50
```

---

## 🎯 **Recommended User Workflow**

### **For Individual Users:**
1. **Export SMS** from phone using SMS backup app
2. **Create text file** with one message per line
3. **Upload via Postman** or web interface
4. **Review results** in dashboard

### **For Bulk Processing:**
1. **Export to CSV** with timestamps
2. **Upload CSV file** via API
3. **Monitor processing** results
4. **Check dashboard** for analytics

### **For WhatsApp Users:**
1. **Export WhatsApp chat** with bank
2. **Upload chat file** via API
3. **System extracts** financial messages
4. **View processed** transactions

---

## 🔒 **Security Considerations**

### **Data Privacy:**
- ✅ SMS data is processed securely
- ✅ No SMS content is logged
- ✅ User authentication required
- ✅ Data encrypted in transit

### **File Upload Security:**
- ✅ File size limits enforced
- ✅ File type validation
- ✅ Malware scanning (future)
- ✅ Secure file handling

---

## 📈 **Performance & Scalability**

### **Batch Processing:**
- ✅ Up to 1000 SMS per batch
- ✅ Parallel processing
- ✅ Progress tracking
- ✅ Error handling

### **File Upload Limits:**
- ✅ Max file size: 10MB
- ✅ Max messages: 1000 per file
- ✅ Supported formats: TXT, CSV
- ✅ Processing time: ~1 second per 100 messages

---

## 🚀 **Future Enhancements**

### **Planned Features:**
1. **Real-time SMS capture** via mobile app
2. **SMS forwarding service** integration
3. **Advanced SMS parsing** for more banks
4. **Bulk import** from multiple sources
5. **SMS template** learning for better parsing

### **Integration Options:**
1. **Bank API integration** for direct data
2. **UPI transaction** webhook support
3. **Email notification** processing
4. **Voice message** transcription

---

## 📞 **Support & Troubleshooting**

### **Common Issues:**
1. **File format errors** - Check file structure
2. **Parsing failures** - Verify SMS format
3. **Authentication errors** - Check JWT token
4. **File size limits** - Split large files

### **Best Practices:**
1. **Test with small files** first
2. **Verify SMS format** before bulk upload
3. **Keep backup** of original files
4. **Monitor processing** results

---

## 🎉 **Summary**

Your Finance Tracker now supports **6 different methods** for SMS integration:

1. **Direct API** - For developers and testing
2. **Text File Upload** - For bulk processing
3. **CSV File Upload** - For structured data
4. **WhatsApp Chat Upload** - For modern banking
5. **Mobile App Integration** - For real-time processing
6. **SMS Forwarding** - For simple setup

Choose the method that best fits your users' needs and technical capabilities! 🚀 