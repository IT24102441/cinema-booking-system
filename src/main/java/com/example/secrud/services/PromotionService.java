package com.example.secrud.services;

import com.example.secrud.models.Promotion;
import com.example.secrud.repos.PromotionRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PromotionService {

    @Autowired
    private PromotionRepo promotionRepo;

    public List<Promotion> getAllPromotions() {
        return promotionRepo.findAll();
    }

    public Optional<Promotion> getPromotionByCode(String code) {
        return promotionRepo.findById(code);
    }

    public Promotion savePromotion(Promotion promotion) {
        return promotionRepo.save(promotion);
    }

    public void deletePromotion(String code) {
        promotionRepo.deleteById(code);
    }
}
