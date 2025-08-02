package com.myfinance.app.finance_tracker.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class CategoryRuleRequest {
    @NotBlank @Size(max = 100)
    private String pattern;

    @NotBlank @Size(max = 50)
    private String category;
}