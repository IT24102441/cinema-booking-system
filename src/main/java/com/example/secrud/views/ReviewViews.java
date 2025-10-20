package com.example.secrud.views;

import com.example.secrud.models.ReviewModel;
import com.example.secrud.services.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class ReviewViews {

    @Autowired
    private ReviewService reviewService;

    @GetMapping("/reviews")
    public String reviewsList() {
        return "reviews/list";
    }

    @GetMapping("/reviews/create")
    public String createReview() {
        return "reviews/create";
    }

    @GetMapping("/reviews/edit")
    public String editReview() {
        return "reviews/edit";
    }

    @GetMapping("/my-reviews")
    public String myReviews() {
        return "reviews/my_reviews";
    }

    @GetMapping("/reviews/read")
    public String readPublicReviews() {
        return "reviews/read";
    }

    @GetMapping("/admin/reviews")
    public String adminReviews(Model model) {
        List<ReviewModel> reviews = reviewService.getAll();
        model.addAttribute("reviews", reviews);
        return "reviews/admin_list";
    }

    @GetMapping("/admin/reviews/reported")
    public String reportedReviews(Model model) {
        List<ReviewModel> reportedReviews = reviewService.getByReported(true);
        model.addAttribute("reviews", reportedReviews);
        model.addAttribute("filterType", "reported");
        return "reviews/admin_list";
    }

    @GetMapping("/admin/reviews/deleted")
    public String deletedReviews(Model model) {
        List<ReviewModel> deletedReviews = reviewService.getByDeleteStatus(true);
        model.addAttribute("reviews", deletedReviews);
        model.addAttribute("filterType", "deleted");
        return "reviews/admin_list";
    }
}


