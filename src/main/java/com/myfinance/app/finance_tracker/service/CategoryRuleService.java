package com.myfinance.app.finance_tracker.service;

import java.util.List;

import com.myfinance.app.finance_tracker.dto.CategoryRuleRequest;
import com.myfinance.app.finance_tracker.dto.CategoryRuleResponse;

public interface CategoryRuleService {
    List<CategoryRuleResponse> listRules(Long userId);
    CategoryRuleResponse createRule(Long userId, CategoryRuleRequest req);
    void deleteRule(Long userId, Long ruleId);
}