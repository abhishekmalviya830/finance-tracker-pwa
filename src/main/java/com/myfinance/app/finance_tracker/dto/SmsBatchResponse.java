package com.myfinance.app.finance_tracker.dto;

import java.util.List;

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
public class SmsBatchResponse {
    private int totalProcessed;
    private int successfulTransactions;
    private int failedTransactions;
    private List<TransactionResult> results;
    
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class TransactionResult {
        private int index;
        private boolean success;
        private String message;
        private TransactionResponse transaction;
        private String error;
    }
} 