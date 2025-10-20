package com.example.secrud.services;

import com.example.secrud.dto.UserDTO;
import com.example.secrud.models.UserModel;
import com.example.secrud.repos.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepo userRepo;

    @Transactional
    public UserModel createUser(UserModel user) {
        return userRepo.save(user);
    }

    public Optional<UserModel> getUserById(Long id) {
        return userRepo.findById(id);
    }

    public Optional<UserModel> getUserByEmail(String email) {
        System.out.println("🔍 UserService: Searching for email: " + email);
        Optional<UserModel> user = userRepo.findByEmail(email);
        if (user.isPresent()) {
            System.out.println("🔍 UserService: Found existing user with email: " + email);
        } else {
            System.out.println("🔍 UserService: No user found with email: " + email);
        }
        return user;
    }

    public List<UserModel> getAllUsers() {
        return userRepo.findAll();
    }

    public List<UserModel> getUsersByDeleteStatus(boolean deleteStatus) {
        return userRepo.findByDeleteStatus(deleteStatus);
    }

    @Transactional
    public UserModel updateUser(Long id, UserModel userDetails) {
        Optional<UserModel> optionalUser = userRepo.findById(id);
        if (optionalUser.isPresent()) {
            UserModel user = optionalUser.get();
            user.setFirstName(userDetails.getFirstName());
            user.setLastName(userDetails.getLastName());
            user.setContactNumber(userDetails.getContactNumber());
            user.setPassword(userDetails.getPassword());
            user.setDeleteStatus(userDetails.isDeleteStatus());
            return userRepo.save(user);
        }
        return null;
    }

    // Make sure this method exists and matches the DTO
    @Transactional
    public UserModel updateUserProfile(Long id, UserDTO.UpdateProfileRequest profileDetails) {
        Optional<UserModel> optionalUser = userRepo.findById(id);
        if (optionalUser.isPresent()) {
            UserModel user = optionalUser.get();

            // Update fields if provided
            if (profileDetails.getFirstName() != null && !profileDetails.getFirstName().isEmpty()) {
                user.setFirstName(profileDetails.getFirstName());
            }
            if (profileDetails.getLastName() != null && !profileDetails.getLastName().isEmpty()) {
                user.setLastName(profileDetails.getLastName());
            }
            if (profileDetails.getContactNumber() != null && !profileDetails.getContactNumber().isEmpty()) {
                user.setContactNumber(profileDetails.getContactNumber());
            }
            // Update password if provided and current password was verified in controller
            if (profileDetails.getNewPassword() != null && !profileDetails.getNewPassword().isEmpty()) {
                user.setPassword(profileDetails.getNewPassword());
            }

            return userRepo.save(user);
        }
        return null;
    }

    // Add this method to verify current password
    public boolean verifyCurrentPassword(Long id, String currentPassword) {
        Optional<UserModel> optionalUser = userRepo.findById(id);
        if (optionalUser.isPresent()) {
            UserModel user = optionalUser.get();
            return user.getPassword().equals(currentPassword);
        }
        return false;
    }

    @Transactional
    public void updateFirstName(Long id, String firstName) {
        userRepo.updateFirstName(id, firstName);
    }

    @Transactional
    public void updateLastName(Long id, String lastName) {
        userRepo.updateLastName(id, lastName);
    }

    @Transactional
    public void updateContactNumber(Long id, String contactNumber) {
        userRepo.updateContactNumber(id, contactNumber);
    }

    @Transactional
    public void updatePassword(Long id, String password) {
        userRepo.updatePassword(id, password);
    }

    @Transactional
    public void updateDeleteStatus(Long id, boolean deleteStatus) {
        userRepo.updateDeleteStatus(id, deleteStatus);
    }

    @Transactional
    public void deleteUser(Long id) {
        userRepo.deleteById(id);
    }

    @Transactional(readOnly = true)
    public Optional<UserModel> login(String email, String password) {
        Optional<UserModel> optionalUser = userRepo.findByEmail(email);
        if (optionalUser.isPresent()) {
            UserModel user = optionalUser.get();
            if (user.getPassword().equals(password) && !user.isDeleteStatus()) {
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }
}