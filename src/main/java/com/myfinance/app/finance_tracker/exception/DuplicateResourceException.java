package com.myfinance.app.finance_tracker.exception;

/**
 * Thrown when a resource already exists and duplication is not allowed.
 */
public class DuplicateResourceException extends RuntimeException {
    public DuplicateResourceException(String message) {
        super(message);
    }
}