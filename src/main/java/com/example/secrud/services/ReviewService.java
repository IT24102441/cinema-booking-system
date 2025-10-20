package com.example.secrud.services;

import com.example.secrud.models.ReviewModel;
import com.example.secrud.repos.ReviewRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class ReviewService {

    @Autowired
    private ReviewRepo reviewRepo;

    @Transactional
    public ReviewModel createReview(ReviewModel review) {
        return reviewRepo.save(review);
    }

    public Optional<ReviewModel> getById(Long id) {
        return reviewRepo.findById(id);
    }

    public List<ReviewModel> getAll() {
        return reviewRepo.findAll();
    }

    public List<ReviewModel> getByMovieName(String movieName) {
        return reviewRepo.findByMovieName(movieName);
    }

    public List<ReviewModel> getByUserEmail(String userEmail) {
        return reviewRepo.findByUserEmail(userEmail);
    }

    public List<ReviewModel> getByReported(boolean reported) {
        return reviewRepo.findByReported(reported);
    }

    public List<ReviewModel> getByDeleteStatus(boolean deleteStatus) {
        return reviewRepo.findByDeleteStatus(deleteStatus);
    }

    @Transactional
    public ReviewModel updateReview(Long id, ReviewModel details) {
        Optional<ReviewModel> optional = reviewRepo.findById(id);
        if (optional.isPresent()) {
            ReviewModel r = optional.get();
            r.setRating(details.getRating());
            r.setComment(details.getComment());
            r.setReported(details.isReported());
            r.setDeleteStatus(details.isDeleteStatus());
            return reviewRepo.save(r);
        }
        return null;
    }

    @Transactional
    public void updateCommentAndRating(Long id, String comment, Integer rating) {
        reviewRepo.updateCommentAndRating(id, comment, rating);
    }

    @Transactional
    public void markReported(Long id, boolean reported) {
        reviewRepo.updateReported(id, reported);
    }

    @Transactional
    public void updateDeleteStatus(Long id, boolean deleteStatus) {
        reviewRepo.updateDeleteStatus(id, deleteStatus);
    }

    @Transactional
    public void delete(Long id) {
        reviewRepo.deleteById(id);
    }
}


