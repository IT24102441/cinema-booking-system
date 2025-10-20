console .log("hello")
let movieName = '';
let seatPrice = 0;
let selectedSeats = [];
let bookedSeats = [];
let allSeats = [];
// New: promotion state
let appliedPromo = null; // will hold response from /api/promotions/apply
let promoDiscountAmount = 0;

// Seat configuration
const seatRows = {
    'A': 24,
    'B': 12,
    'C': 6
};

// Initialize the page
document.addEventListener('DOMContentLoaded', function() {
    extractUrlParams();
    initializePage().then(()=>{});
});

// Extract URL parameters
function extractUrlParams() {
    const urlParams = new URLSearchParams(window.location.search);
    movieName = decodeURIComponent(urlParams.get('movieName') || '');
    seatPrice = parseFloat(urlParams.get('price')?.replace("$","") || '15.99');

    // Update movie title
    document.getElementById('movie-title').textContent = movieName || 'Unknown Movie';
}

// Initialize page
async function initializePage() {
    try {
        await loadBookedSeats();
        generateSeats();
        setupEventListeners();
        hideLoading();
        showSeatContainer();
    } catch (error) {
        console.error('Error initializing page:', error);
        showError('Failed to load seat information. Please try again.');
    }
}

// Load booked seats from API
async function loadBookedSeats() {
    console.log("called")
    try {
        const response = await fetch('/api/bookings');
        if (!response.ok) {
            throw new Error('Failed to fetch bookings');
        }

        const bookings = await response.json();

        // Filter bookings for current movie
        const movieBookings = bookings.filter(booking =>
            booking.movieName === movieName && booking.status === 'CONFIRMED'
        );

        // Extract booked seat numbers
        bookedSeats = [];
        movieBookings.forEach(booking => {
            if (booking.seats && Array.isArray(booking.seats)) {
                booking.seats.forEach(seat => {
                    const seatId = `${seat.rowNumber}${seat.seatNumber}`;
                    bookedSeats.push(seatId);
                });
            }
        });

        console.log('Booked seats:', bookedSeats);
    } catch (error) {
        console.error('Error loading booked seats:', error);
        // Continue with empty booked seats array
        bookedSeats = [];
    }
}

// Generate seat grid
function generateSeats() {
    const seatsGrid = document.getElementById('seats-grid');
    seatsGrid.innerHTML = '';
    allSeats = [];

    Object.entries(seatRows).forEach(([row, count]) => {
        const rowDiv = document.createElement('div');
        rowDiv.className = 'flex justify-center items-center space-x-2 mb-4';

        // Row label
        const rowLabel = document.createElement('div');
        rowLabel.className = 'w-8 h-8 flex items-center justify-center font-bold text-red-500';
        rowLabel.textContent = row;
        rowDiv.appendChild(rowLabel);

        // Seats in row
        for (let i = 1; i <= count; i++) {
            const seatId = `${row}${i}`;
            const seat = createSeat(row, i, seatId);
            allSeats.push(seatId);
            rowDiv.appendChild(seat);
        }

        seatsGrid.appendChild(rowDiv);
    });
}

// Create individual seat element
function createSeat(row, number, seatId) {
    const seat = document.createElement('div');
    seat.className = 'seat';
    seat.dataset.seatId = seatId;
    seat.dataset.row = row;
    seat.dataset.number = number;
    seat.textContent = number;

    // Check if seat is booked
    if (bookedSeats.includes(seatId)) {
        seat.classList.add('booked');
        seat.title = 'This seat is already booked';
    } else {
        seat.classList.add('available');
        seat.addEventListener('click', () => toggleSeat(seatId));
        seat.title = `Select seat ${seatId}`;
    }

    return seat;
}

