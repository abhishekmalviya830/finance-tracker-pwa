package com.myfinance.app.finance_tracker.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.myfinance.app.finance_tracker.model.CategoryRule;

@Repository
public interface CategoryRuleRepository extends JpaRepository<CategoryRule, Long> {
    List<CategoryRule> findByUserId(Long userId);
    boolean existsByUserIdAndPatternIgnoreCase(Long userId, String pattern);
}