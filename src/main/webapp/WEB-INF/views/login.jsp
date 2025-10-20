<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MovieMate - Login</title>
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
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .netflix-red {
            background: #e50914;
        }

        .netflix-red:hover {
            background: #b20710;
        }

        .form-field:focus {
            border-color: #e50914;
            box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.1);
        }

        .error-message {
            color: #ef4444;
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }

        .success-message {
            color: #10b981;
            font-size: 0.875rem;
            margin-top: 0.25rem;
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

                <a href="/browse-movies" class="text-gray-400 hover:text-red-500 transition-colors">
                    <i class="fas fa-film mr-2"></i>Browse Movies
                </a>

                <a href="/cinemas" class="text-gray-400 hover:text-red-500 transition-colors">
                    <i class="fas fa-theater-masks mr-2"></i>Cinemas
                </a>

                <a href="/promotions" class="text-gray-400 hover:text-red-500 transition-colors">
                    <i class="fas fa-tags mr-2"></i>Promotions
                </a>

                <a href="/my-bookings" id="my-bookings-tag" class="hidden text-gray-400 hover:text-red-500 transition-colors">
                    <i class="fas fa-ticket-alt mr-2"></i>My Bookings
                </a>

                <a href="/register" class="text-gray-400 hover:text-red-500 transition-colors">
                    <i class="fas fa-user-plus mr-2"></i>Register
                </a>
            </div>
            <div class="md:hidden">
                <button class="text-white hover:text-red-500">
                    <i class="fas fa-bars text-xl"></i>
                </button>
            </div>
        </div>
    </div>
</nav>

<!-- Login Section -->
<section class="pt-16 pb-25 min-h-screen flex items-center justify-center">
    <div class="max-w-md w-full mx-4">
        <div class="fade-in">
            <!-- Logo and Title -->
            <div class="text-center mb-8">
                <div class="hero-gradient w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4 glow-effect">
                    <i class="fas fa-film text-3xl text-white"></i>
                </div>
                <h1 class="text-3xl font-bold mb-2">Welcome Back</h1>
                <p class="text-gray-400">Sign in to your MovieMate account</p>
            </div>

            <!-- Login Form -->
            <div class="bg-gray-900/50 backdrop-blur-sm border border-gray-800/50 rounded-lg p-8">
                <form id="loginForm">
                    <!-- Email Field -->
                    <div class="mb-6">
                        <label for="email" class="block text-sm font-medium mb-2">
                            <i class="fas fa-envelope mr-2 text-red-500"></i>Email Address
                        </label>
                        <input
                                type="email"
                                id="email"
                                name="email"
                                class="form-field w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none transition-all duration-300"
                                placeholder="Enter your email"
                                required
                        >
                        <div id="emailError" class="error-message hidden"></div>
                    </div>

                    <!-- Password Field -->
                    <div class="mb-6">
                        <label for="password" class="block text-sm font-medium mb-2">
                            <i class="fas fa-lock mr-2 text-red-500"></i>Password
                        </label>
                        <div class="relative">
                            <input
                                    type="password"
                                    id="password"
                                    name="password"
                                    class="form-field w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none transition-all duration-300 pr-12"
                                    placeholder="Enter your password"
                                    required
                            >
                            <button
                                    type="button"
                                    id="togglePassword"
                                    class="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-white"
                            >
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div id="passwordError" class="error-message hidden"></div>
                    </div>

                    <!-- Remember Me -->
                    <div class="flex items-center justify-between mb-6">
                        <label class="flex items-center">
                            <input type="checkbox" id="rememberMe" class="w-4 h-4 text-red-600 bg-gray-800 border-gray-600 rounded focus:ring-red-500">
                            <span class="ml-2 text-sm text-gray-400">Remember me</span>
                        </label>
                        <a href="/forgot-password" class="text-sm text-red-500 hover:text-red-400">
                            Forgot password?
                        </a>
                    </div>

                    <!-- Submit Button -->
                    <button
                            type="submit"
                            id="loginBtn"
                            class="w-full netflix-red text-white py-3 px-4 rounded-lg font-medium transition-all duration-300 hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        <span id="loginBtnText">
                            <i class="fas fa-sign-in-alt mr-2"></i>Sign In
                        </span>
                        <span id="loginBtnLoading" class="hidden">
                            <i class="fas fa-spinner fa-spin mr-2"></i>Signing In...
                        </span>
                    </button>

                    <!-- Success/Error Messages -->
                    <div id="loginMessage" class="hidden mt-4 p-3 rounded-lg text-center">
                        <i id="messageIcon" class="fas mr-2"></i>
                        <span id="messageText"></span>
                    </div>
                </form>

                <!-- Register Link -->
                <div class="text-center mt-6 pt-6 border-t border-gray-800/50">
                    <p class="text-gray-400">
                        Don't have an account?
                        <a href="/register" class="text-red-500 hover:text-red-400 font-medium">
                            Create one now
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>
<jsp:include page="partials/footer.jsp" />
<script src="/js/login.js"></script>
<script src="/js/index.js"></script>
</body>
</html>