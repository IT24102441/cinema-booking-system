<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MovieMate - Admin Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #0f0f23 0%, #1a1a2e 100%); }
        .hero-gradient { background: linear-gradient(135deg, #e50914 0%, #b20710 50%, #8b0000 100%); }
        .glow-effect { box-shadow: 0 0 20px rgba(229, 9, 20, 0.3); }
        .fade-in { animation: fadeIn 0.8s ease-out forwards; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="min-h-screen text-white flex items-center justify-center">
<div class="fade-in w-full max-w-md mx-4">
    <div class="text-center mb-8">
        <div class="hero-gradient w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4 glow-effect">
            <i class="fas fa-lock text-3xl text-white"></i>
        </div>
        <h1 class="text-4xl font-bold mb-2">Admin Login</h1>
        <p class="text-gray-400">Access MovieMate Admin Dashboard</p>
    </div>

    <form id="loginForm" class="bg-gray-900/50 backdrop-blur-sm border border-gray-800/50 rounded-xl p-8">
        <div class="mb-4">
            <label class="block text-sm font-medium mb-2">Email</label>
            <input type="email" id="email" required
                   class="w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500 transition-colors">
            <span id="emailError" class="text-red-500 text-sm hidden">Invalid email format</span>
        </div>
        <div class="mb-6">
            <label class="block text-sm font-medium mb-2">Password</label>
            <input type="password" id="password" required
                   class="w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500 transition-colors">
            <span id="passwordError" class="text-red-500 text-sm hidden">Min 6 characters required</span>
        </div>
        <button type="submit"
                class="w-full hero-gradient py-3 rounded-lg font-medium glow-effect hover:opacity-90 transition-opacity">
            <i class="fas fa-sign-in-alt mr-2"></i>Login
        </button>
        <div id="loginError" class="text-red-500 text-sm mt-4 hidden"></div>
    </form>
</div>

<script src="/js/admin_login.js"></script>
</body>
</html>