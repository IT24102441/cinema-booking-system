<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MovieMate - Admin Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #0f0f23 0%, #1a1a2e 100%); }
        .hero-gradient { background: linear-gradient(135deg, #e50914 0%, #b20710 50%, #8b0000 100%); }
        .glow-effect { box-shadow: 0 0 20px rgba(229, 9, 20, 0.3); }
        .fade-in { animation: fadeIn 0.8s ease-out forwards; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .card-hover { transition: all 0.3s ease; }
        .card-hover:hover { transform: translateY(-8px); box-shadow: 0 20px 40px rgba(229, 9, 20, 0.2); }
        .modal-backdrop { backdrop-filter: blur(8px); }
    </style>
</head>
<body class="min-h-screen text-white">
<nav class="fixed top-0 w-full z-40 bg-black/90 backdrop-blur-md border-b border-gray-800/50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <a href="/" class="text-2xl font-bold text-red-600"><i class="fas fa-film mr-2"></i>MovieMate</a>
            <div class="flex items-center space-x-6">
                <a href="/admin-dashboard" class="text-gray-400 hover:text-red-500 transition-colors"><i class="fas fa-tachometer-alt mr-2"></i>Dashboard</a>
                <button onclick="logout()" class="text-gray-400 hover:text-red-500 transition-colors"><i class="fas fa-sign-out-alt mr-2"></i>Logout</button>
            </div>
        </div>
    </div>
</nav>

<section class="pt-24 pb-12 min-h-screen">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="fade-in">
            <div class="text-center mb-8">
                <h1 class="text-4xl font-bold mb-4">Admin Management</h1>
                <p class="text-gray-400">Manage administrator accounts and permissions</p>
            </div>

            <div class="mb-6 flex flex-col sm:flex-row gap-4">
                <input type="text" id="searchInput" placeholder="Search admins..."
                       class="flex-1 px-4 py-2 bg-gray-900/50 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500">
                <button onclick="openCreateModal()"
                        class="hero-gradient px-6 py-2 rounded-lg font-medium glow-effect hover:opacity-90 transition-opacity">
                    <i class="fas fa-plus mr-2"></i>Add Admin
                </button>
            </div>

            <div class="bg-gray-900/50 backdrop-blur-sm border border-gray-800/50 rounded-xl overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-800/50">
                        <tr>
                            <th class="px-6 py-4 text-left text-sm font-medium text-gray-400">ID</th>
                            <th class="px-6 py-4 text-left text-sm font-medium text-gray-400">Name</th>
                            <th class="px-6 py-4 text-left text-sm font-medium text-gray-400">Email</th>
                            <th class="px-6 py-4 text-left text-sm font-medium text-gray-400">Role</th>
                            <th class="px-6 py-4 text-left text-sm font-medium text-gray-400">Description</th>
                            <th class="px-6 py-4 text-right text-sm font-medium text-gray-400">Actions</th>
                        </tr>
                        </thead>
                        <tbody id="adminTableBody" class="divide-y divide-gray-800/50">
                        <!-- Rows injected by JS -->
                        </tbody>
                    </table>
                    <div id="noResults" class="hidden text-center py-8 text-gray-400">No admins found</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Modal -->
<div id="adminModal" class="hidden fixed inset-0 z-50 flex items-center justify-center modal-backdrop bg-black/70">
    <div class="bg-gray-900 border border-gray-800 rounded-xl p-6 w-full max-w-md mx-4">
        <h2 id="modalTitle" class="text-2xl font-bold mb-4">Create Admin</h2>
        <form id="adminForm" onsubmit="handleSubmit(event)">
            <input type="hidden" id="adminId">
            <div class="mb-4">
                <label class="block text-sm font-medium mb-2">Name</label>
                <input type="text" id="name" required
                       class="w-full px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500">
                <span id="nameError" class="text-red-500 text-sm hidden">Only letters and spaces allowed</span>
            </div>
            <div class="mb-4">
                <label class="block text-sm font-medium mb-2">Email</label>
                <input type="email" id="email" required
                       class="w-full px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500">
                <span id="emailError" class="text-red-500 text-sm hidden">Invalid email format</span>
            </div>
            <div class="mb-4">
                <label class="block text-sm font-medium mb-2">Password</label>
                <input  type="password" id="password" required
                       class="w-full px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500">
                <span id="passwordError" class="text-red-500 text-sm hidden">Min 6 characters</span>
            </div>
            <div class="mb-4">
                <label class="block text-sm font-medium mb-2">Role</label>
                <select id="role" required
                        class="w-full px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500">
                    <option value="">Select Role</option>
                    <option value="Staff Manager">Staff Manager</option>
                    <option value="Movie Manager">Movie Manager</option>
                    <option value="Booking Manager">Booking Manager</option>
                    <option value="Super Admin">Super Admin</option>
                </select>
            </div>
            <div class="mb-6">
                <label class="block text-sm font-medium mb-2">Description</label>
                <textarea id="description" rows="3"
                          class="w-full px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:border-red-500"></textarea>
            </div>
            <div class="flex justify-end gap-3">
                <button type="button" onclick="closeModal()"
                        class="px-4 py-2 bg-gray-700 rounded-lg hover:bg-gray-600 transition-colors">Cancel</button>
                <button type="submit"
                        class="hero-gradient px-4 py-2 rounded-lg font-medium glow-effect hover:opacity-90 transition-opacity">Save</button>
            </div>
        </form>
    </div>
</div>

<script src="/js/admin_list.js">

</script>
</body>
</html>