package com.example.secrud.views;

import com.example.secrud.services.CategoryService;
import com.example.secrud.services.MovieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MovieViews {

    @Autowired
    private MovieService movieService;

    @Autowired
    private CategoryService categoryService;

    @GetMapping(value = "/admin/movies", produces = MediaType.TEXT_HTML_VALUE)
    public String manageMovies(Model model) {
        model.addAttribute("categories", categoryService.findAllNames());
        return "add_movie"; // returns WEB-INF/views/add_movie.jsp for HTML requests
    }

    @GetMapping("/admin/view-added-movies")
    public String viewAddedMovies(Model model) {
        model.addAttribute("movies", movieService.getAllMovies());
        return "admin_movies"; // returns WEB-INF/views/admin_movies.jsp with movies in model
    }

}
