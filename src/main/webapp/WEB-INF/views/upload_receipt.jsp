<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Receipt - MovieMate</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .glow { box-shadow: 0 10px 30px rgba(229, 9, 20, .25); }
        .fade-in { animation: fadeIn .4s ease-out both; }
        .slide-up { animation: slideUp .5s ease-out both; }
        @keyframes fadeIn { from { opacity: 0 } to { opacity: 1 } }
        @keyframes slideUp { from { opacity: 0; transform: translateY(16px) } to { opacity: 1; transform: translateY(0) } }
    </style>
</head>
<body class="min-h-screen text-white" style="background: radial-gradient(1200px 600px at 10% -10%, rgba(229,9,20,.12), transparent 40%), radial-gradient(1200px 600px at 110% 10%, rgba(229,9,20,.08), transparent 40%), #0f0f23;">
<jsp:include page="partials/navbar.jsp" />

<main class="pt-24 pb-16">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header / Steps -->
        <div class="mb-6 slide-up">
            <div class="flex items-center text-sm text-gray-400 space-x-2">
                <span class="px-2 py-1 rounded bg-gray-800/70 border border-gray-700">Step 2 of 2</span>
                <span>•</span>
                <span>Upload your payment receipt</span>
            </div>
            <h1 class="mt-3 text-3xl md:text-4xl font-extrabold tracking-tight">
                <span class="bg-clip-text text-transparent bg-gradient-to-r from-red-500 via-red-400 to-rose-400">Upload Payment Receipt</span>
            </h1>
            <p class="mt-2 text-gray-400">Please provide proof of payment so our team can verify your booking.</p>
        </div>

        <div class="bg-gray-900/75 rounded-2xl border border-gray-800/60 p-6 md:p-8 fade-in">
            <!-- Booking Summary -->
            <div class="bg-gray-800/40 rounded-xl p-4 md:p-5 border border-gray-700/50 mb-6">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4 text-sm">
                    <div class="flex items-center justify-between md:block">
                        <div class="text-gray-400">Booking ID</div>
                        <div class="font-semibold">#${booking.id}</div>
                    </div>
                    <div class="flex items-center justify-between md:block">
                        <div class="text-gray-400">Movie</div>
                        <div class="font-semibold truncate" title="${booking.movieName}">${booking.movieName}</div>
                    </div>
                    <div class="flex items-center justify-between md:block">
                        <div class="text-gray-400">Total Payment</div>
                        <div class="font-semibold text-red-400">$${booking.totalPayment}</div>
                    </div>
                    <div class="flex items-center justify-between md:block">
                        <div class="text-gray-400">Status</div>
                        <div>
                            <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-emerald-500/15 text-emerald-300 border border-emerald-600/30">
                                <i class="fa fa-check mr-1"></i>${booking.status}
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mb-4 text-sm text-gray-300">
                Accepted formats: <span class="text-gray-200 font-medium">JPG, PNG, PDF</span>. Max size: <span class="font-medium">10MB</span>.
            </div>

            <!-- Upload Form -->
            <form id="upload-form" class="space-y-5" data-booking-id="${booking.id}">
                <!-- Drag & Drop Zone -->
                <div id="dropzone" class="relative rounded-xl border-2 border-dashed border-gray-700 hover:border-red-500/60 transition-colors bg-gray-800/40 p-6 cursor-pointer">
                    <input type="file" id="receipt-file" accept="image/*,.pdf" class="absolute inset-0 w-full h-full opacity-0 cursor-pointer" />
                    <div class="flex flex-col items-center justify-center text-center pointer-events-none">
                        <div class="w-14 h-14 rounded-full bg-red-500/10 text-red-400 flex items-center justify-center mb-3 glow">
                            <i class="fas fa-cloud-upload-alt text-2xl"></i>
                        </div>
                        <p class="text-gray-200 font-medium">Drag & drop your file here, or <span class="text-red-400">browse</span></p>
                        <p class="text-xs text-gray-400 mt-1">Only JPG, PNG or PDF up to 10MB</p>
                    </div>
                </div>

                <!-- Preview / Selected file -->
                <div id="file-preview" class="hidden bg-gray-800/50 border border-gray-700/70 rounded-lg p-4">
                    <div class="flex items-center">
                        <div id="preview-thumb" class="w-14 h-14 rounded bg-gray-700 flex items-center justify-center overflow-hidden mr-4">
                            <i class="far fa-file text-2xl text-gray-400"></i>
                        </div>
                        <div class="flex-1">
                            <div id="preview-name" class="font-semibold"></div>
                            <div id="preview-meta" class="text-xs text-gray-400"></div>
                        </div>
                        <button type="button" id="change-file" class="ml-4 px-3 py-2 text-sm rounded bg-gray-700 hover:bg-gray-600">Change</button>
                    </div>
                </div>

                <!-- Progress Bar -->
                <div id="progress-wrapper" class="hidden">
                    <div class="w-full bg-gray-800 rounded-full h-2 overflow-hidden">
                        <div id="progress-bar" class="h-2 bg-gradient-to-r from-red-500 to-rose-500" style="width:0%"></div>
                    </div>
                    <div id="progress-text" class="text-xs text-gray-400 mt-1">0%</div>
                </div>

                <div class="flex items-center justify-end space-x-3">
                    <a href="/" class="px-4 py-2 rounded-lg bg-gray-800 text-gray-300 hover:text-white hover:bg-gray-700 transition"><i class="fas fa-home mr-2"></i>Home</a>
                    <button type="submit" id="upload-btn" class="px-6 py-3 rounded-lg bg-gradient-to-r from-red-600 to-rose-600 hover:from-red-500 hover:to-rose-500 font-semibold transition shadow-md glow">
                        <i class="fas fa-cloud-upload-alt mr-2"></i>Upload Receipt
                    </button>
                </div>
            </form>

            <div id="upload-message" class="mt-5 text-sm"></div>
        </div>
    </div>
</main>

<jsp:include page="partials/footer.jsp" />
<script src="/js/upload_receipt.js"></script>
</body>
</html>