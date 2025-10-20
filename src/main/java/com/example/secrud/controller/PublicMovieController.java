package com.example.secrud.controller;

import com.example.secrud.models.Category;
import com.example.secrud.models.Movie;
import com.example.secrud.services.MovieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.*;

@Controller
public class PublicMovieController {

    @Autowired
    private MovieService movieService;

    @GetMapping("/browse-movies")
    public String browseMovies(Model model) {
        try {
            // Only show published movies and group them by each category they belong to.
            List<Movie> allMovies = movieService.getPublishedMovies();

            Map<String, List<Movie>> moviesByCategory = new LinkedHashMap<>();

            for (Movie m : allMovies) {
                Set<Category> cats = m.getCategories();
                if (cats == null || cats.isEmpty()) {
                    moviesByCategory.computeIfAbsent("UNCATEGORIZED", k -> new ArrayList<>()).add(m);
                } else {
                    for (Category c : cats) {
                        String name = c != null ? c.getName() : "UNCATEGORIZED";
                        moviesByCategory.computeIfAbsent(name, k -> new ArrayList<>()).add(m);
                    }
                }
            }

            System.out.println("DEBUG: Found " + allMovies.size() + " movies");
            System.out.println("DEBUG: Categories: " + moviesByCategory.keySet());

            model.addAttribute("moviesByCategory", moviesByCategory);
            return "browse_movies";
        } catch (Exception e) {
            System.err.println("ERROR in browseMovies: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Unable to load movies at this time");
            return "browse_movies";
        }
    }

    @GetMapping("/browse-movies/{category}")
    public String browseMoviesByCategory(@PathVariable String category, Model model) {
        try {
            List<Movie> movies = movieService.getMoviesByCategory(category);
            model.addAttribute("movies", movies);
            model.addAttribute("category", category);
            return "movies_by_category";
        } catch (Exception e) {
            System.err.println("ERROR in browseMoviesByCategory: " + e.getMessage());
            model.addAttribute("error", "Unable to load " + category + " movies");
            return "movies_by_category";
        }
    }
}