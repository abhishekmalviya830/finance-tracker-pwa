package com.myfinance.app.finance_tracker.dto;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DashboardStatsResponse {
    private BigDecimal totalSpending;
    private BigDecimal totalIncome;
    private BigDecimal netAmount;
    private Long totalTransactions;
    private Map<String, BigDecimal> spendingByCategory;
    private Map<String, BigDecimal> monthlyTrend;
    private List<RecentTransactionDto> recentTransactions;
    private BigDecimal averageTransactionAmount;
    private String topSpendingCategory;
    private BigDecimal topSpendingAmount;
    
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class RecentTransactionDto {
        private Long id;
        private BigDecimal amount;
        private String currency;
        private String merchant;
        private String category;
        private String transactionTime;
    }
} 