package com.myfinance.app.finance_tracker.service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import static org.mockito.Mockito.when;
import org.mockito.junit.jupiter.MockitoExtension;

import com.myfinance.app.finance_tracker.dto.DashboardStatsResponse;
import com.myfinance.app.finance_tracker.model.Transaction;
import com.myfinance.app.finance_tracker.model.TransactionOrigin;
import com.myfinance.app.finance_tracker.model.User;
import com.myfinance.app.finance_tracker.repository.TransactionRepository;

@ExtendWith(MockitoExtension.class)
class DashboardServiceTest {

    @Mock
    private TransactionRepository transactionRepository;

    @InjectMocks
    private DashboardServiceImpl dashboardService;

    private User testUser;
    private List<Transaction> testTransactions;

    @BeforeEach
    void setUp() {
        testUser = new User();
        testUser.setId(1L);
        testUser.setEmail("test@example.com");

        testTransactions = Arrays.asList(
            createTransaction(1L, new BigDecimal("-100.50"), "Food", "Restaurant"),
            createTransaction(2L, new BigDecimal("-50.25"), "Transport", "Uber"),
            createTransaction(3L, new BigDecimal("1000.00"), "Salary", "Company")
        );
    }

    @Test
    void getMonthlyStats_WithTransactions_ReturnsCorrectStats() {
        // Given
        int year = 2024;
        int month = 7;
        when(transactionRepository.findByUserIdAndTransactionTimeBetweenOrderByTransactionTimeDesc(
            eq(1L), any(LocalDateTime.class), any(LocalDateTime.class)))
            .thenReturn(testTransactions);

        // When
        DashboardStatsResponse result = dashboardService.getMonthlyStats(1L, year, month);

        // Then
        assertNotNull(result);
        assertEquals(new BigDecimal("150.75"), result.getTotalSpending());
        assertEquals(new BigDecimal("1000.00"), result.getTotalIncome());
        assertEquals(new BigDecimal("849.25"), result.getNetAmount());
        assertEquals(3L, result.getTotalTransactions());
        assertEquals(2, result.getSpendingByCategory().size());
        assertEquals(new BigDecimal("100.50"), result.getSpendingByCategory().get("Food"));
        assertEquals(new BigDecimal("50.25"), result.getSpendingByCategory().get("Transport"));
    }

    @Test
    void getMonthlyStats_WithNoTransactions_ReturnsEmptyStats() {
        // Given
        when(transactionRepository.findByUserIdAndTransactionTimeBetweenOrderByTransactionTimeDesc(
            eq(1L), any(LocalDateTime.class), any(LocalDateTime.class)))
            .thenReturn(Arrays.asList());

        // When
        DashboardStatsResponse result = dashboardService.getMonthlyStats(1L, 2024, 7);

        // Then
        assertNotNull(result);
        assertEquals(BigDecimal.ZERO, result.getTotalSpending());
        assertEquals(BigDecimal.ZERO, result.getTotalIncome());
        assertEquals(BigDecimal.ZERO, result.getNetAmount());
        assertEquals(0L, result.getTotalTransactions());
        assertTrue(result.getSpendingByCategory().isEmpty());
    }

    private Transaction createTransaction(Long id, BigDecimal amount, String category, String merchant) {
        Transaction transaction = new Transaction();
        transaction.setId(id);
        transaction.setAmount(amount);
        transaction.setCategory(category);
        transaction.setMerchant(merchant);
        transaction.setCurrency("INR");
        transaction.setOrigin(TransactionOrigin.MANUAL);
        transaction.setTransactionTime(LocalDateTime.now());
        transaction.setUser(testUser);
        return transaction;
    }
} 