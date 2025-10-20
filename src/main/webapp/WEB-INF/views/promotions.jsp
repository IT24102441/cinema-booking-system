<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Promotions</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body class="bg-gray-900 text-white p-6">

<jsp:include page="partials/navbar.jsp" />

<div class="container mx-auto pt-20">
    <div class="flex items-center justify-between mb-6">
        <h1 class="text-3xl font-bold mb-6">Available Promotions</h1>
        <!-- Create button removed for non-admin customers -->
    </div>
</div>

    <div class="grid grid-cols-1 gap-4">
        <c:choose>
            <c:when test="${not empty promotions}">
                <c:forEach var="promotion" items="${promotions}">
                    <div class="bg-gray-800/50 rounded-lg p-4">
                        <div class="flex items-center justify-between">
                            <div>
                                <h2 class="text-xl font-semibold">${promotion.promotionCode} - ${promotion.promotionType}</h2>
                                <p class="text-gray-300 mt-1">${promotion.description}</p>
                                <p class="text-sm text-gray-400 mt-2">Valid: ${promotion.startDate} to ${promotion.endDate}</p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="text-gray-400">No promotions available at the moment.</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<jsp:include page="partials/footer.jsp" />
<script src="/js/index.js"></script>
</body>
</html>