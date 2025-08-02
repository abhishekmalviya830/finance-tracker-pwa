package com.myfinance.app.finance_tracker.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Component;

import com.myfinance.app.finance_tracker.model.Transaction;
import com.myfinance.app.finance_tracker.model.TransactionOrigin;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class SmsParser {
    private static final Pattern TXN_PATTERN = Pattern.compile(
        "Rs\\.?\\s?(\\d+[\\d,]*)\\s+(debited|credited)\\s+(?:to|from)\\s+A/c\\s+\\w+\\s+on\\s+(\\d{2}-\\d{2}-\\d{4})\\s+at\\s+\\d{1,2}:\\d{2}\\s+(?:AM|PM)\\s+for\\s+(.+?)(?:\\.|\\s+Avl\\s+Bal|$)",
        Pattern.CASE_INSENSITIVE
    );
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("dd-MM-yyyy");

    /**
     * Parses an SMS into a Transaction object (without user).
     */
    public Optional<Transaction> parse(String sms, Long userId) {
        Matcher m = TXN_PATTERN.matcher(sms);
        if (!m.find()) {
            log.debug("SMS did not match pattern: {}", sms);
            return Optional.empty();
        }
        BigDecimal amt = new BigDecimal(m.group(1).replaceAll(",", ""));
        if ("debited".equalsIgnoreCase(m.group(2))) {
            amt = amt.negate();
        }
        String merchant = m.group(4); // merchant is now group 4
        LocalDate date = LocalDate.parse(m.group(3), DATE_FMT); // date is now group 3
        LocalDateTime txnTime = date.atStartOfDay();

        Transaction txn = Transaction.builder()
            .origin(TransactionOrigin.SMS)
            .rawText(sms)
            .amount(amt)
            .currency("INR")
            .merchant(merchant)
            .category("Uncategorized")
            .transactionTime(txnTime)
            .build();

        return Optional.of(txn);
    }
}