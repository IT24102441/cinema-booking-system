document.addEventListener("DOMContentLoaded", async () => {
    const container = document.getElementById("bookings-container");
    const loading = document.getElementById("loading");

    // Use stored email (login or profile)
    const userEmail = localStorage.getItem("email") || localStorage.getItem("movieUserEmail");
    if (!userEmail) {
        loading.style.display = "none";
        container.innerHTML = `<p class="text-center text-gray-400 text-lg col-span-full">Please log in to view your bookings.</p>`;
        return;
    }

    try {
    const response = await fetch(`/api/bookings/email/${encodeURIComponent(userEmail)}`);
        const bookings = await response.json();

        loading.style.display = "none";

        if (bookings.length === 0) {
            container.innerHTML = `<p class="text-center text-gray-400 text-lg col-span-full">No bookings found.</p>`;
            return;
        }

        bookings.forEach(booking => {
            const card = document.createElement("div");
            card.className = "bg-gray-900/70 border border-gray-800 rounded-xl p-6 shadow-lg hover:border-red-500 transition-all";

            // Decide button HTML based on booking status
            let actionButton = "";
            if (booking.status && booking.status.toLowerCase() !== "cancelled") {
                actionButton = `<button data-id="${booking.id}" class="cancel-btn bg-red-600 hover:bg-red-800 px-4 py-2 rounded-lg font-semibold">Cancel</button>`;
            } else {
                actionButton = `<span class="px-4 py-2 rounded-lg bg-gray-600 text-gray-300 font-semibold">Canceled</span>`;
            }

            const receiptSection = booking.receiptUrl ? `
    <div class="mt-3">
        <p class="mb-1 font-semibold">Payment Receipt:</p>
        <a href="${booking.receiptUrl}" target="_blank" class="text-red-400 hover:text-red-300 underline">View Receipt</a>
    </div>
` : '';

            card.innerHTML = `
    <h3 class="text-2xl font-semibold text-red-500 mb-2">${booking.movieName}</h3>
    <p class="text-gray-400 text-sm mb-2">Booking ID: ${booking.id}</p>
    <p class="mb-1"><strong>Status:</strong> ${booking.status}</p>
    <p class="mb-1"><strong>Payment:</strong> ${booking.paymentStatus}</p>
    <p class="mb-1"><strong>Total:</strong> $${booking.totalPayment}</p>
    <p class="mb-4"><strong>Seats:</strong> ${booking.seats.map(seat => seat.rowNumber + seat.seatNumber).join(", ")}</p>
    ${receiptSection}
    ${actionButton}
  `;

            container.appendChild(card);
        });


        // Handle Cancel Button
        document.querySelectorAll(".cancel-btn").forEach(btn => {
            btn.addEventListener("click", async () => {
                const id = btn.getAttribute("data-id");

                if (!confirm("Are you sure you want to cancel this booking?")) return;

                try {
                    const res = await fetch(`/api/bookings/${id}/status`, {
                        method: "PATCH",
                        headers: { "Content-Type": "application/json" },
                        body: JSON.stringify({
                            status: 'CANCELLED'
                        })

                    });

                    if (res.ok) {
                        alert("Booking cancelled successfully!");
                        btn.closest("div").remove();
                    } else {
                        alert("Failed to cancel booking.");
                    }
                } catch (err) {
                    console.error(err);
                    alert("Error while cancelling booking.");
                }
            });
        });

    } catch (err) {
        console.error(err);
        loading.innerHTML = `<p class="text-red-500">Error loading bookings</p>`;
    }
});
