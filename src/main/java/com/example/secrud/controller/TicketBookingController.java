package com.example.secrud.controller;

import com.example.secrud.models.TicketBookingModel;
import com.example.secrud.models.SeatModel;
import com.example.secrud.services.TicketBookingService;
import com.example.secrud.dto.BookingDTO;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/bookings")
public class TicketBookingController {

    @Autowired
    private TicketBookingService ticketBookingService;

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> createBooking(@RequestBody BookingDTO.CreateBookingRequest request) {
        try {
            TicketBookingModel booking = new TicketBookingModel();
            booking.setMovieName(request.getMovieName());
            booking.setCustomerEmail(request.getCustomerEmail());
            booking.setContactNumber(request.getContactNumber());
            booking.setCustomerName(request.getCustomerName());
            booking.setTotalPayment(request.getTotalPayment());
            booking.setPaymentStatus(request.getPaymentStatus());
            booking.setStatus(TicketBookingModel.BookingStatus.CONFIRMED);

            // set promotion details if present
            if (request.getPromotionCode() != null) {
                booking.setPromotionCode(request.getPromotionCode());
            }
            if (request.getPromoDiscount() != null) {
                booking.setPromoDiscount(request.getPromoDiscount());
            }

            // Create seat entities but don't set booking reference yet
            List<SeatModel> seats = null;
            if (request.getSeats() != null && !request.getSeats().isEmpty()) {
                seats = request.getSeats().stream().map(seatReq -> {
                    SeatModel seat = new SeatModel();
                    seat.setSeatNumber(seatReq.getSeatNumber());
                    seat.setRowNumber(seatReq.getRowNumber());
                    seat.setPrice(seatReq.getPrice());
                    return seat;
                }).collect(Collectors.toList());
                booking.setSeats(seats);
            }
            System.out.println(booking.getSeats().size());
            TicketBookingModel savedBooking = ticketBookingService.createBooking(booking);
            return ResponseEntity.status(HttpStatus.CREATED).body(convertToResponse(savedBooking));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error creating booking: " + e.getMessage());
        }
    }

