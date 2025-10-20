const reviewsEditApi = "/api/reviews";

document.addEventListener("DOMContentLoaded", async () => {
    const params = new URLSearchParams(window.location.search);
    const id = params.get("id");
    if (!id) return;
    document.getElementById("reviewId").value = id;
    try {
        const res = await fetch(`${reviewsEditApi}/${id}`);
        const r = await res.json();
        document.getElementById("movieName").value = r.movieName;
        document.getElementById("userEmail").value = r.userEmail;
        document.getElementById("rating").value = r.rating;
        document.getElementById("comment").value = r.comment;
    } catch (e) {
        console.error("Failed to load review", e);
    }
});

document.getElementById("editReviewForm").addEventListener("submit", async (e) => {
    e.preventDefault();
    const id = document.getElementById("reviewId").value;
    const payload = {
        rating: parseInt(document.getElementById("rating").value, 10),
        comment: document.getElementById("comment").value
    };
    try {
        await fetch(`${reviewsEditApi}/${id}`, {
            method: "PUT",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(payload)
        });
        window.location.href = "/";
    } catch (e) {
        console.error("Failed to update review", e);
    }
});


