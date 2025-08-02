package com.myfinance.app.finance_tracker.controller;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.myfinance.app.finance_tracker.dto.SmsBatchRequest;
import com.myfinance.app.finance_tracker.dto.SmsBatchResponse;
import com.myfinance.app.finance_tracker.dto.TransactionRequest;
import com.myfinance.app.finance_tracker.dto.TransactionResponse;
import com.myfinance.app.finance_tracker.model.TransactionOrigin;
import com.myfinance.app.finance_tracker.service.TransactionService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/transactions")
@RequiredArgsConstructor
public class TransactionController {

    private final TransactionService transactionService;

    @GetMapping
    public ResponseEntity<List<TransactionResponse>> getTransactions(Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        return ResponseEntity.ok(transactionService.getAllTransactions(userId));
    }

    @PostMapping
    public ResponseEntity<TransactionResponse> createTransaction(
            Authentication auth,
            @Valid @RequestBody TransactionRequest req) {
        Long userId = (Long) auth.getPrincipal();
        TransactionResponse resp = transactionService.createTransaction(userId, req);
        return ResponseEntity.status(201).body(resp);
    }

    @PostMapping("/sms/batch")
    public ResponseEntity<SmsBatchResponse> processSmsBatch(
            Authentication auth,
            @Valid @RequestBody SmsBatchRequest request) {
        Long userId = (Long) auth.getPrincipal();
        SmsBatchResponse response = transactionService.processSmsBatch(userId, request);
        return ResponseEntity.status(201).body(response);
    }

    @PostMapping("/sample-data")
    public ResponseEntity<String> createSampleData(Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        
        // Create sample transactions to test categorization
        createSampleTransaction(userId, "Amazon", "Shopping", -1500.0, "Online shopping for electronics");
        createSampleTransaction(userId, "Uber", "Transportation", -250.0, "Ride to office");
        createSampleTransaction(userId, "Zomato", "Food & Dining", -450.0, "Lunch delivery");
        createSampleTransaction(userId, "Swiggy", "Food & Dining", -320.0, "Dinner delivery");
        createSampleTransaction(userId, "Ola", "Transportation", -180.0, "Ride home");
        createSampleTransaction(userId, "Flipkart", "Shopping", -800.0, "Clothing purchase");
        createSampleTransaction(userId, "Netflix", "Entertainment", -499.0, "Monthly subscription");
        createSampleTransaction(userId, "Hospital", "Healthcare", -1200.0, "Medical checkup");
        createSampleTransaction(userId, "School", "Education", -5000.0, "Tuition fees");
        createSampleTransaction(userId, "Salary", "Income", 50000.0, "Monthly salary");
        
        return ResponseEntity.ok("Sample data created successfully!");
    }

    private void createSampleTransaction(Long userId, String merchant, String category, double amount, String description) {
        TransactionRequest request = TransactionRequest.builder()
                .origin(TransactionOrigin.MANUAL)
                .amount(BigDecimal.valueOf(amount))
                .currency("INR")
                .merchant(merchant)
                .category(category)
                .rawText(description)
                .transactionTime(LocalDateTime.now())
                .build();
        
        try {
            transactionService.createTransaction(userId, request);
        } catch (Exception e) {
            // Ignore errors for sample data creation
        }
    }
}