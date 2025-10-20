<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MovieMate - Admin Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #0f0f23 0%, #1a1a2e 100%);
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

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .card-hover {
            transition: all 0.3s ease;
        }

        .card-hover:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(229, 9, 20, 0.2);
        }

        .admin-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .booking-gradient {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .movie-gradient {
            background: linear-gradient(135deg, #f59e0b 0%, #f97316 100%);
        }

        .promo-gradient {
            background: linear-gradient(135deg, #06b6d4 0%, #0ea5a0 100%);
        }

        .review-gradient {
            background: linear-gradient(135deg, #8b5cf6 0%, #a855f7 100%);
        }

        .add-movie-form {
            margin-top: 1rem;
            background: rgba(0, 0, 0, 0.5);
            padding: 1rem;
            border-radius: 8px;
        }

        .add-movie-form label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: bold;
        }

        .add-movie-form input,
        .add-movie-form textarea {
            width: 100%;
            padding: 0.5rem;
            margin-bottom: 1rem;
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 4px;
            background: rgba(255, 255, 255, 0.04);
            color: white;
        }

        .add-movie-form button {
            background: #e50914;
            color: white;
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .add-movie-form button:hover {
            background: #b20710;
        }
    </style>
</head>
<body class="min-h-screen text-white">
<!-- Navigation -->
<nav class="fixed top-0 w-full z-50 bg-black/90 backdrop-blur-md border-b border-gray-800/50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="flex items-center space-x-4">
                <a href="/">
                    <h1 class="text-2xl font-bold text-red-600">
                        <i class="fas fa-film mr-2"></i>MovieMate
                    </h1>
                </a>
            </div>
            <div class="hidden md:flex items-center space-x-6">
                <a href="/" class="text-gray-400 hover:text-red-500 transition-colors">
                    <i class="fas fa-home mr-2"></i>Home
                </a>
                <button class="text-gray-400 hover:text-red-500 transition-colors">
                    <i class="fas fa-sign-out-alt mr-2"></i>Logout
                </button>
            </div>
            <div class="md:hidden">
                <button class="text-white hover:text-red-500">
                    <i class="fas fa-bars text-xl"></i>
                </button>
            </div>
        </div>
    </div>
</nav>

<!-- Dashboard Section -->
<section class="pt-16 pb-12 min-h-screen">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="fade-in">
            <!-- Dashboard Header -->
            <div class="text-center mb-12 pt-8">
                <div class="hero-gradient w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4 glow-effect">
                    <i class="fas fa-tachometer-alt text-3xl text-white"></i>
                </div>
                <h1 class="text-4xl font-bold mb-4">Admin Dashboard</h1>
                <p class="text-gray-400 text-lg">Manage your MovieMate platform</p>
            </div>

            <!-- Dashboard Cards -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-8 max-w-7xl mx-auto">
                <!-- Admin Management Card -->
                <div class="fade-in">
                    <a href="/admin-list" class="block">
                        <div class="card-hover bg-gray-900/50 backdrop-blur-sm border border-gray-800/50 rounded-xl p-8 text-center">
                            <div class="admin-gradient w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-6">
                                <i class="fas fa-users-cog text-2xl text-white"></i>
                            </div>
                            <h3 class="text-2xl font-bold mb-4">Admin Management</h3>
                            <p class="text-gray-400 mb-6 leading-relaxed">
                                Manage administrator accounts, permissions, and user roles. Add, edit, or remove admin access for team members.
                            </p>
                            <div class="flex items-center justify-center space-x-2 text-blue-400">
                                <span class="font-medium">Manage Admins</span>
                                <i class="fas fa-arrow-right"></i>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- Booking Management Card -->
                <div class="fade-in" style="animation-delay: 0.2s;">
                    <a href="/admin/bookings" class="block">
                        <div class="card-hover bg-gray-900/50 backdrop-blur-sm border border-gray-800/50 rounded-xl p-8 text-center">
                            <div class="booking-gradient w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-6">
                                <i class="fas fa-ticket-alt text-2xl text-white"></i>
                            </div>
                            <h3 class="text-2xl font-bold mb-4">Booking Management</h3>
                            <p class="text-gray-400 mb-6 leading-relaxed">
                                View and manage all movie bookings, cancellations, and customer reservations. Monitor booking analytics and reports.
                            </p>
                            <div class="flex items-center justify-center space-x-2 text-pink-400">
                                <span class="font-medium">Manage Bookings</span>
                                <i class="fas fa-arrow-right"></i>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- Movie Management Card -->
                <div class="fade-in" style="animation-delay: 0.4s;">
                    <a href="/admin/movies" class="block">
                        <div class="card-hover bg-gray-900/50 backdrop-blur-sm border border-gray-800/50 rounded-xl p-8 text-center">
                            <div class="movie-gradient w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-6">
                                <i class="fas fa-film text-2xl text-white"></i>
                            </div>
                            <h3 class="text-2xl font-bold mb-4">Movie Management</h3>
                            <p class="text-gray-400 mb-6 leading-relaxed">Add, edit, or remove movies in the catalog. Manage movie metadata and availability.</p>
                            <div class="flex items-center justify-center space-x-2 text-yellow-400">
                                <span class="font-medium">Manage Movies</span>
                                <i class="fas fa-arrow-right"></i>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- Promotion Management Card -->
                <div class="fade-in" style="animation-delay: 0.6s;">
                    <a href="/admin/promotions" class="block">
                        <div class="card-hover bg-gray-900/50 backdrop-blur-sm border border-gray-800/50 rounded-xl p-8 text-center">
                            <div class="promo-gradient w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-6">
                                <i class="fas fa-tags text-2xl text-white"></i>
                            </div>
                            <h3 class="text-2xl font-bold mb-4">Promotion Management</h3>
                            <p class="text-gray-400 mb-6 leading-relaxed">Create and manage promotions, discounts, and featured placements. Schedule campaigns and monitor their performance.</p>
                            <div class="flex items-center justify-center space-x-2 text-teal-300">
                                <span class="font-medium">Manage Promotions</span>
                                <i class="fas fa-arrow-right"></i>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- Review Management Card -->
                <div class="fade-in" style="animation-delay: 0.8s;">
                    <a href="/admin/reviews" class="block">
                        <div class="card-hover bg-gray-900/50 backdrop-blur-sm border border-gray-800/50 rounded-xl p-8 text-center">
                            <div class="review-gradient w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-6">
                                <i class="fas fa-star text-2xl text-white"></i>
                            </div>
                            <h3 class="text-2xl font-bold mb-4">Review Management</h3>
                            <p class="text-gray-400 mb-6 leading-relaxed">Monitor and manage user reviews, handle reported content, and maintain review quality across all movies.</p>
                            <div class="flex items-center justify-center space-x-2 text-purple-300">
                                <span class="font-medium">Manage Reviews</span>
                                <i class="fas fa-arrow-right"></i>
                            </div>
                        </div>
                    </a>
                </div>
            </div>

            <!-- Quick Stats Section -->
            <div class="mt-16 grid grid-cols-1 md:grid-cols-3 gap-6 max-w-6xl mx-auto">
                <div class="bg-gray-900/30 backdrop-blur-sm border border-gray-800/30 rounded-lg p-6 text-center">
                    <div class="text-3xl font-bold text-red-500 mb-2">
                        <i class="fas fa-users mr-2"></i>1,247
                    </div>
                    <p class="text-gray-400">Total Users</p>
                </div>
                <div class="bg-gray-900/30 backdrop-blur-sm border border-gray-800/30 rounded-lg p-6 text-center">
                    <div class="text-3xl font-bold text-green-500 mb-2">
                        <i class="fas fa-ticket-alt mr-2"></i>853
                    </div>
                    <p class="text-gray-400">Active Bookings</p>
                </div>
                <div class="bg-gray-900/30 backdrop-blur-sm border border-gray-800/30 rounded-lg p-6 text-center">
                    <div class="text-3xl font-bold text-blue-500 mb-2">
                        <i class="fas fa-film mr-2"></i>42
                    </div>
                    <p class="text-gray-400">Movies Available</p>
                </div>
            </div>
        </div>
    </div>
</section>
</body>
</html>