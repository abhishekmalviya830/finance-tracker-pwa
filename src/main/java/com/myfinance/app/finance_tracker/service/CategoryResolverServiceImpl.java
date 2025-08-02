package com.myfinance.app.finance_tracker.service;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.regex.Pattern;

import org.springframework.stereotype.Service;

import com.myfinance.app.finance_tracker.model.CategoryRule;
import com.myfinance.app.finance_tracker.repository.CategoryRuleRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CategoryResolverServiceImpl implements CategoryResolverService {

    private final CategoryRuleRepository ruleRepo;

    private static final Map<Pattern,String> STATIC_RULES = new LinkedHashMap<>();
    static {
        // Food & Dining
        STATIC_RULES.put(Pattern.compile(".*\\bzomato\\b.*", Pattern.CASE_INSENSITIVE), "Food & Dining");
        STATIC_RULES.put(Pattern.compile(".*\\bswiggy\\b.*", Pattern.CASE_INSENSITIVE), "Food & Dining");
        STATIC_RULES.put(Pattern.compile(".*\\bstarbucks\\b.*", Pattern.CASE_INSENSITIVE), "Food & Dining");
        STATIC_RULES.put(Pattern.compile(".*\\bmcdonalds\\b.*", Pattern.CASE_INSENSITIVE), "Food & Dining");
        STATIC_RULES.put(Pattern.compile(".*\\bkfc\\b.*", Pattern.CASE_INSENSITIVE), "Food & Dining");
        STATIC_RULES.put(Pattern.compile(".*\\bdominos\\b.*", Pattern.CASE_INSENSITIVE), "Food & Dining");
        STATIC_RULES.put(Pattern.compile(".*\\bpizzahut\\b.*", Pattern.CASE_INSENSITIVE), "Food & Dining");
        STATIC_RULES.put(Pattern.compile(".*\\bcoffee\\b.*", Pattern.CASE_INSENSITIVE), "Food & Dining");
        STATIC_RULES.put(Pattern.compile(".*\\brestaurant\\b.*", Pattern.CASE_INSENSITIVE), "Food & Dining");
        STATIC_RULES.put(Pattern.compile(".*\\bcafe\\b.*", Pattern.CASE_INSENSITIVE), "Food & Dining");
        
        // Travel & Transportation
        STATIC_RULES.put(Pattern.compile(".*\\buber\\b.*", Pattern.CASE_INSENSITIVE), "Travel & Transportation");
        STATIC_RULES.put(Pattern.compile(".*\\bola\\b.*", Pattern.CASE_INSENSITIVE), "Travel & Transportation");
        STATIC_RULES.put(Pattern.compile(".*\\brapido\\b.*", Pattern.CASE_INSENSITIVE), "Travel & Transportation");
        STATIC_RULES.put(Pattern.compile(".*\\bairport\\b.*", Pattern.CASE_INSENSITIVE), "Travel & Transportation");
        STATIC_RULES.put(Pattern.compile(".*\\btrain\\b.*", Pattern.CASE_INSENSITIVE), "Travel & Transportation");
        STATIC_RULES.put(Pattern.compile(".*\\bbus\\b.*", Pattern.CASE_INSENSITIVE), "Travel & Transportation");
        STATIC_RULES.put(Pattern.compile(".*\\bpetrol\\b.*", Pattern.CASE_INSENSITIVE), "Travel & Transportation");
        STATIC_RULES.put(Pattern.compile(".*\\bgas\\b.*", Pattern.CASE_INSENSITIVE), "Travel & Transportation");
        STATIC_RULES.put(Pattern.compile(".*\\bfuel\\b.*", Pattern.CASE_INSENSITIVE), "Travel & Transportation");
        
        // Shopping & Retail
        STATIC_RULES.put(Pattern.compile(".*\\bamazon\\b.*", Pattern.CASE_INSENSITIVE), "Shopping & Retail");
        STATIC_RULES.put(Pattern.compile(".*\\bflipkart\\b.*", Pattern.CASE_INSENSITIVE), "Shopping & Retail");
        STATIC_RULES.put(Pattern.compile(".*\\bmyntra\\b.*", Pattern.CASE_INSENSITIVE), "Shopping & Retail");
        STATIC_RULES.put(Pattern.compile(".*\\bajio\\b.*", Pattern.CASE_INSENSITIVE), "Shopping & Retail");
        STATIC_RULES.put(Pattern.compile(".*\\bnykaa\\b.*", Pattern.CASE_INSENSITIVE), "Shopping & Retail");
        STATIC_RULES.put(Pattern.compile(".*\\bwalmart\\b.*", Pattern.CASE_INSENSITIVE), "Shopping & Retail");
        STATIC_RULES.put(Pattern.compile(".*\\btarget\\b.*", Pattern.CASE_INSENSITIVE), "Shopping & Retail");
        STATIC_RULES.put(Pattern.compile(".*\\bmall\\b.*", Pattern.CASE_INSENSITIVE), "Shopping & Retail");
        STATIC_RULES.put(Pattern.compile(".*\\bstore\\b.*", Pattern.CASE_INSENSITIVE), "Shopping & Retail");
        
        // Entertainment & Streaming
        STATIC_RULES.put(Pattern.compile(".*\\bnetflix\\b.*", Pattern.CASE_INSENSITIVE), "Entertainment & Streaming");
        STATIC_RULES.put(Pattern.compile(".*\\bprime\\b.*", Pattern.CASE_INSENSITIVE), "Entertainment & Streaming");
        STATIC_RULES.put(Pattern.compile(".*\\bamazon prime\\b.*", Pattern.CASE_INSENSITIVE), "Entertainment & Streaming");
        STATIC_RULES.put(Pattern.compile(".*\\bhotstar\\b.*", Pattern.CASE_INSENSITIVE), "Entertainment & Streaming");
        STATIC_RULES.put(Pattern.compile(".*\\bdisney\\b.*", Pattern.CASE_INSENSITIVE), "Entertainment & Streaming");
        STATIC_RULES.put(Pattern.compile(".*\\bspotify\\b.*", Pattern.CASE_INSENSITIVE), "Entertainment & Streaming");
        STATIC_RULES.put(Pattern.compile(".*\\byoutube\\b.*", Pattern.CASE_INSENSITIVE), "Entertainment & Streaming");
        STATIC_RULES.put(Pattern.compile(".*\\btheatre\\b.*", Pattern.CASE_INSENSITIVE), "Entertainment & Streaming");
        STATIC_RULES.put(Pattern.compile(".*\\bmovie\\b.*", Pattern.CASE_INSENSITIVE), "Entertainment & Streaming");
        STATIC_RULES.put(Pattern.compile(".*\\bcinema\\b.*", Pattern.CASE_INSENSITIVE), "Entertainment & Streaming");
        
        // Healthcare & Medical
        STATIC_RULES.put(Pattern.compile(".*\\bhospital\\b.*", Pattern.CASE_INSENSITIVE), "Healthcare & Medical");
        STATIC_RULES.put(Pattern.compile(".*\\bclinic\\b.*", Pattern.CASE_INSENSITIVE), "Healthcare & Medical");
        STATIC_RULES.put(Pattern.compile(".*\\bpharmacy\\b.*", Pattern.CASE_INSENSITIVE), "Healthcare & Medical");
        STATIC_RULES.put(Pattern.compile(".*\\bmedical\\b.*", Pattern.CASE_INSENSITIVE), "Healthcare & Medical");
        STATIC_RULES.put(Pattern.compile(".*\\bdoctor\\b.*", Pattern.CASE_INSENSITIVE), "Healthcare & Medical");
        STATIC_RULES.put(Pattern.compile(".*\\bdentist\\b.*", Pattern.CASE_INSENSITIVE), "Healthcare & Medical");
        STATIC_RULES.put(Pattern.compile(".*\\bmedicine\\b.*", Pattern.CASE_INSENSITIVE), "Healthcare & Medical");
        STATIC_RULES.put(Pattern.compile(".*\\bapollo\\b.*", Pattern.CASE_INSENSITIVE), "Healthcare & Medical");
        STATIC_RULES.put(Pattern.compile(".*\\bfortis\\b.*", Pattern.CASE_INSENSITIVE), "Healthcare & Medical");
        
        // Education & Learning
        STATIC_RULES.put(Pattern.compile(".*\\bschool\\b.*", Pattern.CASE_INSENSITIVE), "Education & Learning");
        STATIC_RULES.put(Pattern.compile(".*\\bcollege\\b.*", Pattern.CASE_INSENSITIVE), "Education & Learning");
        STATIC_RULES.put(Pattern.compile(".*\\buniversity\\b.*", Pattern.CASE_INSENSITIVE), "Education & Learning");
        STATIC_RULES.put(Pattern.compile(".*\\btuition\\b.*", Pattern.CASE_INSENSITIVE), "Education & Learning");
        STATIC_RULES.put(Pattern.compile(".*\\bcourse\\b.*", Pattern.CASE_INSENSITIVE), "Education & Learning");
        STATIC_RULES.put(Pattern.compile(".*\\bclass\\b.*", Pattern.CASE_INSENSITIVE), "Education & Learning");
        STATIC_RULES.put(Pattern.compile(".*\\btraining\\b.*", Pattern.CASE_INSENSITIVE), "Education & Learning");
        STATIC_RULES.put(Pattern.compile(".*\\bworkshop\\b.*", Pattern.CASE_INSENSITIVE), "Education & Learning");
        STATIC_RULES.put(Pattern.compile(".*\\bexam\\b.*", Pattern.CASE_INSENSITIVE), "Education & Learning");
        STATIC_RULES.put(Pattern.compile(".*\\bbook\\b.*", Pattern.CASE_INSENSITIVE), "Education & Learning");
        
        // Income & Salary
        STATIC_RULES.put(Pattern.compile(".*\\bsalary\\b.*", Pattern.CASE_INSENSITIVE), "Income & Salary");
        STATIC_RULES.put(Pattern.compile(".*\\bpayroll\\b.*", Pattern.CASE_INSENSITIVE), "Income & Salary");
        STATIC_RULES.put(Pattern.compile(".*\\bwage\\b.*", Pattern.CASE_INSENSITIVE), "Income & Salary");
        STATIC_RULES.put(Pattern.compile(".*\\bbonus\\b.*", Pattern.CASE_INSENSITIVE), "Income & Salary");
        STATIC_RULES.put(Pattern.compile(".*\\bcommission\\b.*", Pattern.CASE_INSENSITIVE), "Income & Salary");
        STATIC_RULES.put(Pattern.compile(".*\\bfreelance\\b.*", Pattern.CASE_INSENSITIVE), "Income & Salary");
        STATIC_RULES.put(Pattern.compile(".*\\bpayment\\b.*", Pattern.CASE_INSENSITIVE), "Income & Salary");
        STATIC_RULES.put(Pattern.compile(".*\\bcredit\\b.*", Pattern.CASE_INSENSITIVE), "Income & Salary");
        STATIC_RULES.put(Pattern.compile(".*\\btransfer\\b.*", Pattern.CASE_INSENSITIVE), "Income & Salary");
        
        // Banking & Finance
        STATIC_RULES.put(Pattern.compile(".*\\bbank\\b.*", Pattern.CASE_INSENSITIVE), "Banking & Finance");
        STATIC_RULES.put(Pattern.compile(".*\\batm\\b.*", Pattern.CASE_INSENSITIVE), "Banking & Finance");
        STATIC_RULES.put(Pattern.compile(".*\\bwithdrawal\\b.*", Pattern.CASE_INSENSITIVE), "Banking & Finance");
        STATIC_RULES.put(Pattern.compile(".*\\bdeposit\\b.*", Pattern.CASE_INSENSITIVE), "Banking & Finance");
        STATIC_RULES.put(Pattern.compile(".*\\binterest\\b.*", Pattern.CASE_INSENSITIVE), "Banking & Finance");
        STATIC_RULES.put(Pattern.compile(".*\\bloan\\b.*", Pattern.CASE_INSENSITIVE), "Banking & Finance");
        STATIC_RULES.put(Pattern.compile(".*\\bemi\\b.*", Pattern.CASE_INSENSITIVE), "Banking & Finance");
        STATIC_RULES.put(Pattern.compile(".*\\bcredit card\\b.*", Pattern.CASE_INSENSITIVE), "Banking & Finance");
        STATIC_RULES.put(Pattern.compile(".*\\bdebit card\\b.*", Pattern.CASE_INSENSITIVE), "Banking & Finance");
        
        // Utilities & Bills
        STATIC_RULES.put(Pattern.compile(".*\\belectricity\\b.*", Pattern.CASE_INSENSITIVE), "Utilities & Bills");
        STATIC_RULES.put(Pattern.compile(".*\\bwater\\b.*", Pattern.CASE_INSENSITIVE), "Utilities & Bills");
        STATIC_RULES.put(Pattern.compile(".*\\bgas\\b.*", Pattern.CASE_INSENSITIVE), "Utilities & Bills");
        STATIC_RULES.put(Pattern.compile(".*\\binternet\\b.*", Pattern.CASE_INSENSITIVE), "Utilities & Bills");
        STATIC_RULES.put(Pattern.compile(".*\\bphone\\b.*", Pattern.CASE_INSENSITIVE), "Utilities & Bills");
        STATIC_RULES.put(Pattern.compile(".*\\bmobile\\b.*", Pattern.CASE_INSENSITIVE), "Utilities & Bills");
        STATIC_RULES.put(Pattern.compile(".*\\bbroadband\\b.*", Pattern.CASE_INSENSITIVE), "Utilities & Bills");
        STATIC_RULES.put(Pattern.compile(".*\\bcable\\b.*", Pattern.CASE_INSENSITIVE), "Utilities & Bills");
        STATIC_RULES.put(Pattern.compile(".*\\brent\\b.*", Pattern.CASE_INSENSITIVE), "Utilities & Bills");
        STATIC_RULES.put(Pattern.compile(".*\\bmaintenance\\b.*", Pattern.CASE_INSENSITIVE), "Utilities & Bills");
        
        // Insurance & Investment
        STATIC_RULES.put(Pattern.compile(".*\\binsurance\\b.*", Pattern.CASE_INSENSITIVE), "Insurance & Investment");
        STATIC_RULES.put(Pattern.compile(".*\\bpolicy\\b.*", Pattern.CASE_INSENSITIVE), "Insurance & Investment");
        STATIC_RULES.put(Pattern.compile(".*\\bmutual fund\\b.*", Pattern.CASE_INSENSITIVE), "Insurance & Investment");
        STATIC_RULES.put(Pattern.compile(".*\\bstock\\b.*", Pattern.CASE_INSENSITIVE), "Insurance & Investment");
        STATIC_RULES.put(Pattern.compile(".*\\binvestment\\b.*", Pattern.CASE_INSENSITIVE), "Insurance & Investment");
        STATIC_RULES.put(Pattern.compile(".*\\bpremium\\b.*", Pattern.CASE_INSENSITIVE), "Insurance & Investment");
        STATIC_RULES.put(Pattern.compile(".*\\bclaim\\b.*", Pattern.CASE_INSENSITIVE), "Insurance & Investment");
        
        // Personal Care & Beauty
        STATIC_RULES.put(Pattern.compile(".*\\bsalon\\b.*", Pattern.CASE_INSENSITIVE), "Personal Care & Beauty");
        STATIC_RULES.put(Pattern.compile(".*\\bspa\\b.*", Pattern.CASE_INSENSITIVE), "Personal Care & Beauty");
        STATIC_RULES.put(Pattern.compile(".*\\bgym\\b.*", Pattern.CASE_INSENSITIVE), "Personal Care & Beauty");
        STATIC_RULES.put(Pattern.compile(".*\\bfitness\\b.*", Pattern.CASE_INSENSITIVE), "Personal Care & Beauty");
        STATIC_RULES.put(Pattern.compile(".*\\bcosmetics\\b.*", Pattern.CASE_INSENSITIVE), "Personal Care & Beauty");
        STATIC_RULES.put(Pattern.compile(".*\\bparlour\\b.*", Pattern.CASE_INSENSITIVE), "Personal Care & Beauty");
        
        // Home & Living
        STATIC_RULES.put(Pattern.compile(".*\\bfurniture\\b.*", Pattern.CASE_INSENSITIVE), "Home & Living");
        STATIC_RULES.put(Pattern.compile(".*\\bappliance\\b.*", Pattern.CASE_INSENSITIVE), "Home & Living");
        STATIC_RULES.put(Pattern.compile(".*\\bdecoration\\b.*", Pattern.CASE_INSENSITIVE), "Home & Living");
        STATIC_RULES.put(Pattern.compile(".*\\bkitchen\\b.*", Pattern.CASE_INSENSITIVE), "Home & Living");
        STATIC_RULES.put(Pattern.compile(".*\\bcleaning\\b.*", Pattern.CASE_INSENSITIVE), "Home & Living");
        STATIC_RULES.put(Pattern.compile(".*\\bplumber\\b.*", Pattern.CASE_INSENSITIVE), "Home & Living");
        STATIC_RULES.put(Pattern.compile(".*\\belectrician\\b.*", Pattern.CASE_INSENSITIVE), "Home & Living");
        
        // Technology & Electronics
        STATIC_RULES.put(Pattern.compile(".*\\bapple\\b.*", Pattern.CASE_INSENSITIVE), "Technology & Electronics");
        STATIC_RULES.put(Pattern.compile(".*\\bsamsung\\b.*", Pattern.CASE_INSENSITIVE), "Technology & Electronics");
        STATIC_RULES.put(Pattern.compile(".*\\bgoogle\\b.*", Pattern.CASE_INSENSITIVE), "Technology & Electronics");
        STATIC_RULES.put(Pattern.compile(".*\\bmicrosoft\\b.*", Pattern.CASE_INSENSITIVE), "Technology & Electronics");
        STATIC_RULES.put(Pattern.compile(".*\\blaptop\\b.*", Pattern.CASE_INSENSITIVE), "Technology & Electronics");
        STATIC_RULES.put(Pattern.compile(".*\\bphone\\b.*", Pattern.CASE_INSENSITIVE), "Technology & Electronics");
        STATIC_RULES.put(Pattern.compile(".*\\bsoftware\\b.*", Pattern.CASE_INSENSITIVE), "Technology & Electronics");
        STATIC_RULES.put(Pattern.compile(".*\\bapp\\b.*", Pattern.CASE_INSENSITIVE), "Technology & Electronics");
        
        // Charity & Donations
        STATIC_RULES.put(Pattern.compile(".*\\bdonation\\b.*", Pattern.CASE_INSENSITIVE), "Charity & Donations");
        STATIC_RULES.put(Pattern.compile(".*\\bcharity\\b.*", Pattern.CASE_INSENSITIVE), "Charity & Donations");
        STATIC_RULES.put(Pattern.compile(".*\\bfund\\b.*", Pattern.CASE_INSENSITIVE), "Charity & Donations");
        STATIC_RULES.put(Pattern.compile(".*\\bngo\\b.*", Pattern.CASE_INSENSITIVE), "Charity & Donations");
        STATIC_RULES.put(Pattern.compile(".*\\bhelp\\b.*", Pattern.CASE_INSENSITIVE), "Charity & Donations");
    }

    @Override
    public String resolveCategory(Long userId, String rawText, String merchant) {
        String text = (merchant != null ? merchant : "") + " " + (rawText != null ? rawText : "");

        // 1) user-defined rules (highest priority)
        for (CategoryRule r : ruleRepo.findByUserId(userId)) {
            if (text.toLowerCase().contains(r.getPattern().toLowerCase())) {
                return r.getCategory();
            }
        }
        
        // 2) static fallback rules
        for (Map.Entry<Pattern,String> e : STATIC_RULES.entrySet()) {
            if (e.getKey().matcher(text).matches()) {
                return e.getValue();
            }
        }
        
        // 3) default fallback
        return "Uncategorized";
    }
}