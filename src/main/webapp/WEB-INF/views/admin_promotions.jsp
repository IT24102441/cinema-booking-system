<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Promotions</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #0f0f23 0%, #1a1a2e 100%); }
        .hero-gradient { background: linear-gradient(135deg, #e50914 0%, #b20710 50%, #8b0000 100%); }
        .glow-effect { box-shadow: 0 0 20px rgba(229, 9, 20, 0.3); }
        .fade-in { animation: fadeIn 0.8s ease-out forwards; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .card-hover { transition: all 0.3s ease; }
        .card-hover:hover { transform: translateY(-8px); box-shadow: 0 20px 40px rgba(229, 9, 20, 0.2); }
    </style>
</head>
<body class="min-h-screen text-white">

<!-- No navbar here (removed per request). Use admin page styling to match other admin pages -->
<section class="pt-24 pb-12 min-h-screen">
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="fade-in">
        <div class="text-center mb-8">
            <h1 class="text-4xl font-bold mb-4">Promotion Management</h1>
            <p class="text-gray-400">Create and manage promotions, discounts, and featured placements</p>
        </div>

        <div class="mb-6 flex items-center justify-between">
            <div></div>
            <div class="flex items-center space-x-3">
                <c:url var="dashboardUrl" value="/admin-dashboard" />
                <a href="${dashboardUrl}" class="px-4 py-2 bg-gray-700 rounded hover:bg-gray-600">Back to Dashboard</a>
                <c:url var="createUrl" value="/admin/promotions/new" />
                <a href="${createUrl}" class="px-4 py-2 bg-green-600 rounded hover:bg-green-500">Create Promotion</a>
            </div>
        </div>

        <div class="overflow-x-auto bg-gray-800/40 rounded-lg p-4">
            <table class="w-full table-auto">
                <thead>
                <tr class="text-left text-sm font-medium text-gray-400 border-b border-gray-700 pb-2">
                    <th class="px-4 py-2">Promotion Code</th>
                    <th class="px-4 py-2">Type</th>
                    <th class="px-4 py-2">Value</th>
                    <th class="px-4 py-2">Value Type</th>
                    <th class="px-4 py-2">Description</th>
                    <th class="px-4 py-2">Start Date</th>
                    <th class="px-4 py-2">End Date</th>
                    <th class="px-4 py-2 text-right">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty promotions}">
                        <c:forEach var="promotion" items="${promotions}">
                            <tr class="border-b border-gray-800/60">
                                <td class="px-4 py-3 font-medium">${promotion.promotionCode}</td>
                                <td class="px-4 py-3">${promotion.promotionType}</td>
                                <td class="px-4 py-3">${promotion.value}</td>
                                <td class="px-4 py-3">${promotion.valueType}</td>
                                <td class="px-4 py-3">${promotion.description}</td>
                                <td class="px-4 py-3">${promotion.startDate}</td>
                                <td class="px-4 py-3">${promotion.endDate}</td>
                                <td class="px-4 py-3 text-right">
                                    <c:url var="editUrl" value="/admin/promotions/edit/${promotion.promotionCode}" />
                                    <c:url var="deleteUrl" value="/admin/promotions/delete/${promotion.promotionCode}" />
                                    <a href="${editUrl}" class="text-blue-400 hover:underline mr-4">Edit</a>
                                    <a href="${deleteUrl}" class="text-red-400 hover:underline">Delete</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="8" class="px-4 py-8 text-center text-gray-400">No promotions found</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>
</section>
</body>
</html>