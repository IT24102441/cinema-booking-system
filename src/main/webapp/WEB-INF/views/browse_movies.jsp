<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Browse Movies - MovieMate</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        .movie-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .movie-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        }
        .category-badge {
            position: relative;
            overflow: hidden;
        }
        .category-badge::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(246, 0, 0, 0.2), transparent);
            transition: left 0.5s;
        }
        .category-badge:hover::before {
            left: 100%;
        }
    </style>
</head>
<body class="bg-gray-900 text-white min-h-screen">

<jsp:include page="partials/navbar.jsp" />

<!-- Hero Section -->
<div class="relative bg-gradient-to-r from-red-900/50 to-purple-900/50 py-20">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <h1 class="text-4xl md:text-6xl font-bold mb-4 bg-gradient-to-r from-red-400 to-purple-400 bg-clip-text text-transparent">
            Browse Movies
        </h1>
        <p class="text-xl text-gray-300 max-w-2xl mx-auto">
            Discover amazing movies organized by categories. Find your next favorite film!
        </p>
    </div>
</div>

<!-- Main Content -->
<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
    <c:choose>
        <c:when test="${not empty moviesByCategory && !empty moviesByCategory}">
            <!-- Categories Navigation -->
            <div class="mb-8">
                <h2 class="text-2xl font-bold text-gray-300 mb-4">Categories</h2>
                <div class="flex flex-wrap gap-3">
                    <c:forEach var="category" items="${moviesByCategory.keySet()}">
                        <c:if test="${category ne 'UNCATEGORIZED'}">
                            <a href="#${category}"
                               class="category-badge px-4 py-2 bg-gradient-to-r from-red-600 to-purple-600 rounded-full text-white font-semibold hover:from-red-700 hover:to-purple-700 transition-all duration-300">
                                    ${category} <span class="bg-black/30 px-2 py-1 rounded-full text-sm ml-2">${moviesByCategory[category].size()}</span>
                            </a>
                        </c:if>
                    </c:forEach>
                </div>
            </div>

            <!-- Movies by Category -->
            <div class="space-y-16">
                <c:forEach var="entry" items="${moviesByCategory}">
                    <c:if test="${entry.key ne 'UNCATEGORIZED'}">
                    <section id="${entry.key}" class="scroll-mt-20">
                        <div class="flex items-center justify-between mb-8">
                            <div>
                                <h2 class="text-3xl font-bold text-white mb-2">${entry.key} Movies</h2>
                                <p class="text-gray-400">${entry.value.size()} amazing ${entry.key.toLowerCase()} movies</p>
                            </div>
                            <!-- Removed external 'View All' link to keep expansion inline -->
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                            <c:forEach var="movie" items="${entry.value}">
                                <div class="movie-card bg-gray-800 rounded-xl overflow-hidden border border-gray-700 hover:border-red-500 transition-all duration-300">
                                    <c:if test="${not empty movie.imageUrl}">
                                        <div class="h-56 w-full bg-black flex items-center justify-center overflow-hidden">
                                            <img src="${movie.imageUrl}" alt="${movie.title} poster" class="max-h-full max-w-full object-contain"/>
                                        </div>
                                    </c:if>
                                    <div class="p-6">
                                        <div class="flex justify-between items-start mb-3">
                                            <h3 class="text-lg font-bold text-white line-clamp-2 flex-1 mr-2">${movie.title}</h3>
                                            <span class="px-2 py-1 bg-red-600 text-white text-xs rounded-full whitespace-nowrap">
                                                ${entry.key}
                                            </span>
                                        </div>

                                        <div class="space-y-2">
                                            <p class="text-gray-300 text-sm flex items-center">
                                                <i class="fas fa-film mr-2 text-red-400"></i>
                                                ${movie.genre}
                                            </p>
                                            <p class="text-gray-300 text-sm flex items-center">
                                                <i class="fas fa-user mr-2 text-red-400"></i>
                                                ${movie.director}
                                            </p>
                                            <p class="text-gray-300 text-sm flex items-center">
                                                <i class="fas fa-clock mr-2 text-red-400"></i>
                                                ${movie.duration} min
                                            </p>
                                            <p class="text-gray-300 text-sm flex items-center">
                                                <i class="fas fa-calendar mr-2 text-red-400"></i>
                                                ${movie.releaseDate}
                                            </p>
                                            <div class="flex items-center justify-between pt-2">
                                                <span class="text-yellow-400 font-semibold">
                                                    <c:choose>
                                                        <c:when test="${not empty movie.price}">$ ${movie.price}</c:when>
                                                        <c:otherwise>Price: N/A</c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <span class="text-sm text-gray-300 movie-rating" data-movie-id="${movie.id}" data-movie-title="${movie.title}">
                                                    <i class="fa-solid fa-star text-yellow-400 mr-1"></i>
                                                    <span class="rating-value">0.0</span>
                                                </span>
                                            </div>
                                        </div>

                                        <div class="mt-4 pt-4 border-t border-gray-700">
                                            <button class="w-full bg-red-600 hover:bg-red-700 text-white py-3 px-6 rounded-lg font-semibold transition-all duration-300 hover:transform hover:scale-105 hover:shadow-lg flex items-center justify-center group book-now-btn"
                                                    data-title="${movie.title}"
                                                    data-price="${movie.price != null ? movie.price : 15.99}">
                                                <i class="fas fa-ticket-alt mr-2 group-hover:animate-pulse"></i>
                                                Book Now
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </section>
                    </c:if>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <!-- No Movies Available -->
            <div class="text-center py-16">
                <div class="max-w-md mx-auto">
                    <i class="fas fa-film text-8xl text-gray-600 mb-6"></i>
                    <h2 class="text-3xl font-bold text-gray-400 mb-4">No Movies Available Yet</h2>
                    <p class="text-gray-500 text-lg mb-6">
                        Movies will appear here once they are categorized by our administrators.
                        Please check back soon!
                    </p>
                    <c:if test="${not empty error}">
                        <div class="bg-red-900/50 border border-red-700 rounded-lg p-4 mt-4">
                            <p class="text-red-300">${error}</p>
                        </div>
                    </c:if>
                    <div class="mt-8">
                        <a href="/" class="px-6 py-3 bg-red-600 hover:bg-red-700 rounded-lg transition-colors">
                            Return to Homepage
                        </a>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<!-- Footer -->
