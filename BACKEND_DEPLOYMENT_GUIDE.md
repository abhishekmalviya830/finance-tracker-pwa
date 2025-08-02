# 🚀 Backend Deployment Guide - Finance Tracker API

## 📍 **Current Status**

### **✅ What's Working:**
- **Frontend PWA**: Deployed to GitHub Pages
- **Backend API**: Running locally on `localhost:8080`
- **Database**: Local H2 database

### **❌ What Needs Deployment:**
- **Backend API**: Needs cloud deployment
- **Database**: Needs cloud database
- **SMS Processing**: Needs cloud deployment

---

## 🌐 **Backend Deployment Options**

### **Option 1: Heroku (Recommended - Free)**

#### **✅ Benefits:**
- **Free tier available**
- **Easy deployment**
- **PostgreSQL database included**
- **Auto-scaling**
- **Git integration**

#### **📋 Steps:**

##### **Step 1: Create Heroku Account**
1. Go to [Heroku.com](https://heroku.com)
2. Sign up for free account
3. Verify email

##### **Step 2: Install Heroku CLI**
```bash
# Install Heroku CLI
brew tap heroku/brew && brew install heroku

# Login to Heroku
heroku login
```

##### **Step 3: Deploy Backend**
```bash
# Navigate to backend directory
cd /Users/abhishek.malviya/Documents/FinanceTrackerApplication/backend/finance-tracker

# Create Heroku app
heroku create finance-tracker-api-abhishek

# Add PostgreSQL database
heroku addons:create heroku-postgresql:mini

# Deploy to Heroku
git add .
git commit -m "Initial backend deployment"
git push heroku main

# Open the app
heroku open
```

##### **Step 4: Update Frontend Configuration**
Update the API base URL in your Flutter app to point to your Heroku URL.

---

### **Option 2: Railway (Free)**

#### **✅ Benefits:**
- **Free tier available**
- **Simple deployment**
- **PostgreSQL included**
- **GitHub integration**

#### **📋 Steps:**

##### **Step 1: Create Railway Account**
1. Go to [Railway.app](https://railway.app)
2. Sign up with GitHub
3. Create new project

##### **Step 2: Deploy Backend**
1. **Connect GitHub repository**
2. **Select your backend repository**
3. **Add PostgreSQL service**
4. **Deploy automatically**

---

### **Option 3: Render (Free)**

#### **✅ Benefits:**
- **Free tier available**
- **PostgreSQL included**
- **Auto-deployment**
- **Custom domains**

#### **📋 Steps:**

##### **Step 1: Create Render Account**
1. Go to [Render.com](https://render.com)
2. Sign up for free account
3. Connect GitHub

##### **Step 2: Deploy Backend**
1. **Create new Web Service**
2. **Connect your GitHub repository**
3. **Add PostgreSQL database**
4. **Deploy automatically**

---

## 🔧 **Backend Configuration Changes**

### **Database Configuration**

#### **Current (Local H2):**
```properties
# application.properties
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
```

#### **Cloud (PostgreSQL):**
```properties
# application.properties
spring.datasource.url=${DATABASE_URL}
spring.datasource.driverClassName=org.postgresql.Driver
spring.jpa.hibernate.ddl-auto=update
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
```

### **CORS Configuration**

Update CORS to allow your PWA domain:
```java
@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
            .allowedOrigins("https://abhishekmalviya830.github.io")
            .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
            .allowedHeaders("*")
            .allowCredentials(true);
    }
}
```

---

## 📱 **Frontend Configuration Update**

### **Update API Base URL**

#### **Current (Local):**
```dart
// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = 'http://localhost:8080';
}
```

#### **After Backend Deployment:**
```dart
// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = 'https://your-backend-url.herokuapp.com';
}
```

---

## 🚀 **Complete Deployment Workflow**

### **Step 1: Deploy Backend**
```bash
# Navigate to backend
cd /Users/abhishek.malviya/Documents/FinanceTrackerApplication/backend/finance-tracker

# Deploy to Heroku
heroku create finance-tracker-api-abhishek
heroku addons:create heroku-postgresql:mini
git add .
git commit -m "Deploy backend"
git push heroku main
```

### **Step 2: Update Frontend**
1. **Update API base URL** in Flutter app
2. **Rebuild PWA**
3. **Redeploy to GitHub Pages**

### **Step 3: Test Complete App**
1. **Test API endpoints**
2. **Test SMS upload**
3. **Test user registration/login**
4. **Test transaction processing**

---

## 🔍 **Testing Backend Deployment**

### **Test API Endpoints:**
```bash
# Test health check
curl https://your-backend-url.herokuapp.com/health

# Test SMS upload
curl -X POST https://your-backend-url.herokuapp.com/api/sms/upload \
  -H "Content-Type: application/json" \
  -d '{"smsContent": "Rs. 1,250.00 debited from A/c XX1234 for SWIGGY"}'
```

### **Test Database Connection:**
```bash
# Check database status
heroku pg:info
```

---

## 🎯 **Production Checklist**

- [ ] **Backend deployed** to cloud
- [ ] **Database configured** (PostgreSQL)
- [ ] **CORS configured** for PWA domain
- [ ] **Frontend updated** with new API URL
- [ ] **PWA redeployed** with updated config
- [ ] **All endpoints tested**
- [ ] **SMS processing tested**
- [ ] **User authentication tested**

---

## 📞 **Support Commands**

### **Heroku Commands:**
```bash
# View logs
heroku logs --tail

# Check app status
heroku ps

# Open app
heroku open

# Check database
heroku pg:info
```

### **Railway Commands:**
```bash
# View logs
railway logs

# Deploy
railway up
```

---

## 🎉 **Success Criteria**

Your backend is successfully deployed when:
1. ✅ **API responds** to health check
2. ✅ **Database connects** and works
3. ✅ **SMS upload** processes correctly
4. ✅ **User registration** works
5. ✅ **PWA connects** to backend
6. ✅ **All features** work end-to-end

Your Finance Tracker will be fully functional in production! 🚀 