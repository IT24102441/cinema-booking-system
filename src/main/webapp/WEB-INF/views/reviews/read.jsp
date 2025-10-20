<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Read Reviews</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body class="bg-gray-900 text-white p-6">
<jsp:include page="../partials/navbar.jsp" />

<div class="max-w-5xl mx-auto">
    <div class="flex items-center justify-between mb-6">
        <h1 class="text-3xl font-bold">All Reviews</h1>
        <div class="space-x-2">
            <a href="/" class="bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded">Back to Home</a>
            <a href="/reviews/create" class="bg-red-600 hover:bg-red-500 px-4 py-2 rounded">Write a Review</a>
        </div>
    </div>

    <div class="mb-4">
        <input id="searchReviews" placeholder="Search by movie or text" class="w-full p-2 rounded bg-gray-800 border border-gray-700"/>
    </div>

    <div id="reviewsContainer" class="grid grid-cols-1 md:grid-cols-2 gap-4"></div>
</div>
<script src="/js/reviews/read.js"></script>
<script src="/js/index.js"></script>
</body>
</html>


