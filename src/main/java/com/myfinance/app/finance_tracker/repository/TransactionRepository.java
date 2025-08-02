package com.myfinance.app.finance_tracker.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.myfinance.app.finance_tracker.model.Transaction;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {
    List<Transaction> findByUserIdOrderByTransactionTimeDesc(Long userId);
    List<Transaction> findByUserIdAndTransactionTimeBetween(Long userId, LocalDateTime start, LocalDateTime end);
    List<Transaction> findByUserIdAndTransactionTimeBetweenOrderByTransactionTimeDesc(Long userId, LocalDateTime start, LocalDateTime end);
}