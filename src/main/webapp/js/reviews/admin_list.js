const adminReviewsApi = "/api/admins/reviews";

let allReviews = [];
let selectedReviews = new Set();

document.addEventListener("DOMContentLoaded", () => {
    loadAdminReviews();
    setupEventListeners();
});

function setupEventListeners() {
    document.getElementById("adminReviewSearch").addEventListener("input", filterReviews);
    document.getElementById("filterStatus").addEventListener("change", filterReviews);
    document.getElementById("selectAll").addEventListener("change", toggleSelectAll);
    document.getElementById("bulkDeleteBtn").addEventListener("click", bulkDelete);
    document.getElementById("bulkReportBtn").addEventListener("click", bulkReport);
}

async function loadAdminReviews() {
    try {
        const res = await fetch(adminReviewsApi);
        allReviews = await res.json();
        renderAdminReviews(allReviews);
        updateStats();
    } catch (e) {
        console.error("Failed to load admin reviews", e);
    }
}

function renderAdminReviews(reviews) {
    const tbody = document.getElementById("adminReviewsBody");
    tbody.innerHTML = "";
    
    reviews.forEach(r => {
        const tr = document.createElement("tr");
        tr.className = "border-b border-gray-700 hover:bg-gray-700";
        tr.innerHTML = `
            <td class="px-4 py-2">
                <input type="checkbox" class="review-checkbox rounded" data-id="${r.id}" onchange="toggleReviewSelection(${r.id})"/>
            </td>
            <td class="px-4 py-2">${r.id}</td>
            <td class="px-4 py-2">${r.movieName}</td>
            <td class="px-4 py-2">${r.userEmail || 'Guest'}</td>
            <td class="px-4 py-2">
                <span class="bg-yellow-500 text-black px-2 py-1 rounded text-sm">${r.rating}/5</span>
            </td>
            <td class="px-4 py-2 max-w-xs truncate" title="${r.comment}">${r.comment}</td>
            <td class="px-4 py-2">
                <span class="px-2 py-1 rounded text-xs ${getStatusClass(r)}">${getStatusText(r)}</span>
            </td>
            <td class="px-4 py-2">${new Date(r.createdAt).toLocaleDateString()}</td>
            <td class="px-4 py-2 space-x-2">
                <button class="bg-blue-600 hover:bg-blue-500 px-2 py-1 rounded text-xs" onclick="editReview(${r.id})">
                    <i class="fas fa-edit"></i>
                </button>
                <button class="bg-yellow-600 hover:bg-yellow-500 px-2 py-1 rounded text-xs" onclick="toggleReport(${r.id}, ${!r.reported})">
                    <i class="fas fa-flag"></i>
                </button>
                <button class="bg-red-600 hover:bg-red-500 px-2 py-1 rounded text-xs" onclick="deleteReview(${r.id})">
                    <i class="fas fa-trash"></i>
                </button>
            </td>`;
        tbody.appendChild(tr);
    });
}

function getStatusClass(review) {
    if (review.deleteStatus) return "bg-red-600 text-white";
    if (review.reported) return "bg-yellow-600 text-white";
    return "bg-green-600 text-white";
}

function getStatusText(review) {
    if (review.deleteStatus) return "Deleted";
    if (review.reported) return "Reported";
    return "Active";
}

function filterReviews() {
    const searchTerm = document.getElementById("adminReviewSearch").value.toLowerCase();
    const statusFilter = document.getElementById("filterStatus").value;
    
    let filtered = allReviews.filter(r => {
        const matchesSearch = !searchTerm || 
            r.movieName.toLowerCase().includes(searchTerm) ||
            (r.userEmail && r.userEmail.toLowerCase().includes(searchTerm)) ||
            r.comment.toLowerCase().includes(searchTerm);
        
        const matchesStatus = !statusFilter || 
            (statusFilter === "reported" && r.reported) ||
            (statusFilter === "deleted" && r.deleteStatus) ||
            (statusFilter === "active" && !r.reported && !r.deleteStatus);
        
        return matchesSearch && matchesStatus;
    });
    
    renderAdminReviews(filtered);
}

function updateStats() {
    const total = allReviews.length;
    const reported = allReviews.filter(r => r.reported).length;
    const deleted = allReviews.filter(r => r.deleteStatus).length;
    const avgRating = total > 0 ? (allReviews.reduce((sum, r) => sum + r.rating, 0) / total).toFixed(1) : "0.0";
    
    document.getElementById("totalReviews").textContent = total;
    document.getElementById("reportedReviews").textContent = reported;
    document.getElementById("deletedReviews").textContent = deleted;
    document.getElementById("avgRating").textContent = avgRating;
}

function toggleSelectAll() {
    const selectAll = document.getElementById("selectAll");
    const checkboxes = document.querySelectorAll(".review-checkbox");
    
    checkboxes.forEach(cb => {
        cb.checked = selectAll.checked;
        if (selectAll.checked) {
            selectedReviews.add(parseInt(cb.dataset.id));
        } else {
            selectedReviews.delete(parseInt(cb.dataset.id));
        }
    });
    
    updateBulkButtons();
}

function toggleReviewSelection(id) {
    if (selectedReviews.has(id)) {
        selectedReviews.delete(id);
    } else {
        selectedReviews.add(id);
    }
    updateBulkButtons();
}

function updateBulkButtons() {
    const hasSelection = selectedReviews.size > 0;
    document.getElementById("bulkDeleteBtn").disabled = !hasSelection;
    document.getElementById("bulkReportBtn").disabled = !hasSelection;
}

async function toggleReport(id, reported) {
    try {
        await fetch(`${adminReviewsApi}/${id}/report`, {
            method: "PATCH",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ reported })
        });
        loadAdminReviews();
    } catch (e) {
        console.error("Failed to update report status", e);
    }
}

async function deleteReview(id) {
    if (!confirm("Delete this review permanently?")) return;
    try {
        await fetch(`${adminReviewsApi}/${id}`, { method: "DELETE" });
        loadAdminReviews();
    } catch (e) {
        console.error("Failed to delete review", e);
    }
}

async function editReview(id) {
    window.location.href = `/reviews/edit?id=${id}`;
}

async function bulkDelete() {
    if (selectedReviews.size === 0) return;
    if (!confirm(`Delete ${selectedReviews.size} reviews permanently?`)) return;
    
    try {
        const promises = Array.from(selectedReviews).map(id => 
            fetch(`${adminReviewsApi}/${id}`, { method: "DELETE" })
        );
        await Promise.all(promises);
        selectedReviews.clear();
        loadAdminReviews();
    } catch (e) {
        console.error("Failed to bulk delete reviews", e);
    }
}

async function bulkReport() {
    if (selectedReviews.size === 0) return;
    if (!confirm(`Report ${selectedReviews.size} reviews?`)) return;
    
    try {
        const promises = Array.from(selectedReviews).map(id => 
            fetch(`${adminReviewsApi}/${id}/report`, {
                method: "PATCH",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ reported: true })
            })
        );
        await Promise.all(promises);
        selectedReviews.clear();
        loadAdminReviews();
    } catch (e) {
        console.error("Failed to bulk report reviews", e);
    }
}

function goToDashboard() {
    window.location.href = "/admin-dashboard";
}

function goToHome() {
    window.location.href = "/";
}
