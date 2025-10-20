package com.example.secrud.views;

import com.example.secrud.models.Category;
import com.example.secrud.models.Movie;
import com.example.secrud.services.CategoryService;
import com.example.secrud.services.MovieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
public class MovieEditViewController {

    @Autowired
    private MovieService movieService;

    @Autowired
    private CategoryService categoryService;

    @GetMapping("/admin/movies/edit-form/{id}")
    public String editMovieForm(@PathVariable Long id, Model model) {
        Movie movie = movieService.getMovieById(id).orElse(null);
        if (movie == null) {
            model.addAttribute("error", "Movie not found");
            return "edit_movie_categories"; // JSP will show error
        }
        List<String> categories = categoryService.findAllNames();
        Set<String> assigned = movie.getCategories() != null ? movie.getCategories().stream().map(Category::getName).collect(Collectors.toSet()) : Set.of();
        model.addAttribute("movie", movie);
        model.addAttribute("categories", categories);
        model.addAttribute("assigned", assigned);
        return "edit_movie_categories";
    }
}
