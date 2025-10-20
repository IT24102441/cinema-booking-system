package com.example.secrud.services;

import com.example.secrud.models.TicketBookingModel;
import com.example.secrud.models.SeatModel;
import com.example.secrud.repos.TicketBookingRepo;
import com.example.secrud.repos.SeatRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Service
public class TicketBookingService {

    @Autowired
    private TicketBookingRepo ticketBookingRepo;

    @Autowired
    private SeatRepo seatRepo;

    @Transactional
    public TicketBookingModel createBooking(TicketBookingModel booking) {
        List<SeatModel> seats= booking.getSeats();
        booking.setSeats(null);

        booking.setStatus(TicketBookingModel.BookingStatus.CONFIRMED);
        TicketBookingModel savedBooking = ticketBookingRepo.save(booking);
        System.out.println("Booking id is "+savedBooking.getId());
        // Then save seats with booking reference
        if (seats != null && !seats.isEmpty()) {
            for (SeatModel seat : seats) {
                seat.setBooking(savedBooking);
            }
            List<SeatModel> savedSeats = seatRepo.saveAll(seats);
            savedBooking.setSeats(savedSeats);
        }

        return savedBooking;
    }

    public Optional<TicketBookingModel> getBookingById(Long id) {
        return ticketBookingRepo.findByIdWithSeatsLoaded(id);
    }

    public List<TicketBookingModel> getAllBookings() {
        return ticketBookingRepo.findAll();
    }

    public List<TicketBookingModel> getBookingsByEmail(String email) {
        return ticketBookingRepo.findByCustomerEmail(email);
    }

    public List<TicketBookingModel> getBookingsByStatus(TicketBookingModel.BookingStatus status) {
        return ticketBookingRepo.findByStatus(status);
    }

    public List<TicketBookingModel> getBookingsByPaymentStatus(TicketBookingModel.PaymentStatus paymentStatus) {
        return ticketBookingRepo.findByPaymentStatus(paymentStatus);
    }

    @Transactional
    public TicketBookingModel updateBooking(Long id, TicketBookingModel bookingDetails) {
        Optional<TicketBookingModel> optionalBooking = ticketBookingRepo.findById(id);
        if (optionalBooking.isPresent()) {
            TicketBookingModel booking = optionalBooking.get();
            booking.setMovieName(bookingDetails.getMovieName());
            booking.setCustomerEmail(bookingDetails.getCustomerEmail());
            booking.setContactNumber(bookingDetails.getContactNumber());
            booking.setCustomerName(bookingDetails.getCustomerName());
            booking.setTotalPayment(bookingDetails.getTotalPayment());
            booking.setStatus(bookingDetails.getStatus());
            booking.setPaymentStatus(bookingDetails.getPaymentStatus());
            return ticketBookingRepo.save(booking);
        }
        return null;
    }

    @Transactional
    public void updateBookingStatus(Long id, TicketBookingModel.BookingStatus status) {
        ticketBookingRepo.updateBookingStatus(id, status);
    }

    @Transactional
    public void updatePaymentStatus(Long id, TicketBookingModel.PaymentStatus paymentStatus) {
        ticketBookingRepo.updatePaymentStatus(id, paymentStatus);
    }

    @Transactional
    public void cancelBooking(Long id) {
        seatRepo.deleteByBookingId(id);
        ticketBookingRepo.updateBookingStatus(id, TicketBookingModel.BookingStatus.CANCELLED);
    }

    @Transactional
    public void deleteBooking(Long id) {
        seatRepo.deleteByBookingId(id);
        ticketBookingRepo.deleteById(id);
    }

    @Transactional
    public TicketBookingModel addSeatsToBooking(Long bookingId, List<SeatModel> seats) {
        Optional<TicketBookingModel> optionalBooking = ticketBookingRepo.findById(bookingId);
        if (optionalBooking.isPresent()) {
            TicketBookingModel booking = optionalBooking.get();
            for (SeatModel seat : seats) {
                seat.setBooking(booking);
            }
            seatRepo.saveAll(seats);
            return ticketBookingRepo.findByIdWithSeatsLoaded(bookingId).orElse(null);
        }
        return null;
    }

    @Transactional
    public void removeSeatsFromBooking(Long bookingId) {
        seatRepo.deleteByBookingId(bookingId);
    }

    @Transactional
    public TicketBookingModel updateReceiptPath(Long id, String receiptPath) {
        Optional<TicketBookingModel> optionalBooking = ticketBookingRepo.findById(id);
        if (optionalBooking.isPresent()) {
            TicketBookingModel booking = optionalBooking.get();
            booking.setReceiptPath(receiptPath);
            return ticketBookingRepo.save(booking);
        }
        return null;
    }
}