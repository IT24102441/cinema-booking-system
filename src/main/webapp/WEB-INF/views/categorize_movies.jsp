<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Categorize Movies</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body class="bg-gray-900 text-white p-6">

<div class="container mx-auto max-w-6xl">
    <div class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold">Categorize Movies</h1>
        <div class="space-x-4">
            <a href="/admin/view-added-movies" class="px-4 py-2 bg-blue-600 rounded hover:bg-blue-700 transition-colors">
                <i class="fas fa-arrow-left mr-2"></i>Back to Movies
            </a>
            <a href="/browse-movies" class="px-4 py-2 bg-green-600 rounded hover:bg-green-700 transition-colors" target="_blank">
                <i class="fas fa-eye mr-2"></i>View Public Page
            </a>
        </div>
    </div>

    <!-- Add Category Form -->
    <div class="mb-6 p-4 rounded-lg flex items-center justify-between shadow-2xl" style="background: linear-gradient(90deg,#0f1724 0%, #062969 40%, #3b82f6 100%); border: 1px solid rgba(250,204,21,0.18);">
        <div>
            <h3 class="text-lg font-semibold text-yellow-300">Manage Categories</h3>
            <p class="text-yellow-100 text-sm">Add a new category that will appear in the "Choose Category" dropdown.</p>
        </div>
        <form action="/admin/categories/add" method="POST" class="flex items-center space-x-3">
            <input name="name" required placeholder="New category name"
                   class="bg-white text-gray-900 px-4 py-2 rounded-lg border border-gray-200 focus:border-yellow-400 focus:outline-none shadow-sm" />
            <button type="submit" class="px-4 py-2 bg-yellow-500 hover:bg-yellow-600 active:translate-y-0.5 rounded-lg text-black font-semibold shadow-lg transition transform hover:-translate-y-0.5">Add</button>
        </form>
    </div>

    <!-- Add this after the navigation links section -->
    <c:if test="${not empty categorizedMovies && categorizedMovies.size() > 0}">
        <div class="mb-6 p-6 bg-gradient-to-r from-purple-900 to-blue-900 rounded-xl border border-purple-500">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between">
                <div class="mb-4 md:mb-0">
                    <h3 class="text-xl font-bold text-white mb-2">
                        <i class="fas fa-rocket mr-2 text-yellow-400"></i>
                        Ready to Publish!
                    </h3>
                    <p class="text-purple-200">
                        You have ${categorizedMovies.size()} movies categorized and ready for public viewing.
                    </p>
                </div>
                <form action="/admin/categories/publish" method="POST">
                    <button type="submit"
                            class="w-full md:w-auto px-8 py-3 bg-gradient-to-r from-yellow-500 to-orange-500 hover:from-yellow-600 hover:to-orange-600 text-white font-bold rounded-lg transition-all duration-300 transform hover:scale-105 shadow-lg">
                        <i class="fas fa-paper-plane mr-2"></i>
                        Publish to Browse Page
                    </button>
                </form>
            </div>
        </div>
    </c:if>

    <!-- Success/Error Messages -->
    <c:if test="${not empty successMessage}">
        <div class="mb-6 p-4 bg-green-900 border border-green-600 rounded-lg text-green-200">
            <div class="flex items-center">
                <i class="fas fa-check-circle mr-2 text-green-400"></i>
                    ${successMessage}
            </div>
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="mb-6 p-4 bg-red-900 border border-red-600 rounded-lg text-red-200">
            <div class="flex items-center">
                <i class="fas fa-exclamation-circle mr-2 text-red-400"></i>
                    ${errorMessage}
            </div>
        </div>
    </c:if>

    <!-- Uncategorized Movies -->
    <div class="mb-12">
        <div class="flex items-center mb-4">
            <h2 class="text-2xl font-semibold text-yellow-400 mr-3">Uncategorized Movies</h2>
            <span class="px-2 py-1 bg-yellow-600 text-yellow-100 text-sm rounded-full">${uncategorizedMovies.size()} movies</span>
        </div>

        <c:choose>
            <c:when test="${not empty uncategorizedMovies}">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:forEach var="movie" items="${uncategorizedMovies}">
                        <div class="bg-gray-800 rounded-xl p-6 border-2 border-yellow-500 shadow-lg">
                            <div class="mb-4">
                                <h3 class="text-xl font-bold text-white mb-2">${movie.title}</h3>
                                <p class="text-gray-300 mb-1"><i class="fas fa-film mr-2 text-yellow-400"></i>${movie.genre}</p>
                                <p class="text-gray-300 mb-1"><i class="fas fa-clock mr-2 text-yellow-400"></i>${movie.duration} minutes</p>
                                <p class="text-gray-300"><i class="fas fa-user mr-2 text-yellow-400"></i>${movie.director}</p>
                                <p class="text-gray-400 text-sm mt-2"><i class="fas fa-calendar mr-2"></i>Released: ${movie.releaseDate}</p>
                            </div>

                            <form action="/admin/categories/assign" method="POST" class="mt-4">
                                <input type="hidden" name="movieId" value="${movie.id}">
                                <div class="space-y-3">
                                    <div class="flex flex-wrap gap-2">
                                        <c:forEach var="cat" items="${categories}">
                                            <label class="inline-flex items-center bg-gray-700 px-3 py-2 rounded-lg border border-gray-600 cursor-pointer">
                                                <input type="checkbox" name="categories" value="${cat}"
                                                       class="form-checkbox h-4 w-4 text-yellow-400" />
                                                <span class="ml-2 text-white">${cat}</span>
                                            </label>
                                        </c:forEach>
                                    </div>
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                                        <div>
                                            <label class="block text-sm text-gray-300 mb-1">Image URL</label>
                                            <input name="imageUrl" type="url" placeholder="https://example.com/poster.jpg" value="${movie.imageUrl}"
                                                   class="w-full bg-gray-900 border border-gray-700 rounded-lg px-3 py-2 text-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-yellow-400" />
                                        </div>
                                        <div>
                                            <label class="block text-sm text-gray-300 mb-1">Price (USD)</label>
                                            <input name="price" type="number" min="0" step="0.01" placeholder="15.99" value="${movie.price}"
                                                   class="w-full bg-gray-900 border border-gray-700 rounded-lg px-3 py-2 text-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-yellow-400" />
                                        </div>
                                    </div>
                                    <div>
                                        <button type="submit" class="bg-green-600 hover:bg-green-700 px-4 py-3 rounded-lg transition-colors duration-200 transform hover:scale-105">
                                            <i class="fas fa-check text-white mr-2"></i>Assign Selected
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="bg-gray-800 rounded-xl p-12 text-center border-2 border-dashed border-yellow-500">
                    <i class="fas fa-check-circle text-5xl text-yellow-400 mb-4"></i>
                    <h3 class="text-2xl font-bold text-yellow-400 mb-2">All Movies Categorized!</h3>
                    <p class="text-gray-400 text-lg">Great job! All movies have been assigned to categories.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Categorized Movies -->
    <div class="mb-8">
        <div class="flex items-center mb-4">
            <h2 class="text-2xl font-semibold text-green-400 mr-3">Categorized Movies</h2>
            <span class="px-2 py-1 bg-green-600 text-green-100 text-sm rounded-full">${categorizedMovies.size()} movies</span>
        </div>

        <c:choose>
            <c:when test="${not empty categorizedMovies}">
                <div class="space-y-8">
                    <!-- Iterate categories and use moviesByCategory map provided by controller -->
                    <c:forEach var="category" items="${categories}">
                        <c:set var="categoryMovies" value="${moviesByCategory[category]}"/>
                        <c:if test="${not empty categoryMovies}">
                            <div class="bg-gray-800 rounded-xl p-6 border border-green-500 shadow-lg">
                                <div class="flex items-center justify-between mb-4">
                                    <h3 class="text-xl font-bold text-green-400">${category} Movies</h3>
                                    <span class="px-3 py-1 bg-green-600 text-green-100 text-sm rounded-full">${fn:length(categoryMovies)} movies</span>
                                </div>

                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <c:forEach var="movie" items="${categoryMovies}">
                                        <div class="bg-gray-700 rounded-lg p-4 flex justify-between items-center hover:bg-gray-650 transition-colors">
                                            <div class="flex-1">
                                                <h4 class="font-semibold text-white text-lg mb-1">${movie.title}</h4>
                                                <p class="text-gray-300 text-sm mb-1">${movie.genre} • ${movie.duration}min</p>
                                                <p class="text-gray-400 text-sm">Director: ${movie.director}</p>
                                            </div>
                                            <div class="ml-4 flex items-center space-x-2">
                                                <form action="/admin/categories/remove" method="POST" class="">
                                                    <input type="hidden" name="movieId" value="${movie.id}">
                                                    <input type="hidden" name="category" value="${category}">
                                                    <button type="submit"
                                                            onclick="return confirm('Remove ${category} category from ${movie.title}?')"
                                                            class="bg-red-600 hover:bg-red-700 px-3 py-2 rounded text-sm transition-colors duration-200">
                                                        <i class="fas fa-times mr-1"></i>Remove
                                                    </button>
                                                </form>
                                                <form action="/admin/movies/edit-form/${movie.id}" method="GET" class="">
                                                    <button type="submit"
                                                            class="bg-blue-600 hover:bg-blue-700 px-3 py-2 rounded text-sm transition-colors duration-200">
                                                        <i class="fas fa-edit mr-1"></i>Edit Categories
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="bg-gray-800 rounded-xl p-12 text-center border-2 border-dashed border-green-500">
                    <i class="fas fa-film text-5xl text-green-400 mb-4"></i>
                    <h3 class="text-2xl font-bold text-green-400 mb-2">No Movies Categorized Yet</h3>
                    <p class="text-gray-400 text-lg">Start by assigning categories to movies from the uncategorized section above.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    // Add some interactive features
    document.addEventListener('DOMContentLoaded', function() {
        // Add focus styles to selects
        const selects = document.querySelectorAll('select');
        selects.forEach(select => {
            select.addEventListener('focus', function() {
                this.parentElement.classList.add('ring-2', 'ring-yellow-400', 'rounded-lg');
            });
            select.addEventListener('blur', function() {
                this.parentElement.classList.remove('ring-2', 'ring-yellow-400', 'rounded-lg');
            });
        });

        console.log('Categorization page loaded successfully');
        console.log('Uncategorized movies: ${uncategorizedMovies.size()}');
        console.log('Categorized movies: ${categorizedMovies.size()}');
    });
</script>

</body>
</html>