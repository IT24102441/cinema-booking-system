<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create/Edit Promotion</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" href="data:image/x-icon;base64,AA" />
</head>
<body class="bg-gray-900 text-white p-6">
<div class="container mx-auto max-w-2xl">
    <div class="flex items-center justify-between mb-6">
        <h1 class="text-2xl font-bold">
            <c:choose>
                <c:when test="${not empty promotion and not empty promotion.promotionCode}">Edit Promotion</c:when>
                <c:otherwise>Create Promotion</c:otherwise>
            </c:choose>
        </h1>
        <a href="/admin/promotions" class="px-3 py-1 bg-gray-700 rounded hover:bg-gray-600">Back</a>
    </div>

    <c:choose>
        <%-- Edit form --%>
        <c:when test="${not empty promotion and not empty promotion.promotionCode}">
            <form action="/admin/promotions/update" method="post" class="bg-gray-800/60 rounded-lg p-6 space-y-4">
                <!-- Promotion Code (readonly for edit) -->
                <div>
                    <label class="block text-sm text-gray-300 mb-1" for="promotionCode">Promotion Code *</label>
                    <input id="promotionCode" required readonly 
                           value="${not empty promotion.promotionCode ? promotion.promotionCode : ''}" 
                           class="w-full px-3 py-2 rounded bg-gray-700 text-white border border-gray-600" />
                    <input type="hidden" name="promotionCode" 
                           value="${not empty promotion.promotionCode ? promotion.promotionCode : ''}" />
                    <p class="text-xs text-gray-400 mt-1">Promotion code cannot be changed</p>
                </div>

                <!-- Promotion Type -->
                <div>
                    <label class="block text-sm text-gray-300 mb-1" for="promotionType">Promotion Type *</label>
                    <select id="promotionType" name="promotionType" required
                            class="w-full px-3 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:border-blue-500 focus:outline-none">
                        <option value="" disabled ${empty promotion.promotionType ? 'selected' : ''}>Select type</option>
                        <c:forEach var="type" items="${promotionTypes}">
                            <option value="${type}" <c:if test="${type == promotion.promotionType}">selected</c:if>>
                                <c:out value="${type}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Promotion Value and Value Type -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm text-gray-300 mb-1" for="value">Discount Value</label>
                        <input id="value" name="value" type="number" step="0.01" min="0"
                               value="${not empty promotion.value ? promotion.value : ''}"
                               class="w-full px-3 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:border-blue-500 focus:outline-none" />
                        <p class="text-xs text-gray-400 mt-1">Enter fixed amount or percent (depending on Value Type)</p>
                    </div>
                    <div>
                        <label class="block text-sm text-gray-300 mb-1" for="valueType">Value Type</label>
                        <select id="valueType" name="valueType"
                                class="w-full px-3 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:border-blue-500 focus:outline-none">
                            <option value="" disabled ${empty promotion.valueType ? 'selected' : ''}>Select</option>
                            <c:forEach var="vt" items="${valueTypes}">
                                <option value="${vt}" <c:if test="${vt == promotion.valueType}">selected</c:if>>${vt}</option>
                            </c:forEach>
                        </select>
                        <p class="text-xs text-gray-400 mt-1">FIXED = fixed amount off, PERCENT = percentage off</p>
                    </div>
                </div>

                <!-- Description -->
                <div>
                    <label class="block text-sm text-gray-300 mb-1" for="description">Description</label>
                    <textarea id="description" name="description" rows="4" 
                              placeholder="Enter promotion details..."
                              class="w-full px-3 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:border-blue-500 focus:outline-none">${not empty promotion.description ? promotion.description : ''}</textarea>
                    <p class="text-xs text-gray-400 mt-1">Maximum 1000 characters</p>
                </div>

                <!-- Date Range -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm text-gray-300 mb-1" for="startDate">Start Date</label>
                        <input id="startDate" name="startDate" type="date" 
                               value="${not empty startDateStr ? startDateStr : ''}" 
                               class="w-full px-3 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:border-blue-500 focus:outline-none" />
                    </div>
                    <div>
                        <label class="block text-sm text-gray-300 mb-1" for="endDate">End Date</label>
                        <input id="endDate" name="endDate" type="date" 
                               value="${not empty endDateStr ? endDateStr : ''}" 
                               class="w-full px-3 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:border-blue-500 focus:outline-none" />
                    </div>
                </div>

                <!-- Created At (display only) -->
                <c:if test="${not empty createdAtStr}">
                    <div class="bg-gray-700/50 rounded p-3">
                        <label class="block text-sm text-gray-300 mb-1">Created At</label>
                        <p class="text-white">${createdAtStr}</p>
                    </div>
                </c:if>

                <!-- CSRF Protection -->
                <c:if test="${not empty _csrf}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </c:if>

                <div class="flex justify-end space-x-3 pt-4">
                    <a href="/admin/promotions" class="px-4 py-2 bg-gray-600 rounded hover:bg-gray-500 transition-colors">Cancel</a>
                    <button type="submit" class="px-4 py-2 bg-blue-600 rounded hover:bg-blue-500 transition-colors">Update Promotion</button>
                </div>
            </form>
        </c:when>

        <%-- Create form --%>
        <c:otherwise>
            <form action="/admin/promotions/create" method="post" class="bg-gray-800/60 rounded-lg p-6 space-y-4">
                <!-- Promotion Code -->
                <div>
                    <label class="block text-sm text-gray-300 mb-1" for="promotionCode">Promotion Code *</label>
                    <input id="promotionCode" name="promotionCode" required 
                           placeholder="e.g., SUMMER25, WELCOME10"
                           class="w-full px-3 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:border-blue-500 focus:outline-none" />
                    <p class="text-xs text-gray-400 mt-1">Unique code for the promotion</p>
                </div>

                <!-- Promotion Type -->
                <div>
                    <label class="block text-sm text-gray-300 mb-1" for="promotionType">Promotion Type *</label>
                    <select id="promotionType" name="promotionType" required
                            class="w-full px-3 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:border-blue-500 focus:outline-none">
                        <option value="" disabled selected>Select type</option>
                        <c:forEach var="type" items="${promotionTypes}">
                            <option value="${type}">${type}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Promotion Value and Value Type -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm text-gray-300 mb-1" for="value">Discount Value</label>
                        <input id="value" name="value" type="number" step="0.01" min="0"
                               class="w-full px-3 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:border-blue-500 focus:outline-none" />
                        <p class="text-xs text-gray-400 mt-1">Enter fixed amount or percent (depending on Value Type)</p>
                    </div>
                    <div>
                        <label class="block text-sm text-gray-300 mb-1" for="valueType">Value Type</label>
                        <select id="valueType" name="valueType"
                                class="w-full px-3 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:border-blue-500 focus:outline-none">
                            <option value="" disabled selected>Select</option>
                            <c:forEach var="vt" items="${valueTypes}">
                                <option value="${vt}">${vt}</option>
                            </c:forEach>
                        </select>
                        <p class="text-xs text-gray-400 mt-1">FIXED = fixed amount off, PERCENT = percentage off</p>
                    </div>
                </div>

                <!-- Description -->
                <div>
                    <label class="block text-sm text-gray-300 mb-1" for="description">Description</label>
                    <textarea id="description" name="description" rows="4" 
                              placeholder="Enter promotion details..."
                              class="w-full px-3 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:border-blue-500 focus:outline-none"></textarea>
                    <p class="text-xs text-gray-400 mt-1">Maximum 1000 characters</p>
                </div>

                <!-- Date Range -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm text-gray-300 mb-1" for="startDate">Start Date</label>
                        <input id="startDate" name="startDate" type="date" 
                               class="w-full px-3 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:border-blue-500 focus:outline-none" />
                    </div>
                    <div>
                        <label class="block text-sm text-gray-300 mb-1" for="endDate">End Date</label>
                        <input id="endDate" name="endDate" type="date" 
                               class="w-full px-3 py-2 rounded bg-gray-700 text-white border border-gray-600 focus:border-blue-500 focus:outline-none" />
                    </div>
                </div>

                <!-- CSRF Protection -->
                <c:if test="${not empty _csrf}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </c:if>

                <div class="flex justify-end space-x-3 pt-4">
                    <a href="/admin/promotions" class="px-4 py-2 bg-gray-600 rounded hover:bg-gray-500 transition-colors">Cancel</a>
                    <button type="submit" class="px-4 py-2 bg-green-600 rounded hover:bg-green-500 transition-colors">Create Promotion</button>
                </div>
            </form>
        </c:otherwise>
    </c:choose>
</div>

<script>
    // Client-side validation for dates
    document.addEventListener('DOMContentLoaded', function() {
        const startDate = document.getElementById('startDate');
        const endDate = document.getElementById('endDate');
        
        if (startDate && endDate) {
            endDate.addEventListener('change', function() {
                if (startDate.value && endDate.value) {
                    if (new Date(endDate.value) < new Date(startDate.value)) {
                        alert('End date cannot be before start date');
                        endDate.value = '';
                    }
                }
            });
            
            startDate.addEventListener('change', function() {
                if (startDate.value && endDate.value) {
                    if (new Date(endDate.value) < new Date(startDate.value)) {
                        alert('End date cannot be before start date');
                        endDate.value = '';
                    }
                }
            });
        }
    });
</script>
</body>
</html>