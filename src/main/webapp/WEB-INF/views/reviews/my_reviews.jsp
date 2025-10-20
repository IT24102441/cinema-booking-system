<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Reviews</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-900 text-white p-6">
<jsp:include page="../partials/navbar.jsp"/>
<div class="container mx-auto pt-20">
    <div class="flex items-center justify-between mb-6">
        <h1 class="text-3xl font-bold">My Reviews</h1>
        <div class="space-x-2">
            <a href="/" class="bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded">Go to Home</a>
            <a href="/reviews/create" class="bg-red-600 hover:bg-red-500 px-4 py-2 rounded">Write a Review</a>
        </div>
    </div>
    <div class="overflow-x-auto">
        <table class="min-w-full bg-gray-800 rounded-lg overflow-hidden">
            <thead class="bg-gray-700">
            <tr>
                <th class="px-4 py-2 text-left">Movie</th>
                <th class="px-4 py-2 text-left">Rating</th>
                <th class="px-4 py-2 text-left">Comment</th>
                <th class="px-4 py-2 text-left">Actions</th>
            </tr>
            </thead>
            <tbody id="myReviewsBody"></tbody>
        </table>
    </div>
</div>

<script src="/js/reviews/my_reviews.js"></script>
<jsp:include page="../partials/footer.jsp" />
<script src="/js/index.js"></script>
</body>
</html>


