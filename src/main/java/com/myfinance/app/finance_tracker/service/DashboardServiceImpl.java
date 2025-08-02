package com.myfinance.app.finance_tracker.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.myfinance.app.finance_tracker.dto.DashboardStatsResponse;
import com.myfinance.app.finance_tracker.dto.DashboardStatsResponse.RecentTransactionDto;
import com.myfinance.app.finance_tracker.model.Transaction;
import com.myfinance.app.finance_tracker.repository.TransactionRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DashboardServiceImpl implements DashboardService {

    private final TransactionRepository transactionRepository;

    @Override
    public DashboardStatsResponse getMonthlyStats(Long userId, int year, int month) {
        YearMonth yearMonth = YearMonth.of(year, month);
        LocalDateTime startOfMonth = yearMonth.atDay(1).atStartOfDay();
        LocalDateTime endOfMonth = yearMonth.atEndOfMonth().atTime(23, 59, 59);

        List<Transaction> transactions = transactionRepository
            .findByUserIdAndTransactionTimeBetweenOrderByTransactionTimeDesc(userId, startOfMonth, endOfMonth);

        return buildDashboardStats(transactions);
    }

    @Override
    public DashboardStatsResponse getYearlyStats(Long userId, int year) {
        LocalDateTime startOfYear = LocalDateTime.of(year, 1, 1, 0, 0, 0);
        LocalDateTime endOfYear = LocalDateTime.of(year, 12, 31, 23, 59, 59);

        List<Transaction> transactions = transactionRepository
            .findByUserIdAndTransactionTimeBetweenOrderByTransactionTimeDesc(userId, startOfYear, endOfYear);

        return buildDashboardStats(transactions);
    }

    private DashboardStatsResponse buildDashboardStats(List<Transaction> transactions) {
        if (transactions.isEmpty()) {
            return DashboardStatsResponse.builder()
                .totalSpending(BigDecimal.ZERO)
                .totalIncome(BigDecimal.ZERO)
                .netAmount(BigDecimal.ZERO)
                .totalTransactions(0L)
                .spendingByCategory(Map.of())
                .monthlyTrend(Map.of())
                .recentTransactions(List.of())
                .averageTransactionAmount(BigDecimal.ZERO)
                .topSpendingCategory("No spending")
                .topSpendingAmount(BigDecimal.ZERO)
                .build();
        }

        // Calculate totals
        BigDecimal totalSpending = transactions.stream()
            .filter(t -> t.getAmount().compareTo(BigDecimal.ZERO) < 0)
            .map(Transaction::getAmount)
            .reduce(BigDecimal.ZERO, BigDecimal::add)
            .abs();

        BigDecimal totalIncome = transactions.stream()
            .filter(t -> t.getAmount().compareTo(BigDecimal.ZERO) > 0)
            .map(Transaction::getAmount)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal netAmount = totalIncome.subtract(totalSpending);

        // Spending by category
        Map<String, BigDecimal> spendingByCategory = transactions.stream()
            .filter(t -> t.getAmount().compareTo(BigDecimal.ZERO) < 0)
            .collect(Collectors.groupingBy(
                Transaction::getCategory,
                Collectors.reducing(BigDecimal.ZERO, Transaction::getAmount, (a, b) -> a.add(b.abs()))
            ));

        // Monthly trend (last 6 months)
        Map<String, BigDecimal> monthlyTrend = calculateMonthlyTrend(transactions);

        // Recent transactions (last 5)
        List<RecentTransactionDto> recentTransactions = transactions.stream()
            .limit(5)
            .map(this::toRecentTransactionDto)
            .collect(Collectors.toList());

        // Average transaction amount
        BigDecimal averageTransactionAmount = transactions.stream()
            .map(Transaction::getAmount)
            .reduce(BigDecimal.ZERO, BigDecimal::add)
            .divide(BigDecimal.valueOf(transactions.size()), 2, RoundingMode.HALF_UP);

        // Top spending category
        String topSpendingCategory = spendingByCategory.entrySet().stream()
            .max(Map.Entry.comparingByValue())
            .map(Map.Entry::getKey)
            .orElse("No spending");

        BigDecimal topSpendingAmount = spendingByCategory.getOrDefault(topSpendingCategory, BigDecimal.ZERO);

        return DashboardStatsResponse.builder()
            .totalSpending(totalSpending)
            .totalIncome(totalIncome)
            .netAmount(netAmount)
            .totalTransactions((long) transactions.size())
            .spendingByCategory(spendingByCategory)
            .monthlyTrend(monthlyTrend)
            .recentTransactions(recentTransactions)
            .averageTransactionAmount(averageTransactionAmount)
            .topSpendingCategory(topSpendingCategory)
            .topSpendingAmount(topSpendingAmount)
            .build();
    }

    private Map<String, BigDecimal> calculateMonthlyTrend(List<Transaction> transactions) {
        return transactions.stream()
            .collect(Collectors.groupingBy(
                t -> t.getTransactionTime().getYear() + "-" + 
                     String.format("%02d", t.getTransactionTime().getMonthValue()),
                Collectors.reducing(BigDecimal.ZERO, Transaction::getAmount, BigDecimal::add)
            ));
    }

    private RecentTransactionDto toRecentTransactionDto(Transaction transaction) {
        return RecentTransactionDto.builder()
            .id(transaction.getId())
            .amount(transaction.getAmount())
            .currency(transaction.getCurrency())
            .merchant(transaction.getMerchant())
            .category(transaction.getCategory())
            .transactionTime(transaction.getTransactionTime().toString())
            .build();
    }
} 