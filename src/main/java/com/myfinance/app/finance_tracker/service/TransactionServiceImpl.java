package com.myfinance.app.finance_tracker.service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.myfinance.app.finance_tracker.dto.SmsBatchRequest;
import com.myfinance.app.finance_tracker.dto.SmsBatchRequest.SmsMessage;
import com.myfinance.app.finance_tracker.dto.SmsBatchResponse;
import com.myfinance.app.finance_tracker.dto.SmsBatchResponse.TransactionResult;
import com.myfinance.app.finance_tracker.dto.TransactionRequest;
import com.myfinance.app.finance_tracker.dto.TransactionResponse;
import com.myfinance.app.finance_tracker.model.Transaction;
import com.myfinance.app.finance_tracker.model.TransactionOrigin;
import com.myfinance.app.finance_tracker.model.User;
import com.myfinance.app.finance_tracker.repository.TransactionRepository;
import com.myfinance.app.finance_tracker.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class TransactionServiceImpl implements TransactionService {

    private final TransactionRepository transactionRepository;
    private final UserRepository userRepository;
    private final SmsParser smsParser;
    private final CategoryResolverService categoryResolver;

    @Override
    public List<TransactionResponse> getAllTransactions(Long userId) {
        return transactionRepository.findByUserIdOrderByTransactionTimeDesc(userId)
            .stream()
            .map(this::toDto)
            .collect(Collectors.toList());
    }

    @Override
    public TransactionResponse createTransaction(Long userId, TransactionRequest req) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));

        Transaction txn;
        if (req.getOrigin() == TransactionOrigin.SMS) {
            txn = smsParser.parse(req.getRawText(), userId)
                .orElseThrow(() -> new RuntimeException("Unable to parse SMS"));
            txn.setUser(user);
        } else {
            txn = Transaction.builder()
                .user(user)
                .origin(req.getOrigin())
                .rawText(req.getRawText())
                .amount(req.getAmount() != null ? req.getAmount() : BigDecimal.ZERO)
                .currency(req.getCurrency() != null ? req.getCurrency() : "INR")
                .merchant(req.getMerchant())
                .category(req.getCategory()) // Will be overwritten below if not null
                .transactionTime(req.getTransactionTime())
                .build();
        }

        // Category resolution using user-defined and static rules
        String resolvedCategory = categoryResolver.resolveCategory(
            user.getId(),
            txn.getRawText(),
            txn.getMerchant()
        );
        txn.setCategory(resolvedCategory);

        Transaction saved = transactionRepository.save(txn);
        return toDto(saved);
    }

    @Override
    public SmsBatchResponse processSmsBatch(Long userId, SmsBatchRequest request) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));

        List<TransactionResult> results = request.getMessages().stream()
            .map(sms -> processSmsMessage(user, sms))
            .collect(Collectors.toList());

        int successful = (int) results.stream().filter(TransactionResult::isSuccess).count();
        int failed = results.size() - successful;

        return SmsBatchResponse.builder()
            .totalProcessed(request.getMessages().size())
            .successfulTransactions(successful)
            .failedTransactions(failed)
            .results(results)
            .build();
    }

    private TransactionResult processSmsMessage(User user, SmsMessage smsMessage) {
        try {
            TransactionRequest req = TransactionRequest.builder()
                .origin(TransactionOrigin.SMS)
                .rawText(smsMessage.getText())
                .transactionTime(LocalDateTime.now()) // You might want to parse from smsMessage.getTimestamp()
                .build();

            TransactionResponse transaction = createTransaction(user.getId(), req);
            
            return TransactionResult.builder()
                .success(true)
                .message("Transaction created successfully")
                .transaction(transaction)
                .build();
        } catch (Exception e) {
            return TransactionResult.builder()
                .success(false)
                .error(e.getMessage())
                .build();
        }
    }

    private TransactionResponse toDto(Transaction t) {
        return TransactionResponse.builder()
            .id(t.getId())
            .amount(t.getAmount())
            .currency(t.getCurrency())
            .merchant(t.getMerchant())
            .category(t.getCategory())
            .transactionTime(t.getTransactionTime())
            .origin(t.getOrigin())
            .rawText(t.getRawText())
            .userId(t.getUser().getId())
            .build();
    }
}