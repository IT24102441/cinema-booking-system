document.addEventListener('DOMContentLoaded', function() {
    const registerForm = document.getElementById('registerForm');
    const firstNameInput = document.getElementById('firstName');
    const lastNameInput = document.getElementById('lastName');
    const emailInput = document.getElementById('email');
    const contactNumberInput = document.getElementById('contactNumber');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const agreeTermsCheckbox = document.getElementById('agreeTerms');
    const registerBtn = document.getElementById('registerBtn');
    const registerBtnText = document.getElementById('registerBtnText');
    const registerBtnLoading = document.getElementById('registerBtnLoading');
    const registerMessage = document.getElementById('registerMessage');
    const togglePassword = document.getElementById('togglePassword');
    const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');

    // Regular expressions for validation
    const nameRegex = /^[a-zA-Z]{2,30}$/;
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const contactRegex = /^[+]?[\d\s\-\(\)]{10,15}$/;
    const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

    // Toggle password visibility
    togglePassword.addEventListener('click', function() {
        togglePasswordVisibility(passwordInput, this);
    });

    toggleConfirmPassword.addEventListener('click', function() {
        togglePasswordVisibility(confirmPasswordInput, this);
    });

    function togglePasswordVisibility(input, button) {
        const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
        input.setAttribute('type', type);

        const icon = button.querySelector('i');
        if (type === 'password') {
            icon.className = 'fas fa-eye';
        } else {
            icon.className = 'fas fa-eye-slash';
        }
    }

    // Validation functions
    function validateName(name, fieldName) {
        if (!name.trim()) {
            return `${fieldName} is required`;
        }
        if (!nameRegex.test(name.trim())) {
            return `${fieldName} must contain only letters (2-30 characters)`;
        }
        return null;
    }

    function validateEmail(email) {
        if (!email.trim()) {
            return 'Email is required';
        }
        if (!emailRegex.test(email.trim())) {
            return 'Please enter a valid email address';
        }
        return null;
    }

    function validateContactNumber(contact) {
        if (!contact.trim()) {
            return 'Contact number is required';
        }
        if (!contactRegex.test(contact.trim())) {
            return 'Please enter a valid contact number (10-15 digits)';
        }
        return null;
    }

    function validatePassword(password) {
        if (!password) {
            return 'Password is required';
        }
        if (!passwordRegex.test(password)) {
            return 'Password must be at least 8 characters with uppercase, lowercase, number, and special character';
        }
        return null;
    }

    function validateConfirmPassword(password, confirmPassword) {
        if (!confirmPassword) {
            return 'Please confirm your password';
        }
        if (password !== confirmPassword) {
            return 'Passwords do not match';
        }
        return null;
    }

    function validateTerms(agreed) {
        if (!agreed) {
            return 'You must agree to the terms and conditions';
        }
        return null;
    }

    // Show error message
    function showError(fieldId, message) {
        const errorElement = document.getElementById(fieldId + 'Error');
        const inputElement = document.getElementById(fieldId);

        errorElement.textContent = message;
        errorElement.classList.remove('hidden');
        inputElement.classList.add('field-invalid');
        inputElement.classList.remove('field-valid');
    }

    // Hide error message and show valid state
    function hideError(fieldId) {
        const errorElement = document.getElementById(fieldId + 'Error');
        const inputElement = document.getElementById(fieldId);

        errorElement.classList.add('hidden');
        inputElement.classList.remove('field-invalid');
        inputElement.classList.add('field-valid');
    }

    // Clear field state
    function clearFieldState(fieldId) {
        const errorElement = document.getElementById(fieldId + 'Error');
        const inputElement = document.getElementById(fieldId);

        errorElement.classList.add('hidden');
        inputElement.classList.remove('field-invalid', 'field-valid');
    }

    // Show success/error message
    function showMessage(message, isSuccess = false) {
        registerMessage.textContent = message;
        registerMessage.classList.remove('hidden', 'bg-red-600/20', 'text-red-400', 'bg-green-600/20', 'text-green-400');

        if (isSuccess) {
            registerMessage.classList.add('bg-green-600/20', 'text-green-400');
        } else {
            registerMessage.classList.add('bg-red-600/20', 'text-red-400');
        }
    }

    // Hide message
    function hideMessage() {
        registerMessage.classList.add('hidden');
    }

    // Set loading state
    function setLoading(isLoading) {
        registerBtn.disabled = isLoading;

        if (isLoading) {
            registerBtnText.classList.add('hidden');
            registerBtnLoading.classList.remove('hidden');
        } else {
            registerBtnText.classList.remove('hidden');
            registerBtnLoading.classList.add('hidden');
        }
    }

    // Real-time validation
    firstNameInput.addEventListener('input', function() {
        const error = validateName(this.value, 'First name');
        if (this.value.trim() === '') {
            clearFieldState('firstName');
        } else if (error) {
            showError('firstName', error);
        } else {
            hideError('firstName');
        }
    });

    lastNameInput.addEventListener('input', function() {
        const error = validateName(this.value, 'Last name');
        if (this.value.trim() === '') {
            clearFieldState('lastName');
        } else if (error) {
            showError('lastName', error);
        } else {
            hideError('lastName');
        }
    });

    emailInput.addEventListener('input', function() {
        const error = validateEmail(this.value);
        if (this.value.trim() === '') {
            clearFieldState('email');
        } else if (error) {
            showError('email', error);
        } else {
            hideError('email');
        }
    });

    contactNumberInput.addEventListener('input', function() {
        const error = validateContactNumber(this.value);
        if (this.value.trim() === '') {
            clearFieldState('contactNumber');
        } else if (error) {
            showError('contactNumber', error);
        } else {
            hideError('contactNumber');
        }
    });

    passwordInput.addEventListener('input', function() {
        const error = validatePassword(this.value);
        if (this.value === '') {
            clearFieldState('password');
        } else if (error) {
            showError('password', error);
        } else {
            hideError('password');
        }

        // Revalidate confirm password if it has a value
        if (confirmPasswordInput.value) {
            const confirmError = validateConfirmPassword(this.value, confirmPasswordInput.value);
            if (confirmError) {
                showError('confirmPassword', confirmError);
            } else {
                hideError('confirmPassword');
            }
        }
    });

    confirmPasswordInput.addEventListener('input', function() {
        const error = validateConfirmPassword(passwordInput.value, this.value);
        if (this.value === '') {
            clearFieldState('confirmPassword');
        } else if (error) {
            showError('confirmPassword', error);
        } else {
            hideError('confirmPassword');
        }
    });

    // Form submission
    registerForm.addEventListener('submit', async function(e) {
        e.preventDefault();
        hideMessage();

        const formData = {
            firstName: firstNameInput.value.trim(),
            lastName: lastNameInput.value.trim(),
            email: emailInput.value.trim(),
            contactNumber: contactNumberInput.value.trim(),
            password: passwordInput.value,
            confirmPassword: confirmPasswordInput.value,
            agreeTerms: agreeTermsCheckbox.checked
        };

        console.log('Form data:', formData);

        let isValid = true;

        // Validate all fields
        const firstNameError = validateName(formData.firstName, 'First name');
        if (firstNameError) {
            showError('firstName', firstNameError);
            isValid = false;
        }

        const lastNameError = validateName(formData.lastName, 'Last name');
        if (lastNameError) {
            showError('lastName', lastNameError);
            isValid = false;
        }

        const emailError = validateEmail(formData.email);
        if (emailError) {
            showError('email', emailError);
            isValid = false;
        }

        const contactError = validateContactNumber(formData.contactNumber);
        if (contactError) {
            showError('contactNumber', contactError);
            isValid = false;
        }

        const passwordError = validatePassword(formData.password);
        if (passwordError) {
            showError('password', passwordError);
            isValid = false;
        }

        const confirmPasswordError = validateConfirmPassword(formData.password, formData.confirmPassword);
        if (confirmPasswordError) {
            showError('confirmPassword', confirmPasswordError);
            isValid = false;
        }

        const termsError = validateTerms(formData.agreeTerms);
        if (termsError) {
            showError('agreeTerms', termsError);
            isValid = false;
        }

        if (!isValid) {
            console.log('Form validation failed');
            return;
        }

        // Set loading state
        setLoading(true);
        console.log('Sending registration request...');

        try {
            // Prepare data for API
            const userData = {
                firstName: formData.firstName,
                lastName: formData.lastName,
                email: formData.email,
                contactNumber: formData.contactNumber,
                password: formData.password
            };

            console.log('Sending user data:', userData);

            const response = await fetch('/api/users', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(userData)
            });

            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers);

            // First get the response as text
            const responseText = await response.text();
            console.log('Raw response text:', responseText);

            if (response.ok) {
                console.log('Registration successful');

                try {
                    // Try to parse as JSON
                    const user = JSON.parse(responseText);
                    console.log('Parsed user data:', user);

                    showMessage('Account created successfully! Redirecting to login...', true);

                    // Clear form
                    registerForm.reset();

                    // Clear all field states
                    ['firstName', 'lastName', 'email', 'contactNumber', 'password', 'confirmPassword'].forEach(field => {
                        clearFieldState(field);
                    });

                    // Redirect to login page after success
                    setTimeout(() => {
                        window.location.href = '/login';
                    }, 2000);

                } catch (parseError) {
                    console.error('JSON parse error:', parseError);
                    // If it's not JSON, maybe it's a plain text success message
                    showMessage('Account created successfully! Redirecting to login...', true);

                    registerForm.reset();
                    setTimeout(() => {
                        window.location.href = '/login';
                    }, 2000);
                }

            } else {
                console.log('Registration failed with status:', response.status);

                // Handle different error responses
                if (response.status === 409) {
                    console.log('Duplicate email error');
                    showError('email', 'An account with this email already exists. Please use a different email.');
                    emailInput.focus();
                } else if (response.status === 400) {
                    console.log('Bad request error');
                    showMessage('Invalid data provided. Please check your input and try again.');
                } else if (response.status === 500) {
                    console.log('Server error:', responseText);
                    // Check if it's a duplicate email error from SQL exception
                    if (responseText.includes('Duplicate entry') ||
                        responseText.includes('movie_users.UK') ||
                        responseText.includes('email already exists')) {
                        showError('email', 'An account with this email already exists. Please use a different email.');
                        emailInput.focus();
                    } else {
                        showMessage('Server error. Please try again later.');
                    }
                } else {
                    console.log('Other error:', responseText);
                    showMessage(responseText || 'Registration failed. Please try again.');
                }
            }

        } catch (error) {
            console.error('Registration network error:', error);
            console.error('Error details:', error.name, error.message);

            if (error.name === 'TypeError' && error.message.includes('fetch')) {
                showMessage('Network error. Please check your connection and try again.');
            } else {
                showMessage('An unexpected error occurred. Please try again.');
            }
        } finally {
            setLoading(false);
            console.log('Registration process completed');
        }
    });registerForm.addEventListener('submit', async function(e) {
        e.preventDefault();
        console.log('=== FORM SUBMISSION STARTED ===');

        // Clear previous messages and errors
        hideMessage();
        ['firstName', 'lastName', 'email', 'contactNumber', 'password', 'confirmPassword', 'agreeTerms'].forEach(field => {
            const errorElement = document.getElementById(field + 'Error');
            if (errorElement) errorElement.classList.add('hidden');
        });

        // Get form data
        const formData = {
            firstName: firstNameInput.value.trim(),
            lastName: lastNameInput.value.trim(),
            email: emailInput.value.trim(),
            contactNumber: contactNumberInput.value.trim(),
            password: passwordInput.value,
            confirmPassword: confirmPasswordInput.value,
            agreeTerms: agreeTermsCheckbox.checked
        };

        console.log('Form data collected:', formData);

        // Basic validation
        if (!formData.agreeTerms) {
            showError('agreeTerms', 'You must agree to the terms and conditions');
            return;
        }

        if (formData.password !== formData.confirmPassword) {
            showError('confirmPassword', 'Passwords do not match');
            return;
        }

        // Set loading state
        setLoading(true);
        console.log('Sending request to server...');

        try {
            // Prepare API data (remove confirmPassword as it's not needed by backend)
            const apiData = {
                firstName: formData.firstName,
                lastName: formData.lastName,
                email: formData.email,
                contactNumber: formData.contactNumber,
                password: formData.password
            };

            console.log('Sending to API:', apiData);

            const response = await fetch('/api/users', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(apiData)
            });

            console.log('Response received. Status:', response.status);

            // Get response as text first
            const responseText = await response.text();
            console.log('Raw response:', responseText);

            if (response.ok) {
                console.log('Registration successful!');

                // Show success message
                registerMessage.textContent = 'Account created successfully! Redirecting to login...';
                registerMessage.className = 'mt-4 p-3 rounded-lg text-center bg-green-600/20 text-green-400';
                registerMessage.classList.remove('hidden');

                // Clear form
                registerForm.reset();

                // Redirect to login
                setTimeout(() => {
                    window.location.href = '/login?message=registration_success';
                }, 2000);

            } else {
                console.log('Registration failed. Status:', response.status);

                // Handle specific error cases
                if (response.status === 409) {
                    showError('email', 'This email is already registered. Please use a different email.');
                    emailInput.focus();
                } else if (response.status === 400) {
                    registerMessage.textContent = 'Invalid data. Please check your information and try again.';
                    registerMessage.className = 'mt-4 p-3 rounded-lg text-center bg-red-600/20 text-red-400';
                    registerMessage.classList.remove('hidden');
                } else {
                    registerMessage.textContent = responseText || 'Registration failed. Please try again.';
                    registerMessage.className = 'mt-4 p-3 rounded-lg text-center bg-red-600/20 text-red-400';
                    registerMessage.classList.remove('hidden');
                }
            }

        } catch (error) {
            console.error('Network error:', error);
            registerMessage.textContent = 'Network error. Please check your connection and try again.';
            registerMessage.className = 'mt-4 p-3 rounded-lg text-center bg-red-600/20 text-red-400';
            registerMessage.classList.remove('hidden');
        } finally {
            setLoading(false);
            console.log('=== FORM SUBMISSION COMPLETED ===');
        }
    });

// Simplified showError function
    function showError(fieldId, message) {
        const errorElement = document.getElementById(fieldId + 'Error');
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.classList.remove('hidden');
        }
    }

// Simplified hideMessage function
    function hideMessage() {
        registerMessage.classList.add('hidden');
    }
});