    // New: create booking with receipt upload and promotion via multipart/form-data
    @PostMapping(value = "/with-receipt", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> createBookingWithReceipt(
            @RequestParam("movieName") String movieName,
            @RequestParam("customerEmail") String customerEmail,
            @RequestParam("contactNumber") String contactNumber,
            @RequestParam("customerName") String customerName,
            @RequestParam("totalPayment") BigDecimal totalPayment,
            @RequestParam(value = "promotionCode", required = false) String promotionCode,
            @RequestParam(value = "promoDiscount", required = false) BigDecimal promoDiscount,
            @RequestParam("seats") String seatsJson,
            @RequestPart(value = "receipt", required = false) MultipartFile receipt
    ) {
        try {
            TicketBookingModel booking = new TicketBookingModel();
            booking.setMovieName(movieName);
            booking.setCustomerEmail(customerEmail);
            booking.setContactNumber(contactNumber);
            booking.setCustomerName(customerName);
            booking.setTotalPayment(totalPayment);
            booking.setStatus(TicketBookingModel.BookingStatus.CONFIRMED);
            booking.setPaymentStatus(TicketBookingModel.PaymentStatus.PENDING);

            if (promotionCode != null && !promotionCode.isBlank()) booking.setPromotionCode(promotionCode);
            if (promoDiscount != null) booking.setPromoDiscount(promoDiscount);

            // Parse seats JSON
            ObjectMapper mapper = new ObjectMapper();
            List<BookingDTO.CreateSeatRequest> seatReqs = mapper.readValue(seatsJson, new TypeReference<List<BookingDTO.CreateSeatRequest>>(){});
            if (seatReqs != null && !seatReqs.isEmpty()) {
                List<SeatModel> seats = seatReqs.stream().map(sr -> {
                    SeatModel s = new SeatModel();
                    s.setSeatNumber(sr.getSeatNumber());
                    s.setRowNumber(sr.getRowNumber());
                    s.setPrice(sr.getPrice());
                    return s;
                }).collect(Collectors.toList());
                booking.setSeats(seats);
            }

            // Save receipt file if present
            if (receipt != null && !receipt.isEmpty()) {
                String uploadsDir = System.getProperty("user.dir") + "/uploads/receipts";
                Path uploadPath = Paths.get(uploadsDir);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                String original = receipt.getOriginalFilename();
                String ext = (original != null && original.contains(".")) ? original.substring(original.lastIndexOf('.')) : "";
                String newName = UUID.randomUUID().toString() + ext;
                Path target = uploadPath.resolve(newName);
                Files.copy(receipt.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
                booking.setReceiptPath(target.toAbsolutePath().toString());
            }

            TicketBookingModel saved = ticketBookingService.createBooking(booking);
            return ResponseEntity.status(HttpStatus.CREATED).body(convertToResponse(saved));
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid seats payload or file error: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error creating booking with receipt: " + e.getMessage());
        }
    }

    @PostMapping(value = "/{id}/receipt", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> uploadReceipt(@PathVariable("id") Long id,
                                           @RequestPart("receipt") MultipartFile receipt) {
        try {
            if (receipt == null || receipt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Receipt file is required");
            }
            String uploadsDir = System.getProperty("user.dir") + "/uploads/receipts";
            Path uploadPath = Paths.get(uploadsDir);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            String original = receipt.getOriginalFilename();
            String ext = (original != null && original.contains(".")) ? original.substring(original.lastIndexOf('.')) : "";
            String newName = UUID.randomUUID().toString() + ext;
            Path target = uploadPath.resolve(newName);
            Files.copy(receipt.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);

            TicketBookingModel updated = ticketBookingService.updateReceiptPath(id, target.toAbsolutePath().toString());
            if (updated == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Booking not found");
            }
            return ResponseEntity.ok().body("Receipt uploaded successfully");
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("File error: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error uploading receipt: " + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getBookingById(@PathVariable Long id) {
        try {
            Optional<TicketBookingModel> booking = ticketBookingService.getBookingById(id);
            if (booking.isPresent()) {
                return ResponseEntity.ok(convertToResponse(booking.get()));
            }
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Booking not found");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving booking: " + e.getMessage());
        }
    }

    @GetMapping
    public ResponseEntity<?> getAllBookings() {
        try {
            List<TicketBookingModel> bookings = ticketBookingService.getAllBookings();
            List<BookingDTO.BookingResponse> responses = bookings.stream()
                    .map(this::convertToResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(responses);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving bookings: " + e.getMessage());
        }
    }

    @GetMapping("/email/{email}")
    public ResponseEntity<?> getBookingsByEmail(@PathVariable String email) {
        try {
            List<TicketBookingModel> bookings = ticketBookingService.getBookingsByEmail(email);
            List<BookingDTO.BookingResponse> responses = bookings.stream()
                    .map(this::convertToResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(responses);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving bookings: " + e.getMessage());
        }
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<?> getBookingsByStatus(@PathVariable TicketBookingModel.BookingStatus status) {
        try {
            List<TicketBookingModel> bookings = ticketBookingService.getBookingsByStatus(status);
            List<BookingDTO.BookingResponse> responses = bookings.stream()
                    .map(this::convertToResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(responses);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving bookings: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateBooking(@PathVariable Long id, @RequestBody BookingDTO.UpdateBookingRequest request) {
        try {
            TicketBookingModel bookingDetails = new TicketBookingModel();
            bookingDetails.setMovieName(request.getMovieName());
            bookingDetails.setCustomerEmail(request.getCustomerEmail());
            bookingDetails.setContactNumber(request.getContactNumber());
            bookingDetails.setCustomerName(request.getCustomerName());
            bookingDetails.setTotalPayment(request.getTotalPayment());
            bookingDetails.setStatus(request.getStatus());
            bookingDetails.setPaymentStatus(request.getPaymentStatus());

            TicketBookingModel updatedBooking = ticketBookingService.updateBooking(id, bookingDetails);
            if (updatedBooking != null) {
                return ResponseEntity.ok(convertToResponse(updatedBooking));
            }
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Booking not found");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error updating booking: " + e.getMessage());
        }
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<?> updateBookingStatus(@PathVariable Long id, @RequestBody BookingDTO.StatusUpdateRequest request) {
        try {
            ticketBookingService.updateBookingStatus(id, request.getStatus());
            return ResponseEntity.ok("Booking status updated successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error updating booking status: " + e.getMessage());
        }
    }

    @PatchMapping("/{id}/payment-status")
    public ResponseEntity<?> updatePaymentStatus(@PathVariable Long id, @RequestBody BookingDTO.PaymentStatusUpdateRequest request) {
        try {
            ticketBookingService.updatePaymentStatus(id, request.getPaymentStatus());
            return ResponseEntity.ok("Payment status updated successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error updating payment status: " + e.getMessage());
        }
    }

    @PostMapping("/{id}/seats")
    public ResponseEntity<?> addSeatsToBooking(@PathVariable Long id, @RequestBody BookingDTO.AddSeatsRequest request) {
        try {
            List<SeatModel> seats = request.getSeats().stream().map(seatReq -> {
                SeatModel seat = new SeatModel();
                seat.setSeatNumber(seatReq.getSeatNumber());
                seat.setRowNumber(seatReq.getRowNumber());
                seat.setPrice(seatReq.getPrice());
                return seat;
            }).collect(Collectors.toList());

            TicketBookingModel updatedBooking = ticketBookingService.addSeatsToBooking(id, seats);
            if (updatedBooking != null) {
                return ResponseEntity.ok(convertToResponse(updatedBooking));
            }
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Booking not found");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error adding seats: " + e.getMessage());
        }
    }

    @PatchMapping("/{id}/cancel")
    public ResponseEntity<?> cancelBooking(@PathVariable Long id) {
        try {
            ticketBookingService.cancelBooking(id);
            return ResponseEntity.ok("Booking cancelled successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error cancelling booking: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteBooking(@PathVariable Long id) {
        try {
            ticketBookingService.deleteBooking(id);
            return ResponseEntity.ok("Booking deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error deleting booking: " + e.getMessage());
        }
    }

    private BookingDTO.BookingResponse convertToResponse(TicketBookingModel booking) {
        BookingDTO.BookingResponse response = new BookingDTO.BookingResponse();
        response.setId(booking.getId());
        response.setMovieName(booking.getMovieName());
        response.setCreatedAt(booking.getCreatedAt());
        response.setUpdatedAt(booking.getUpdatedAt());
        response.setStatus(booking.getStatus());
        response.setCustomerEmail(booking.getCustomerEmail());
        response.setContactNumber(booking.getContactNumber());
        response.setCustomerName(booking.getCustomerName());
        response.setTotalPayment(booking.getTotalPayment());
        response.setPaymentStatus(booking.getPaymentStatus());
        // Map receipt path to a web URL if available
        if (booking.getReceiptPath() != null && !booking.getReceiptPath().isEmpty()) {
            try {
                java.nio.file.Path p = java.nio.file.Paths.get(booking.getReceiptPath());
                String fileName = p.getFileName().toString();
                String url = "/receipts/" + fileName;
                response.setReceiptUrl(url);
            } catch (Exception ignored) {}
        }

        if (booking.getSeats() != null) {
            List<BookingDTO.SeatResponse> seatResponses = booking.getSeats().stream().map(seat -> {
                BookingDTO.SeatResponse seatResponse = new BookingDTO.SeatResponse();
                seatResponse.setId(seat.getId());
                seatResponse.setSeatNumber(seat.getSeatNumber());
                seatResponse.setRowNumber(seat.getRowNumber());
                seatResponse.setPrice(seat.getPrice());
                return seatResponse;
            }).collect(Collectors.toList());
            response.setSeats(seatResponses);
        }

        return response;
    }
}