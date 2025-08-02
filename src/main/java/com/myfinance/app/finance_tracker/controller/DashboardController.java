package com.myfinance.app.finance_tracker.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.myfinance.app.finance_tracker.dto.DashboardStatsResponse;
import com.myfinance.app.finance_tracker.service.DashboardService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardService dashboardService;

    @GetMapping("/stats/monthly")
    public ResponseEntity<DashboardStatsResponse> getMonthlyStats(
            Authentication auth,
            @RequestParam(defaultValue = "#{T(java.time.LocalDateTime).now().getYear()}") int year,
            @RequestParam(defaultValue = "#{T(java.time.LocalDateTime).now().getMonthValue()}") int month) {
        
        Long userId = (Long) auth.getPrincipal();
        DashboardStatsResponse stats = dashboardService.getMonthlyStats(userId, year, month);
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/stats/yearly")
    public ResponseEntity<DashboardStatsResponse> getYearlyStats(
            Authentication auth,
            @RequestParam(defaultValue = "#{T(java.time.LocalDateTime).now().getYear()}") int year) {
        
        Long userId = (Long) auth.getPrincipal();
        DashboardStatsResponse stats = dashboardService.getYearlyStats(userId, year);
        return ResponseEntity.ok(stats);
    }
} 