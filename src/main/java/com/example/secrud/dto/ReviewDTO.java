package com.example.secrud.dto;

import java.time.LocalDateTime;

public class ReviewDTO {

    public static class CreateRequest {
        private String movieName;
        private String userEmail; // optional for guests
        private Integer rating;
        private String comment;

        public String getMovieName() { return movieName; }
        public void setMovieName(String movieName) { this.movieName = movieName; }
        public String getUserEmail() { return userEmail; }
        public void setUserEmail(String userEmail) { this.userEmail = userEmail; }
        public Integer getRating() { return rating; }
        public void setRating(Integer rating) { this.rating = rating; }
        public String getComment() { return comment; }
        public void setComment(String comment) { this.comment = comment; }
    }

    public static class UpdateRequest {
        private Integer rating;
        private String comment;

        public Integer getRating() { return rating; }
        public void setRating(Integer rating) { this.rating = rating; }
        public String getComment() { return comment; }
        public void setComment(String comment) { this.comment = comment; }
    }

    public static class ReportRequest {
        private boolean reported;
        public boolean isReported() { return reported; }
        public void setReported(boolean reported) { this.reported = reported; }
    }

    public static class DeleteStatusRequest {
        private boolean deleteStatus;
        public boolean isDeleteStatus() { return deleteStatus; }
        public void setDeleteStatus(boolean deleteStatus) { this.deleteStatus = deleteStatus; }
    }

    public static class Response {
        private Long id;
        private String movieName;
        private String userEmail;
        private Integer rating;
        private String comment;
        private boolean reported;
        private boolean deleteStatus;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }
        public String getMovieName() { return movieName; }
        public void setMovieName(String movieName) { this.movieName = movieName; }
        public String getUserEmail() { return userEmail; }
        public void setUserEmail(String userEmail) { this.userEmail = userEmail; }
        public Integer getRating() { return rating; }
        public void setRating(Integer rating) { this.rating = rating; }
        public String getComment() { return comment; }
        public void setComment(String comment) { this.comment = comment; }
        public boolean isReported() { return reported; }
        public void setReported(boolean reported) { this.reported = reported; }
        public boolean isDeleteStatus() { return deleteStatus; }
        public void setDeleteStatus(boolean deleteStatus) { this.deleteStatus = deleteStatus; }
        public LocalDateTime getCreatedAt() { return createdAt; }
        public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
        public LocalDateTime getUpdatedAt() { return updatedAt; }
        public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    }
}


