package com.myfinance.app.finance_tracker.service;

import com.myfinance.app.finance_tracker.dto.*;
import com.myfinance.app.finance_tracker.exception.*;
import com.myfinance.app.finance_tracker.model.*;
import com.myfinance.app.finance_tracker.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class CategoryRuleServiceImpl implements CategoryRuleService {
    private final CategoryRuleRepository ruleRepo;
    private final UserRepository userRepo;

    @Override
    public List<CategoryRuleResponse> listRules(Long userId) {
        return ruleRepo.findByUserId(userId).stream()
            .map(rule -> CategoryRuleResponse.builder()
                .id(rule.getId())
                .pattern(rule.getPattern())
                .category(rule.getCategory())
                .build())
            .collect(Collectors.toList());
    }

    @Override
    public CategoryRuleResponse createRule(Long userId, CategoryRuleRequest req) {
        if (!userRepo.existsById(userId)) {
            throw new ResourceNotFoundException("User not found");
        }
        if (ruleRepo.existsByUserIdAndPatternIgnoreCase(userId, req.getPattern())) {
            if (ruleRepo.existsByUserIdAndPatternIgnoreCase(userId, req.getPattern())) {
                throw new DuplicateResourceException("Rule already exists for pattern: " + req.getPattern());
            }
        }
        CategoryRule rule = CategoryRule.builder()
            .user(userRepo.getReferenceById(userId))
            .pattern(req.getPattern().toLowerCase())
            .category(req.getCategory())
            .build();
        rule = ruleRepo.save(rule);
        return CategoryRuleResponse.builder()
            .id(rule.getId())
            .pattern(rule.getPattern())
            .category(rule.getCategory())
            .build();
    }

    @Override
    public void deleteRule(Long userId, Long ruleId) {
        CategoryRule rule = ruleRepo.findById(ruleId)
            .orElseThrow(() -> new ResourceNotFoundException("Rule not found: " + ruleId));
        if (!rule.getUser().getId().equals(userId)) {
            throw new AccessDeniedException("Cannot delete rule of another user");
        }
        ruleRepo.delete(rule);
    }
}