// Toggle seat selection
function toggleSeat(seatId) {
    const seatElement = document.querySelector(`[data-seat-id="${seatId}"]`);

    if (seatElement.classList.contains('booked')) {
        return;
    }

    if (selectedSeats.includes(seatId)) {
        // Deselect seat
        selectedSeats = selectedSeats.filter(id => id !== seatId);
        seatElement.classList.remove('selected');
        seatElement.classList.add('available');
    } else {
        // Select seat
        selectedSeats.push(seatId);
        seatElement.classList.remove('available');
        seatElement.classList.add('selected');
    }

    // When seat selection changes any applied promo must be cleared (amount changed)
    clearAppliedPromo();

    updateBookingSummary();
    updateFormVisibility();
}

// New: clear any applied promotion state and UI
function clearAppliedPromo() {
    appliedPromo = null;
    promoDiscountAmount = 0;
    const promoMessage = document.getElementById('promo-message');
    const promoDiscountEl = document.getElementById('promo-discount');
    if (promoMessage) promoMessage.textContent = '';
    if (promoDiscountEl) promoDiscountEl.textContent = '';
    // Update totals to reflect no discount
    const totalPriceEl = document.getElementById('total-price');
    if (totalPriceEl) {
        const base = parseFloat((selectedSeats.length * seatPrice).toFixed(2)) || 0;
        totalPriceEl.textContent = `$${base.toFixed(2)}`;
    }
}

// Update booking summary
function updateBookingSummary() {
    const summaryDiv = document.getElementById('booking-summary');
    const selectedSeatsList = document.getElementById('selected-seats-list');
    const seatCount = document.getElementById('seat-count');
    const seatPriceElement = document.getElementById('seat-price');
    const totalPrice = document.getElementById('total-price');

    if (selectedSeats.length === 0) {
        summaryDiv.classList.add('hidden');
        // also clear promo when no seats
        clearAppliedPromo();
        return;
    }

    // Show summary
    summaryDiv.classList.remove('hidden');

    // Update selected seats list
    selectedSeatsList.innerHTML = '';
    selectedSeats.sort().forEach(seatId => {
        const seatDiv = document.createElement('div');
        seatDiv.className = 'flex justify-between items-center py-2 px-3 bg-gray-800/50 rounded';
        seatDiv.innerHTML = `
            <span class="font-semibold">Seat ${seatId}</span>
            <span class="text-red-500">$${seatPrice.toFixed(2)}</span>
        `;
        selectedSeatsList.appendChild(seatDiv);
    });

    // Update totals
    seatCount.textContent = selectedSeats.length;
    seatPriceElement.textContent = `$${seatPrice.toFixed(2)}`;

    const baseTotal = parseFloat((selectedSeats.length * seatPrice).toFixed(2));
    let finalTotal = baseTotal;

    // If promo applied, show discount and adjust total
    const promoDiscountEl = document.getElementById('promo-discount');
    const promoMessage = document.getElementById('promo-message');
    if (appliedPromo && appliedPromo.valid) {
        promoDiscountAmount = parseFloat(appliedPromo.discountAmount || 0);
        finalTotal = parseFloat(appliedPromo.newTotal || finalTotal);
        if (promoDiscountEl) promoDiscountEl.textContent = `Discount: -$${promoDiscountAmount.toFixed(2)} (code: ${appliedPromo.promotionCode})`;
        if (promoMessage) promoMessage.textContent = 'Promo applied';
    } else {
        if (promoDiscountEl) promoDiscountEl.textContent = '';
        if (promoMessage) promoMessage.textContent = '';
    }

    totalPrice.textContent = `$${finalTotal.toFixed(2)}`;
}

// Update form visibility
function updateFormVisibility() {
    const customerForm = document.getElementById('customer-form');

    if (selectedSeats.length > 0) {
        customerForm.classList.remove('hidden');
    } else {
        customerForm.classList.add('hidden');
    }
}

// Setup event listeners
function setupEventListeners() {
    const bookingForm = document.getElementById('booking-form');
    bookingForm.addEventListener('submit', handleBookingSubmit);

    // Promotion apply
    const applyPromoBtn = document.getElementById('apply-promo-btn');
    if (applyPromoBtn) {
        applyPromoBtn.addEventListener('click', handleApplyPromo);
    }
}

