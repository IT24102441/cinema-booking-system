<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Bookings</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body class="bg-gray-900 text-white p-6">
<nav class="fixed top-0 w-full z-40 bg-black/90 backdrop-blur-md border-b border-gray-800/50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <a href="/" class="text-2xl font-bold text-red-600"><i class="fas fa-film mr-2"></i>MovieMate</a>
            <div class="flex items-center space-x-6">
                <a href="/admin-dashboard" class="text-gray-400 hover:text-red-500 transition-colors"><i class="fas fa-tachometer-alt mr-2"></i>Dashboard</a>
                <button onclick="logout()" class="text-gray-400 hover:text-red-500 transition-colors"><i class="fas fa-sign-out-alt mr-2"></i>Logout</button>
            </div>
        </div>
    </div>
</nav>

<div class="container mx-auto">
    <h1 class="text-3xl font-bold mb-6">Ticket Bookings Management</h1>

    <div class="mb-4">
        <input type="text" id="searchInput" placeholder="Search by customer or movie"
               class="w-full p-2 rounded-lg border border-gray-700 bg-gray-800 text-white"/>
    </div>

    <div class="overflow-x-auto">
        <table class="min-w-full bg-gray-800 rounded-lg overflow-hidden" id="bookingsTable">
            <thead class="bg-gray-700">
            <tr>
                <th class="px-4 py-2 text-left">ID</th>
                <th class="px-4 py-2 text-left">Movie</th>
                <th class="px-4 py-2 text-left">Customer</th>
                <th class="px-4 py-2 text-left">Email</th>
                <th class="px-4 py-2 text-left">Payment</th>
                <th class="px-4 py-2 text-left">Status</th>
                <th class="px-4 py-2 text-left">Payment Status</th>
                <th class="px-4 py-2 text-left">Seats</th>
                <th class="px-4 py-2 text-left">Actions</th>
            </tr>
            </thead>
            <tbody id="bookingsBody">
            <!-- Rows will be populated dynamically via JS -->
            </tbody>
        </table>
    </div>
</div>

<script src="/js/list.js"></script>
</body>
</html>
