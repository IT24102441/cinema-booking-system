<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Review</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-900 text-white p-6">
<div class="max-w-xl mx-auto">
    <h1 class="text-3xl font-bold mb-6">Create Review</h1>
    <form id="createReviewForm" class="space-y-4">
        <input type="text" id="movieName" placeholder="Movie Name" class="w-full p-2 rounded bg-gray-800 border border-gray-700" required/>
        <input type="email" id="userEmail" placeholder="Your Email (optional)" class="w-full p-2 rounded bg-gray-800 border border-gray-700"/>
        <input type="number" min="1" max="5" id="rating" placeholder="Rating (1-5)" class="w-full p-2 rounded bg-gray-800 border border-gray-700" required />
        <textarea id="comment" placeholder="Comment" class="w-full p-2 rounded bg-gray-800 border border-gray-700" rows="5" required></textarea>
        <div class="flex gap-2">
            <button type="submit" class="bg-red-600 hover:bg-red-500 px-4 py-2 rounded">Save</button>
            <a href="/" class="bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded">Back to Home</a>
        </div>
    </form>
</div>

<script src="/js/reviews/create.js"></script>
</body>
</html>


