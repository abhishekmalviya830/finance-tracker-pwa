package com.myfinance.app.finance_tracker.service;

public interface CategoryResolverService {
    /**
     * Resolve a transaction's category by:
     * 1) User-defined rules
     * 2) Static fallback rules
     * 3) Default "Uncategorized"
     */
    String resolveCategory(Long userId, String rawText, String merchant);
}