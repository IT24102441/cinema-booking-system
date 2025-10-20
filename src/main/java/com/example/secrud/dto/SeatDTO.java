package com.example.secrud.dto;

import java.math.BigDecimal;

public class SeatDTO {

    public static class CreateSeatRequest {
        private String seatNumber;
        private String rowNumber;
        private BigDecimal price;
        private Long bookingId;

        public String getSeatNumber() { return seatNumber; }
        public void setSeatNumber(String seatNumber) { this.seatNumber = seatNumber; }

        public String getRowNumber() { return rowNumber; }
        public void setRowNumber(String rowNumber) { this.rowNumber = rowNumber; }

        public BigDecimal getPrice() { return price; }
        public void setPrice(BigDecimal price) { this.price = price; }

        public Long getBookingId() { return bookingId; }
        public void setBookingId(Long bookingId) { this.bookingId = bookingId; }
    }

    public static class UpdateSeatRequest {
        private String seatNumber;
        private String rowNumber;
        private BigDecimal price;

        public String getSeatNumber() { return seatNumber; }
        public void setSeatNumber(String seatNumber) { this.seatNumber = seatNumber; }

        public String getRowNumber() { return rowNumber; }
        public void setRowNumber(String rowNumber) { this.rowNumber = rowNumber; }

        public BigDecimal getPrice() { return price; }
        public void setPrice(BigDecimal price) { this.price = price; }
    }

    public static class SeatResponse {
        private Long id;
        private String seatNumber;
        private String rowNumber;
        private BigDecimal price;
        private Long bookingId;

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public String getSeatNumber() { return seatNumber; }
        public void setSeatNumber(String seatNumber) { this.seatNumber = seatNumber; }

        public String getRowNumber() { return rowNumber; }
        public void setRowNumber(String rowNumber) { this.rowNumber = rowNumber; }

        public BigDecimal getPrice() { return price; }
        public void setPrice(BigDecimal price) { this.price = price; }

        public Long getBookingId() { return bookingId; }
        public void setBookingId(Long bookingId) { this.bookingId = bookingId; }
    }

    public static class CreateMultipleSeatsRequest {
        private java.util.List<CreateSeatRequest> seats;

        public java.util.List<CreateSeatRequest> getSeats() { return seats; }
        public void setSeats(java.util.List<CreateSeatRequest> seats) { this.seats = seats; }
    }
}