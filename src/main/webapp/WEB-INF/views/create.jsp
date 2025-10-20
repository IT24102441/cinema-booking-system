<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Your Seats - MovieMate</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/home.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #0f0f23 0%, #1a1a2e 100%);
        }

        .seat {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            border: 2px solid #374151;
            background: #1f2937;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 600;
            color: #9ca3af;
        }

        .seat.available:hover {
            border-color: #e50914;
            background: #dc2626;
            color: white;
            transform: scale(1.1);
            box-shadow: 0 4px 15px rgba(229, 9, 20, 0.4);
        }

        .seat.selected {
            border-color: #e50914;
            background: #e50914;
            color: white;
            transform: scale(1.1);
            box-shadow: 0 4px 15px rgba(229, 9, 20, 0.6);
        }

        .seat.booked {
            border-color: #6b7280;
            background: #374151;
            color: #9ca3af;
            cursor: not-allowed;
        }

        .screen {
            background: linear-gradient(135deg, #e50914 0%, #b20710 100%);
            border-radius: 100px;
            height: 8px;
            position: relative;
            margin: 0 auto 40px;
            box-shadow: 0 4px 20px rgba(229, 9, 20, 0.4);
        }

        .screen::before {
            content: "SCREEN";
            position: absolute;
            top: -30px;
            left: 50%;
            transform: translateX(-50%);
            color: #e50914;
            font-weight: 600;
            font-size: 14px;
            letter-spacing: 2px;
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

        .loading-spinner {
            border: 4px solid #374151;
            border-top: 4px solid #e50914;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .modal-overlay {
            backdrop-filter: blur(8px);
            transition: opacity 0.3s ease-out;
        }

        .modal-content {
            animation: modalSlideUp 0.4s ease-out forwards;
        }

        @keyframes modalSlideUp {
            from {
                opacity: 0;
                transform: translateY(50px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .card-input {
            background: rgba(31, 41, 55, 0.8);
            border: 2px solid #374151;
            color: white;
            transition: all 0.3s ease;
        }

        .card-input:focus {
            border-color: #e50914;
            background: rgba(31, 41, 55, 1);
            outline: none;
        }

        .payment-progress {
            width: 0%;
            transition: width 2s ease-in-out;
        }
    </style>
</head>
<body class="min-h-screen text-white">
<jsp:include page="partials/navbar.jsp" />
<!-- Navigation -->
<nav class="fixed top-0 w-full z-50 bg-black/90 backdrop-blur-md border-b border-gray-800/50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="flex items-center space-x-4">
                <a href="/" class="text-2xl font-bold text-red-600">
                    <i class="fas fa-film mr-2"></i>MovieMate
                </a>
            </div>
            <div class="flex items-center space-x-6">
                <a href="/" class="text-gray-400 hover:text-red-500 transition-colors">
                    <i class="fas fa-arrow-left mr-2"></i>Back to Movies
                </a>
            </div>
        </div>
    </div>
</nav>

<!-- Main Content -->
<main class="pt-20 pb-12">
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Movie Info -->
        <div class="text-center mb-12 fade-in">
            <h1 id="movie-title" class="text-4xl md:text-5xl font-bold mb-4">Loading...</h1>
            <p class="text-xl text-gray-400 mb-6">Select your preferred seats</p>
            <div class="flex justify-center items-center space-x-8 text-sm">
                <div class="flex items-center">
                    <div class="seat available mr-2"></div>
                    <span>Available</span>
                </div>
                <div class="flex items-center">
                    <div class="seat selected mr-2"></div>
                    <span>Selected</span>
                </div>
                <div class="flex items-center">
                    <div class="seat booked mr-2"></div>
                    <span>Booked</span>
                </div>
            </div>
        </div>

        <!-- Loading State -->
        <div id="loading-seats" class="text-center py-20">
            <div class="loading-spinner mx-auto mb-4"></div>
            <p class="text-xl text-gray-400">Loading seat availability...</p>
        </div>

        <!-- Seat Selection -->
        <div id="seat-container" class="hidden slide-up">
            <div class="bg-gray-900/80 backdrop-blur-sm rounded-lg p-8 border border-gray-800/50">
                <!-- Screen -->
                <div class="screen w-3/4 mb-12"></div>

                <!-- Seats Grid -->
                <div id="seats-grid" class="space-y-4">
                    <!-- Seats will be loaded here by JavaScript -->
                </div>
            </div>
        </div>

        <!-- Booking Summary -->
        <div id="booking-summary" class="hidden mt-8 slide-up">
            <div class="bg-gray-900/80 backdrop-blur-sm rounded-lg p-6 border border-gray-800/50">
                <h3 class="text-2xl font-bold mb-4">
                    <i class="fas fa-ticket-alt text-red-500 mr-2"></i>
                    Booking Summary
                </h3>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Selected Seats -->
                    <div>
                        <h4 class="text-lg font-semibold mb-3">Selected Seats</h4>
                        <div id="selected-seats-list" class="space-y-2">
                            <!-- Selected seats will appear here -->
                        </div>
                    </div>

                    <!-- Price Details -->
                    <div>
                        <h4 class="text-lg font-semibold mb-3">Price Details</h4>
                        <div class="space-y-2">
                            <div class="flex justify-between">
                                <span>Seat Price:</span>
                                <span id="seat-price">$0.00</span>
                            </div>
                            <div class="flex justify-between">
                                <span>Number of Seats:</span>
                                <span id="seat-count">0</span>
                            </div>
                            <!-- Promotion input moved here -->
                            <div class="mt-2">
                                <div class="flex items-center space-x-2">
                                    <input type="text" id="promo-code-input" placeholder="Promo code (optional)"
                                           class="flex-1 px-3 py-2 bg-gray-800/60 text-white rounded border border-gray-700" />
                                    <button type="button" id="apply-promo-btn" class="px-3 py-2 bg-indigo-600 rounded hover:bg-indigo-500">Apply</button>
                                </div>
                                <p id="promo-message" class="text-sm mt-2 text-yellow-300"></p>
                                <p id="promo-discount" class="text-sm mt-1 text-green-400"></p>
                            </div>
                            <div class="border-t border-gray-700 pt-2 flex justify-between font-bold text-lg">
                                <span>Total:</span>
                                <span id="total-price">$0.00</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Customer Information Form -->
        <div id="customer-form" class="hidden mt-8 slide-up">
            <div class="bg-gray-900/80 backdrop-blur-sm rounded-lg p-6 border border-gray-800/50">
                <h3 class="text-2xl font-bold mb-6">
                    <i class="fas fa-user text-red-500 mr-2"></i>
                    Customer Information
                </h3>

                <form id="booking-form" class="space-y-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-medium mb-2">Full Name *</label>
                            <input
                                    type="text"
                                    id="customer-name"
                                    required
                                    class="w-full px-4 py-3 bg-gray-800/50 border border-gray-700 rounded-lg focus:border-red-500 focus:outline-none transition-colors"
                                    placeholder="Enter your full name"
                            >
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-2">Email Address *</label>
                            <input
                                    type="email"
                                    id="customer-email"
                                    required
                                    class="w-full px-4 py-3 bg-gray-800/50 border border-gray-700 rounded-lg focus:border-red-500 focus:outline-none transition-colors"
                                    placeholder="Enter your email"
                            >
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-2">Contact Number *</label>
                            <input
                                    type="tel"
                                    id="contact-number"
                                    required
                                    class="w-full px-4 py-3 bg-gray-800/50 border border-gray-700 rounded-lg focus:border-red-500 focus:outline-none transition-colors"
                                    placeholder="Enter your contact number"
                            >
                        </div>
                    </div>

                    <!-- Receipt upload moved to dedicated page after booking is created -->

                    <div class="flex justify-center">
                        <button
                                type="submit"
                                id="book-now-btn"
                                class="netflix-red text-white py-3 px-8 rounded-lg font-semibold transition-all duration-300 hover:transform hover:scale-105 hover:shadow-lg flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed"
                        >
                            <i class="fas fa-paperclip mr-2"></i>
                            <span id="book-btn-text">Place Booking</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<!-- Removed Payment Gateway Modal -->

<!-- Success Modal -->
<div id="success-modal" class="hidden fixed inset-0 bg-black/80 backdrop-blur-sm z-50 flex items-center justify-center modal-overlay">
    <div class="bg-gray-900 rounded-xl p-8 max-w-md mx-4 border border-gray-800 modal-content">
        <div class="text-center">
            <div class="w-16 h-16 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-4">
                <i class="fas fa-check text-2xl text-white"></i>
            </div>
            <h3 class="text-2xl font-bold mb-4">Booking Confirmed!</h3>
            <p class="text-gray-400 mb-6">Your movie tickets have been successfully booked.</p>
            <div id="booking-details" class="text-left bg-gray-800/50 rounded-lg p-4 mb-6">
                <!-- Booking details will be shown here -->
            </div>
            <button
                    onclick="window.location.href='/'"
                    class="netflix-red text-white py-2 px-6 rounded-lg font-semibold hover:bg-red-700 transition-colors"
            >
                Back to Home
            </button>
        </div>
    </div>
</div>

<jsp:include page="partials/footer.jsp" />
<script src="/js/create.js"></script>
</body>
</html>
