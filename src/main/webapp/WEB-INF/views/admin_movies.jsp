<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Movies</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body class="bg-gray-900 text-white p-6">

<div class="container mx-auto">
    <h1 class="text-3xl font-bold mb-6">Movie Catalog</h1>

    <div class="mb-4">
        <a href="/admin/movies" class="px-4 py-2 bg-green-600 rounded">Add New Movie</a>
    </div>

    <a href="/admin/categories" class="text-gray-400 hover:text-red-500 transition-colors">
        <i class="fas fa-tags mr-2"></i>Categorize Movies
    </a>

    <div class="overflow-x-auto bg-gray-800/40 rounded-lg p-4">
        <table class="w-full table-auto">
            <thead>
            <tr class="text-left text-sm font-medium text-gray-400 border-b border-gray-700 pb-2">
                <th class="px-4 py-2">Title</th>
                <th class="px-4 py-2">Genre</th>
                <th class="px-4 py-2">Director</th>
                <th class="px-4 py-2">Duration</th>
                <th class="px-4 py-2">Release Date</th>
                <th class="px-4 py-2 text-right">Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty movies}">
                    <c:forEach var="movie" items="${movies}">
                        <tr class="border-b border-gray-800/60">
                            <td class="px-4 py-3">${movie.title}</td>
                            <td class="px-4 py-3">${movie.genre}</td>
                            <td class="px-4 py-3">${movie.director}</td>
                            <td class="px-4 py-3">${movie.duration}</td>
                            <td class="px-4 py-3">${movie.releaseDate}</td>
                            <td class="px-4 py-3 text-right">
                                <a href="/admin/movies/edit/${movie.id}" class="text-blue-400 hover:underline mr-4">Edit</a>
                                <a href="/admin/movies/delete/${movie.id}" class="text-red-400 hover:underline">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="6" class="px-4 py-8 text-center text-gray-400">No movies found</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>