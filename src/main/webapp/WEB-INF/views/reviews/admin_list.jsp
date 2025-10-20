<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin - Review Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body class="bg-gray-900 text-white p-6">

<div class="container mx-auto">
    <div class="flex items-center justify-between mb-6">
        <h1 class="text-3xl font-bold">Admin - Review Management</h1>
        <div class="space-x-2">
            <button onclick="goToDashboard()" class="bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded">Back to Dashboard</button>
            <button onclick="goToHome()" class="bg-blue-600 hover:bg-blue-500 px-4 py-2 rounded">Go to Home</button>
        </div>
    </div>

    <!-- Admin Controls -->
    <div class="mb-6 p-4 bg-gray-800 rounded-lg">
        <div class="flex items-center justify-between mb-4">
            <div class="flex items-center space-x-4">
                <input type="text" id="adminReviewSearch" placeholder="Search reviews..." class="p-2 rounded bg-gray-700 border border-gray-600 text-white"/>
                <select id="filterStatus" class="p-2 rounded bg-gray-700 border border-gray-600 text-white">
                    <option value="">All Reviews</option>
                    <option value="reported">Reported Only</option>
                    <option value="deleted">Deleted Only</option>
                    <option value="active">Active Only</option>
                </select>
            </div>
            <div class="flex items-center space-x-2">
                <button id="bulkDeleteBtn" class="bg-red-600 hover:bg-red-500 px-4 py-2 rounded disabled:opacity-50" disabled>
                    <i class="fas fa-trash mr-2"></i>Bulk Delete
                </button>
                <button id="bulkReportBtn" class="bg-yellow-600 hover:bg-yellow-500 px-4 py-2 rounded disabled:opacity-50" disabled>
                    <i class="fas fa-flag mr-2"></i>Bulk Report
                </button>
            </div>
        </div>
    </div>

    <div class="overflow-x-auto">
        <table class="min-w-full bg-gray-800 rounded-lg overflow-hidden" id="adminReviewsTable">
            <thead class="bg-gray-700">
            <tr>
                <th class="px-4 py-2 text-left">
                    <input type="checkbox" id="selectAll" class="rounded"/>
                </th>
                <th class="px-4 py-2 text-left">ID</th>
                <th class="px-4 py-2 text-left">Movie</th>
                <th class="px-4 py-2 text-left">User</th>
                <th class="px-4 py-2 text-left">Rating</th>
                <th class="px-4 py-2 text-left">Comment</th>
                <th class="px-4 py-2 text-left">Status</th>
                <th class="px-4 py-2 text-left">Created</th>
                <th class="px-4 py-2 text-left">Actions</th>
            </tr>
            </thead>
            <tbody id="adminReviewsBody"></tbody>
        </table>
    </div>

    <!-- Review Stats -->
    <div class="mt-8 grid grid-cols-1 md:grid-cols-4 gap-4">
        <div class="bg-gray-800 p-4 rounded-lg text-center">
            <div class="text-2xl font-bold text-blue-400" id="totalReviews">0</div>
            <div class="text-gray-400">Total Reviews</div>
        </div>
        <div class="bg-gray-800 p-4 rounded-lg text-center">
            <div class="text-2xl font-bold text-yellow-400" id="reportedReviews">0</div>
            <div class="text-gray-400">Reported</div>
        </div>
        <div class="bg-gray-800 p-4 rounded-lg text-center">
            <div class="text-2xl font-bold text-red-400" id="deletedReviews">0</div>
            <div class="text-gray-400">Deleted</div>
        </div>
        <div class="bg-gray-800 p-4 rounded-lg text-center">
            <div class="text-2xl font-bold text-green-400" id="avgRating">0.0</div>
            <div class="text-gray-400">Avg Rating</div>
        </div>
    </div>
</div>

<script src="/js/reviews/admin_list.js"></script>
</body>
</html>
