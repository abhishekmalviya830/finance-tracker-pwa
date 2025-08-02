package com.myfinance.app.finance_tracker.exception;

/**
 * Thrown when a user attempts to perform an unauthorized operation.
 */
public class AccessDeniedException extends RuntimeException {
    public AccessDeniedException(String message) {
        super(message);
    }
}