// Handle booking form submission (redirect to receipt upload after creating booking)
async function handleBookingSubmit(event) {
    event.preventDefault();

    if (selectedSeats.length === 0) {
        showError('Please select at least one seat.');
        return;
    }

    const customerName = document.getElementById('customer-name').value.trim();
    const customerEmail = document.getElementById('customer-email').value.trim();
    const contactNumber = document.getElementById('contact-number').value.trim();

    if (!customerName || !customerEmail || !contactNumber) {
        showError('Please fill in all required fields.');
        return;
    }

    // Build seats payload
    const seatsPayload = selectedSeats.map(seatId => {
        const row = seatId.charAt(0);
        const number = parseInt(seatId.substring(1), 10);
        return { seatNumber: number.toString(), rowNumber: row, price: parseFloat(seatPrice.toFixed(2)) };
    });

    // Compute totals
    const baseTotal = parseFloat((selectedSeats.length * seatPrice).toFixed(2));
    let finalTotal = baseTotal;
    let promoCode = '';
    if (appliedPromo && appliedPromo.valid) {
        finalTotal = parseFloat(appliedPromo.newTotal);
        promoCode = appliedPromo.promotionCode || '';
    }

    const payload = {
        movieName: movieName,
        customerName: customerName,
        customerEmail: customerEmail,
        contactNumber: contactNumber,
        totalPayment: parseFloat(finalTotal.toFixed(2)),
        paymentStatus: 'PENDING',
        seats: seatsPayload
    };
    if (promoCode) payload.promotionCode = promoCode;
    if (promoDiscountAmount) payload.promoDiscount = parseFloat(promoDiscountAmount.toFixed(2));

    // Disable button
    const btn = document.getElementById('book-now-btn');
    const btnText = document.getElementById('book-btn-text');
    if (btn && btnText) {
        btn.disabled = true;
        btnText.textContent = 'Placing Booking...';
    }

    try {
        const resp = await fetch('/api/bookings', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });
        if (!resp.ok) {
            const text = await resp.text();
            throw new Error(text || 'Failed to place booking');
        }
        const result = await resp.json();
        // Redirect to receipt upload page
        window.location.href = `/bookings/${result.id}/upload-receipt`;
    } catch (err) {
        console.error('Booking submit error:', err);
        showError(err.message || 'Failed to place booking');
        if (btn && btnText) {
            btn.disabled = false;
            btnText.textContent = 'Place Booking';
        }
    }
}

// New: handle apply promo button
async function handleApplyPromo() {
    const codeInput = document.getElementById('promo-code-input');
    const promoMessage = document.getElementById('promo-message');
    const promoDiscountEl = document.getElementById('promo-discount');
    promoMessage.textContent = '';
    promoDiscountEl.textContent = '';
    appliedPromo = null;
    promoDiscountAmount = 0;

    const code = codeInput.value.trim();
    if (!code) {
        promoMessage.textContent = 'Please enter a promo code.';
        return;
    }
    if (selectedSeats.length === 0) {
        promoMessage.textContent = 'Select seats first to calculate discount.';
        return;
    }
    const amount = parseFloat((selectedSeats.length * seatPrice).toFixed(2));
    try {
        const resp = await fetch(`/api/promotions/apply?code=${encodeURIComponent(code)}&amount=${amount}`);
        const data = await resp.json();
        if (!resp.ok || !data.valid) {
            promoMessage.textContent = data.message || 'Promo invalid';
            return;
        }
        // success
        appliedPromo = data; // store entire response
        // discountAmount and newTotal are BigDecimal-like strings from backend; ensure numeric
        promoDiscountAmount = parseFloat(data.discountAmount);
        promoDiscountEl.textContent = `Discount: -$${promoDiscountAmount.toFixed(2)} (code: ${data.promotionCode})`;
        promoMessage.textContent = 'Promo applied successfully';
        // update summary total
        const totalPriceEl = document.getElementById('total-price');
        if (totalPriceEl) totalPriceEl.textContent = `$${parseFloat(data.newTotal).toFixed(2)}`;
    } catch (err) {
        console.error('Error applying promo', err);
        promoMessage.textContent = 'Error applying promo. Try again later.';
    }
}

