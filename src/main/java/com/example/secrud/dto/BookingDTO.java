package com.example.secrud.dto;

import com.example.secrud.models.TicketBookingModel;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookingDTO {

    public static class CreateBookingRequest {
        private String movieName;
        private String customerEmail;
        private String contactNumber;
        private String customerName;
        private BigDecimal totalPayment;
        private TicketBookingModel.PaymentStatus paymentStatus;
        private List<CreateSeatRequest> seats = new ArrayList<CreateSeatRequest>();
        // New promotion fields
        private String promotionCode;
        private BigDecimal promoDiscount;

        public String getMovieName() { return movieName; }
        public void setMovieName(String movieName) { this.movieName = movieName; }

        public String getCustomerEmail() { return customerEmail; }
        public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

        public String getContactNumber() { return contactNumber; }
        public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

        public String getCustomerName() { return customerName; }
        public void setCustomerName(String customerName) { this.customerName = customerName; }

        public BigDecimal getTotalPayment() { return totalPayment; }
        public void setTotalPayment(BigDecimal totalPayment) { this.totalPayment = totalPayment; }

        public TicketBookingModel.PaymentStatus getPaymentStatus() { return paymentStatus; }
        public void setPaymentStatus(TicketBookingModel.PaymentStatus paymentStatus) { this.paymentStatus = paymentStatus; }

        public List<CreateSeatRequest> getSeats() { return seats; }
        public void setSeats(List<CreateSeatRequest> seats) { this.seats = seats; }

        public String getPromotionCode() { return promotionCode; }
        public void setPromotionCode(String promotionCode) { this.promotionCode = promotionCode; }

        public BigDecimal getPromoDiscount() { return promoDiscount; }
        public void setPromoDiscount(BigDecimal promoDiscount) { this.promoDiscount = promoDiscount; }
    }

    public static class UpdateBookingRequest {
        private String movieName;
        private String customerEmail;
        private String contactNumber;
        private String customerName;
        private BigDecimal totalPayment;
        private TicketBookingModel.BookingStatus status;
        private TicketBookingModel.PaymentStatus paymentStatus;

        public String getMovieName() { return movieName; }
        public void setMovieName(String movieName) { this.movieName = movieName; }

        public String getCustomerEmail() { return customerEmail; }
        public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

        public String getContactNumber() { return contactNumber; }
        public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

        public String getCustomerName() { return customerName; }
        public void setCustomerName(String customerName) { this.customerName = customerName; }

        public BigDecimal getTotalPayment() { return totalPayment; }
        public void setTotalPayment(BigDecimal totalPayment) { this.totalPayment = totalPayment; }

        public TicketBookingModel.BookingStatus getStatus() { return status; }
        public void setStatus(TicketBookingModel.BookingStatus status) { this.status = status; }

        public TicketBookingModel.PaymentStatus getPaymentStatus() { return paymentStatus; }
        public void setPaymentStatus(TicketBookingModel.PaymentStatus paymentStatus) { this.paymentStatus = paymentStatus; }
    }

    public static class BookingResponse {
        private Long id;
        private String movieName;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
        private TicketBookingModel.BookingStatus status;
        private String customerEmail;
        private String contactNumber;
        private String customerName;
        private BigDecimal totalPayment;
        private TicketBookingModel.PaymentStatus paymentStatus;
        private List<SeatResponse> seats;
        private String receiptUrl;

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public String getMovieName() { return movieName; }
        public void setMovieName(String movieName) { this.movieName = movieName; }

        public LocalDateTime getCreatedAt() { return createdAt; }
        public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

        public LocalDateTime getUpdatedAt() { return updatedAt; }
        public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

        public TicketBookingModel.BookingStatus getStatus() { return status; }
        public void setStatus(TicketBookingModel.BookingStatus status) { this.status = status; }

        public String getCustomerEmail() { return customerEmail; }
        public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

        public String getContactNumber() { return contactNumber; }
        public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

        public String getCustomerName() { return customerName; }
        public void setCustomerName(String customerName) { this.customerName = customerName; }

        public BigDecimal getTotalPayment() { return totalPayment; }
        public void setTotalPayment(BigDecimal totalPayment) { this.totalPayment = totalPayment; }

        public TicketBookingModel.PaymentStatus getPaymentStatus() { return paymentStatus; }
        public void setPaymentStatus(TicketBookingModel.PaymentStatus paymentStatus) { this.paymentStatus = paymentStatus; }

        public List<SeatResponse> getSeats() { return seats; }
        public void setSeats(List<SeatResponse> seats) { this.seats = seats; }

        public String getReceiptUrl() { return receiptUrl; }
        public void setReceiptUrl(String receiptUrl) { this.receiptUrl = receiptUrl; }
    }

    public static class CreateSeatRequest {
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

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public String getSeatNumber() { return seatNumber; }
        public void setSeatNumber(String seatNumber) { this.seatNumber = seatNumber; }

        public String getRowNumber() { return rowNumber; }
        public void setRowNumber(String rowNumber) { this.rowNumber = rowNumber; }

        public BigDecimal getPrice() { return price; }
        public void setPrice(BigDecimal price) { this.price = price; }
    }

    public static class StatusUpdateRequest {
        private TicketBookingModel.BookingStatus status;

        public TicketBookingModel.BookingStatus getStatus() { return status; }
        public void setStatus(TicketBookingModel.BookingStatus status) { this.status = status; }
    }

    public static class PaymentStatusUpdateRequest {
        private TicketBookingModel.PaymentStatus paymentStatus;

        public TicketBookingModel.PaymentStatus getPaymentStatus() { return paymentStatus; }
        public void setPaymentStatus(TicketBookingModel.PaymentStatus paymentStatus) { this.paymentStatus = paymentStatus; }
    }

    public static class AddSeatsRequest {
        private List<CreateSeatRequest> seats;

        public List<CreateSeatRequest> getSeats() { return seats; }
        public void setSeats(List<CreateSeatRequest> seats) { this.seats = seats; }
    }
}