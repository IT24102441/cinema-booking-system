package com.example.secrud.controller;

import com.example.secrud.dto.AdminDTO;
import com.example.secrud.dto.ReviewDTO;
import com.example.secrud.models.AdminModel;
import com.example.secrud.models.ReviewModel;
import com.example.secrud.services.AdminService;
import com.example.secrud.services.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admins")
public class AdminController {

    private final AdminService adminService;
    private final ReviewService reviewService;

    @Autowired
    public AdminController(AdminService adminService, ReviewService reviewService) {
        this.adminService = adminService;
        this.reviewService = reviewService;
    }

    // 🔹 CREATE
    @PostMapping
    public ResponseEntity<?> createAdmin(@RequestBody AdminDTO.Request request) {
        try {
            AdminDTO.Response response = adminService.createAdmin(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Error: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Unexpected error: " + e.getMessage());
        }
    }

    // 🔹 READ ALL
    @GetMapping
    public ResponseEntity<?> getAllAdmins() {
        try {
            List<AdminDTO.Response> admins = adminService.getAllAdmins();
            return ResponseEntity.ok(admins);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to fetch admins: " + e.getMessage());
        }
    }

    // 🔹 READ BY ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getAdminById(@PathVariable Long id) {
        try {
            AdminDTO.Response response = adminService.getAdminById(id);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Error: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Unexpected error: " + e.getMessage());
        }
    }

    // 🔹 UPDATE
    @PutMapping("/{id}")
    public ResponseEntity<?> updateAdmin(@PathVariable Long id, @RequestBody AdminDTO.Request request) {
        try {
            AdminDTO.Response response = adminService.updateAdmin(id, request);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Error: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Update failed: " + e.getMessage());
        }
    }

    // 🔹 DELETE
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteAdmin(@PathVariable Long id) {
        try {
            adminService.deleteAdmin(id);
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Error: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Deletion failed: " + e.getMessage());
        }
    }

    // 🔹 LOGIN
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody AdminDTO.LoginRequest loginRequest) {
        try {
            AdminModel admin = adminService.authenticate(loginRequest.getEmail(), loginRequest.getPassword());
            // You can add a token here if needed (e.g., "token": "dummy-token")
            AdminDTO.LoginResponse response = new AdminDTO.LoginResponse(
                    admin.getId(),
                    admin.getName(),
                    admin.getEmail(),
                    admin.getRole(),
                    "logged-in" // placeholder; replace with real token in real apps
            );
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Error: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Login failed: " + e.getMessage());
        }
    }

    // ==================== REVIEW MANAGEMENT ENDPOINTS ====================

    // 🔹 GET ALL REVIEWS FOR ADMIN
    @GetMapping("/reviews")
    public ResponseEntity<?> getAllReviewsForAdmin() {
        try {
            List<ReviewDTO.Response> reviews = reviewService.getAll().stream()
                    .map(this::toReviewResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(reviews);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to fetch reviews: " + e.getMessage());
        }
    }

    // 🔹 GET REVIEW BY ID FOR ADMIN
    @GetMapping("/reviews/{id}")
    public ResponseEntity<?> getReviewByIdForAdmin(@PathVariable Long id) {
        try {
            Optional<ReviewModel> reviewOpt = reviewService.getById(id);
            if (reviewOpt.isPresent()) {
                ReviewDTO.Response response = toReviewResponse(reviewOpt.get());
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Review not found");
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to fetch review: " + e.getMessage());
        }
    }

    // 🔹 UPDATE REVIEW STATUS (REPORT/DELETE)
    @PatchMapping("/reviews/{id}/report")
    public ResponseEntity<?> updateReviewReportStatus(@PathVariable Long id, @RequestBody ReviewDTO.ReportRequest request) {
        try {
            reviewService.markReported(id, request.isReported());
            return ResponseEntity.ok("Review report status updated successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to update report status: " + e.getMessage());
        }
    }

    @PatchMapping("/reviews/{id}/delete-status")
    public ResponseEntity<?> updateReviewDeleteStatus(@PathVariable Long id, @RequestBody ReviewDTO.DeleteStatusRequest request) {
        try {
            reviewService.updateDeleteStatus(id, request.isDeleteStatus());
            return ResponseEntity.ok("Review delete status updated successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to update delete status: " + e.getMessage());
        }
    }

    // 🔹 DELETE REVIEW PERMANENTLY
    @DeleteMapping("/reviews/{id}")
    public ResponseEntity<?> deleteReviewPermanently(@PathVariable Long id) {
        try {
            reviewService.delete(id);
            return ResponseEntity.ok("Review deleted permanently");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to delete review: " + e.getMessage());
        }
    }

    // 🔹 GET REVIEWS BY STATUS
    @GetMapping("/reviews/status/reported")
    public ResponseEntity<?> getReportedReviews() {
        try {
            List<ReviewDTO.Response> reviews = reviewService.getByReported(true).stream()
                    .map(this::toReviewResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(reviews);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to fetch reported reviews: " + e.getMessage());
        }
    }

    @GetMapping("/reviews/status/deleted")
    public ResponseEntity<?> getDeletedReviews() {
        try {
            List<ReviewDTO.Response> reviews = reviewService.getByDeleteStatus(true).stream()
                    .map(this::toReviewResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(reviews);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to fetch deleted reviews: " + e.getMessage());
        }
    }

    // Helper method to convert ReviewModel to ReviewDTO.Response
    private ReviewDTO.Response toReviewResponse(ReviewModel review) {
        ReviewDTO.Response response = new ReviewDTO.Response();
        response.setId(review.getId());
        response.setMovieName(review.getMovieName());
        response.setUserEmail(review.getUserEmail());
        response.setRating(review.getRating());
        response.setComment(review.getComment());
        response.setReported(review.isReported());
        response.setDeleteStatus(review.isDeleteStatus());
        response.setCreatedAt(review.getCreatedAt());
        response.setUpdatedAt(review.getUpdatedAt());
        return response;
    }
}