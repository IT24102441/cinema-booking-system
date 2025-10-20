package com.example.secrud.repos;

import com.example.secrud.models.ReviewModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface ReviewRepo extends JpaRepository<ReviewModel, Long> {

    List<ReviewModel> findByMovieName(String movieName);

    List<ReviewModel> findByUserEmail(String userEmail);

    List<ReviewModel> findByReported(boolean reported);

    List<ReviewModel> findByDeleteStatus(boolean deleteStatus);

    @Modifying
    @Transactional
    @Query("UPDATE ReviewModel r SET r.comment = :comment, r.rating = :rating WHERE r.id = :id")
    void updateCommentAndRating(@Param("id") Long id, @Param("comment") String comment, @Param("rating") Integer rating);

    @Modifying
    @Transactional
    @Query("UPDATE ReviewModel r SET r.reported = :reported WHERE r.id = :id")
    void updateReported(@Param("id") Long id, @Param("reported") boolean reported);

    @Modifying
    @Transactional
    @Query("UPDATE ReviewModel r SET r.deleteStatus = :deleteStatus WHERE r.id = :id")
    void updateDeleteStatus(@Param("id") Long id, @Param("deleteStatus") boolean deleteStatus);
}


