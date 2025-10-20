<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MovieMate -Book Your Movie</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/home.css">

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #0f0f23 0%, #1a1a2e 100%);
        }

        .movie-card {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .movie-card:hover {
            transform: translateY(-8px) scale(1.02);
        }

        .hero-gradient {
            background: linear-gradient(135deg, #e50914 0%, #b20710 50%, #8b0000 100%);
        }

        .glow-effect {
            box-shadow: 0 0 20px rgba(229, 9, 20, 0.3);
        }

        .fade-in {
            animation: fadeIn 0.8s ease-out forwards;
        }

        .slide-up {
            animation: slideUp 0.6s ease-out forwards;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .netflix-red {
            background: #e50914;
        }

        .netflix-red:hover {
            background: #b20710;
        }
    </style>
</head>
<body class="min-h-screen text-white">

<jsp:include page="partials/navbar.jsp" />
<jsp:include page="partials/carousel.jsp"/>
<!-- Hero Section -->
<section class="pt-16 pb-12">
    <div class="hero-gradient text-center py-20 fade-in">
        <div class="max-w-4xl mx-auto px-4">
            <h1 class="text-5xl md:text-7xl font-bold mb-6">
                Book Your Movie
                <span class="block text-3xl md:text-4xl font-normal mt-2 opacity-90">Experience Cinema Like Never Before</span>
            </h1>
            <p class="text-xl md:text-2xl opacity-90 mb-8">
                Premium seats, latest movies, unforgettable moments
            </p>
            <div class="flex justify-center">
                <div class="glow-effect rounded-full p-1">
                    <i class="fas fa-play text-6xl text-white animate-pulse"></i>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Movies Section -->
<section class="py-16">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="slide-up">
            <h2 class="text-4xl font-bold text-center mb-4">
                <i class="fas fa-star text-yellow-500 mr-3"></i>
                Now Showing
            </h2>
            <p class="text-xl text-center text-gray-400 mb-12">
                Choose from our collection of blockbuster movies
            </p>
        </div>

        <!-- Movies Grid -->
        <div id="movies-grid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">
            <!-- Movies will be loaded here by JavaScript -->
        </div>

        <!-- Loading State -->
        <div id="loading" class="text-center py-20">
            <div class="inline-flex items-center justify-center w-16 h-16 border-4 border-red-600 border-t-transparent rounded-full animate-spin mb-4"></div>
            <p class="text-xl text-gray-400">Loading amazing movies...</p>
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="py-20 bg-black/40">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
            <h2 class="text-4xl font-bold mb-4">Why Choose MovieMate?</h2>
            <p class="text-xl text-gray-400">Premium movie experience with unmatched convenience</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div class="text-center p-8 rounded-lg bg-gray-900/50 backdrop-blur-sm border border-gray-800/50 hover:border-red-500/50 transition-all duration-300">
                <div class="w-16 h-16 bg-red-600 rounded-full flex items-center justify-center mx-auto mb-6">
                    <i class="fas fa-couch text-2xl text-white"></i>
                </div>
                <h3 class="text-2xl font-semibold mb-4">Premium Seats</h3>
                <p class="text-gray-400">Comfortable reclining seats with perfect viewing angles</p>
            </div>

            <div class="text-center p-8 rounded-lg bg-gray-900/50 backdrop-blur-sm border border-gray-800/50 hover:border-red-500/50 transition-all duration-300">
                <div class="w-16 h-16 bg-red-600 rounded-full flex items-center justify-center mx-auto mb-6">
                    <i class="fas fa-mobile-alt text-2xl text-white"></i>
                </div>
                <h3 class="text-2xl font-semibold mb-4">Easy Booking</h3>
                <p class="text-gray-400">Book your tickets in just a few clicks from anywhere</p>
            </div>

            <div class="text-center p-8 rounded-lg bg-gray-900/50 backdrop-blur-sm border border-gray-800/50 hover:border-red-500/50 transition-all duration-300">
                <div class="w-16 h-16 bg-red-600 rounded-full flex items-center justify-center mx-auto mb-6">
                    <i class="fas fa-shield-alt text-2xl text-white"></i>
                </div>
                <h3 class="text-2xl font-semibold mb-4">Secure Payment</h3>
                <p class="text-gray-400">Safe and secure payment methods for your peace of mind</p>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<jsp:include page="partials/footer.jsp" />
<script src="/js/home.js"></script>
<script src="/js/index.js"></script>
</body>
</html>