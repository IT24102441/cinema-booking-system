document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.getElementById('loginForm');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const loginBtn = document.getElementById('loginBtn');
    const loginBtnText = document.getElementById('loginBtnText');
    const loginBtnLoading = document.getElementById('loginBtnLoading');
    const loginMessage = document.getElementById('loginMessage');
    const togglePassword = document.getElementById('togglePassword');

    // Toggle password visibility
    togglePassword.addEventListener('click', function() {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);

        const icon = this.querySelector('i');
        if (type === 'password') {
            icon.className = 'fas fa-eye';
        } else {
            icon.className = 'fas fa-eye-slash';
        }
    });

    // Email validation
    function validateEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    // Password validation
    function validatePassword(password) {
        return password.length >= 6;
    }

    // Show error message
    function showError(fieldId, message) {
        const errorElement = document.getElementById(fieldId + 'Error');
        errorElement.textContent = message;
        errorElement.classList.remove('hidden');

        const inputElement = document.getElementById(fieldId);
        inputElement.classList.add('border-red-500');
    }

    // Hide error message
    function hideError(fieldId) {
        const errorElement = document.getElementById(fieldId + 'Error');
        errorElement.classList.add('hidden');

        const inputElement = document.getElementById(fieldId);
        inputElement.classList.remove('border-red-500');
    }

    // Show success/error message
    function showMessage(message, isSuccess = false) {
        loginMessage.textContent = message;
        loginMessage.classList.remove('hidden', 'bg-red-600/20', 'text-red-400', 'bg-green-600/20', 'text-green-400');

        if (isSuccess) {
            loginMessage.classList.add('bg-green-600/20', 'text-green-400');
        } else {
            loginMessage.classList.add('bg-red-600/20', 'text-red-400');
        }
    }

    // Hide message
    function hideMessage() {
        loginMessage.classList.add('hidden');
    }

    // Set loading state
    function setLoading(isLoading) {
        loginBtn.disabled = isLoading;

        if (isLoading) {
            loginBtnText.classList.add('hidden');
            loginBtnLoading.classList.remove('hidden');
        } else {
            loginBtnText.classList.remove('hidden');
            loginBtnLoading.classList.add('hidden');
        }
    }

    // Clear all errors
    function clearErrors() {
        hideError('email');
        hideError('password');
        hideMessage();
    }

    // Real-time validation
    emailInput.addEventListener('input', function() {
        if (this.value.trim() === '') {
            hideError('email');
        } else if (!validateEmail(this.value)) {
            showError('email', 'Please enter a valid email address');
        } else {
            hideError('email');
        }
    });

    passwordInput.addEventListener('input', function() {
        if (this.value === '') {
            hideError('password');
        } else if (!validatePassword(this.value)) {
            showError('password', 'Password must be at least 6 characters long');
        } else {
            hideError('password');
        }
    });

    // Form submission
    loginForm.addEventListener('submit', async function(e) {
        e.preventDefault();
        clearErrors();

        const email = emailInput.value.trim();
        const password = passwordInput.value;

        let isValid = true;

        // Validate email
        if (!email) {
            showError('email', 'Email is required');
            isValid = false;
        } else if (!validateEmail(email)) {
            showError('email', 'Please enter a valid email address');
            isValid = false;
        }

        // Validate password
        if (!password) {
            showError('password', 'Password is required');
            isValid = false;
        } else if (!validatePassword(password)) {
            showError('password', 'Password must be at least 6 characters long');
            isValid = false;
        }

        if (!isValid) {
            return;
        }

        // Set loading state
        setLoading(true);

        try {
            // Create form data for POST request
            const formData = new FormData();
            formData.append('email', email);
            formData.append('password', password);

            const response = await fetch('/api/users/login', {
                method: 'POST',
                body: formData
            });

            // ✅ Safe parsing: JSON if available, otherwise ignore
            let data = null;
            try {
                data = await response.json();
            } catch {
                data = null; // If response is not JSON, ignore
            }

            if (response.ok) {
                // ✅ Login success
                localStorage.setItem("email", data.email);
                localStorage.setItem('user', JSON.stringify(data));
                localStorage.setItem('isLoggedIn', 'true');
                localStorage.setItem("movieUserId", data.id);

                showMessage('Login successful! Redirecting...', true);

                // Redirect after short delay
                setTimeout(() => {
                    window.location.href = '/';
                }, 2000);

            } else {
                // ❌ Login failed
                if (response.status === 401) {
                    showMessage('Invalid email or password. Please try again.');
                } else {
                    showMessage('Login failed. Please try again.');
                }
            }
        } catch (error) {
            console.error('Login error:', error);
            showMessage('Network error. Please check your connection and try again.');
        } finally {
            setLoading(false);
        }

    });
});