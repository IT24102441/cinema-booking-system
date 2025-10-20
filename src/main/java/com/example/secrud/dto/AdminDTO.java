package com.example.secrud.dto;



public class AdminDTO {

    // 🔹 General DTO for CRUD operations (safe for responses)
    public static class Response {
        private Long id;
        private String name;
        private String role;
        private String email;
        private String description;

        public Response() {}

        public Response(Long id, String name, String role, String email, String description) {
            this.id = id;
            this.name = name;
            this.role = role;
            this.email = email;
            this.description = description;
        }

        // Getters and Setters
        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public String getName() { return name; }
        public void setName(String name) { this.name = name; }

        public String getRole() { return role; }
        public void setRole(String role) { this.role = role; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
    }

    // 🔹 DTO for creating or updating an admin (includes password for creation)
    public static class Request {
        private String name;
        private String role;
        private String password;
        private String email;
        private String description;

        public Request() {}

        // Getters and Setters
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }

        public String getRole() { return role; }
        public void setRole(String role) { this.role = role; }

        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
    }

    // 🔹 DTO for admin login requests
    public static class LoginRequest {

        private String email;

        private String password;

        public LoginRequest() {}

        public LoginRequest(String email, String password) {
            this.email = email;
            this.password = password;
        }

        // Getters and Setters
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }
    }

    // 🔹 DTO for successful login response (e.g., with token)
    public static class LoginResponse {
        private Long id;
        private String name;
        private String email;
        private String role;
        private String token; // e.g., JWT token

        public LoginResponse() {}

        public LoginResponse(Long id, String name, String email, String role, String token) {
            this.id = id;
            this.name = name;
            this.email = email;
            this.role = role;
            this.token = token;
        }

        // Getters and Setters
        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public String getName() { return name; }
        public void setName(String name) { this.name = name; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getRole() { return role; }
        public void setRole(String role) { this.role = role; }

        public String getToken() { return token; }
        public void setToken(String token) { this.token = token; }
    }
}