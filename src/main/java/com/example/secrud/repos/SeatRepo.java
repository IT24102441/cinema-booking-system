package com.example.secrud.repos;

import com.example.secrud.models.SeatModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface SeatRepo extends JpaRepository<SeatModel, Long> {

    List<SeatModel> findByBookingId(Long bookingId);

    @Modifying
    @Transactional
    @Query("DELETE FROM SeatModel s WHERE s.booking.id = :bookingId")
    void deleteByBookingId(@Param("bookingId") Long bookingId);
}
