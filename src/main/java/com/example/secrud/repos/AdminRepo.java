package com.example.secrud.repos;

import com.example.secrud.models.AdminModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AdminRepo extends JpaRepository<AdminModel, Long> {

    // Optional: Custom method to find admin by email (useful for login)
    Optional<AdminModel> findByEmail(String email);
}