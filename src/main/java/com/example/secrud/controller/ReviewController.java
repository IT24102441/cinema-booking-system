package com.example.secrud.controller;

import com.example.secrud.dto.ReviewDTO;
import com.example.secrud.models.ReviewModel;
import com.example.secrud.services.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/reviews")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    @PostMapping
    public ResponseEntity<?> create(@RequestBody ReviewDTO.CreateRequest request) {
        try {
            ReviewModel r = new ReviewModel();
            r.setMovieName(request.getMovieName());
            r.setUserEmail(request.getUserEmail());
            r.setRating(request.getRating());
            r.setComment(request.getComment());
            ReviewModel saved = reviewService.createReview(r);
            return ResponseEntity.status(HttpStatus.CREATED).body(toResponse(saved));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error creating review: " + e.getMessage());
        }
    }

    @GetMapping
    public ResponseEntity<?> getAll() {
        List<ReviewDTO.Response> list = reviewService.getAll().stream().map(this::toResponse).collect(Collectors.toList());
        return ResponseEntity.ok(list);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> get(@PathVariable Long id) {
        Optional<ReviewModel> opt = reviewService.getById(id);
        return opt.<ResponseEntity<?>>map(reviewModel -> ResponseEntity.ok(toResponse(reviewModel)))
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).body("Review not found"));
    }

    @GetMapping("/movie/{movieName}")
    public ResponseEntity<?> byMovie(@PathVariable String movieName) {
        List<ReviewDTO.Response> list = reviewService.getByMovieName(movieName).stream().map(this::toResponse).collect(Collectors.toList());
        return ResponseEntity.ok(list);
    }

    @GetMapping("/user/{userEmail}")
    public ResponseEntity<?> byUser(@PathVariable String userEmail) {
        List<ReviewDTO.Response> list = reviewService.getByUserEmail(userEmail).stream().map(this::toResponse).collect(Collectors.toList());
        return ResponseEntity.ok(list);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody ReviewDTO.UpdateRequest request) {
        try {
            ReviewModel details = new ReviewModel();
            details.setRating(request.getRating());
            details.setComment(request.getComment());
            ReviewModel updated = reviewService.updateReview(id, details);
            if (updated != null) return ResponseEntity.ok(toResponse(updated));
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Review not found");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error updating review: " + e.getMessage());
        }
    }

    @PatchMapping("/{id}/report")
    public ResponseEntity<?> report(@PathVariable Long id, @RequestBody ReviewDTO.ReportRequest req) {
        reviewService.markReported(id, req.isReported());
        return ResponseEntity.ok("Reported status updated");
    }

    @PatchMapping("/{id}/delete-status")
    public ResponseEntity<?> deleteStatus(@PathVariable Long id, @RequestBody ReviewDTO.DeleteStatusRequest req) {
        reviewService.updateDeleteStatus(id, req.isDeleteStatus());
        return ResponseEntity.ok("Delete status updated");
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        reviewService.delete(id);
        return ResponseEntity.ok("Review deleted");
    }

    private ReviewDTO.Response toResponse(ReviewModel r) {
        ReviewDTO.Response res = new ReviewDTO.Response();
        res.setId(r.getId());
        res.setMovieName(r.getMovieName());
        res.setUserEmail(r.getUserEmail());
        res.setRating(r.getRating());
        res.setComment(r.getComment());
        res.setReported(r.isReported());
        res.setDeleteStatus(r.isDeleteStatus());
        res.setCreatedAt(r.getCreatedAt());
        res.setUpdatedAt(r.getUpdatedAt());
        return res;
    }
}


