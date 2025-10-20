package com.example.secrud.views;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TicketBookingViews {

    @GetMapping("/")
    public  String home(){
        return  "index";
    }

    @GetMapping("/create-booking")
    public  String createBooking(){
        return  "create";
    }

    @GetMapping("/edit-booking")
    public  String editBooking(){
        return  "edit";
    }

    @GetMapping("/admin/bookings")
    public  String adminList(){
        return  "list";
    }

    @GetMapping("/my-bookings")
    public  String userList(){
        return  "user_bookings";
    }


}
