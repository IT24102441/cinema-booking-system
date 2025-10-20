<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Movie - MovieMate</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg,#0f0f23 0%, #1a1a2e 100%); }
        .hero-gradient { background: linear-gradient(135deg,#e50914 0%, #b20710 50%, #8b0000 100%); }
        .glow-effect { box-shadow: 0 0 20px rgba(229,9,20,0.25); }
        .error-input { border-color: #ef4444 !important; }
        .error-message { color: #ef4444; font-size: 0.875rem; margin-top: 0.25rem; }
    </style>
</head>
<body class="min-h-screen text-white flex items-start">

<nav class="w-full bg-black/90 backdrop-blur-md border-b border-gray-800/50 fixed top-0 z-40">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <a href="/" class="text-2xl font-bold text-red-600"><i class="fas fa-film mr-2"></i>MovieMate</a>
            <div class="hidden md:flex items-center space-x-6">
                <a href="/admin-dashboard" class="text-gray-400 hover:text-red-500 transition-colors"><i class="fas fa-tachometer-alt mr-2"></i>Dashboard</a>
                <a href="/admin/view-added-movies" class="text-gray-400 hover:text-red-500 transition-colors">Movies</a>
            </div>
        </div>
    </div>
</nav>

<main class="w-full flex-grow flex items-start justify-center pt-24 px-4">
    <div class="max-w-3xl w-full">
        <div class="bg-gray-900/50 backdrop-blur-sm border border-gray-800/50 rounded-xl p-8">
            <div class="text-center mb-6">
                <div class="hero-gradient w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4 glow-effect">
                    <i class="fas fa-plus text-2xl text-white"></i>
                </div>
                <h1 class="text-3xl font-bold">Add New Movie</h1>
                <p class="text-gray-400">Add a movie to the MovieMate catalogue.</p>
            </div>

            <form id="addMovieForm" action="/admin/movies" method="POST" class="space-y-4">
                <noscript>
                    <div class="bg-yellow-50 text-yellow-800 p-3 rounded">JavaScript disabled — the form will submit with a full page reload.</div>
                </noscript>

                <div>
                    <label for="title" class="block text-sm font-medium text-gray-300 mb-1">Title</label>
                    <input type="text" id="title" name="title" required
                           class="w-full px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500" />
                </div>

                <div>
                    <label for="genre" class="block text-sm font-medium text-gray-300 mb-1">Genre</label>
                    <input type="text" id="genre" name="genre" required
                           class="w-full px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500" />
                    <div id="genreError" class="error-message hidden">Genre must contain only letters, spaces, and hyphens</div>
                </div>

                <div>
                    <label for="director" class="block text-sm font-medium text-gray-300 mb-1">Director</label>
                    <input type="text" id="director" name="director" required
                           class="w-full px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500" />
                    <div id="directorError" class="error-message hidden">Director name must contain only letters, spaces, and periods</div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label for="duration" class="block text-sm font-medium text-gray-300 mb-1">Duration (minutes)</label>
                        <input type="number" id="duration" name="duration" required min="1"
                               class="w-full px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500" />
                        <div id="durationError" class="error-message hidden">Duration must be a positive number (at least 1 minute)</div>
                    </div>
                    <div>
                        <label for="releaseDate" class="block text-sm font-medium text-gray-300 mb-1">Release Date</label>
                        <input type="date" id="releaseDate" name="releaseDate" required
                               class="w-full px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500" />
                    </div>
                </div>

                <div class="flex items-center justify-between mt-6">
                    <div class="flex gap-3">
                        <button type="submit" id="submitBtn"
                                class="hero-gradient px-5 py-2 rounded-lg font-medium text-white hover:opacity-90 transition-opacity">Add Movie</button>
                        <a href="/admin/view-added-movies" class="px-5 py-2 rounded-lg bg-gray-700 hover:bg-gray-600 transition-colors">View Movies</a>
                    </div>
                    <a href="/admin-dashboard" class="text-gray-400 hover:text-red-500">Back to Dashboard</a>
                </div>
            </form>

            <div id="successMessage" class="mt-4 text-green-400 hidden">Movie added successfully!</div>
            <div id="errorMessage" class="mt-4 text-red-400 hidden"></div>
        </div>
    </div>
</main>

<script>
    (function() {
        const form = document.getElementById('addMovieForm');
        const successMessage = document.getElementById('successMessage');
        const errorMessage = document.getElementById('errorMessage');
        const submitBtn = document.getElementById('submitBtn');
        
        // Error message elements
        const genreError = document.getElementById('genreError');
        const directorError = document.getElementById('directorError');
        const durationError = document.getElementById('durationError');
        
        let hideTimer = null;

        function showSuccess(text) {
            clearTimeout(hideTimer);
            errorMessage.classList.add('hidden');
            successMessage.textContent = text;
            successMessage.classList.remove('hidden');
            hideTimer = setTimeout(() => { successMessage.classList.add('hidden'); }, 5000);
        }

        function showError(text) {
            clearTimeout(hideTimer);
            successMessage.classList.add('hidden');
            errorMessage.textContent = text;
            errorMessage.classList.remove('hidden');
            hideTimer = setTimeout(() => { errorMessage.classList.add('hidden'); }, 7000);
        }

        // Validation functions
        function validateTextOnly(input, errorElement, fieldName) {
            const value = input.value.trim();
            // Allow letters, spaces, hyphens, and periods (for director names with initials)
            const textRegex = /^[A-Za-z\s\-\.]+$/;
            
            if (value && !textRegex.test(value)) {
                input.classList.add('error-input');
                errorElement.classList.remove('hidden');
                return false;
            } else {
                input.classList.remove('error-input');
                errorElement.classList.add('hidden');
                return true;
            }
        }

        function validateDuration(input, errorElement) {
            const value = parseInt(input.value);
            
            if (isNaN(value) || value < 1) {
                input.classList.add('error-input');
                errorElement.classList.remove('hidden');
                return false;
            } else {
                input.classList.remove('error-input');
                errorElement.classList.add('hidden');
                return true;
            }
        }

        function validateForm() {
            const genreInput = document.getElementById('genre');
            const directorInput = document.getElementById('director');
            const durationInput = document.getElementById('duration');
            
            const isGenreValid = validateTextOnly(genreInput, genreError, 'genre');
            const isDirectorValid = validateTextOnly(directorInput, directorError, 'director');
            const isDurationValid = validateDuration(durationInput, durationError);
            
            return isGenreValid && isDirectorValid && isDurationValid;
        }

        // Add event listeners for real-time validation
        document.getElementById('genre').addEventListener('input', function() {
            validateTextOnly(this, genreError, 'genre');
        });

        document.getElementById('director').addEventListener('input', function() {
            validateTextOnly(this, directorError, 'director');
        });

        document.getElementById('duration').addEventListener('input', function() {
            validateDuration(this, durationError);
        });

        form.addEventListener('submit', async function(event) {
            if (typeof fetch === 'undefined') return; // allow normal POST if no fetch
            event.preventDefault();

            // Validate form before submission
            if (!validateForm()) {
                showError('Please fix the validation errors before submitting.');
                return;
            }

            const formData = new FormData(form);
            const data = Object.fromEntries(formData.entries());
            if (data.duration) data.duration = parseInt(data.duration, 10);

            submitBtn.disabled = true;
            const orig = submitBtn.textContent;
            submitBtn.textContent = 'Adding...';

            try {
                const res = await fetch('/admin/movies', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                });

                if (res.ok) {
                    // Your backend returns the Movie object directly (no success wrapper)
                    const savedMovie = await res.json();
                    showSuccess(`Movie  added successfully!`);
                    form.reset();
                    document.querySelectorAll('.error-input').forEach(el => el.classList.remove('error-input'));
                    document.querySelectorAll('.error-message').forEach(el => el.classList.add('hidden'));
                } else {
                    let errorMsg = 'Failed to add the movie.';
                    try {
                        const errorData = await res.json();
                        errorMsg = errorData.message || errorMsg;
                    } catch(e) {
                        // If no JSON response, use status text
                        errorMsg = res.statusText || errorMsg;
                    }
                    showError(errorMsg);
                }
            } catch (err) {
                console.error('Fetch error:', err);
                showError('An error occurred while adding the movie.');
            } finally {
                submitBtn.disabled = false;
                submitBtn.textContent = orig;
            }
        });
    })();
</script>

</body>
</html>