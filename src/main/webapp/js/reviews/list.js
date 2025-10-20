const reviewsApi = "/api/reviews";

document.addEventListener("DOMContentLoaded", () => {
    loadReviews();
    document.getElementById("reviewSearch").addEventListener("input", filter);
});

async function loadReviews() {
    try {
        const res = await fetch(reviewsApi);
        const data = await res.json();
        render(data);
    } catch (e) {
        console.error("Failed to load reviews", e);
    }
}

function render(list) {
    const tbody = document.getElementById("reviewsBody");
    tbody.innerHTML = "";
    list.forEach(r => {
        const tr = document.createElement("tr");
        tr.className = "border-b border-gray-700 hover:bg-gray-700";
        tr.innerHTML = `
            <td class="px-4 py-2">${r.id}</td>
            <td class="px-4 py-2">${r.movieName}</td>
            <td class="px-4 py-2">${r.userEmail}</td>
            <td class="px-4 py-2">${r.rating}</td>
            <td class="px-4 py-2 truncate max-w-md" title="${r.comment}">${r.comment}</td>
            <td class="px-4 py-2">
                <input type="checkbox" ${r.reported ? 'checked' : ''} onchange="toggleReport(${r.id}, this.checked)"/>
            </td>
            <td class="px-4 py-2 space-x-2">
                <button class="bg-blue-600 hover:bg-blue-500 px-2 py-1 rounded" onclick="goEdit(${r.id})"><i class="fas fa-edit"></i></button>
                <button class="bg-red-600 hover:bg-red-500 px-2 py-1 rounded" onclick="removeReview(${r.id})"><i class="fas fa-trash"></i></button>
            </td>`;
        tbody.appendChild(tr);
    });
}

function filter() {
    const term = document.getElementById("reviewSearch").value.toLowerCase();
    const rows = document.querySelectorAll("#reviewsBody tr");
    rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(term) ? "" : "none";
    });
}

function goEdit(id) {
    window.location.href = `/reviews/edit?id=${id}`;
}

async function toggleReport(id, reported) {
    try {
        await fetch(`${reviewsApi}/${id}/report`, {
            method: "PATCH",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ reported })
        });
    } catch (e) {
        console.error("Failed to update report status", e);
    }
}

async function removeReview(id) {
    if (!confirm("Delete this review?")) return;
    try {
        await fetch(`${reviewsApi}/${id}`, { method: "DELETE" });
        loadReviews();
    } catch (e) {
        console.error("Failed to delete review", e);
    }
}


