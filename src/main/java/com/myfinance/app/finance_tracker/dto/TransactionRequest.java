package com.myfinance.app.finance_tracker.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.myfinance.app.finance_tracker.model.TransactionOrigin;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class TransactionRequest {
    @NotNull
    private TransactionOrigin origin;

    @Size(max = 512)
    private String rawText;

    @NotNull
    private LocalDateTime transactionTime;

    // Only for MANUAL entries:
    private BigDecimal amount;
    private String currency;
    private String merchant;
    private String category;
}