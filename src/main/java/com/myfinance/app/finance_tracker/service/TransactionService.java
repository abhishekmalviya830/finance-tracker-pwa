package com.myfinance.app.finance_tracker.service;

import java.util.List;

import com.myfinance.app.finance_tracker.dto.SmsBatchRequest;
import com.myfinance.app.finance_tracker.dto.SmsBatchResponse;
import com.myfinance.app.finance_tracker.dto.TransactionRequest;
import com.myfinance.app.finance_tracker.dto.TransactionResponse;

public interface TransactionService {
    List<TransactionResponse> getAllTransactions(Long userId);
    TransactionResponse createTransaction(Long userId, TransactionRequest request);
    SmsBatchResponse processSmsBatch(Long userId, SmsBatchRequest request);
}