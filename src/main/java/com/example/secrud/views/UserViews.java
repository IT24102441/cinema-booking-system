package com.example.secrud.views;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class UserViews {
    @GetMapping("/login")
    public String login(){
        return "login";
    }

    @GetMapping("/register")
    public String register(){
        return "register";
    }

    @GetMapping("/profile")
    public String profile(){
        return "profile";
    }

    @GetMapping("/cinemas")
    public String cinemas(){
        return "cinemas";
    }

    @GetMapping("/user-management")
    public String userManagement(){
        return "user_list";
    }

    // Admin list route moved to AdminViewController to avoid conflicts

    @GetMapping("/admin-login")
    public String adminLogin(){
        return "admin_login";
    }

    // Admin dashboard route moved to AdminViewController to avoid conflicts
    @GetMapping({"/admin/dashboard","/admin-dashbaord"})
    public String adminDasbaord(){
        return "admin_dashboard";
    }


}