// Show success modal
function showSuccessModal(bookingResult) {
    const modal = document.getElementById('success-modal');
    const bookingDetails = document.getElementById('booking-details');

    bookingDetails.innerHTML = `
        <div class="space-y-2">
            <div class="flex justify-between">
                <span class="text-gray-400">Booking ID:</span>
                <span class="font-semibold">#${bookingResult.id}</span>
            </div>
            <div class="flex justify-between">
                <span class="text-gray-400">Movie:</span>
                <span class="font-semibold">${bookingResult.movieName}</span>
            </div>
            <div class="flex justify-between">
                <span class="text-gray-400">Seats:</span>
                <span class="font-semibold">${selectedSeats.join(', ')}</span>
            </div>
            <div class="flex justify-between">
                <span class="text-gray-400">Total Amount:</span>
                <span class="font-semibold text-red-500">$${document.getElementById('total-price').textContent.replace('$','')}</span>
            </div>
            <div class="flex justify-between">
                <span class="text-gray-400">Status:</span>
                <span class="font-semibold text-yellow-500">PENDING VERIFICATION</span>
            </div>
        </div>
    `;

    modal.classList.remove('hidden');
}

// Show error message
function showError(message) {
    // Create a custom error modal instead of alert
    const errorDiv = document.createElement('div');
    errorDiv.className = 'fixed top-4 right-4 bg-red-600 text-white px-6 py-3 rounded-lg shadow-lg z-50 transition-all duration-300';
    errorDiv.innerHTML = `
        <div class="flex items-center">
            <i class="fas fa-exclamation-triangle mr-2"></i>
            <span>${message}</span>
            <button class="ml-4 text-white hover:text-gray-200" onclick="this.parentElement.parentElement.remove()">
                <i class="fas fa-times"></i>
            </button>
        </div>
    `;

    document.body.appendChild(errorDiv);

    // Auto remove after 5 seconds
    setTimeout(() => {
        if (errorDiv.parentElement) {
            errorDiv.remove();
        }
    }, 5000);
}

// Hide loading spinner
function hideLoading() {
    const loadingElement = document.getElementById('loading-seats');
    loadingElement.style.display = 'none';
}

// Show seat container
function showSeatContainer() {
    const seatContainer = document.getElementById('seat-container');
    seatContainer.classList.remove('hidden');

    // Trigger animation
    setTimeout(() => {
        seatContainer.style.opacity = '1';
        seatContainer.style.transform = 'translateY(0)';
    }, 100);
}

// Utility function to format seat ID
function formatSeatId(row, number) {
    return `${row}${number}`;
}

// Add smooth scrolling for form sections
function scrollToElement(elementId) {
    const element = document.getElementById(elementId);
    if (element) {
        element.scrollIntoView({
            behavior: 'smooth',
            block: 'start'
        });
    }
}

// Handle window resize
window.addEventListener('resize', function() {
    // Adjust seat grid if needed
    const seatsGrid = document.getElementById('seats-grid');
    if (window.innerWidth < 768) {
        seatsGrid.classList.add('text-xs');
    } else {
        seatsGrid.classList.remove('text-xs');
    }
});

// Handle back navigation
window.addEventListener('beforeunload', function(event) {
    if (selectedSeats.length > 0) {
        event.preventDefault();
        event.returnValue = 'You have selected seats. Are you sure you want to leave?';
        return event.returnValue;
    }
});

// Close modals when clicking outside
document.addEventListener('click', function(event) {
    const successModal = document.getElementById('success-modal');
    if (event.target === successModal) {
        successModal.classList.add('hidden');
    }
});