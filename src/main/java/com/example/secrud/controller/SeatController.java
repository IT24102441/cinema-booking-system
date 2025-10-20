package com.example.secrud.controller;

import com.example.secrud.models.SeatModel;
import com.example.secrud.models.TicketBookingModel;
import com.example.secrud.services.SeatService;
import com.example.secrud.services.TicketBookingService;
import com.example.secrud.dto.SeatDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/seats")
public class SeatController {

    @Autowired
    private SeatService seatService;

    @Autowired
    private TicketBookingService ticketBookingService;

    @PostMapping
    public ResponseEntity<?> createSeat(@RequestBody SeatDTO.CreateSeatRequest request) {
        try {
            SeatModel seat = new SeatModel();
            seat.setSeatNumber(request.getSeatNumber());
            seat.setRowNumber(request.getRowNumber());
            seat.setPrice(request.getPrice());

            if (request.getBookingId() != null) {
                Optional<TicketBookingModel> booking = ticketBookingService.getBookingById(request.getBookingId());
                if (booking.isPresent()) {
                    seat.setBooking(booking.get());
                } else {
                    return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Booking not found");
                }
            }

            SeatModel savedSeat = seatService.createSeat(seat);
            return ResponseEntity.status(HttpStatus.CREATED).body(convertToResponse(savedSeat));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error creating seat: " + e.getMessage());
        }
    }

    @PostMapping("/multiple")
    public ResponseEntity<?> createMultipleSeats(@RequestBody SeatDTO.CreateMultipleSeatsRequest request) {
        try {
            List<SeatModel> seats = request.getSeats().stream().map(seatReq -> {
                SeatModel seat = new SeatModel();
                seat.setSeatNumber(seatReq.getSeatNumber());
                seat.setRowNumber(seatReq.getRowNumber());
                seat.setPrice(seatReq.getPrice());

                if (seatReq.getBookingId() != null) {
                    Optional<TicketBookingModel> booking = ticketBookingService.getBookingById(seatReq.getBookingId());
                    if (booking.isPresent()) {
                        seat.setBooking(booking.get());
                    }
                }
                return seat;
            }).collect(Collectors.toList());

            List<SeatModel> savedSeats = seatService.createSeats(seats);
            List<SeatDTO.SeatResponse> responses = savedSeats.stream()
                    .map(this::convertToResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.status(HttpStatus.CREATED).body(responses);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error creating seats: " + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getSeatById(@PathVariable Long id) {
        try {
            Optional<SeatModel> seat = seatService.getSeatById(id);
            if (seat.isPresent()) {
                return ResponseEntity.ok(convertToResponse(seat.get()));
            }
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Seat not found");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving seat: " + e.getMessage());
        }
    }

    @GetMapping
    public ResponseEntity<?> getAllSeats() {
        try {
            List<SeatModel> seats = seatService.getAllSeats();
            List<SeatDTO.SeatResponse> responses = seats.stream()
                    .map(this::convertToResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(responses);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving seats: " + e.getMessage());
        }
    }

    @GetMapping("/booking/{bookingId}")
    public ResponseEntity<?> getSeatsByBookingId(@PathVariable Long bookingId) {
        try {
            List<SeatModel> seats = seatService.getSeatsByBookingId(bookingId);
            List<SeatDTO.SeatResponse> responses = seats.stream()
                    .map(this::convertToResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(responses);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving seats: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateSeat(@PathVariable Long id, @RequestBody SeatDTO.UpdateSeatRequest request) {
        try {
            SeatModel seatDetails = new SeatModel();
            seatDetails.setSeatNumber(request.getSeatNumber());
            seatDetails.setRowNumber(request.getRowNumber());
            seatDetails.setPrice(request.getPrice());

            SeatModel updatedSeat = seatService.updateSeat(id, seatDetails);
            if (updatedSeat != null) {
                return ResponseEntity.ok(convertToResponse(updatedSeat));
            }
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Seat not found");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error updating seat: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteSeat(@PathVariable Long id) {
        try {
            seatService.deleteSeat(id);
            return ResponseEntity.ok("Seat deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error deleting seat: " + e.getMessage());
        }
    }

    @DeleteMapping("/booking/{bookingId}")
    public ResponseEntity<?> deleteSeatsByBookingId(@PathVariable Long bookingId) {
        try {
            seatService.deleteSeatsByBookingId(bookingId);
            return ResponseEntity.ok("Seats deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error deleting seats: " + e.getMessage());
        }
    }

    private SeatDTO.SeatResponse convertToResponse(SeatModel seat) {
        SeatDTO.SeatResponse response = new SeatDTO.SeatResponse();
        response.setId(seat.getId());
        response.setSeatNumber(seat.getSeatNumber());
        response.setRowNumber(seat.getRowNumber());
        response.setPrice(seat.getPrice());

        if (seat.getBooking() != null) {
            response.setBookingId(seat.getBooking().getId());
        }

        return response;
    }
}