<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reviews - Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body class="bg-gray-900 text-white p-6">

<div class="container mx-auto">
    <div class="flex items-center justify-between mb-6">
        <h1 class="text-3xl font-bold">Reviews Management</h1>
        <a href="/" class="bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded">Go to Home</a>
    </div>

    <div class="flex items-center mb-4 gap-2">
        <input type="text" id="reviewSearch" placeholder="Search by movie or user" class="w-full p-2 rounded-lg border border-gray-700 bg-gray-800 text-white"/>
        <a href="/reviews/create" class="bg-red-600 hover:bg-red-500 px-4 py-2 rounded">New</a>
    </div>

    <div class="overflow-x-auto">
        <table class="min-w-full bg-gray-800 rounded-lg overflow-hidden" id="reviewsTable">
            <thead class="bg-gray-700">
            <tr>
                <th class="px-4 py-2 text-left">ID</th>
                <th class="px-4 py-2 text-left">Movie</th>
                <th class="px-4 py-2 text-left">User</th>
                <th class="px-4 py-2 text-left">Rating</th>
                <th class="px-4 py-2 text-left">Comment</th>
                <th class="px-4 py-2 text-left">Reported</th>
                <th class="px-4 py-2 text-left">Actions</th>
            </tr>
            </thead>
            <tbody id="reviewsBody"></tbody>
        </table>
    </div>
</div>

<script src="/js/reviews/list.js"></script>
</body>
</html>


