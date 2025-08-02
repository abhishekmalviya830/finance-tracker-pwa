package com.myfinance.app.finance_tracker.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.myfinance.app.finance_tracker.model.TransactionOrigin;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class TransactionResponse {
    private Long id;
    private BigDecimal amount;
    private String currency;
    private String merchant;
    private String category;
    private LocalDateTime transactionTime;
    private TransactionOrigin origin;
    private String rawText;
    private Long userId;
}