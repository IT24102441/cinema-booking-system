<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tailwind Carousel</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css"/>
    <style>
        /* Make navigation arrows bigger and red */
        .swiper-button-next,
        .swiper-button-prev {
            color: #e50914 !important; /* Netflix red */
            width: 3rem !important;
            height: 3rem !important;
            background: rgba(0, 0, 0, 0.5);
            border-radius: 50%;
            padding: 1rem;
        }

        .swiper-button-next:after,
        .swiper-button-prev:after {
            font-size: 1.5rem !important;
            font-weight: bold;
        }

        /* Pagination dots style */
        .swiper-pagination-bullet {
            background-color: #e50914 !important; /* Red dots */
            opacity: 0.7 !important;
            width: 12px !important;
            height: 12px !important;
        }

        .swiper-pagination-bullet-active {
            background-color: #ffffff !important; /* White for active */
            opacity: 1 !important;
        }

        /* Ensure consistent slide sizing with contained images */
        .swiper-slide {
            height: 600px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #1a202c; /* Dark background for letterboxing */
            position: relative;
        }

        .carousel-image {
            width: 100%;
            height: 100%;
            object-fit: contain; /* Show full image without cropping */
            object-position: center;
        }

        /* Gradient overlay for better text readability */
        .gradient-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 60%;
            background: linear-gradient(to top, rgba(0,0,0,0.9) 0%, transparent 100%);
            pointer-events: none;
        }

        /* Text container styling */
        .carousel-caption {
            z-index: 10;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.9);
        }

        /* Optional: Add a subtle border to images */
        .image-container {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
</head>
<body class="bg-gray-900 text-white">

<!-- Swiper Carousel -->
<div class="swiper mySwiper max-w-7xl mx-auto relative" style="margin-top: 80px;">
    <div class="swiper-wrapper">

        <!-- Slide 1 -->
        <div class="swiper-slide">
            <div class="image-container">
                <img
                        src="https://sm.ign.com/ign_pk/photo/h/how-to-wat/how-to-watch-the-pirates-of-the-caribbean-movies-in-chronolo_a6tk.jpg"
                        alt="Pirates of the Caribbean"
                        class="carousel-image"
                        onerror="this.src='https://via.placeholder.com/1200x600/1f2937/ffffff?text=Pirates+of+the+Caribbean'"
                >
            </div>
            <div class="gradient-overlay"></div>
            <div class="carousel-caption absolute bottom-16 left-10 text-white max-w-2xl">
                <h2 class="text-4xl font-bold mb-2">Epic Adventures</h2>
                <p class="mb-4 text-lg">Join Captain Jack Sparrow on thrilling high-seas adventures</p>
                <a href="#" class="bg-red-600 hover:bg-red-700 px-6 py-3 rounded-lg font-semibold transition duration-300 inline-block">
                    Book Now
                </a>
            </div>
        </div>

        <!-- Slide 2 -->
        <div class="swiper-slide">
            <div class="image-container">
                <img
                        src="https://alishahussain27.wordpress.com/wp-content/uploads/2014/11/the-hobbit-the-desolation-of-smaug-2013-movie-banner-poster.jpg"
                        alt="The Hobbit"
                        class="carousel-image"
                        onerror="this.src='https://via.placeholder.com/1200x600/1f2937/ffffff?text=The+Hobbit'"
                >
            </div>
            <div class="gradient-overlay"></div>
            <div class="carousel-caption absolute bottom-16 left-10 text-white max-w-2xl">
                <h2 class="text-4xl font-bold mb-2">Fantasy Epic</h2>
                <p class="mb-4 text-lg">Embark on an unforgettable journey through Middle-earth</p>
                <a href="#" class="bg-red-600 hover:bg-red-700 px-6 py-3 rounded-lg font-semibold transition duration-300 inline-block">
                    Book Now
                </a>
            </div>
        </div>

        <!-- Slide 3 -->
        <div class="swiper-slide">
            <div class="image-container">
                <img
                        src="/images/movie3.jpg"
                        alt="Zootopia 2"
                        class="carousel-image"
                        onerror="this.src='https://via.placeholder.com/1200x600/1f2937/ffffff?text=Zootopia+2'"
                >
            </div>
            <div class="gradient-overlay"></div>
            <div class="carousel-caption absolute bottom-16 left-10 text-white max-w-2xl">
                <h2 class="text-4xl font-bold mb-2">Animated Fun</h2>
                <p class="mb-4 text-lg">Return to the amazing city where animals live like humans</p>
                <a href="#" class="bg-red-600 hover:bg-red-700 px-6 py-3 rounded-lg font-semibold transition duration-300 inline-block">
                    Book Now
                </a>
            </div>
        </div>

        <!-- Slide 4 -->
        <div class="swiper-slide">
            <div class="image-container">
                <img
                        src="/images/image.jpg"
                        alt="How to Train Your Dragon"
                        class="carousel-image"
                        onerror="this.src='https://via.placeholder.com/1200x600/1f2937/ffffff?text=How+to+Train+Your+Dragon'"
                >
            </div>
            <div class="gradient-overlay"></div>
            <div class="carousel-caption absolute bottom-16 left-10 text-white max-w-2xl">
                <h2 class="text-4xl font-bold mb-2">Dragon Fantasy</h2>
                <p class="mb-4 text-lg">Soar through skies in this heartwarming tale of friendship</p>
                <a href="#" class="bg-red-600 hover:bg-red-700 px-6 py-3 rounded-lg font-semibold transition duration-300 inline-block">
                    Book Now
                </a>
            </div>
        </div>

    </div>

    <!-- Pagination (dots) -->
    <div class="swiper-pagination !bottom-6"></div>

    <!-- Navigation Arrows -->
    <div class="swiper-button-next"></div>
    <div class="swiper-button-prev"></div>
</div>

<!-- Swiper JS -->
<script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
<script>
    const swiper = new Swiper(".mySwiper", {
        loop: true,
        autoplay: {
            delay: 5000,
            disableOnInteraction: false,
        },
        pagination: {
            el: ".swiper-pagination",
            clickable: true,
        },
        navigation: {
            nextEl: ".swiper-button-next",
            prevEl: ".swiper-button-prev",
        },
        // Add effect for smoother transitions
        effect: 'fade',
        fadeEffect: {
            crossFade: true
        },
        // Responsive breakpoints
        breakpoints: {
            320: {
                slidesPerView: 1,
                spaceBetween: 10
            },
            768: {
                slidesPerView: 1,
                spaceBetween: 20
            },
            1024: {
                slidesPerView: 1,
                spaceBetween: 30
            }
        }
    });
</script>
</body>
</html>