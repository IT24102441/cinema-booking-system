package com.example.secrud.services;

import com.example.secrud.models.Category;
import com.example.secrud.repos.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    public List<Category> findAll() {
        return categoryRepository.findAll();
    }

    public List<String> findAllNames() {
        return categoryRepository.findAll().stream().map(Category::getName).collect(Collectors.toList());
    }

    public boolean existsByName(String name) {
        return categoryRepository.existsByName(name);
    }

    public Category addCategory(String name) {
        if (name == null || name.trim().isEmpty()) return null;
        String normalized = name.trim();
        if (categoryRepository.existsByName(normalized)) return categoryRepository.findByName(normalized).orElse(null);
        Category c = new Category(normalized);
        return categoryRepository.save(c);
    }

    public Category findByName(String name) {
        if (name == null) return null;
        return categoryRepository.findByName(name.trim()).orElse(null);
    }
}
