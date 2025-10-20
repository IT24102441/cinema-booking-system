<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Edit Movie Categories - MovieMate</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="min-h-screen text-white flex items-start justify-center pt-24 px-4" style="background:linear-gradient(135deg,#0f0f23 0%, #1a1a2e 100%)">

<div class="max-w-3xl w-full">
    <div class="bg-gray-900/50 backdrop-blur-sm border border-gray-800/50 rounded-xl p-8">
        <div class="flex items-center gap-4 mb-6">
            <a href="/admin/categories" class="text-gray-400 hover:text-white">&larr; Back</a>
            <h1 class="text-2xl font-bold">Edit Categories for: <span class="text-red-400">${movie.title}</span></h1>
        </div>

        <c:if test="${not empty error}">
            <div class="mb-4 p-3 bg-red-900 border border-red-700 rounded text-red-200">${error}</div>
        </c:if>

        <form id="editMovieForm" method="POST" action="/admin/movies/edit/${movie.id}" class="space-y-6">
            <!-- preserve genre value as hidden field (not editable) -->
            <input type="hidden" name="genre" value="${movie.genre}" />
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-300 mb-1">Title</label>
                    <input id="title" name="title" value="${movie.title}" required
                           class="w-full px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500" />
                    <div id="titleError" class="text-red-400 text-sm mt-1 hidden">Title cannot be empty</div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-300 mb-1">Director</label>
                    <input id="director" name="director" value="${movie.director}" required
                           class="w-full px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500" />
                    <div id="directorError" class="text-red-400 text-sm mt-1 hidden">Director name must contain only letters, spaces, and periods</div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-300 mb-1">Duration (minutes)</label>
                    <input id="duration" type="number" name="duration" min="1" value="${movie.duration}" required
                           class="w-full px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500" />
                    <div id="durationError" class="text-red-400 text-sm mt-1 hidden">Duration must be a positive number</div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-300 mb-1">Release Date</label>
                    <input id="releaseDate" type="date" name="releaseDate" value="${movie.releaseDate}" required
                           class="w-full px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500" />
                    <div id="releaseDateError" class="text-red-400 text-sm mt-1 hidden">Please provide a release date</div>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-300 mb-1">Current Categories</label>
                    <div class="flex flex-wrap gap-2">
                        <c:forEach var="cname" items="${movie.categories}">
                            <span class="px-3 py-1 bg-gray-800 rounded-full border border-gray-700 text-sm">${cname.name}</span>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-300 mb-2">Assign / Unassign Categories</label>
                <div class="flex flex-wrap gap-2">
                    <c:forEach var="cat" items="${categories}">
                        <label class="inline-flex items-center bg-gray-800 px-3 py-2 rounded-lg border border-gray-700 cursor-pointer">
                            <input type="checkbox" name="categories" value="${cat}" class="h-4 w-4" 
                                   <c:if test="${assigned != null && assigned.contains(cat)}">checked</c:if> />
                            <span class="ml-2 text-white text-sm">${cat}</span>
                        </label>
                    </c:forEach>
                </div>
                <p class="text-gray-400 text-sm mt-2">Select categories to assign to this movie. Uncheck to remove.</p>
            </div>

            <div class="flex items-center justify-between mt-6">
                <div class="flex gap-3">
                    <button id="saveBtn" type="submit" class="bg-green-600 hover:bg-green-700 px-5 py-2 rounded-lg font-medium text-white transition transform hover:scale-105 shadow-lg focus:outline-none focus:ring-2 focus:ring-green-400">Save Changes</button>
                    <a href="/admin/categories" class="px-5 py-2 rounded-lg bg-gray-700 hover:bg-gray-600">Cancel</a>
                </div>
                <form action="/admin/categories/remove" method="POST" onsubmit="return confirm('Remove all categories from ${movie.title}?')">
                    <input type="hidden" name="movieId" value="${movie.id}" />
                    <input type="hidden" name="category" value="" />
                    <button type="submit" class="px-4 py-2 bg-red-600 hover:bg-red-700 rounded text-sm">Remove All</button>
                </form>
            </div>
        </form>
    </div>
</div>

<script>
    (function(){
        const form = document.getElementById('editMovieForm');
        const title = document.getElementById('title');
        const director = document.getElementById('director');
        const duration = document.getElementById('duration');
        const releaseDate = document.getElementById('releaseDate');
        const titleError = document.getElementById('titleError');
        const directorError = document.getElementById('directorError');
        const durationError = document.getElementById('durationError');
        const releaseDateError = document.getElementById('releaseDateError');

        function validateTitle(){
            const v = (title.value || '').trim();
            if(!v){ title.classList.add('border-red-500'); titleError.classList.remove('hidden'); return false; }
            title.classList.remove('border-red-500'); titleError.classList.add('hidden'); return true;
        }

        function validateDirector(){
            const v = (director.value || '').trim();
            const re = /^[A-Za-z\s\.]+$/;
            if(!v || !re.test(v)){ director.classList.add('border-red-500'); directorError.classList.remove('hidden'); return false; }
            director.classList.remove('border-red-500'); directorError.classList.add('hidden'); return true;
        }

        function validateDuration(){
            const v = parseInt(duration.value, 10);
            if(isNaN(v) || v < 1){ duration.classList.add('border-red-500'); durationError.classList.remove('hidden'); return false; }
            duration.classList.remove('border-red-500'); durationError.classList.add('hidden'); return true;
        }

        function validateReleaseDate(){
            const v = (releaseDate.value || '').trim();
            if(!v){ releaseDate.classList.add('border-red-500'); releaseDateError.classList.remove('hidden'); return false; }
            releaseDate.classList.remove('border-red-500'); releaseDateError.classList.add('hidden'); return true;
        }

        title.addEventListener('input', validateTitle);
        director.addEventListener('input', validateDirector);
        duration.addEventListener('input', validateDuration);
        releaseDate.addEventListener('change', validateReleaseDate);

        form.addEventListener('submit', function(e){
            if(!validateTitle() || !validateDirector() || !validateDuration() || !validateReleaseDate()){
                e.preventDefault();
                return false;
            }
            // form will submit normally
        });
    })();
</script>

</body>
</html>