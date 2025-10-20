package com.example.secrud.repos;

import com.example.secrud.models.TicketBookingModel;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface TicketBookingRepo extends JpaRepository<TicketBookingModel, Long> {

    @Query("SELECT b FROM TicketBookingModel b LEFT JOIN FETCH b.seats WHERE b.id = :id")
    Optional<TicketBookingModel> findByIdWithSeatsLoaded(@Param("id") Long id);

    // Load booking + seats in a single query
    @EntityGraph(attributePaths = "seats")
    Optional<TicketBookingModel> findById(Long id);

    List<TicketBookingModel> findByCustomerEmail(String customerEmail);

    List<TicketBookingModel> findByStatus(TicketBookingModel.BookingStatus status);

    List<TicketBookingModel> findByPaymentStatus(TicketBookingModel.PaymentStatus paymentStatus);

    @Modifying
    @Transactional
    @Query("DELETE FROM SeatModel s WHERE s.booking.id = :bookingId")
    void deleteSeatsByBookingId(@Param("bookingId") Long bookingId);

    @Modifying
    @Transactional
    @Query("UPDATE TicketBookingModel b SET b.status = :status WHERE b.id = :id")
    void updateBookingStatus(@Param("id") Long id,
                             @Param("status") TicketBookingModel.BookingStatus status);

    @Modifying
    @Transactional
    @Query("UPDATE TicketBookingModel b SET b.paymentStatus = :paymentStatus WHERE b.id = :id")
    void updatePaymentStatus(@Param("id") Long id,
                             @Param("paymentStatus") TicketBookingModel.PaymentStatus paymentStatus);
}
