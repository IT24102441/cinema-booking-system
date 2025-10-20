package com.example.secrud.views;

import com.example.secrud.models.Promotion;
import com.example.secrud.services.PromotionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/promotions")
public class PromotionViews {

    @Autowired
    private PromotionService promotionService;

    // Predefined promotion types for dropdown
    private static final List<String> PROMOTION_TYPES = List.of(
            "DISCOUNT",
            "FREE_SHIPPING",
            "BOGO",
            "FEATURED"
    );

    // Value types for discount calculation
    private static final List<String> VALUE_TYPES = List.of("FIXED", "PERCENT");

    // GET /admin/promotions - List all promotions
    @GetMapping
    public String managePromotions(Model model) {
        model.addAttribute("promotions", promotionService.getAllPromotions());
        return "admin_promotions";
    }

    // GET /admin/promotions/new - Show create form
    @GetMapping("/new")
    public String showCreatePromotionForm(Model model) {
        // Provide promotion types for the dropdown
        model.addAttribute("promotionTypes", PROMOTION_TYPES);
        model.addAttribute("valueTypes", VALUE_TYPES);
        // Do not add a Promotion object here to avoid JSP formatting issues (e.g. fmt:formatDate with java.time.LocalDateTime).
        return "admin_promotion_form";
    }

    // POST /admin/promotions/create - Handle form submission
    @PostMapping("/create")
    public String createPromotion(
            @RequestParam("promotionCode") String promotionCode,
            @RequestParam("promotionType") String promotionType,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "startDate", required = false) String startDateStr,
            @RequestParam(value = "endDate", required = false) String endDateStr,
            @RequestParam(value = "value", required = false) String valueStr,
            @RequestParam(value = "valueType", required = false) String valueType
    ) {

        LocalDate startDate = null;
        LocalDate endDate = null;
        try {
            if (startDateStr != null && !startDateStr.isBlank()) startDate = LocalDate.parse(startDateStr);
        } catch (DateTimeParseException ignored) {}
        try {
            if (endDateStr != null && !endDateStr.isBlank()) endDate = LocalDate.parse(endDateStr);
        } catch (DateTimeParseException ignored) {}

        BigDecimal value = null;
        try {
            if (valueStr != null && !valueStr.isBlank()) value = new BigDecimal(valueStr);
        } catch (Exception ignored) {}

        Promotion promotion = new Promotion();
        promotion.setPromotionCode(promotionCode);
        promotion.setPromotionType(promotionType);
        promotion.setDescription(description);
        promotion.setStartDate(startDate);
        promotion.setEndDate(endDate);
        promotion.setValue(value);
        promotion.setValueType(valueType);

        promotionService.savePromotion(promotion);
        return "redirect:/admin/promotions";
    }

    // Your other methods remain the same...
    @GetMapping("/edit/{code}")
    public String showEditPromotionForm(@PathVariable("code") String code, Model model) {
        Optional<Promotion> optional = promotionService.getPromotionByCode(code);
        if (optional.isPresent()) {
            Promotion p = optional.get();
            model.addAttribute("promotion", p);

            // Provide promotion types for the dropdown
            model.addAttribute("promotionTypes", PROMOTION_TYPES);
            model.addAttribute("valueTypes", VALUE_TYPES);

            // Add preformatted date strings to avoid JSP fmt issues
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

            if (p.getStartDate() != null) model.addAttribute("startDateStr", p.getStartDate().format(dateFormatter));
            else model.addAttribute("startDateStr", "");

            if (p.getEndDate() != null) model.addAttribute("endDateStr", p.getEndDate().format(dateFormatter));
            else model.addAttribute("endDateStr", "");

            return "admin_promotion_form";
        }
        return "redirect:/admin/promotions";
    }

    @PostMapping("/update")
    public String updatePromotion(
            @RequestParam("promotionCode") String promotionCode,
            @RequestParam("promotionType") String promotionType,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "startDate", required = false) String startDateStr,
            @RequestParam(value = "endDate", required = false) String endDateStr,
            @RequestParam(value = "value", required = false) String valueStr,
            @RequestParam(value = "valueType", required = false) String valueType
    ) {

        LocalDate startDate = null;
        LocalDate endDate = null;
        try {
            if (startDateStr != null && !startDateStr.isBlank()) startDate = LocalDate.parse(startDateStr);
        } catch (DateTimeParseException ignored) {}
        try {
            if (endDateStr != null && !endDateStr.isBlank()) endDate = LocalDate.parse(endDateStr);
        } catch (DateTimeParseException ignored) {}

        BigDecimal value = null;
        try {
            if (valueStr != null && !valueStr.isBlank()) value = new BigDecimal(valueStr);
        } catch (Exception ignored) {}

        Optional<Promotion> optional = promotionService.getPromotionByCode(promotionCode);
        Promotion promotion;
        if (optional.isPresent()) {
            promotion = optional.get();
            promotion.setPromotionType(promotionType);
            promotion.setDescription(description);
            promotion.setStartDate(startDate);
            promotion.setEndDate(endDate);
            promotion.setValue(value);
            promotion.setValueType(valueType);
        } else {
            promotion = new Promotion();
            promotion.setPromotionCode(promotionCode);
            promotion.setPromotionType(promotionType);
            promotion.setDescription(description);
            promotion.setStartDate(startDate);
            promotion.setEndDate(endDate);
            promotion.setValue(value);
            promotion.setValueType(valueType);
        }

        promotionService.savePromotion(promotion);
        return "redirect:/admin/promotions";
    }

    @GetMapping("/delete/{code}")
    public String deletePromotion(@PathVariable("code") String code) {
        promotionService.deletePromotion(code);
        return "redirect:/admin/promotions";
    }


    //test form 
    @GetMapping("/test")
public String testJsp() {
    System.out.println("=== TEST JSP ACCESSED ===");
    return "test"; // This should resolve to /WEB-INF/views/test.jsp
}
}