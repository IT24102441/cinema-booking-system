package com.example.secrud.controller;

import com.example.secrud.dto.UserDTO;
import com.example.secrud.models.UserModel;
import com.example.secrud.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping
    public ResponseEntity<?> createUser(@RequestBody UserModel user) {
        try {
            System.out.println("=== REGISTRATION ATTEMPT ===");
            System.out.println("Email: " + user.getEmail());

            // Normalize email
            if (user.getEmail() != null) {
                user.setEmail(user.getEmail().trim().toLowerCase());
                System.out.println("Normalized email to: " + user.getEmail());
            }

            // Validation
            if (user.getFirstName() == null || user.getFirstName().trim().length() < 2 || user.getFirstName().trim().length() > 20) {
                return errorResponse("INVALID_FIRST_NAME", "First name must be between 2 and 20 characters");
            }

            if (user.getLastName() == null || user.getLastName().trim().length() < 2 || user.getLastName().trim().length() > 20) {
                return errorResponse("INVALID_LAST_NAME", "Last name must be between 2 and 20 characters");
            }

            if (user.getEmail() == null || user.getEmail().trim().isEmpty() || !user.getEmail().contains("@")) {
                return errorResponse("INVALID_EMAIL", "Valid email is required");
            }

            // Enhanced email check
            System.out.println("🔍 Enhanced email check for: " + user.getEmail());

            // Method 1: Repository check
            Optional<UserModel> existingUser = userService.getUserByEmail(user.getEmail());

            // Method 2: Manual check in case repository has issues
            if (!existingUser.isPresent()) {
                List<UserModel> allUsers = userService.getAllUsers();
                existingUser = allUsers.stream()
                        .filter(u -> u.getEmail().equalsIgnoreCase(user.getEmail()))
                        .findFirst();
            }

            if (existingUser.isPresent()) {
                System.out.println("❌ Email CONFIRMED as duplicate: " + user.getEmail());
                System.out.println("❌ Existing user ID: " + existingUser.get().getId());
                return errorResponse("EMAIL_EXISTS", "An account with this email already exists");
            }

            System.out.println("✅ Email confirmed available, creating user...");

            UserModel savedUser = userService.createUser(user);
            System.out.println("✅ User created successfully with ID: " + savedUser.getId());

            return ResponseEntity.status(HttpStatus.CREATED).body(savedUser);

        } catch (Exception e) {
            System.out.println("❌ ERROR in createUser: " + e.getMessage());

            // Specific handling for duplicate key error
            if (e.getMessage() != null && e.getMessage().contains("Duplicate entry")) {
                System.out.println("🚨 DATABASE CONSTRAINT VIOLATION - Email exists in database but our check missed it!");

                // Suggest using a different email
                return errorResponse("EMAIL_CONSTRAINT_VIOLATION",
                        "This email appears to be registered in our system. Please use a different email address or try: " +
                                "test" + System.currentTimeMillis() + "@example.com");
            }

            e.printStackTrace();
            return errorResponse("SERVER_ERROR", "Error creating user account");
        }
    }

    // Add this helper method
    private ResponseEntity<?> errorResponse(String error, String message) {
        Map<String, String> response = new HashMap<>();
        response.put("error", error);
        response.put("message", message);

        HttpStatus status = "SERVER_ERROR".equals(error) ? HttpStatus.INTERNAL_SERVER_ERROR : HttpStatus.BAD_REQUEST;
        if (error.contains("EMAIL")) {
            status = HttpStatus.CONFLICT;
        }

        return ResponseEntity.status(status).body(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getUserById(@PathVariable Long id) {
        try {
            Optional<UserModel> user = userService.getUserById(id);
            if (user.isPresent()) {
                return ResponseEntity.ok(user.get());
            }
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error retrieving user: " + e.getMessage());
        }
    }

    @GetMapping("/email/{email}")
    public ResponseEntity<?> getUserByEmail(@PathVariable String email) {
        try {
            Optional<UserModel> user = userService.getUserByEmail(email);
            if (user.isPresent()) {
                return ResponseEntity.ok(user.get());
            }
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error retrieving user: " + e.getMessage());
        }
    }

    @GetMapping
    public ResponseEntity<?> getAllUsers() {
        try {
            List<UserModel> users = userService.getAllUsers();
            return ResponseEntity.ok(users);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error retrieving users: " + e.getMessage());
        }
    }

    @GetMapping("/delete-status/{status}")
    public ResponseEntity<?> getUsersByDeleteStatus(@PathVariable boolean status) {
        try {
            List<UserModel> users = userService.getUsersByDeleteStatus(status);
            return ResponseEntity.ok(users);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error retrieving users: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateUser(@PathVariable Long id, @RequestBody UserDTO.UpdateUserRequest userDetails) {
        try {
            Optional<UserModel> existingUserOpt = userService.getUserById(id);
            if(existingUserOpt.isEmpty()){
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
            }
            UserModel existingUser = existingUserOpt.get();

            UserModel savingUser = new UserModel();
            savingUser.setId(existingUser.getId());
            savingUser.setContactNumber(
                    userDetails.getContactNumber() == null
                            ? existingUser.getContactNumber()
                            : userDetails.getContactNumber()
            );
            savingUser.setEmail(existingUser.getEmail());
            savingUser.setFirstName(
                    userDetails.getFirstName() == null
                            ? existingUser.getFirstName()
                            : userDetails.getFirstName()
            );
            savingUser.setLastName(
                    userDetails.getLastName() == null
                            ? existingUser.getLastName()
                            : userDetails.getLastName()
            );
            savingUser.setPassword(
                    userDetails.getPassword() == null
                            ? existingUser.getPassword()
                            : userDetails.getPassword()
            );
            savingUser.setDeleteStatus(
                    userDetails.getDeleteStatus() == null
                            ? existingUser.isDeleteStatus()
                            : userDetails.getDeleteStatus()
            );
            savingUser.setCreatedAt(existingUser.getCreatedAt());

            UserModel updatedUser = userService.updateUser(id, savingUser);
            if (updatedUser != null) {
                return ResponseEntity.ok(updatedUser);
            }
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error updating user: " + e.getMessage());
        }
    }

    // New endpoint for profile updates with current password verification
    @PutMapping("/{id}/profile")
    public ResponseEntity<?> updateProfile(
            @PathVariable Long id,
            @RequestBody UserDTO.UpdateProfileRequest profileDetails) {
        try {
            // Verify current password if trying to change password
            if (profileDetails.getNewPassword() != null && !profileDetails.getNewPassword().isEmpty()) {
                if (profileDetails.getCurrentPassword() == null || profileDetails.getCurrentPassword().isEmpty()) {
                    Map<String, String> errorResponse = new HashMap<>();
                    errorResponse.put("error", "CURRENT_PASSWORD_REQUIRED");
                    errorResponse.put("message", "Current password is required to change password");
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
                }

                boolean isCurrentPasswordValid = userService.verifyCurrentPassword(
                        id, profileDetails.getCurrentPassword());

                if (!isCurrentPasswordValid) {
                    Map<String, String> errorResponse = new HashMap<>();
                    errorResponse.put("error", "INVALID_CURRENT_PASSWORD");
                    errorResponse.put("message", "Current password is incorrect");
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
                }
            }

            UserModel updatedUser = userService.updateUserProfile(id, profileDetails);
            if (updatedUser != null) {
                return ResponseEntity.ok(updatedUser);
            }
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error updating profile: " + e.getMessage());
        }
    }

    @PatchMapping("/{id}/first-name")
    public ResponseEntity<?> updateFirstName(@PathVariable Long id, @RequestBody String firstName) {
        try {
            userService.updateFirstName(id, firstName);
            return ResponseEntity.ok("First name updated successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error updating first name: " + e.getMessage());
        }
    }

    @PatchMapping("/{id}/last-name")
    public ResponseEntity<?> updateLastName(@PathVariable Long id, @RequestBody String lastName) {
        try {
            userService.updateLastName(id, lastName);
            return ResponseEntity.ok("Last name updated successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error updating last name: " + e.getMessage());
        }
    }

    @PatchMapping("/{id}/contact")
    public ResponseEntity<?> updateContactNumber(@PathVariable Long id, @RequestBody String contactNumber) {
        try {
            userService.updateContactNumber(id, contactNumber);
            return ResponseEntity.ok("Contact number updated successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error updating contact number: " + e.getMessage());
        }
    }

    @PatchMapping("/{id}/password")
    public ResponseEntity<?> updatePassword(@PathVariable Long id, @RequestBody UserDTO.UpdatePasswordRequest passwordRequest) {
        try {
            // Verify current password
            boolean isCurrentPasswordValid = userService.verifyCurrentPassword(id, passwordRequest.getCurrentPassword());
            if (!isCurrentPasswordValid) {
                Map<String, String> errorResponse = new HashMap<>();
                errorResponse.put("error", "INVALID_CURRENT_PASSWORD");
                errorResponse.put("message", "Current password is incorrect");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
            }

            userService.updatePassword(id, passwordRequest.getNewPassword());
            return ResponseEntity.ok("Password updated successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error updating password: " + e.getMessage());
        }
    }

    @PatchMapping("/{id}/delete-status")
    public ResponseEntity<?> updateDeleteStatus(@PathVariable Long id, @RequestBody boolean deleteStatus) {
        try {
            userService.updateDeleteStatus(id, deleteStatus);
            return ResponseEntity.ok("Delete status updated successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error updating delete status: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        try {
            userService.deleteUser(id);
            return ResponseEntity.ok("User deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error deleting user: " + e.getMessage());
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestParam String email, @RequestParam String password) {
        try {
            Optional<UserModel> user = userService.login(email, password);
            if (user.isPresent()) {
                return ResponseEntity.ok(user.get());
            }
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid credentials");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error during login: " + e.getMessage());
        }
    }

    // Current user endpoint
    @GetMapping("/current")
    public ResponseEntity<?> getCurrentUser() {
        try {
            // This is a placeholder - you'll need to implement proper authentication
            return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED)
                    .body("Current user endpoint not implemented yet");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error retrieving current user: " + e.getMessage());
        }
    }

    @DeleteMapping("/debug/cleanup-duplicates")
    public ResponseEntity<?> cleanupDuplicateEmails() {
        try {
            List<UserModel> allUsers = userService.getAllUsers();
            Map<String, List<UserModel>> emailGroups = new HashMap<>();

            // Group users by email
            for (UserModel user : allUsers) {
                emailGroups.computeIfAbsent(user.getEmail().toLowerCase(), k -> new ArrayList<>()).add(user);
            }

            // Remove duplicates (keep the first one, delete others)
            int removedCount = 0;
            for (Map.Entry<String, List<UserModel>> entry : emailGroups.entrySet()) {
                if (entry.getValue().size() > 1) {
                    System.out.println("Found duplicate email: " + entry.getKey() + " with " + entry.getValue().size() + " entries");
                    // Keep the first one, delete the rest
                    for (int i = 1; i < entry.getValue().size(); i++) {
                        userService.deleteUser(entry.getValue().get(i).getId());
                        removedCount++;
                    }
                }
            }

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Removed " + removedCount + " duplicate users");
            response.put("remainingUsers", userService.getAllUsers().size());
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error cleaning duplicates: " + e.getMessage());
        }
    }
}