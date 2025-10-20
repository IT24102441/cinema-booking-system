<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Review</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-900 text-white p-6">
<div class="max-w-xl mx-auto">
    <div class="flex items-center justify-between mb-6">
        <h1 class="text-3xl font-bold">Edit Review</h1>
        <a href="/" class="bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded">Go to Home</a>
    </div>
    <form id="editReviewForm" class="space-y-4">
        <input type="hidden" id="reviewId" />
        <input type="text" id="movieName" class="w-full p-2 rounded bg-gray-800 border border-gray-700" disabled />
        <input type="email" id="userEmail" class="w-full p-2 rounded bg-gray-800 border border-gray-700" disabled />
        <input type="number" min="1" max="5" id="rating" placeholder="Rating (1-5)" class="w-full p-2 rounded bg-gray-800 border border-gray-700" required />
        <textarea id="comment" placeholder="Comment" class="w-full p-2 rounded bg-gray-800 border border-gray-700" rows="5" required></textarea>
        <div class="flex gap-2">
            <button type="submit" class="bg-red-600 hover:bg-red-500 px-4 py-2 rounded">Update</button>
            <a href="/" class="bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded">Go to Home</a>
        </div>
    </form>
</div>

<script src="/js/reviews/edit.js"></script>
</body>
</html>


