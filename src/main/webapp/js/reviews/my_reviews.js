const reviewsUserApi = "/api/reviews";

document.addEventListener("DOMContentLoaded", () => {
    const email = localStorage.getItem("movieUserEmail");
    if (!email) {
        loadAllReviewsForGuests();
    } else {
        loadMyReviews(email);
    }
});

async function loadMyReviews(email) {
    try {
        const res = await fetch(`${reviewsUserApi}/user/${encodeURIComponent(email)}`);
        const list = await res.json();
        const tbody = document.getElementById("myReviewsBody");
        tbody.innerHTML = "";
        list.forEach(r => {
            const tr = document.createElement("tr");
            tr.className = "border-b border-gray-700 hover:bg-gray-700";
            tr.innerHTML = `
                <td class="px-4 py-2">${r.movieName}</td>
                <td class="px-4 py-2">${r.rating}</td>
                <td class="px-4 py-2">${r.comment}</td>
                <td class="px-4 py-2 space-x-2">
                    <a class="bg-blue-600 hover:bg-blue-500 px-2 py-1 rounded" href="/reviews/edit?id=${r.id}">Edit</a>
                    <button class="bg-red-600 hover:bg-red-500 px-2 py-1 rounded" onclick="removeReview(${r.id})">Delete</button>
                </td>`;
            tbody.appendChild(tr);
        });
    } catch (e) {
        console.error("Failed to load user reviews", e);
    }
}

async function loadAllReviewsForGuests() {
    try {
        const res = await fetch(reviewsUserApi);
        const list = await res.json();
        const tbody = document.getElementById("myReviewsBody");
        tbody.innerHTML = "";
        list.forEach(r => {
            const tr = document.createElement("tr");
            tr.className = "border-b border-gray-700 hover:bg-gray-700";
            tr.innerHTML = `
                <td class="px-4 py-2">${r.movieName}</td>
                <td class="px-4 py-2">${r.rating}</td>
                <td class="px-4 py-2">${r.comment}</td>
                <td class="px-4 py-2 space-x-2">
                    <span class="text-gray-400">Guest</span>
                    <a class="bg-blue-600 hover:bg-blue-500 px-2 py-1 rounded ml-2" href="/reviews/edit?id=${r.id}">Edit</a>
                    <button class="bg-red-600 hover:bg-red-500 px-2 py-1 rounded" onclick="removeReview(${r.id})">Delete</button>
                </td>`;
            tbody.appendChild(tr);
        });
    } catch (e) {
        console.error("Failed to load reviews", e);
    }
}

async function removeReview(id) {
    if (!confirm("Delete this review?")) return;
    try {
        await fetch(`${reviewsUserApi}/${id}`, { method: "DELETE" });
        const email = localStorage.getItem("movieUserEmail");
        if (email) {
            loadMyReviews(email);
        } else {
            loadAllReviewsForGuests();
        }
    } catch (e) {
        console.error("Failed to delete review", e);
    }
}


