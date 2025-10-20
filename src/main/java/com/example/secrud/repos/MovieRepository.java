package com.example.secrud.repos;

import com.example.secrud.models.Movie;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MovieRepository extends JpaRepository<Movie, Long> {

    // Find movies by category name (traverse many-to-many relation)
    List<Movie> findByCategories_Name(String name);

    // Find movies that have been categorized (have at least one category)
    List<Movie> findByCategoriesIsNotEmpty();

    // Find published movies (flag)
    List<Movie> findByPublishedTrue();

    // Find uncategorized movies (no categories)
    @Query("SELECT m FROM Movie m WHERE m.categories IS EMPTY")
    List<Movie> findUncategorizedMovies();

    // Find movies by title (for search functionality)
    List<Movie> findByTitleContainingIgnoreCase(String title);

    // Find movies by genre
    List<Movie> findByGenreContainingIgnoreCase(String genre);
}