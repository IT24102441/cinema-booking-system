package com.example.secrud.config;

import com.example.secrud.models.AdminModel;
import com.example.secrud.repos.AdminRepo;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Component
public class DataInitializer implements CommandLineRunner, WebMvcConfigurer {

    private final AdminRepo adminRepo;

    public DataInitializer(AdminRepo adminRepo) {
        this.adminRepo = adminRepo;
    }

    @Override
    public void run(String... args) throws Exception {
        final String email = "admin@gmail.com";
        final String password = "admin123";
        boolean exists = adminRepo.findByEmail(email).isPresent();
        if (!exists) {
            AdminModel admin = new AdminModel();
            admin.setName("Administrator");
            admin.setEmail(email);
            admin.setPassword(password); // plain-text for now (matches existing app behaviour)
            admin.setRole("ADMIN");
            admin.setDescription("Auto-created admin account on startup");
            adminRepo.save(admin);
            System.out.println("[INIT] Created admin user: " + email + " with password: " + password);
        } else {
            System.out.println("[INIT] Admin user already exists: " + email);
        }
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String receiptsPath = System.getProperty("user.dir") + "/uploads/receipts/";
        registry.addResourceHandler("/receipts/**")
                .addResourceLocations("file:" + receiptsPath);
    }
}
