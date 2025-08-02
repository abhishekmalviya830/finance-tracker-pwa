# 🚀 Railway Deployment Guide - Finance Tracker Backend

## ✅ **Why Railway?**
- **No payment verification required**
- **Free tier available**
- **PostgreSQL database included**
- **GitHub integration**
- **Simple deployment**

---

## 📋 **Step-by-Step Railway Deployment**

### **Step 1: Create Railway Account**
1. **Go to [Railway.app](https://railway.app)**
2. **Click "Start a New Project"**
3. **Sign up with GitHub** (recommended)
4. **Verify your email**

### **Step 2: Create GitHub Repository for Backend**
1. **Go to [GitHub.com](https://github.com)**
2. **Click "New repository"**
3. **Name**: `finance-tracker-backend`
4. **Make it Public**
5. **Don't initialize with README**
6. **Click "Create repository"**

### **Step 3: Push Backend Code to GitHub**
```bash
# Navigate to backend directory
cd /Users/abhishek.malviya/Documents/FinanceTrackerApplication/backend/finance-tracker

# Initialize git repository
git init
git add .
git commit -m "Initial backend commit"

# Add remote repository (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/finance-tracker-backend.git
git branch -M main
git push -u origin main
```

### **Step 4: Deploy on Railway**
1. **Go to Railway Dashboard**
2. **Click "New Project"**
3. **Select "Deploy from GitHub repo"**
4. **Choose your `finance-tracker-backend` repository**
5. **Railway will auto-detect Spring Boot**

### **Step 5: Add PostgreSQL Database**
1. **In Railway project, click "New"**
2. **Select "Database" → "PostgreSQL"**
3. **Railway will create database automatically**

### **Step 6: Configure Environment Variables**
1. **Go to your Spring Boot service**
2. **Click "Variables" tab**
3. **Add these variables**:
   ```
   DATABASE_URL=postgresql://username:password@host:port/database
   PORT=8080
   ```

---

## 🔧 **Backend Configuration Changes**

### **Update application.properties**
```properties
# Database Configuration
spring.datasource.url=${DATABASE_URL}
spring.datasource.driverClassName=org.postgresql.Driver
spring.jpa.hibernate.ddl-auto=update
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect

# Server Configuration
server.port=${PORT:8080}

# CORS Configuration
spring.web.cors.allowed-origins=https://abhishekmalviya830.github.io
spring.web.cors.allowed-methods=GET,POST,PUT,DELETE,OPTIONS
spring.web.cors.allowed-headers=*
spring.web.cors.allow-credentials=true
```

### **Add PostgreSQL Dependency**
```xml
<!-- In pom.xml -->
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```

---

## 📱 **Update Frontend Configuration**

### **Update API Base URL**
```dart
// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  // Replace with your Railway URL
  static const String baseUrl = 'https://your-app-name.railway.app';
}
```

---

## 🚀 **Complete Deployment Workflow**

### **Step 1: Prepare Backend**
```bash
# Navigate to backend
cd /Users/abhishek.malviya/Documents/FinanceTrackerApplication/backend/finance-tracker

# Add PostgreSQL dependency if not present
# Update application.properties
# Commit changes
git add .
git commit -m "Configure for Railway deployment"
git push origin main
```

### **Step 2: Deploy on Railway**
1. **Create Railway account**
2. **Connect GitHub repository**
3. **Add PostgreSQL database**
4. **Deploy automatically**

### **Step 3: Update Frontend**
1. **Get Railway URL**
2. **Update API base URL in Flutter app**
3. **Rebuild PWA**
4. **Redeploy to GitHub Pages**

### **Step 4: Test Complete App**
1. **Test API endpoints**
2. **Test SMS upload**
3. **Test user registration/login**
4. **Test transaction processing**

---

## 🔍 **Testing Your Deployment**

### **Test API Health Check**
```bash
# Replace with your Railway URL
curl https://your-app-name.railway.app/health
```

### **Test SMS Upload**
```bash
curl -X POST https://your-app-name.railway.app/api/sms/upload \
  -H "Content-Type: application/json" \
  -d '{"smsContent": "Rs. 1,250.00 debited from A/c XX1234 for SWIGGY"}'
```

### **Test User Registration**
```bash
curl -X POST https://your-app-name.railway.app/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"firstName":"John","lastName":"Doe","email":"test@example.com","password":"password123"}'
```

---

## 🎯 **Railway Dashboard Features**

### **Monitoring:**
- **Real-time logs**
- **Performance metrics**
- **Error tracking**
- **Resource usage**

### **Database:**
- **PostgreSQL console**
- **Data browser**
- **Backup management**
- **Connection details**

### **Deployment:**
- **Auto-deploy from GitHub**
- **Manual deployments**
- **Rollback options**
- **Environment variables**

---

## 📞 **Railway Commands**

### **Install Railway CLI (Optional)**
```bash
npm install -g @railway/cli
railway login
```

### **Railway CLI Commands**
```bash
# Deploy manually
railway up

# View logs
railway logs

# Open app
railway open

# Check status
railway status
```

---

## 🎉 **Success Criteria**

Your backend is successfully deployed when:
1. ✅ **Railway shows "Deployed" status**
2. ✅ **API responds to health check**
3. ✅ **Database connects successfully**
4. ✅ **SMS upload endpoint works**
5. ✅ **User registration works**
6. ✅ **PWA connects to backend**
7. ✅ **All features work end-to-end**

---

## 🔧 **Troubleshooting**

### **Common Issues:**

#### **Build Fails:**
- Check Java version compatibility
- Verify Maven dependencies
- Check application.properties syntax

#### **Database Connection Fails:**
- Verify DATABASE_URL environment variable
- Check PostgreSQL service is running
- Verify database credentials

#### **CORS Errors:**
- Update allowed origins in application.properties
- Check frontend URL matches backend CORS config

#### **Port Issues:**
- Ensure PORT environment variable is set
- Check Railway port configuration

---

## 📊 **Railway Pricing**

### **Free Tier:**
- **$5 credit monthly**
- **512MB RAM**
- **Shared CPU**
- **PostgreSQL database**
- **Custom domains**

### **Paid Plans:**
- **$5/month**: 1GB RAM, dedicated CPU
- **$20/month**: 2GB RAM, better performance
- **Custom**: Enterprise solutions

---

## 🎯 **Next Steps After Deployment**

1. **Test all API endpoints**
2. **Update frontend API URL**
3. **Redeploy PWA**
4. **Test complete user flow**
5. **Monitor performance**
6. **Set up custom domain (optional)**

Your Finance Tracker backend will be fully functional on Railway! 🚀 