const readApi = "/api/reviews";

document.addEventListener("DOMContentLoaded", () => {
    loadAll();
    document.getElementById("searchReviews").addEventListener("input", filter);
});

let cached = [];

async function loadAll() {
    try {
        const res = await fetch(readApi);
        cached = await res.json();
        render(cached);
    } catch (e) {
        console.error("Failed to load reviews", e);
    }
}

function render(list) {
    const container = document.getElementById("reviewsContainer");
    container.innerHTML = "";
    list.forEach(r => {
        const card = document.createElement("div");
        card.className = "p-4 rounded bg-gray-800 border border-gray-700";
        card.innerHTML = `
            <div class=\"flex items-center justify-between mb-2\">
                <h3 class=\"text-xl font-semibold\">${r.movieName}</h3>
                <span class=\"bg-yellow-500 text-black px-2 py-0.5 rounded\">${r.rating} / 5</span>
            </div>
            <p class=\"text-gray-300 mb-1\">${r.comment}</p>
            <p class=\"text-gray-500 text-sm\">By: ${r.userEmail ? r.userEmail : 'Guest'} • ${new Date(r.createdAt).toLocaleString()}</p>
        `;
        container.appendChild(card);
    });
}

function filter() {
    const term = document.getElementById("searchReviews").value.toLowerCase();
    const filtered = cached.filter(r =>
        (r.movieName && r.movieName.toLowerCase().includes(term)) ||
        (r.comment && r.comment.toLowerCase().includes(term))
    );
    render(filtered);
}


