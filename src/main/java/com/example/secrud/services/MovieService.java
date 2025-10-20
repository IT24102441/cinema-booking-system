package com.example.secrud.services;

import com.example.secrud.models.Movie;
import com.example.secrud.repos.MovieRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class MovieService {

    @Autowired
    private MovieRepository movieRepository;

    public List<Movie> getAllMovies() {
        return movieRepository.findAll();
    }

    public List<Movie> getPublishedMovies() {
        return movieRepository.findByPublishedTrue();
    }

    public Optional<Movie> getMovieById(Long id) {
        return movieRepository.findById(id);
    }

    public Movie addMovie(Movie movie) {
        // Update category summary when adding new movie
        updateCategorySummary(movie);
        return movieRepository.save(movie);
    }

    public Movie updateMovie(Long id, Movie movieDetails) {
        return movieRepository.findById(id).map(movie -> {
            movie.setTitle(movieDetails.getTitle());
            movie.setGenre(movieDetails.getGenre());
            movie.setDirector(movieDetails.getDirector());
            movie.setDuration(movieDetails.getDuration());
            movie.setReleaseDate(movieDetails.getReleaseDate());

            // replace categories set (never null)
            if (movieDetails.getCategories() != null) {
                movie.setCategories(movieDetails.getCategories());
            } else {
                movie.setCategories(new java.util.HashSet<>());
            }

            // Update the denormalized category summary column
            updateCategorySummary(movie);

            movie.setImageUrl(movieDetails.getImageUrl());
            movie.setPrice(movieDetails.getPrice());
            if (movieDetails.getPublished() != null) {
                movie.setPublished(movieDetails.getPublished());
            }
            return movieRepository.save(movie);
        }).orElseThrow(() -> new RuntimeException("Movie not found with id " + id));
    }

    public void deleteMovie(Long id) {
        movieRepository.deleteById(id);
    }

    // Get movies by category name
    public List<Movie> getMoviesByCategory(String categoryName) {
        return movieRepository.findByCategories_Name(categoryName);
    }

    // Get all categorized movies
    public List<Movie> getCategorizedMovies() {
        return movieRepository.findByCategoriesIsNotEmpty();
    }

    // Get uncategorized movies
    public List<Movie> getUncategorizedMovies() {
        return movieRepository.findUncategorizedMovies();
    }

    // NEW METHOD: Helper method to update category summary
    private void updateCategorySummary(Movie movie) {
        if (movie.getCategories() != null && !movie.getCategories().isEmpty()) {
            String cats = movie.getCategories().stream()
                    .filter(java.util.Objects::nonNull)
                    .map(c -> c.getName())
                    .filter(n -> n != null && !n.isBlank())
                    .sorted()
                    .reduce((a, b) -> a + "," + b)
                    .orElse("");
            movie.setCategory(cats);
        } else {
            movie.setCategory(null);
        }
    }

    // NEW METHOD: Explicitly update categories and summary
    public Movie updateMovieCategories(Long movieId, Movie movie) {
        // Update the category summary before saving
        updateCategorySummary(movie);
        return movieRepository.save(movie);
    }
}