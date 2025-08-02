package com.myfinance.app.finance_tracker.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.myfinance.app.finance_tracker.dto.CategoryRuleRequest;
import com.myfinance.app.finance_tracker.dto.CategoryRuleResponse;
import com.myfinance.app.finance_tracker.service.CategoryRuleService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/rules")
@RequiredArgsConstructor
public class CategoryRuleController {

    private final CategoryRuleService ruleService;

    @GetMapping
    public ResponseEntity<List<CategoryRuleResponse>> listRules(Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        return ResponseEntity.ok(ruleService.listRules(userId));
    }

    @PostMapping
    public ResponseEntity<CategoryRuleResponse> createRule(
            Authentication auth,
            @Valid @RequestBody CategoryRuleRequest req) {
        Long userId = (Long) auth.getPrincipal();
        CategoryRuleResponse resp = ruleService.createRule(userId, req);
        return ResponseEntity.status(201).body(resp);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteRule(
            Authentication auth,
            @PathVariable("id") Long id) {
        Long userId = (Long) auth.getPrincipal();
        ruleService.deleteRule(userId, id);
        return ResponseEntity.noContent().build();
    }
}