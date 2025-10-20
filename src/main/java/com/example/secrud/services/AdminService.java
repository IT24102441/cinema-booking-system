package com.example.secrud.services;

import com.example.secrud.dto.AdminDTO;
import com.example.secrud.models.AdminModel;
import com.example.secrud.repos.AdminRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class AdminService {

    private final AdminRepo adminRepo;

    @Autowired
    public AdminService(AdminRepo adminRepo) {
        this.adminRepo = adminRepo;
    }

    // 🔹 CREATE
    public AdminDTO.Response createAdmin(AdminDTO.Request request) {
        if (adminRepo.findByEmail(request.getEmail()).isPresent()) {
            throw new RuntimeException("Admin with email " + request.getEmail() + " already exists");
        }

        AdminModel admin = new AdminModel();
        admin.setName(request.getName());
        admin.setRole(request.getRole());
        admin.setEmail(request.getEmail());
        admin.setDescription(request.getDescription());
        admin.setPassword(request.getPassword()); // Plain text password

        AdminModel savedAdmin = adminRepo.save(admin);
        return toResponseDto(savedAdmin);
    }

    // 🔹 READ ALL
    public List<AdminDTO.Response> getAllAdmins() {
        return adminRepo.findAll().stream()
                .map(this::toResponseDto)
                .collect(Collectors.toList());
    }

    // 🔹 READ BY ID
    public AdminDTO.Response getAdminById(Long id) {
        AdminModel admin = adminRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Admin not found with id: " + id));
        return toResponseDto(admin);
    }

    // 🔹 UPDATE
    public AdminDTO.Response updateAdmin(Long id, AdminDTO.Request request) {
        AdminModel existingAdmin = adminRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Admin not found with id: " + id));

        if (!existingAdmin.getEmail().equals(request.getEmail())) {
            if (adminRepo.findByEmail(request.getEmail()).isPresent()) {
                throw new RuntimeException("Another admin already uses email: " + request.getEmail());
            }
        }

        existingAdmin.setName(request.getName());
        existingAdmin.setRole(request.getRole());
        existingAdmin.setEmail(request.getEmail());
        existingAdmin.setDescription(request.getDescription());
        System.out.println("Password "+existingAdmin.getPassword());

        AdminModel updatedAdmin = adminRepo.save(existingAdmin);
        return toResponseDto(updatedAdmin);
    }

    // 🔹 DELETE
    public void deleteAdmin(Long id) {
        if (!adminRepo.existsById(id)) {
            throw new RuntimeException("Admin not found with id: " + id);
        }
        adminRepo.deleteById(id);
    }

    // 🔹 LOGIN (plain text comparison)
    public AdminModel authenticate(String email, String rawPassword) {
        // Hard-coded fallback admin account
        if ("admin".equals(email) && "admin123".equals(rawPassword)) {
            return adminRepo.findByEmail(email).orElseGet(() -> {
                AdminModel admin = new AdminModel();
                admin.setId(0L);
                admin.setName("Administrator");
                admin.setEmail("admin@gmail.com");
                admin.setPassword("admin123");
                admin.setRole("ADMIN");
                admin.setDescription("Hard-coded fallback admin account");
                return admin;
            });
        }

        AdminModel admin = adminRepo.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Invalid email or password"));
        if (!admin.getPassword().equals(rawPassword)) {
            throw new RuntimeException("Invalid email or password");
        }
        return admin;
    }

    // 🔹 Helper: Convert Entity → Response DTO
    private AdminDTO.Response toResponseDto(AdminModel admin) {
        return new AdminDTO.Response(
                admin.getId(),
                admin.getName(),
                admin.getRole(),
                admin.getEmail(),
                admin.getDescription()
        );
    }
}