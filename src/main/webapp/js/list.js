const apiBase = "/api/bookings";

document.addEventListener("DOMContentLoaded", () => {
    loadBookings();

    // Search/filter
    const searchInput = document.getElementById("searchInput");
    searchInput.addEventListener("input", filterTable);
});

async function loadBookings() {
    try {
        const response = await fetch(apiBase);
        const bookings = await response.json();
        populateTable(bookings);
    } catch (error) {
        console.error("Error loading bookings:", error);
    }
}

function populateTable(bookings) {
    const tbody = document.getElementById("bookingsBody");
    tbody.innerHTML = "";

    bookings.forEach(booking => {
        const tr = document.createElement("tr");
        tr.className = "border-b border-gray-700 hover:bg-gray-700 transition-all";

        const seats = booking.seats ? booking.seats.map(s => s.seatNumber).join(", ") : "";

        tr.innerHTML = `
            <td class="px-4 py-2">${booking.id}</td>
            <td class="px-4 py-2">${booking.movieName}</td>
            <td class="px-4 py-2">${booking.customerName}</td>
            <td class="px-4 py-2">${booking.customerEmail}</td>
            <td class="px-4 py-2">${booking.totalPayment}</td>
            <td class="px-4 py-2">
                <select class="bg-gray-800 text-white p-1 rounded status-select" data-id="${booking.id}">
                    <option value="CONFIRMED" ${booking.status === 'CONFIRMED' ? 'selected' : ''}>CONFIRMED</option>
                    <option value="CANCELLED" ${booking.status === 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                </select>
            </td>
            <td class="px-4 py-2">
                <select class="bg-gray-800 text-white p-1 rounded payment-select" data-id="${booking.id}">
                    <option value="PENDING" ${booking.paymentStatus === 'PENDING' ? 'selected' : ''}>PENDING</option>
                    <option value="COMPLETED" ${booking.paymentStatus === 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                    <option value="REFUNDED" ${booking.paymentStatus === 'REFUNDED' ? 'selected' : ''}>REFUNDED</option>
                </select>
            </td>
            <td class="px-4 py-2">${seats}</td>
            <td class="px-4 py-2 space-x-2">
                <button class="bg-red-600 hover:bg-red-500 px-2 py-1 rounded delete-btn" data-id="${booking.id}"><i class="fas fa-trash"></i></button>
            </td>
        `;

        tbody.appendChild(tr);
    });

    // Add event listeners for status/payment changes and delete buttons
    document.querySelectorAll(".status-select").forEach(select => {
        select.addEventListener("change", e => updateStatus(e.target.dataset.id, e.target.value));
    });

    document.querySelectorAll(".payment-select").forEach(select => {
        select.addEventListener("change", e => updatePaymentStatus(e.target.dataset.id, e.target.value));
    });

    document.querySelectorAll(".delete-btn").forEach(btn => {
        btn.addEventListener("click", e => deleteBooking(e.target.dataset.id));
    });
}

// Filter table by input
function filterTable() {
    const filter = document.getElementById("searchInput").value.toLowerCase();
    const rows = document.querySelectorAll("#bookingsBody tr");

    rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(filter) ? "" : "none";
    });
}

async function updateStatus(id, status) {
    try {
        await fetch(`${apiBase}/${id}/status`, {
            method: "PATCH",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ status })
        });
        console.log(`Booking ${id} status updated to ${status}`);
    } catch (error) {
        console.error("Error updating status:", error);
    }
}

async function updatePaymentStatus(id, paymentStatus) {
    try {
        await fetch(`${apiBase}/${id}/payment-status`, {
            method: "PATCH",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ paymentStatus })
        });
        console.log(`Booking ${id} payment updated to ${paymentStatus}`);
    } catch (error) {
        console.error("Error updating payment status:", error);
    }
}

async function deleteBooking(id) {
    if (!confirm("Are you sure you want to delete this booking?")) return;

    try {
        await fetch(`${apiBase}/${id}`, { method: "DELETE" });
        loadBookings();
        console.log(`Booking ${id} deleted`);
    } catch (error) {
        console.error("Error deleting booking:", error);
    }
}
