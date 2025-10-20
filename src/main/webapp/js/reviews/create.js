const reviewsApiBase = "/api/reviews";

document.getElementById("createReviewForm").addEventListener("submit", async (e) => {
    e.preventDefault();
    const emailVal = document.getElementById("userEmail").value;
    const payload = {
        movieName: document.getElementById("movieName").value,
        userEmail: emailVal && emailVal.length > 0 ? emailVal : null,
        rating: parseInt(document.getElementById("rating").value, 10),
        comment: document.getElementById("comment").value
    };
    try {
        await fetch(reviewsApiBase, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(payload)
        });
        window.location.href = "/";
    } catch (e) {
        console.error("Failed to create review", e);
    }
});


