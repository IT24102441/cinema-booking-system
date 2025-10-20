package com.example.secrud.controller;

import com.example.secrud.models.Category;
import com.example.secrud.models.Movie;
import com.example.secrud.services.CategoryService;
import com.example.secrud.services.MovieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/categories")
public class CategoryController {

    @Autowired
    private MovieService movieService;

    @Autowired
    private CategoryService categoryService;

    // Predefined categories (used to seed DB if empty)
    private static final List<String> DEFAULT_CATEGORIES = Arrays.asList(
            "FAMILY", "HORROR", "ADVENTURE", "ACTION", "COMEDY",
            "DRAMA", "SCI_FI", "ROMANCE", "THRILLER", "DOCUMENTARY"
    );

    @GetMapping
    public String showCategorizationPage(Model model) {
        // Seed default categories if none exist
        if (categoryService.findAllNames().isEmpty()) {
            DEFAULT_CATEGORIES.forEach(categoryService::addCategory);
        }

        // Get all uncategorized movies
        List<Movie> uncategorizedMovies = movieService.getUncategorizedMovies();

        // Get categorized movies
        List<Movie> categorizedMovies = movieService.getCategorizedMovies();

        // Build map of category -> movies for display
        List<String> categoryNames = categoryService.findAllNames();
        Map<String, List<Movie>> moviesByCategory = categoryNames.stream()
                .collect(Collectors.toMap(name -> name, name -> movieService.getMoviesByCategory(name)));

        System.out.println("DEBUG: Uncategorized movies count: " + uncategorizedMovies.size());
        System.out.println("DEBUG: Categorized movies count: " + categorizedMovies.size());

        model.addAttribute("uncategorizedMovies", uncategorizedMovies);
        model.addAttribute("categorizedMovies", categorizedMovies);
        model.addAttribute("categories", categoryNames);
        model.addAttribute("moviesByCategory", moviesByCategory);

        return "categorize_movies";
    }

    @PostMapping("/assign")
    public String assignCategory(@RequestParam("movieId") Long movieId,
                                 @RequestParam(value = "categories", required = false) List<String> categoryNames,
                                 @RequestParam(value = "imageUrl", required = false) String imageUrl,
                                 @RequestParam(value = "price", required = false) String price,
                                 RedirectAttributes redirectAttributes) {
        try {
            System.out.println("DEBUG: Assigning categories - Movie ID: " + movieId + ", Categories: " + categoryNames);

            Movie movie = movieService.getMovieById(movieId)
                    .orElseThrow(() -> new RuntimeException("Movie not found with id: " + movieId));

            // Update optional extra fields
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                movie.setImageUrl(imageUrl.trim());
            }
            try {
                if (price != null && !price.trim().isEmpty()) {
                    java.math.BigDecimal p = new java.math.BigDecimal(price.trim());
                    movie.setPrice(p);
                }
            } catch (Exception ignored) {}

            if (categoryNames == null || categoryNames.isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "No categories selected for '" + movie.getTitle() + "'");
                return "redirect:/admin/categories";
            }

            // In CategoryController.assignCategory() method, replace this section:
            for (String categoryName : categoryNames) {
                if (categoryName == null || categoryName.trim().isEmpty()) continue;
                String normalized = categoryName.trim();
                Category cat = categoryService.findByName(normalized);
                if (cat == null) cat = categoryService.addCategory(normalized);
                if (cat != null) {
                    movie.addCategory(cat);
                }
            }
// Ensure changes are not visible on public page until explicitly published
            movie.setPublished(false);
            Movie updatedMovie = movieService.updateMovie(movieId, movie); // This will now update the category column
            System.out.println("DEBUG: Successfully assigned categories to: " + updatedMovie.getTitle());

            redirectAttributes.addFlashAttribute("successMessage", "Successfully assigned categories to '" + movie.getTitle() + "'");
        } catch (Exception e) {
            System.err.println("ERROR: Failed to assign categories: " + e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", "Error: " + e.getMessage());
        }

        return "redirect:/admin/categories";
    }

    @PostMapping("/remove")
    public String removeCategory(@RequestParam("movieId") Long movieId,
                                 @RequestParam(value = "category", required = false) String categoryName,
                                 RedirectAttributes redirectAttributes) {
        try {
            System.out.println("DEBUG: Removing category from movie ID: " + movieId + " category=" + categoryName);

            Movie movie = movieService.getMovieById(movieId)
                    .orElseThrow(() -> new RuntimeException("Movie not found"));

            if (categoryName != null && !categoryName.trim().isEmpty()) {
                Category cat = categoryService.findByName(categoryName.trim());
                if (cat != null) {
                    movie.removeCategory(cat);
                    // Unpublish when categories change
                    movie.setPublished(false);
                    movieService.updateMovie(movieId, movie);
                    redirectAttributes.addFlashAttribute("successMessage", "Category '" + cat.getName() + "' removed from '" + movie.getTitle() + "'");
                } else {
                    redirectAttributes.addFlashAttribute("errorMessage", "Category not found: " + categoryName);
                }
            } else {
                // If no category specified, remove all categories
                movie.setCategories(null);
                movie.setPublished(false);
                movieService.updateMovie(movieId, movie);
                redirectAttributes.addFlashAttribute("successMessage", "All categories removed from '" + movie.getTitle() + "'");
            }

            System.out.println("DEBUG: Successfully removed category from: " + movie.getTitle());

        } catch (Exception e) {
            System.err.println("ERROR: Failed to remove category: " + e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", "Error: " + e.getMessage());
        }

        return "redirect:/admin/categories";
    }

    // Add new category
    @PostMapping("/add")
    public String addCategory(@RequestParam("name") String name, RedirectAttributes redirectAttributes) {
        try {
            if (name == null || name.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Category name cannot be empty");
                return "redirect:/admin/categories";
            }
            String normalized = name.trim();
            if (categoryService.existsByName(normalized)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Category '" + normalized + "' already exists");
                return "redirect:/admin/categories";
            }
            categoryService.addCategory(normalized);
            redirectAttributes.addFlashAttribute("successMessage", "Category '" + normalized + "' added successfully");
        } catch (Exception e) {
            System.err.println("ERROR: Failed to add category: " + e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", "Error adding category: " + e.getMessage());
        }
        return "redirect:/admin/categories";
    }

    // Publish categorized movies to public page (existing behavior)
    @PostMapping("/publish")
    public String publishMovies(RedirectAttributes redirectAttributes) {
        try {
            List<Movie> categorizedMovies = movieService.getCategorizedMovies();
            int count = 0;
            for (Movie m : categorizedMovies) {
                if (Boolean.TRUE.equals(m.getPublished())) continue;
                m.setPublished(true);
                movieService.updateMovie(m.getId(), m);
                count++;
            }
            System.out.println("DEBUG: Published " + count + " categorized movies");
            redirectAttributes.addFlashAttribute("successMessage",
                    "Successfully published " + count + " categorized movies to the public browse page!");

        } catch (Exception e) {
            System.err.println("ERROR: Failed to publish movies: " + e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Error publishing movies: " + e.getMessage());
        }

        return "redirect:/admin/categories";
    }
}