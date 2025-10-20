<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MovieMate - Profile</title>
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

        /* Modal Enhancements */
        .modal-backdrop {
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
        }

        .modal-container {
            max-height: 90vh;
            overflow-y: auto;
            animation: modalSlideIn 0.3s ease-out;
        }

        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: scale(0.9) translateY(-20px);
            }
            to {
                opacity: 1;
                transform: scale(1) translateY(0);
            }
        }

        /* Improved responsive layout */
        .profile-section {
            min-height: calc(168vh - 11rem);
            padding: 1rem 0;
        }

        .profile-form-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 1rem;
        }

        /* Better spacing for sections */
        .account-info-section {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid rgba(107, 114, 128, 0.3);
        }

        .profile-header-section {
            margin-bottom: 1rem;
        }

        /* Ensure modals are always visible */
        .modal-fix {
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            width: 100vw !important;
            height: 100vh !important;
            z-index: 99999 !important;
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

                <a href="/my-reviews" id="my-reviews-tag" class="text-gray-400 hover:text-red-500 transition-colors">
                    <i class="fas fa-star mr-2"></i>My Reviews
                </a>

                <button id="logoutBtn" class="text-gray-400 hover:text-red-500 transition-colors">
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

<!-- Profile Section -->
<section class="pt-32 pb-32 profile-section flex items-center justify-center">
    <div class="profile-form-container w-full mx-4 px-4">
        <div class="fade-in">
            <!-- Profile Header -->
            <div class="text-center profile-header-section">
                <div class="hero-gradient w-20 h-20 sm:w-24 sm:h-24 rounded-full flex items-center justify-center mx-auto mb-4 glow-effect">
                    <i class="fas fa-user text-3xl sm:text-4xl text-white"></i>
                </div>
                <h1 class="text-2xl sm:text-3xl font-bold mb-2">My Profile</h1>
                <p class="text-gray-400 text-sm sm:text-base">Manage your account information</p>
            </div>

            <!-- Profile Form -->
            <div class="bg-gray-900/50 backdrop-blur-sm border border-gray-800/50 rounded-lg p-4 sm:p-6 lg:p-8">
                <form id="profileForm">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
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
                    </div>

                    <!-- Email Field (readonly) -->
                    <div class="mb-6">
                        <label for="email" class="block text-sm font-medium mb-2">
                            <i class="fas fa-envelope mr-2 text-red-500"></i>Email Address
                        </label>
                        <input
                                type="email"
                                id="email"
                                name="email"
                                class="form-field w-full px-4 py-3 bg-gray-700 border border-gray-600 rounded-lg cursor-not-allowed opacity-60"
                                placeholder="Your email"
                                readonly
                        >
                        <p class="text-xs text-gray-500 mt-1">Email cannot be changed</p>
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

                    <!-- Change Password Button -->
                    <div class="mb-6">
                        <button
                                type="button"
                                id="changePasswordBtn"
                                class="w-full bg-blue-600 hover:bg-blue-700 text-white py-3 px-4 rounded-lg font-medium transition-all duration-300 hover:shadow-lg"
                        >
                            <i class="fas fa-key mr-2"></i>Change Password
                        </button>
                        <p class="text-xs text-gray-500 mt-2 text-center">
                            Click to change your password
                        </p>
                    </div>

                    <!-- Action Buttons -->
                    <div class="flex flex-col sm:flex-row gap-4">
                        <button
                                type="submit"
                                id="updateBtn"
                                class="flex-1 netflix-red text-white py-3 px-4 rounded-lg font-medium transition-all duration-300 hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed"
                        >
                            <span id="updateBtnText">
                                <i class="fas fa-save mr-2"></i>Update Profile
                            </span>
                            <span id="updateBtnLoading" class="hidden">
                                <i class="fas fa-spinner fa-spin mr-2"></i>Updating...
                            </span>
                        </button>

                        <button
                                type="button"
                                id="deleteBtn"
                                class="flex-1 bg-red-600 hover:bg-red-700 text-white py-3 px-4 rounded-lg font-medium transition-all duration-300 hover:shadow-lg"
                        >
                            <i class="fas fa-trash mr-2"></i>Delete Account
                        </button>
                    </div>

                    <!-- Success/Error Messages -->
                    <div id="profileMessage" class="hidden mt-4 p-3 rounded-lg text-center"></div>
                </form>

                <!-- Account Info -->
                <div class="account-info-section">
                    <h3 class="text-lg font-semibold text-gray-300 mb-4 flex items-center">
                        <i class="fas fa-info-circle mr-2 text-red-500"></i>Account Information
                    </h3>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 text-sm">
                        <div class="bg-gray-800/50 rounded-lg p-4 border border-gray-700/50">
                            <div class="flex items-center mb-2">
                                <i class="fas fa-calendar-plus text-red-500 mr-2"></i>
                                <span class="font-medium text-gray-300">Account Created</span>
                            </div>
                            <span id="createdAt" class="text-gray-400 text-sm">Loading...</span>
                        </div>
                        <div class="bg-gray-800/50 rounded-lg p-4 border border-gray-700/50">
                            <div class="flex items-center mb-2">
                                <i class="fas fa-calendar-edit text-red-500 mr-2"></i>
                                <span class="font-medium text-gray-300">Last Updated</span>
                            </div>
                            <span id="updatedAt" class="text-gray-400 text-sm">Loading...</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Delete Confirmation Modal -->
<div id="deleteModal" class="modal-fix bg-black/80 modal-backdrop hidden flex items-center justify-center">
    <div class="bg-gray-900 border border-gray-800 rounded-lg p-4 sm:p-6 max-w-md mx-4 modal-container shadow-2xl">
        <div class="text-center">
            <div class="bg-red-600/20 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <i class="fas fa-exclamation-triangle text-2xl text-red-500"></i>
            </div>
            <h3 class="text-xl font-bold mb-2">Delete Account</h3>
            <p class="text-gray-400 mb-6">
                This action cannot be undone. Your account and all associated data will be permanently deleted.
            </p>
            <div class="flex gap-3">
                <button id="cancelDelete" class="flex-1 bg-gray-700 hover:bg-gray-600 text-white py-2 px-4 rounded-lg transition-colors">
                    Cancel
                </button>
                <button id="confirmDelete" class="flex-1 bg-red-600 hover:bg-red-700 text-white py-2 px-4 rounded-lg transition-colors">
                    <span id="deleteConfirmText">Delete</span>
                    <span id="deleteConfirmLoading" class="hidden">
                        <i class="fas fa-spinner fa-spin"></i>
                    </span>
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Password Confirmation Modal -->
<div id="passwordModal" class="modal-fix bg-black/80 modal-backdrop hidden flex items-center justify-center">
    <div class="bg-gray-900 border border-gray-800 rounded-lg p-4 sm:p-6 max-w-md mx-4 w-full modal-container shadow-2xl">
        <div class="text-center mb-6">
            <div class="bg-blue-600/20 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <i class="fas fa-lock text-2xl text-blue-500"></i>
            </div>
            <h3 class="text-xl font-bold mb-2">Change Password</h3>
            <p class="text-gray-400 text-sm">
                Please enter your current password and your new password
            </p>
        </div>
        
        <form id="passwordConfirmForm">
            <!-- Current Password Field -->
            <div class="mb-4">
                <label for="currentPassword" class="block text-sm font-medium mb-2 text-left">
                    <i class="fas fa-key mr-2 text-red-500"></i>Current Password
                </label>
                <div class="relative">
                    <input
                            type="password"
                            id="currentPassword"
                            name="currentPassword"
                            class="form-field w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none transition-all duration-300 pr-12"
                            placeholder="Enter your current password"
                            required
                    >
                    <button
                            type="button"
                            id="toggleCurrentPassword"
                            class="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-white"
                    >
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
                <div id="currentPasswordError" class="error-message hidden"></div>
            </div>

            <!-- New Password Field -->
            <div class="mb-4">
                <label for="newPassword" class="block text-sm font-medium mb-2 text-left">
                    <i class="fas fa-lock mr-2 text-red-500"></i>New Password
                </label>
                <div class="relative">
                    <input
                            type="password"
                            id="newPassword"
                            name="newPassword"
                            class="form-field w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none transition-all duration-300 pr-12"
                            placeholder="Enter your new password"
                            required
                    >
                    <button
                            type="button"
                            id="toggleNewPassword"
                            class="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-white"
                    >
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
                <div id="newPasswordError" class="error-message hidden"></div>
            </div>

            <!-- Confirm New Password Field -->
            <div class="mb-6">
                <label for="confirmNewPassword" class="block text-sm font-medium mb-2 text-left">
                    <i class="fas fa-lock mr-2 text-red-500"></i>Confirm New Password
                </label>
                <div class="relative">
                    <input
                            type="password"
                            id="confirmNewPassword"
                            name="confirmNewPassword"
                            class="form-field w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none transition-all duration-300 pr-12"
                            placeholder="Re-enter your new password"
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

            <!-- Modal Message -->
            <div id="passwordModalMessage" class="hidden mb-4 p-3 rounded-lg text-center"></div>

            <!-- Action Buttons -->
            <div class="flex gap-3">
                <button type="button" id="cancelPassword" class="flex-1 bg-gray-700 hover:bg-gray-600 text-white py-2 px-4 rounded-lg transition-colors">
                    Cancel
                </button>
                <button type="submit" id="confirmPassword" class="flex-1 netflix-red text-white py-2 px-4 rounded-lg transition-colors">
                    <span id="confirmPasswordText">Change Password</span>
                    <span id="confirmPasswordLoading" class="hidden">
                        <i class="fas fa-spinner fa-spin mr-2"></i>Updating...
                    </span>
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Logout Confirmation Modal -->
<div id="logoutModal" class="modal-fix bg-black/80 modal-backdrop hidden flex items-center justify-center">
    <div class="bg-gray-900 border border-gray-800 rounded-lg p-4 sm:p-6 max-w-md mx-4 modal-container shadow-2xl">
        <div class="text-center">
            <div class="bg-yellow-600/20 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <i class="fas fa-sign-out-alt text-2xl text-yellow-500"></i>
            </div>
            <h3 class="text-xl font-bold mb-2">Logout</h3>
            <p class="text-gray-400 mb-6">
                Are you sure you want to logout?
            </p>
            <div class="flex gap-3">
                <button id="cancelLogout" class="flex-1 bg-gray-700 hover:bg-gray-600 text-white py-2 px-4 rounded-lg transition-colors">
                    Cancel
                </button>
                <button id="confirmLogout" class="flex-1 netflix-red text-white py-2 px-4 rounded-lg transition-colors">
                    Logout
                </button>
            </div>
        </div>
    </div>
</div>
<jsp:include page="partials/footer.jsp" />
<script src="/js/profile.js"></script>
</body>
</html>