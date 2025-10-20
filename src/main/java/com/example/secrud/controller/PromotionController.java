package com.example.secrud.controller;

import com.example.secrud.models.Promotion;
import com.example.secrud.services.PromotionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/promotions")
public class PromotionController {

    @Autowired
    private PromotionService promotionService;

    @GetMapping("/apply")
    public ResponseEntity<?> applyPromotion(@RequestParam("code") String code,
                                            @RequestParam(value = "amount") BigDecimal amount) {
        try {
            Optional<Promotion> opt = promotionService.getPromotionByCode(code);
            if (!opt.isPresent()) {
                Map<String, Object> body = new HashMap<>();
                body.put("valid", false);
                body.put("message", "Promotion code not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(body);
            }
            Promotion promo = opt.get();
            LocalDate today = LocalDate.now();
            if (promo.getStartDate() != null && promo.getEndDate() != null) {
                if (today.isBefore(promo.getStartDate()) || today.isAfter(promo.getEndDate())) {
                    Map<String, Object> body = new HashMap<>();
                    body.put("valid", false);
                    body.put("message", "Promotion is not active");
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
                }
            }
            BigDecimal discount = BigDecimal.ZERO;
            String valueType = promo.getValueType();
            BigDecimal value = promo.getValue() == null ? BigDecimal.ZERO : promo.getValue();
            if (valueType != null && valueType.equalsIgnoreCase("PERCENT")) {
                // percent off
                discount = amount.multiply(value).divide(new BigDecimal(100));
            } else {
                // fixed off
                discount = value;
            }
            if (discount.compareTo(amount) > 0) {
                discount = amount; // cannot exceed amount
            }
            BigDecimal newTotal = amount.subtract(discount);
            Map<String, Object> body = new HashMap<>();
            body.put("valid", true);
            body.put("promotionCode", promo.getPromotionCode());
            body.put("promotionType", promo.getPromotionType());
            body.put("valueType", valueType);
            body.put("value", value);
            body.put("discountAmount", discount);
            body.put("newTotal", newTotal);
            return ResponseEntity.ok(body);
        } catch (Exception e) {
            Map<String, Object> body = new HashMap<>();
            body.put("valid", false);
            body.put("message", "Error applying promotion: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
        }
    }
}
