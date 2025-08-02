package com.myfinance.app.finance_tracker.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.myfinance.app.finance_tracker.dto.SmsBatchRequest;
import com.myfinance.app.finance_tracker.dto.SmsBatchResponse;
import com.myfinance.app.finance_tracker.service.TransactionService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/sms")
@RequiredArgsConstructor
@Slf4j
public class SmsUploadController {

    private final TransactionService transactionService;

    /**
     * Upload SMS messages from a text file
     * Each line in the file should contain one SMS message
     */
    @PostMapping("/upload/text")
    public ResponseEntity<SmsBatchResponse> uploadSmsTextFile(
            Authentication auth,
            @RequestParam("file") MultipartFile file) {
        
        Long userId = (Long) auth.getPrincipal();
        
        try {
            List<SmsBatchRequest.SmsMessage> messages = parseTextFile(file);
            SmsBatchRequest request = SmsBatchRequest.builder()
                .messages(messages)
                .build();
            
            SmsBatchResponse response = transactionService.processSmsBatch(userId, request);
            return ResponseEntity.ok(response);
            
        } catch (IOException e) {
            log.error("Error processing SMS file", e);
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * Upload SMS messages from a CSV file
     * Expected format: timestamp,message_text
     */
    @PostMapping("/upload/csv")
    public ResponseEntity<SmsBatchResponse> uploadSmsCsvFile(
            Authentication auth,
            @RequestParam("file") MultipartFile file) {
        
        Long userId = (Long) auth.getPrincipal();
        
        try {
            List<SmsBatchRequest.SmsMessage> messages = parseCsvFile(file);
            SmsBatchRequest request = SmsBatchRequest.builder()
                .messages(messages)
                .build();
            
            SmsBatchResponse response = transactionService.processSmsBatch(userId, request);
            return ResponseEntity.ok(response);
            
        } catch (IOException e) {
            log.error("Error processing SMS CSV file", e);
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * Upload SMS messages from WhatsApp chat export
     * Parses WhatsApp chat format and extracts SMS-like messages
     */
    @PostMapping("/upload/whatsapp")
    public ResponseEntity<SmsBatchResponse> uploadWhatsAppChat(
            Authentication auth,
            @RequestParam("file") MultipartFile file) {
        
        Long userId = (Long) auth.getPrincipal();
        
        try {
            List<SmsBatchRequest.SmsMessage> messages = parseWhatsAppChat(file);
            SmsBatchRequest request = SmsBatchRequest.builder()
                .messages(messages)
                .build();
            
            SmsBatchResponse response = transactionService.processSmsBatch(userId, request);
            return ResponseEntity.ok(response);
            
        } catch (IOException e) {
            log.error("Error processing WhatsApp chat file", e);
            return ResponseEntity.badRequest().build();
        }
    }

    private List<SmsBatchRequest.SmsMessage> parseTextFile(MultipartFile file) throws IOException {
        List<SmsBatchRequest.SmsMessage> messages = new ArrayList<>();
        
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(file.getInputStream()))) {
            
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty() && !line.startsWith("#")) {
                    // Parse format: timestamp|sender|message_text
                    String[] parts = line.split("\\|", 3);
                    if (parts.length >= 3) {
                        String timestamp = parts[0].trim();
                        String sender = parts[1].trim();
                        String messageText = parts[2].trim();
                        
                        messages.add(SmsBatchRequest.SmsMessage.builder()
                            .text(messageText)
                            .timestamp(timestamp)
                            .build());
                    } else {
                        // Fallback: treat as plain message
                        messages.add(SmsBatchRequest.SmsMessage.builder()
                            .text(line)
                            .timestamp(LocalDateTime.now().toString())
                            .build());
                    }
                }
            }
        }
        
        return messages;
    }

    private List<SmsBatchRequest.SmsMessage> parseCsvFile(MultipartFile file) throws IOException {
        List<SmsBatchRequest.SmsMessage> messages = new ArrayList<>();
        
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(file.getInputStream()))) {
            
            String line;
            boolean firstLine = true;
            while ((line = reader.readLine()) != null) {
                if (firstLine) {
                    firstLine = false; // Skip header
                    continue;
                }
                
                String[] parts = line.split(",", 2);
                if (parts.length >= 2) {
                    String timestamp = parts[0].trim();
                    String text = parts[1].trim();
                    
                    messages.add(SmsBatchRequest.SmsMessage.builder()
                        .text(text)
                        .timestamp(timestamp)
                        .build());
                }
            }
        }
        
        return messages;
    }

    private List<SmsBatchRequest.SmsMessage> parseWhatsAppChat(MultipartFile file) throws IOException {
        List<SmsBatchRequest.SmsMessage> messages = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yy, HH:mm");
        
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(file.getInputStream()))) {
            
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                
                // Look for WhatsApp message format: [date, time] sender: message
                if (line.matches("\\[\\d{1,2}/\\d{1,2}/\\d{2}, \\d{1,2}:\\d{2}\\] .*: .*")) {
                    // Extract timestamp and message
                    int timestampEnd = line.indexOf("]");
                    int messageStart = line.indexOf(": ", timestampEnd) + 2;
                    
                    if (timestampEnd > 0 && messageStart > 2) {
                        String timestampStr = line.substring(1, timestampEnd);
                        String messageText = line.substring(messageStart);
                        
                        try {
                            LocalDateTime timestamp = LocalDateTime.parse(timestampStr, formatter);
                            messages.add(SmsBatchRequest.SmsMessage.builder()
                                .text(messageText)
                                .timestamp(timestamp.toString())
                                .build());
                        } catch (Exception e) {
                            log.warn("Could not parse timestamp: {}", timestampStr);
                        }
                    }
                }
            }
        }
        
        return messages;
    }
} 