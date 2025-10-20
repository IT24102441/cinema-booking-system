<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MovieMate - Register</title>
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

        .field-valid {
            border-color: #10b981;
        }

        .field-invalid {
            border-color: #ef4444;
        }

        /* Improved responsive layout for register page */
        .register-section {
            min-height: calc(178vh - 5rem);
            padding: 8rem 1rem 3rem; /* top padding to clear fixed navbar */
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Center form container and give breathing space */
        .register-form-container {
            max-width: 480px;
            width: 100%;
            margin: 0 auto;
            padding: 2rem;
        }

        /* Better spacing for form fields */
        .register-form-container form > div {
            margin-bottom: 1.25rem;
        }

        /* Card-style background consistency */
        .register-card {
            background: rgba(17, 24, 39, 0.7); /* matches Tailwind gray-900/70 */
            backdrop-filter: blur(6px);
            border: 1px solid rgba(75, 85, 99, 0.5);
            border-radius: 0.75rem;
            box-shadow: 0 0 20px rgba(0,0,0,0.4);
        }

        /* Responsive adjustments for smaller devices */
        @media (max-width: 640px) {
            .register-section {
                padding-top: 7rem;
            }
            .register-form-container {
                padding: 1.5rem;
            }
        }

        /* Fade-in animation for smooth entrance */
        .register-fade-in {
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.6s ease-out forwards;
        }

        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
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

                <a href="/login" class="text-gray-400 hover:text-red-500 transition-colors">
                    <i class="fas fa-sign-in-alt mr-2"></i>Login
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

<!-- Register Section -->
<section class="register-section">
    <div class="register-form-container register-fade-in">
        <div class="fade-in">
            <!-- Logo and Title -->
            <div class="text-center mb-8">
                <div class="hero-gradient w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4 glow-effect">
                    <i class="fas fa-user-plus text-3xl text-white"></i>
                </div>
                <h1 class="text-3xl font-bold mb-2">Join MovieMate</h1>
                <p class="text-gray-400">Create your account to book amazing movies</p>
            </div>

            <!-- Registration Form -->
            <div class="register-card p-8">
            <form id="registerForm">
                    <!-- First Name Field -->
                    <div class="mb-6">
                        <label for="firstName" class="block text-sm font-medium mb-2">
                            <i class="fas fa-user mr-2 text-red-500"></i>First Name
                        </label>
                        <input
                                type="text"
                                id="firstName"
                                name="firstName"
                                class="form-field w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none transition-all duration-300"
                                placeholder="Enter your first name"
                                required
                        >
                        <div id="firstNameError" class="error-message hidden"></div>
                    </div>

                    <!-- Last Name Field -->
                    <div class="mb-6">
                        <label for="lastName" class="block text-sm font-medium mb-2">
                            <i class="fas fa-user mr-2 text-red-500"></i>Last Name
                        </label>
                        <input
                                type="text"
                                id="lastName"
                                name="lastName"
                                class="form-field w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none transition-all duration-300"
                                placeholder="Enter your last name"
                                required
                        >
                        <div id="lastNameError" class="error-message hidden"></div>
                    </div>

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

                    <!-- Contact Number Field -->
                    <div class="mb-6">
                        <label for="contactNumber" class="block text-sm font-medium mb-2">
                            <i class="fas fa-phone mr-2 text-red-500"></i>Contact Number
                        </label>
                        <input
                                type="tel"
                                id="contactNumber"
                                name="contactNumber"
                                class="form-field w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none transition-all duration-300"
                                placeholder="Enter your contact number"
                                required
                        >
                        <div id="contactNumberError" class="error-message hidden"></div>
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
                                    placeholder="Create a strong password"
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
                        <div class="mt-2 text-xs text-gray-500">
                            Password must be at least 8 characters with uppercase, lowercase, number, and special character
                        </div>
                    </div>

                    <!-- Confirm Password Field -->
                    <div class="mb-6">
                        <label for="confirmPassword" class="block text-sm font-medium mb-2">
                            <i class="fas fa-lock mr-2 text-red-500"></i>Confirm Password
                        </label>
                        <div class="relative">
                            <input
                                    type="password"
                                    id="confirmPassword"
                                    name="confirmPassword"
                                    class="form-field w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none transition-all duration-300 pr-12"
                                    placeholder="Confirm your password"
                                    required
                            >
                            <button
                                    type="button"
                                    id="toggleConfirmPassword"
                                    class="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-white"
                            >
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div id="confirmPasswordError" class="error-message hidden"></div>
                    </div>

                    <!-- Terms and Conditions -->
                    <div class="mb-6">
                        <label class="flex items-start">
                            <input
                                    type="checkbox"
                                    id="agreeTerms"
                                    class="w-4 h-4 text-red-600 bg-gray-800 border-gray-600 rounded focus:ring-red-500 mt-1 mr-3"
                                    required
                            >
                            <span class="text-sm text-gray-400">
                                I agree to the
                                <a href="/terms" class="text-red-500 hover:text-red-400">Terms of Service</a>
                                and
                                <a href="/privacy" class="text-red-500 hover:text-red-400">Privacy Policy</a>
                            </span>
                        </label>
                        <div id="agreeTermsError" class="error-message hidden"></div>
                    </div>

                    <!-- Submit Button -->
                    <button
                            type="submit"
                            id="registerBtn"
                            class="w-full netflix-red text-white py-3 px-4 rounded-lg font-medium transition-all duration-300 hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        <span id="registerBtnText">
                            <i class="fas fa-user-plus mr-2"></i>Create Account
                        </span>
                        <span id="registerBtnLoading" class="hidden">
                            <i class="fas fa-spinner fa-spin mr-2"></i>Creating Account...
                        </span>
                    </button>

                    <!-- Success/Error Messages -->
                    <div id="registerMessage" class="hidden mt-4 p-3 rounded-lg text-center"></div>
                </form>

                <!-- Login Link -->
                <div class="text-center mt-6 pt-6 border-t border-gray-800/50">
                    <p class="text-gray-400">
                        Already have an account?
                        <a href="/login" class="text-red-500 hover:text-red-400 font-medium">
                            Sign in here
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</section>
<jsp:include page="partials/footer.jsp" />
<script src="/js/register.js"></script>
<script src="/js/index.js"></script>
</body>
</html>