<jsp:include page="partials/footer.jsp" />

<script>
    // Smooth scrolling for category links
    document.addEventListener('DOMContentLoaded', function() {
        const categoryLinks = document.querySelectorAll('a[href^="#"]');
        categoryLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const targetId = this.getAttribute('href').substring(1);
                const targetElement = document.getElementById(targetId);
                if (targetElement) {
                    targetElement.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Delegate Book Now clicks
        document.body.addEventListener('click', function(e) {
            const btn = e.target.closest('.book-now-btn');
            if (btn) {
                const title = btn.getAttribute('data-title') || '';
                const price = btn.getAttribute('data-price') || '15.99';
                if (typeof bookMovie === 'function') {
                    bookMovie(title, price);
                } else {
                    const encoded = encodeURIComponent(title);
                    window.location.href = `/create-booking?movieName=${encoded}&price=${price}`;
                }
            }
        });

        // Assign random fake rating per movie (stable for session)
        const ratings = JSON.parse(sessionStorage.getItem('movieRatings') || '{}');
        document.querySelectorAll('.movie-rating').forEach(el => {
            const key = el.getAttribute('data-movie-id') || el.getAttribute('data-movie-title');
            if (!key) return;
            if (!ratings[key]) {
                // random between 3.5 and 5.0 with one decimal
                const val = Math.round((3.5 + Math.random() * 1.5) * 10) / 10;
                ratings[key] = val.toFixed(1);
            }
            const span = el.querySelector('.rating-value');
            if (span) span.textContent = ratings[key];
        });
        sessionStorage.setItem('movieRatings', JSON.stringify(ratings));

        // Add loading animation
        const movieCards = document.querySelectorAll('.movie-card');
        movieCards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.1}s`;
            card.classList.add('animate-fade-in-up');
        });
    });

    // Add some CSS animations
    const style = document.createElement('style');
    style.textContent = `
    @keyframes fade-in-up {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    .animate-fade-in-up {
        animation: fade-in-up 0.6s ease-out forwards;
    }
    .line-clamp-2 {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
`;
    document.head.appendChild(style);
</script>
<script src="/js/index.js"></script>
</body>
</html>