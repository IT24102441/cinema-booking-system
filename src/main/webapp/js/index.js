// Sample movie data
const moviesData = [
    {
        id: 1,
        title: "Avengers: Endgame",
        genre: "Action, Sci-Fi",
        duration: "181 min",
        rating: "8.4",
        image: "https://veniceoarsman.com/wp-content/uploads/2019/05/MV5BMTAxMDkwMDg2ODJeQTJeQWpwZ15BbWU4MDQ2NDEwODcz._V1_SY1000_CR006841000_AL_-616x900.jpg",
        description: "The epic conclusion to the Infinity Saga",
        price: "$15.99"
    },
    {
        id: 2,
        title: "The Dark Knight",
        genre: "Action, Crime, Drama",
        duration: "152 min",
        rating: "9.0",
        image: "https://play-lh.googleusercontent.com/auIs5tjWlLYaFPGClZOJ7m5YVbnX6uBvz0X02r8TkwFKdzE53ww2MqWSS9gU0YNqoYwvpg",
        description: "Batman faces his greatest challenge yet",
        price: "$14.99"
    },
    {
        id: 3,
        title: "Inception",
        genre: "Action, Sci-Fi, Thriller",
        duration: "148 min",
        rating: "8.8",
        image: "https://m.media-amazon.com/images/M/MV5BMTM0MjUzNjkwMl5BMl5BanBnXkFtZTcwNjY0OTk1Mw@@._V1_.jpg",
        description: "A mind-bending journey through dreams",
        price: "$13.99"
    },
    {
        id: 4,
        title: "Interstellar",
        genre: "Adventure, Drama, Sci-Fi",
        duration: "169 min",
        rating: "8.6",
        image: "https://m.media-amazon.com/images/M/MV5BYzdjMDAxZGItMjI2My00ODA1LTlkNzItOWFjMDU5ZDJlYWY3XkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg",
        description: "A journey beyond the stars",
        price: "$16.99"
    },
    {
        id: 5,
        title: "Black Panther",
        genre: "Action, Adventure, Sci-Fi",
        duration: "134 min",
        rating: "7.3",
        image: "https://lumiere-a.akamaihd.net/v1/images/p_blackpanther_19754_4ac13f07.jpeg?region=0%2C0%2C540%2C810",
        description: "The king of Wakanda rises",
        price: "$15.49"
    },
    {
        id: 6,
        title: "Spider-Man: No Way Home",
        genre: "Action, Adventure, Sci-Fi",
        duration: "148 min",
        rating: "8.2",
        image: "https://m.media-amazon.com/images/M/MV5BMmFiZGZjMmEtMTA0Ni00MzA2LTljMTYtZGI2MGJmZWYzZTQ2XkEyXkFqcGc@._V1_.jpg",
        description: "The multiverse unleashed",
        price: "$17.99"
    },
    {
        id: 7,
        title: "Dune",
        genre: "Action, Adventure, Drama",
        duration: "155 min",
        rating: "8.0",
        image: "https://m.media-amazon.com/images/M/MV5BNTc0YmQxMjEtODI5MC00NjFiLTlkMWUtOGQ5NjFmYWUyZGJhXkEyXkFqcGc@._V1_.jpg",
        description: "A mythic and emotionally charged hero's journey",
        price: "$16.49"
    },
    {
        id: 8,
        title: "Top Gun: Maverick",
        genre: "Action, Drama",
        duration: "130 min",
        rating: "8.3",
        image: "https://m.media-amazon.com/images/M/MV5BMDBkZDNjMWEtOTdmMi00NmExLTg5MmMtNTFlYTJlNWY5YTdmXkEyXkFqcGc@._V1_.jpg",
        description: "Maverick returns to the skies",
        price: "$15.99"
    }
];

// DOM elements
let moviesGrid;
let loadingElement;
let loginBtn;
let myBookingsBtn;
let profileBtn;

// Initialize the page
document.addEventListener('DOMContentLoaded', function() {
    initializeElements();
    loadMovies();
    addScrollAnimations();
});

// Initialize DOM elements
function initializeElements() {
    moviesGrid = document.getElementById('movies-grid');
    loadingElement = document.getElementById('loading');
    loginBtn = document.getElementById("login-tag")
    myBookingsBtn = document.getElementById("my-bookings-tag")
    profileBtn = document.getElementById("profile-tag")
    if (localStorage.getItem("movieUserId")) {
        loginBtn.classList.add("hidden");
        myBookingsBtn.classList.remove("hidden");
        profileBtn.classList.remove("hidden");
    } else {
        loginBtn.classList.remove("hidden");
        myBookingsBtn.classList.add("hidden");
        profileBtn.classList.add("hidden");
    }

}

