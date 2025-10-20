package com.example.secrud.views;

import com.example.secrud.models.TicketBookingModel;
import com.example.secrud.services.TicketBookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.Optional;

@Controller
public class BookingReceiptViews {

    @Autowired
    private TicketBookingService bookingService;

    @GetMapping("/bookings/{id}/upload-receipt")
    public String showUploadReceipt(@PathVariable("id") Long id, Model model) {
        Optional<TicketBookingModel> bookingOpt = bookingService.getBookingById(id);
        if (bookingOpt.isEmpty()) {
            return "redirect:/";
        }
        model.addAttribute("booking", bookingOpt.get());
        return "upload_receipt";
    }
}
