<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MovieMate - Cinemas</title>
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

        .cinema-card {
            background: rgba(17, 24, 39, 0.7);
            backdrop-filter: blur(6px);
            border: 1px solid rgba(75, 85, 99, 0.5);
            transition: all 0.3s ease;
        }

        .cinema-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
            border-color: rgba(229, 9, 20, 0.5);
        }

        .cinema-image {
            background: linear-gradient(45deg, #1f2937, #374151);
            background-size: 200% 200%;
            animation: gradientShift 3s ease infinite;
        }

        @keyframes gradientShift {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }

        .feature-icon {
            background: linear-gradient(135deg, #e50914, #b20710);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .search-input:focus {
            border-color: #e50914;
            box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.1);
        }

        .filter-btn {
            transition: all 0.3s ease;
        }

        .filter-btn.active {
            background: #e50914;
            color: white;
        }

        .filter-btn:hover {
            background: #b20710;
            color: white;
        }

        /* Responsive grid adjustments */
        @media (max-width: 768px) {
            .cinema-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (min-width: 769px) and (max-width: 1024px) {
            .cinema-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (min-width: 1025px) {
            .cinema-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }
    </style>
</head>
<body class="min-h-screen text-white">
    <jsp:include page="partials/navbar.jsp" />

    <!-- Hero Section -->
    <section class="pt-20 pb-12 bg-gradient-to-b from-gray-900/50 to-transparent">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center fade-in">
                <div class="hero-gradient w-20 h-20 sm:w-24 sm:h-24 rounded-full flex items-center justify-center mx-auto mb-6 glow-effect">
                    <i class="fas fa-theater-masks text-3xl sm:text-4xl text-white"></i>
                </div>
                <h1 class="text-4xl sm:text-5xl font-bold mb-4">Our Cinemas</h1>
                <p class="text-gray-400 text-lg max-w-2xl mx-auto">
                    Discover premium movie experiences at our state-of-the-art cinema locations
                </p>
            </div>
        </div>
    </section>

    <!-- Search and Filter Section -->
    <section class="py-8">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="fade-in">
                <!-- Search Bar -->
                <div class="mb-8">
                    <div class="relative max-w-md mx-auto">
                        <input
                            type="text"
                            id="cinemaSearch"
                            placeholder="Search cinemas..."
                            class="search-input w-full px-4 py-3 pl-12 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none transition-all duration-300"
                        >
                        <i class="fas fa-search absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    </div>
                </div>

                <!-- Filter Buttons -->
                <div class="flex flex-wrap justify-center gap-3 mb-8">
                    <button class="filter-btn active px-4 py-2 bg-gray-700 text-gray-300 rounded-lg" data-filter="all">
                        All Cinemas
                    </button>
                    <button class="filter-btn px-4 py-2 bg-gray-700 text-gray-300 rounded-lg" data-filter="premium">
                        <i class="fas fa-star mr-2 feature-icon"></i>Premium
                    </button>
                    <button class="filter-btn px-4 py-2 bg-gray-700 text-gray-300 rounded-lg" data-filter="imax">
                        <i class="fas fa-expand mr-2 feature-icon"></i>IMAX
                    </button>
                    <button class="filter-btn px-4 py-2 bg-gray-700 text-gray-300 rounded-lg" data-filter="dolby">
                        <i class="fas fa-volume-up mr-2 feature-icon"></i>Dolby Atmos
                    </button>
                    <button class="filter-btn px-4 py-2 bg-gray-700 text-gray-300 rounded-lg" data-filter="4dx">
                        <i class="fas fa-magic mr-2 feature-icon"></i>4DX
                    </button>
                </div>
            </div>
        </div>
    </section>

    <!-- Cinemas Grid -->
    <section class="pb-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="cinema-grid grid gap-8">
                <!-- Cinema 1: Premium IMAX -->
                <div class="cinema-card rounded-lg overflow-hidden" data-category="premium imax">
                    <div class="cinema-image h-48 flex items-center justify-center">
                        <i class="fas fa-theater-masks text-6xl text-gray-400"></i>
                    </div>
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-3">
                            <h3 class="text-xl font-bold text-white">CineMax Premium</h3>
                            <div class="flex space-x-1">
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                            </div>
                        </div>
                        <p class="text-gray-400 mb-4">
                            Experience movies like never before with our premium IMAX screens and luxury seating.
                        </p>
                        <div class="flex flex-wrap gap-2 mb-4">
                            <span class="px-3 py-1 bg-red-600/20 text-red-400 rounded-full text-sm">
                                <i class="fas fa-expand mr-1"></i>IMAX
                            </span>
                            <span class="px-3 py-1 bg-blue-600/20 text-blue-400 rounded-full text-sm">
                                <i class="fas fa-volume-up mr-1"></i>Dolby Atmos
                            </span>
                            <span class="px-3 py-1 bg-purple-600/20 text-purple-400 rounded-full text-sm">
                                <i class="fas fa-couch mr-1"></i>Luxury Seating
                            </span>
                        </div>
                        <div class="flex items-center justify-between">
                            <div class="text-sm text-gray-400">
                                <i class="fas fa-map-marker-alt mr-2"></i>Downtown Plaza
                            </div>
                            <button class="netflix-red text-white px-4 py-2 rounded-lg hover:shadow-lg transition-all">
                                View Details
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Cinema 2: 4DX Experience -->
                <div class="cinema-card rounded-lg overflow-hidden" data-category="4dx">
                    <div class="cinema-image h-48 flex items-center justify-center">
                        <i class="fas fa-magic text-6xl text-gray-400"></i>
                    </div>
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-3">
                            <h3 class="text-xl font-bold text-white">CineMax 4DX</h3>
                            <div class="flex space-x-1">
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-gray-400"></i>
                            </div>
                        </div>
                        <p class="text-gray-400 mb-4">
                            Feel the movie with motion seats, wind, rain, and scent effects for an immersive experience.
                        </p>
                        <div class="flex flex-wrap gap-2 mb-4">
                            <span class="px-3 py-1 bg-green-600/20 text-green-400 rounded-full text-sm">
                                <i class="fas fa-magic mr-1"></i>4DX
                            </span>
                            <span class="px-3 py-1 bg-orange-600/20 text-orange-400 rounded-full text-sm">
                                <i class="fas fa-wind mr-1"></i>Motion Effects
                            </span>
                            <span class="px-3 py-1 bg-pink-600/20 text-pink-400 rounded-full text-sm">
                                <i class="fas fa-tint mr-1"></i>Weather Effects
                            </span>
                        </div>
                        <div class="flex items-center justify-between">
                            <div class="text-sm text-gray-400">
                                <i class="fas fa-map-marker-alt mr-2"></i>Mall of Entertainment
                            </div>
                            <button class="netflix-red text-white px-4 py-2 rounded-lg hover:shadow-lg transition-all">
                                View Details
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Cinema 3: Dolby Atmos -->
                <div class="cinema-card rounded-lg overflow-hidden" data-category="dolby premium">
                    <div class="cinema-image h-48 flex items-center justify-center">
                        <i class="fas fa-volume-up text-6xl text-gray-400"></i>
                    </div>
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-3">
                            <h3 class="text-xl font-bold text-white">CineMax Dolby</h3>
                            <div class="flex space-x-1">
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                            </div>
                        </div>
                        <p class="text-gray-400 mb-4">
                            Crystal clear sound with Dolby Atmos technology and premium visual experience.
                        </p>
                        <div class="flex flex-wrap gap-2 mb-4">
                            <span class="px-3 py-1 bg-blue-600/20 text-blue-400 rounded-full text-sm">
                                <i class="fas fa-volume-up mr-1"></i>Dolby Atmos
                            </span>
                            <span class="px-3 py-1 bg-yellow-600/20 text-yellow-400 rounded-full text-sm">
                                <i class="fas fa-eye mr-1"></i>4K Vision
                            </span>
                            <span class="px-3 py-1 bg-red-600/20 text-red-400 rounded-full text-sm">
                                <i class="fas fa-heart mr-1"></i>Premium
                            </span>
                        </div>
                        <div class="flex items-center justify-between">
                            <div class="text-sm text-gray-400">
                                <i class="fas fa-map-marker-alt mr-2"></i>City Center
                            </div>
                            <button class="netflix-red text-white px-4 py-2 rounded-lg hover:shadow-lg transition-all">
                                View Details
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Cinema 4: Standard -->
                <div class="cinema-card rounded-lg overflow-hidden" data-category="standard">
                    <div class="cinema-image h-48 flex items-center justify-center">
                        <i class="fas fa-film text-6xl text-gray-400"></i>
                    </div>
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-3">
                            <h3 class="text-xl font-bold text-white">CineMax Standard</h3>
                            <div class="flex space-x-1">
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-gray-400"></i>
                            </div>
                        </div>
                        <p class="text-gray-400 mb-4">
                            Quality movie experience with comfortable seating and great sound at affordable prices.
                        </p>
                        <div class="flex flex-wrap gap-2 mb-4">
                            <span class="px-3 py-1 bg-gray-600/20 text-gray-400 rounded-full text-sm">
                                <i class="fas fa-film mr-1"></i>Standard
                            </span>
                            <span class="px-3 py-1 bg-green-600/20 text-green-400 rounded-full text-sm">
                                <i class="fas fa-dollar-sign mr-1"></i>Affordable
                            </span>
                            <span class="px-3 py-1 bg-blue-600/20 text-blue-400 rounded-full text-sm">
                                <i class="fas fa-users mr-1"></i>Family Friendly
                            </span>
                        </div>
                        <div class="flex items-center justify-between">
                            <div class="text-sm text-gray-400">
                                <i class="fas fa-map-marker-alt mr-2"></i>Suburban Plaza
                            </div>
                            <button class="netflix-red text-white px-4 py-2 rounded-lg hover:shadow-lg transition-all">
                                View Details
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Cinema 5: Premium IMAX -->
                <div class="cinema-card rounded-lg overflow-hidden" data-category="premium imax">
                    <div class="cinema-image h-48 flex items-center justify-center">
                        <i class="fas fa-expand text-6xl text-gray-400"></i>
                    </div>
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-3">
                            <h3 class="text-xl font-bold text-white">CineMax Ultra IMAX</h3>
                            <div class="flex space-x-1">
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                            </div>
                        </div>
                        <p class="text-gray-400 mb-4">
                            Our flagship location featuring the largest IMAX screen in the region with luxury amenities.
                        </p>
                        <div class="flex flex-wrap gap-2 mb-4">
                            <span class="px-3 py-1 bg-red-600/20 text-red-400 rounded-full text-sm">
                                <i class="fas fa-expand mr-1"></i>Ultra IMAX
                            </span>
                            <span class="px-3 py-1 bg-purple-600/20 text-purple-400 rounded-full text-sm">
                                <i class="fas fa-crown mr-1"></i>Flagship
                            </span>
                            <span class="px-3 py-1 bg-yellow-600/20 text-yellow-400 rounded-full text-sm">
                                <i class="fas fa-coffee mr-1"></i>Premium Lounge
                            </span>
                        </div>
                        <div class="flex items-center justify-between">
                            <div class="text-sm text-gray-400">
                                <i class="fas fa-map-marker-alt mr-2"></i>Metro Center
                            </div>
                            <button class="netflix-red text-white px-4 py-2 rounded-lg hover:shadow-lg transition-all">
                                View Details
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Cinema 6: Dolby Vision -->
                <div class="cinema-card rounded-lg overflow-hidden" data-category="dolby premium">
                    <div class="cinema-image h-48 flex items-center justify-center">
                        <i class="fas fa-eye text-6xl text-gray-400"></i>
                    </div>
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-3">
                            <h3 class="text-xl font-bold text-white">CineMax Dolby Vision</h3>
                            <div class="flex space-x-1">
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                                <i class="fas fa-star text-yellow-400"></i>
                            </div>
                        </div>
                        <p class="text-gray-400 mb-4">
                            Cutting-edge Dolby Vision technology for the ultimate visual and audio experience.
                        </p>
                        <div class="flex flex-wrap gap-2 mb-4">
                            <span class="px-3 py-1 bg-blue-600/20 text-blue-400 rounded-full text-sm">
                                <i class="fas fa-volume-up mr-1"></i>Dolby Atmos
                            </span>
                            <span class="px-3 py-1 bg-yellow-600/20 text-yellow-400 rounded-full text-sm">
                                <i class="fas fa-eye mr-1"></i>Dolby Vision
                            </span>
                            <span class="px-3 py-1 bg-red-600/20 text-red-400 rounded-full text-sm">
                                <i class="fas fa-star mr-1"></i>Premium
                            </span>
                        </div>
                        <div class="flex items-center justify-between">
                            <div class="text-sm text-gray-400">
                                <i class="fas fa-map-marker-alt mr-2"></i>Tech District
                            </div>
                            <button class="netflix-red text-white px-4 py-2 rounded-lg hover:shadow-lg transition-all">
                                View Details
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="py-16 bg-gray-900/30">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-12 fade-in">
                <h2 class="text-3xl font-bold mb-4">Why Choose Our Cinemas?</h2>
                <p class="text-gray-400 text-lg max-w-2xl mx-auto">
                    Experience the future of cinema with our cutting-edge technology and premium amenities
                </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                <div class="text-center fade-in">
                    <div class="hero-gradient w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4 glow-effect">
                        <i class="fas fa-expand text-2xl text-white"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2">IMAX Technology</h3>
                    <p class="text-gray-400">Larger-than-life screens with crystal clear imagery</p>
                </div>

                <div class="text-center fade-in">
                    <div class="hero-gradient w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4 glow-effect">
                        <i class="fas fa-volume-up text-2xl text-white"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2">Dolby Atmos</h3>
                    <p class="text-gray-400">Immersive surround sound that moves around you</p>
                </div>

                <div class="text-center fade-in">
                    <div class="hero-gradient w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4 glow-effect">
                        <i class="fas fa-couch text-2xl text-white"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2">Luxury Seating</h3>
                    <p class="text-gray-400">Reclining seats with premium comfort</p>
                </div>

                <div class="text-center fade-in">
                    <div class="hero-gradient w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4 glow-effect">
                        <i class="fas fa-magic text-2xl text-white"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2">4DX Experience</h3>
                    <p class="text-gray-400">Feel the movie with motion and effects</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <jsp:include page="partials/footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Search functionality
            const searchInput = document.getElementById('cinemaSearch');
            const cinemaCards = document.querySelectorAll('.cinema-card');
            const filterButtons = document.querySelectorAll('.filter-btn');

            // Search function
            searchInput.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();
                cinemaCards.forEach(card => {
                    const title = card.querySelector('h3').textContent.toLowerCase();
                    const description = card.querySelector('p').textContent.toLowerCase();
                    const location = card.querySelector('.text-gray-400').textContent.toLowerCase();
                    
                    if (title.includes(searchTerm) || description.includes(searchTerm) || location.includes(searchTerm)) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });

            // Filter functionality
            filterButtons.forEach(button => {
                button.addEventListener('click', function() {
                    // Remove active class from all buttons
                    filterButtons.forEach(btn => btn.classList.remove('active'));
                    // Add active class to clicked button
                    this.classList.add('active');

                    const filter = this.getAttribute('data-filter');
                    
                    cinemaCards.forEach(card => {
                        const categories = card.getAttribute('data-category').split(' ');
                        
                        if (filter === 'all' || categories.includes(filter)) {
                            card.style.display = 'block';
                        } else {
                            card.style.display = 'none';
                        }
                    });
                });
            });

            // View Details button functionality
            const viewDetailsButtons = document.querySelectorAll('button');
            viewDetailsButtons.forEach(button => {
                if (button.textContent.trim() === 'View Details') {
                    button.addEventListener('click', function() {
                        const cinemaCard = this.closest('.cinema-card');
                        const cinemaName = cinemaCard.querySelector('h3').textContent;
                        
                        // Show alert for now - can be replaced with modal or navigation
                        alert(`Viewing details for ${cinemaName}\n\nThis would typically open a detailed view or booking page.`);
                    });
                }
            });

            // Check authentication status
            const userId = localStorage.getItem("movieUserId");
            const profileTag = document.getElementById("profile-tag");
            const loginTag = document.getElementById("login-tag");
            const myBookingsTag = document.getElementById("my-bookings-tag");

            if (userId) {
                // User is logged in
                if (profileTag) profileTag.classList.remove("hidden");
                if (myBookingsTag) myBookingsTag.classList.remove("hidden");
                if (loginTag) loginTag.classList.add("hidden");
            } else {
                // User is not logged in
                if (profileTag) profileTag.classList.add("hidden");
                if (myBookingsTag) myBookingsTag.classList.add("hidden");
                if (loginTag) loginTag.classList.remove("hidden");
            }
        });
    </script>
</body>
</html>
