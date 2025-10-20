package com.example.secrud.services;



import com.example.secrud.models.SeatModel;
import com.example.secrud.repos.SeatRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Service
public class SeatService {

    @Autowired
    private SeatRepo seatRepo;

    public SeatModel createSeat(SeatModel seat) {
        return seatRepo.save(seat);
    }

    public List<SeatModel> createSeats(List<SeatModel> seats) {
        return seatRepo.saveAll(seats);
    }

    public Optional<SeatModel> getSeatById(Long id) {
        return seatRepo.findById(id);
    }

    public List<SeatModel> getAllSeats() {
        return seatRepo.findAll();
    }

    public List<SeatModel> getSeatsByBookingId(Long bookingId) {
        return seatRepo.findByBookingId(bookingId);
    }

    public SeatModel updateSeat(Long id, SeatModel seatDetails) {
        Optional<SeatModel> optionalSeat = seatRepo.findById(id);
        if (optionalSeat.isPresent()) {
            SeatModel seat = optionalSeat.get();
            seat.setSeatNumber(seatDetails.getSeatNumber());
            seat.setRowNumber(seatDetails.getRowNumber());
            seat.setPrice(seatDetails.getPrice());
            return seatRepo.save(seat);
        }
        return null;
    }

    public void deleteSeat(Long id) {
        seatRepo.deleteById(id);
    }

    @Transactional
    public void deleteSeatsByBookingId(Long bookingId) {
        seatRepo.deleteByBookingId(bookingId);
    }
}