// Load movies with animation
function loadMovies() {
    // Simulate loading delay for better UX
    setTimeout(() => {
        hideLoading();
        renderMovies();
        animateMovieCards();
    }, 1500);
}

// Hide loading spinner
function hideLoading() {
    if (loadingElement) {
        loadingElement.style.display = 'none';
    }
}

// Render movie cards
function renderMovies() {
    if (!moviesGrid) return;

    moviesGrid.innerHTML = '';

    moviesData.forEach((movie, index) => {
        const movieCard = createMovieCard(movie, index);
        moviesGrid.appendChild(movieCard);
    });
}

// Create individual movie card
function createMovieCard(movie, index) {
    const card = document.createElement('div');
    card.className = 'movie-card bg-gray-900/80 backdrop-blur-sm rounded-lg overflow-hidden border border-gray-800/50 hover:border-red-500/50 hover:shadow-2xl opacity-0 transform translate-y-8';
    card.style.animationDelay = `${index * 0.1}s`;

    card.innerHTML = `
        <div class="relative group">
            <img 
                src="${movie.image}" 
                alt="${movie.title}"
                class="w-full h-80 object-cover transition-transform duration-500 group-hover:scale-105"
                loading="lazy"
            >
            <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
            <div class="absolute top-4 right-4">
                <span class="bg-yellow-500 text-black px-2 py-1 rounded-full text-sm font-semibold flex items-center">
                    <i class="fas fa-star mr-1"></i>
                    ${movie.rating}
                </span>
            </div>
            <div class="absolute bottom-4 left-4 right-4 opacity-0 group-hover:opacity-100 transition-all duration-300 transform translate-y-4 group-hover:translate-y-0">
                <p class="text-white text-sm mb-2">${movie.description}</p>
            </div>
        </div>
        
        <div class="p-6">
            <h3 class="text-xl font-bold text-white mb-2 group-hover:text-red-400 transition-colors">
                ${movie.title}
            </h3>
            
            <div class="flex items-center text-sm text-gray-400 mb-3">
                <i class="fas fa-tag mr-2 text-red-500"></i>
                <span>${movie.genre}</span>
            </div>
            
            <div class="flex items-center text-sm text-gray-400 mb-4">
                <i class="fas fa-clock mr-2 text-red-500"></i>
                <span>${movie.duration}</span>
                <span class="ml-auto text-xl font-bold text-white">${movie.price}</span>
            </div>
            
            <button 
                onclick="bookMovie('${movie.title}','${movie.price}')" 
                class="w-full netflix-red text-white py-3 px-6 rounded-lg font-semibold transition-all duration-300 hover:transform hover:scale-105 hover:shadow-lg flex items-center justify-center group"
            >
                <i class="fas fa-ticket-alt mr-2 group-hover:animate-pulse"></i>
                Book Now
            </button>
        </div>
    `;

    return card;
}

// Animate movie cards on load
function animateMovieCards() {
    const cards = document.querySelectorAll('.movie-card');
    cards.forEach((card, index) => {
        setTimeout(() => {
            card.classList.add('animate-fade-in');
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });
}

// Book movie function
function bookMovie(movieName,price) {
    // Add click animation
    event.target.style.transform = 'scale(0.95)';
    setTimeout(() => {
        event.target.style.transform = 'scale(1.05)';
        setTimeout(() => {
            event.target.style.transform = 'scale(1)';
        }, 100);
    }, 100);

    // Navigate after animation
    setTimeout(() => {
        const encodedMovieName = encodeURIComponent(movieName);
        window.location.href = `/create-booking?movieName=${encodedMovieName}&price=${price}`;
    }, 300);
}

// Add scroll animations
function addScrollAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-fade-in');
            }
        });
    }, observerOptions);

    // Observe elements with slide-up class
    document.querySelectorAll('.slide-up').forEach(el => {
        observer.observe(el);
    });
}

// Add smooth scrolling for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Add navbar scroll effect
window.addEventListener('scroll', function() {
    const nav = document.querySelector('nav');
    if (window.scrollY > 100) {
        nav.classList.add('bg-black');
        nav.classList.remove('bg-black/90');
    } else {
        nav.classList.add('bg-black/90');
        nav.classList.remove('bg-black');
    }
});

// Add loading animation for images
function addImageLoadingEffect() {
    const images = document.querySelectorAll('img');
    images.forEach(img => {
        img.addEventListener('load', function() {
            this.style.opacity = '1';
        });
        img.addEventListener('error', function() {
            this.src = 'https://via.placeholder.com/400x600/1f2937/ffffff?text=Movie+Poster';
        });
    });
}

// Call image loading effect after movies are rendered
setTimeout(addImageLoadingEffect, 2000);