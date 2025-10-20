<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MovieMate - My Bookings</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="min-h-screen bg-gradient-to-br from-[#0f0f23] to-[#1a1a2e] text-white">
<jsp:include page="partials/navbar.jsp" />

<!-- Navbar -->
<nav class="fixed top-0 w-full z-50 bg-black/90 backdrop-blur-md border-b border-gray-800/50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <a href="/">
                <h1 class="text-2xl font-bold text-red-600">
                    <i class="fas fa-film mr-2"></i>MovieMate
                </h1>
            </a>
            <div class="flex space-x-6">
                <a href="/" class="hover:text-red-500"><i class="fas fa-home mr-2"></i>Home</a>
                <a href="/my-bookings" class="text-red-500"><i class="fas fa-ticket-alt mr-2"></i>My Bookings</a>
            </div>
        </div>
    </div>
</nav>

<!-- Bookings Section -->
<section class="pt-20 pb-12 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <h2 class="text-4xl font-bold text-center mb-8">My Bookings</h2>
    <div id="bookings-container" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <!-- JS will render bookings here -->
    </div>

    <!-- Loading State -->
    <div id="loading" class="text-center py-16">
        <div class="inline-flex w-16 h-16 border-4 border-red-600 border-t-transparent rounded-full animate-spin mb-4"></div>
        <p class="text-gray-400">Fetching your bookings...</p>
    </div>
</section>

<!-- Footer -->
<jsp:include page="partials/footer.jsp" />

<script src="/js/user_bookings.js"></script>
</body>
</html>
