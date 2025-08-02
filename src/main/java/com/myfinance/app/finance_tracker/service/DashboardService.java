package com.myfinance.app.finance_tracker.service;

import com.myfinance.app.finance_tracker.dto.DashboardStatsResponse;

public interface DashboardService {
    DashboardStatsResponse getMonthlyStats(Long userId, int year, int month);
    DashboardStatsResponse getYearlyStats(Long userId, int year);
} 