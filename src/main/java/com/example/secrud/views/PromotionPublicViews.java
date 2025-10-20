package com.example.secrud.views;

import com.example.secrud.services.PromotionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PromotionPublicViews {

    @Autowired
    private PromotionService promotionService;

    @GetMapping(value = "/promotions", produces = MediaType.TEXT_HTML_VALUE)
    public String viewPromotions(Model model) {
        model.addAttribute("promotions", promotionService.getAllPromotions());
        return "promotions"; // resolves to WEB-INF/views/promotions.jsp
    }
}
