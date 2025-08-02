# Finance Tracker API

A production-ready Spring Boot application for personal finance tracking with SMS parsing, categorization rules, and comprehensive analytics.

## Features

- ✅ **Authentication**: JWT-based user registration and login
- ✅ **Transaction Management**: Create and retrieve financial transactions
- ✅ **Rule Engine**: Smart categorization based on user-defined patterns
- ✅ **Dashboard Analytics**: Monthly/yearly spending insights and trends
- ✅ **SMS Batch Processing**: Bulk upload and parsing of SMS transactions
- ✅ **Production Ready**: Docker containerization, health checks, monitoring

## Tech Stack

- **Backend**: Spring Boot 3.5.4, Java 17
- **Database**: MySQL 8.0
- **Security**: Spring Security with JWT
- **Testing**: JUnit 5, Mockito, Spring Boot Test
- **Containerization**: Docker, Docker Compose
- **Monitoring**: Spring Boot Actuator

## Quick Start

### Prerequisites

- Java 17+
- Maven 3.6+
- Docker & Docker Compose (for containerized deployment)
- MySQL 8.0 (for local development)

### Local Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd finance-tracker
   ```

2. **Set up MySQL database**
   ```sql
   CREATE DATABASE finance_tracker;
   CREATE USER 'finance_user'@'localhost' IDENTIFIED BY 'finance_pass';
   GRANT ALL PRIVILEGES ON finance_tracker.* TO 'finance_user'@'localhost';
   FLUSH PRIVILEGES;
   ```

3. **Update application.properties**
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/finance_tracker
   spring.datasource.username=finance_user
   spring.datasource.password=finance_pass
   ```

4. **Run the application**
   ```bash
   mvn spring-boot:run
   ```

### Docker Deployment

1. **Build and run with Docker Compose**
   ```bash
   docker-compose up --build
   ```

2. **Or build Docker image manually**
   ```bash
   docker build -t finance-tracker .
   docker run -p 8080:8080 finance-tracker
   ```

## API Documentation

### Authentication

#### Register User
```http
POST /api/auth/signup
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

### Transactions

#### Create Transaction
```http
POST /api/transactions
Authorization: Bearer <jwt-token>
Content-Type: application/json

{
  "origin": "MANUAL",
  "amount": 100.50,
  "currency": "INR",
  "merchant": "Coffee Shop",
  "category": "Food",
  "transactionTime": "2024-07-30T10:30:00"
}
```

#### Get All Transactions
```http
GET /api/transactions
Authorization: Bearer <jwt-token>
```

#### Batch SMS Processing
```http
POST /api/transactions/sms/batch
Authorization: Bearer <jwt-token>
Content-Type: application/json

{
  "messages": [
    {
      "text": "Rs.100 debited from A/c XX1234 on 30-07-24 at 10:30 AM. Avl Bal: Rs.5000.00",
      "timestamp": "2024-07-30T10:30:00"
    }
  ]
}
```

### Dashboard Analytics

#### Monthly Statistics
```http
GET /api/dashboard/stats/monthly?year=2024&month=7
Authorization: Bearer <jwt-token>
```

#### Yearly Statistics
```http
GET /api/dashboard/stats/yearly?year=2024
Authorization: Bearer <jwt-token>
```

### Category Rules

#### Create Category Rule
```http
POST /api/category-rules
Authorization: Bearer <jwt-token>
Content-Type: application/json

{
  "pattern": "coffee|starbucks",
  "category": "Food & Beverages"
}
```

#### Get Category Rules
```http
GET /api/category-rules
Authorization: Bearer <jwt-token>
```

## Health Checks

The application includes Spring Boot Actuator for monitoring:

- **Health Check**: `GET /actuator/health`
- **Application Info**: `GET /actuator/info`

## Testing

### Run Unit Tests
```bash
mvn test
```

### Run Integration Tests
```bash
mvn test -Dspring.profiles.active=test
```

### Test Coverage
```bash
mvn jacoco:report
```

## Production Deployment

### Environment Variables

Set these environment variables for production:

```bash
SPRING_DATASOURCE_URL=jdbc:mysql://your-db-host:3306/finance_tracker
SPRING_DATASOURCE_USERNAME=your_db_user
SPRING_DATASOURCE_PASSWORD=your_db_password
APP_JWT_SECRET=your-super-secret-jwt-key
APP_JWT_EXPIRATION_MS=86400000
```

### AWS Deployment

1. **Build Docker image**
   ```bash
   docker build -t finance-tracker .
   ```

2. **Push to ECR**
   ```bash
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin your-account.dkr.ecr.us-east-1.amazonaws.com
   docker tag finance-tracker:latest your-account.dkr.ecr.us-east-1.amazonaws.com/finance-tracker:latest
   docker push your-account.dkr.ecr.us-east-1.amazonaws.com/finance-tracker:latest
   ```

3. **Deploy to ECS/Fargate or use AWS App Runner**

### Render Deployment

1. **Connect your GitHub repository to Render**
2. **Create a new Web Service**
3. **Set build command**: `mvn clean package -DskipTests`
4. **Set start command**: `java -jar target/finance-tracker-0.0.1-SNAPSHOT.jar`
5. **Add environment variables**

## Security Considerations

- ✅ JWT tokens with configurable expiration
- ✅ Password hashing with BCrypt
- ✅ Input validation and sanitization
- ✅ SQL injection prevention with JPA
- ✅ CORS configuration
- ✅ Error message sanitization

## Performance Optimizations

- ✅ Database connection pooling with HikariCP
- ✅ JPA query optimization
- ✅ Lazy loading for associations
- ✅ Transaction management
- ✅ Caching strategies

## Monitoring & Logging

- ✅ Spring Boot Actuator health checks
- ✅ Structured logging
- ✅ Error tracking
- ✅ Performance metrics

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

This project is licensed under the MIT License. 