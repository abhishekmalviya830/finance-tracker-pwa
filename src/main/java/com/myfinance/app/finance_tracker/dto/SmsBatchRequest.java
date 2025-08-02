package com.myfinance.app.finance_tracker.dto;

import java.util.List;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SmsBatchRequest {
    
    @NotEmpty(message = "SMS messages cannot be empty")
    @Size(max = 100, message = "Cannot process more than 100 SMS messages at once")
    private List<@Valid SmsMessage> messages;
    
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class SmsMessage {
        @NotEmpty(message = "SMS text cannot be empty")
        @Size(max = 1000, message = "SMS text cannot exceed 1000 characters")
        private String text;
        
        private String timestamp; // Optional timestamp for the SMS
    }
} 