document.addEventListener('DOMContentLoaded', function() {
    // Get user data from localStorage
    let userId = localStorage.getItem("movieUserId");
    if (!userId) {
        try {
            const storedUser = localStorage.getItem('user');
            if (storedUser) {
                const parsed = JSON.parse(storedUser);
                if (parsed && parsed.id) {
                    userId = String(parsed.id);
                    localStorage.setItem('movieUserId', userId);
                }
                if (parsed && parsed.email && !localStorage.getItem('email')) {
                    localStorage.setItem('email', parsed.email);
                }
            }
        } catch (e) {
            // ignore JSON parse issues
        }
    }

    // DOM elements
    const profileForm = document.getElementById('profileForm');
    const firstNameInput = document.getElementById('firstName');
    const lastNameInput = document.getElementById('lastName');
    const emailInput = document.getElementById('email');
    const contactNumberInput = document.getElementById('contactNumber');
    const changePasswordBtn = document.getElementById('changePasswordBtn');
    const newPasswordInput = document.getElementById('newPassword');
    const toggleNewPassword = document.getElementById('toggleNewPassword');

    const updateBtn = document.getElementById('updateBtn');
    const updateBtnText = document.getElementById('updateBtnText');
    const updateBtnLoading = document.getElementById('updateBtnLoading');

    const deleteBtn = document.getElementById('deleteBtn');
    const logoutBtn = document.getElementById('logoutBtn');

    const profileMessage = document.getElementById('profileMessage');
    const createdAt = document.getElementById('createdAt');
    const updatedAt = document.getElementById('updatedAt');

    // Modals
    const deleteModal = document.getElementById('deleteModal');
    const logoutModal = document.getElementById('logoutModal');
    const passwordModal = document.getElementById('passwordModal');
    const cancelDelete = document.getElementById('cancelDelete');
    const confirmDelete = document.getElementById('confirmDelete');
    const deleteConfirmText = document.getElementById('deleteConfirmText');
    const deleteConfirmLoading = document.getElementById('deleteConfirmLoading');
    const cancelLogout = document.getElementById('cancelLogout');
    const confirmLogout = document.getElementById('confirmLogout');

    // Password modal elements
    const passwordConfirmForm = document.getElementById('passwordConfirmForm');
    const currentPasswordInput = document.getElementById('currentPassword');
    const confirmNewPasswordInput = document.getElementById('confirmNewPassword');
    const toggleCurrentPassword = document.getElementById('toggleCurrentPassword');
    const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');
    const cancelPassword = document.getElementById('cancelPassword');
    const confirmPassword = document.getElementById('confirmPassword');
    const confirmPasswordText = document.getElementById('confirmPasswordText');
    const confirmPasswordLoading = document.getElementById('confirmPasswordLoading');
    const passwordModalMessage = document.getElementById('passwordModalMessage');

    // Check if user is logged in
    if (!userId) {
        window.location.href = '/login';
        return;
    }

    // Check if all required DOM elements exist
    if (!profileForm || !changePasswordBtn || !deleteBtn || !logoutBtn ||
        !deleteModal || !logoutModal || !passwordModal || !profileMessage) {
        console.error('Required DOM elements not found');
        return;
    }

    // Load user profile data
    loadUserProfile();

    // Change Password Button
    changePasswordBtn.addEventListener('click', function() {
        showPasswordModal();
    });

    // Toggle current password visibility in modal
    if (toggleCurrentPassword) {
        toggleCurrentPassword.addEventListener('click', function() {
            const type = currentPasswordInput.type === 'password' ? 'text' : 'password';
            currentPasswordInput.type = type;
            this.innerHTML = type === 'password' ? '<i class="fas fa-eye"></i>' : '<i class="fas fa-eye-slash"></i>';
        });
    }

    // Toggle new password visibility in modal
    if (toggleNewPassword) {
        toggleNewPassword.addEventListener('click', function() {
            const type = newPasswordInput.type === 'password' ? 'text' : 'password';
            newPasswordInput.type = type;
            this.innerHTML = type === 'password' ? '<i class="fas fa-eye"></i>' : '<i class="fas fa-eye-slash"></i>';
        });
    }

    // Toggle confirm password visibility in modal
    if (toggleConfirmPassword) {
        toggleConfirmPassword.addEventListener('click', function() {
            const type = confirmNewPasswordInput.type === 'password' ? 'text' : 'password';
            confirmNewPasswordInput.type = type;
            this.innerHTML = type === 'password' ? '<i class="fas fa-eye"></i>' : '<i class="fas fa-eye-slash"></i>';
        });
    }

    // Profile form submission
    profileForm.addEventListener('submit', function(e) {
        e.preventDefault();
        // Update profile without password change
        updateProfile();
    });

    // Password modal event listeners
    if (cancelPassword) {
        cancelPassword.addEventListener('click', function() {
            hidePasswordModal();
        });
    }

    if (passwordConfirmForm) {
        passwordConfirmForm.addEventListener('submit', function(e) {
            e.preventDefault();
            confirmPasswordChange();
        });
    }

    // Delete account button
    deleteBtn.addEventListener('click', function() {
        deleteModal.classList.remove('hidden');
        deleteModal.classList.add('flex');
    });

    // Logout button
    logoutBtn.addEventListener('click', function() {
        logoutModal.classList.remove('hidden');
        logoutModal.classList.add('flex');
    });

    // Cancel delete
    cancelDelete.addEventListener('click', function() {
        deleteModal.classList.add('hidden');
        deleteModal.classList.remove('flex');
    });

    // Confirm delete
    confirmDelete.addEventListener('click', function() {
        deleteAccount();
    });

    // Cancel logout
    cancelLogout.addEventListener('click', function() {
        logoutModal.classList.add('hidden');
        logoutModal.classList.remove('flex');
    });

    // Confirm logout
    confirmLogout.addEventListener('click', function() {
        logout();
    });

    // Load user profile
    async function loadUserProfile() {
        try {
            const response = await fetch(`/api/users/${userId}`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (response.ok) {
                const user = await response.json();
                populateForm(user);
            } else {
                // Fallback: try fetch by email from localStorage
                const email = localStorage.getItem('email') || localStorage.getItem('movieUserEmail');
                if (email) {
                    const res2 = await fetch(`/api/users/email/${encodeURIComponent(email)}`);
                    if (res2.ok) {
                        const user2 = await res2.json();
                        // persist canonical ID
                        if (user2 && user2.id) {
                            localStorage.setItem('movieUserId', user2.id);
                        }
                        populateForm(user2);
                        return;
                    }
                }
                showMessage('Failed to load profile data', 'error');
                if (response.status === 401) logout();
            }
        } catch (error) {
            showMessage('Error loading profile: ' + error.message, 'error');
        }
    }

    // Populate form with user data
    function populateForm(user) {
        firstNameInput.value = user.firstName || '';
        lastNameInput.value = user.lastName || '';
        emailInput.value = user.email || '';
        contactNumberInput.value = user.contactNumber || '';

        if (user.createdAt) {
            createdAt.textContent = new Date(user.createdAt).toLocaleDateString();
        }
        if (user.updatedAt) {
            updatedAt.textContent = new Date(user.updatedAt).toLocaleDateString();
        }
    }

    // Update profile
    async function updateProfile() {
        if (!validateForm()) return;

        setUpdateLoading(true);
        clearMessages();

        const updateData = {
            firstName: firstNameInput.value.trim(),
            lastName: lastNameInput.value.trim(),
            contactNumber: contactNumberInput.value.trim()
        };

        try {
            const response = await fetch(`/api/users/${userId}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(updateData)
            });

            if (response.ok) {
                const updatedUser = await response.json();

                // Update localStorage
                localStorage.setItem('movieUserFirstName', updatedUser.firstName);
                localStorage.setItem('movieUserLastName', updatedUser.lastName);
                localStorage.setItem('movieUserEmail', updatedUser.email);
                localStorage.setItem('movieUserContactNumber', updatedUser.contactNumber);

                showMessage('Profile updated successfully!', 'success');
                loadUserProfile(); // Reload to get updated timestamps
            } else {
                const errorText = await response.text();
                showMessage(errorText || 'Failed to update profile', 'error');
            }
        } catch (error) {
            showMessage('Error updating profile: ' + error.message, 'error');
        } finally {
            setUpdateLoading(false);
        }
    }

    // Show password confirmation modal
    function showPasswordModal() {
        passwordModal.classList.remove('hidden');
        passwordModal.classList.add('flex');
        clearPasswordModalMessages();
        clearPasswordModalFields();
    }

    // Hide password confirmation modal
    function hidePasswordModal() {
        passwordModal.classList.add('hidden');
        passwordModal.classList.remove('flex');
        clearPasswordModalFields();
        clearPasswordModalMessages();
    }

    // Clear password modal fields
    function clearPasswordModalFields() {
        currentPasswordInput.value = '';
        newPasswordInput.value = '';
        confirmNewPasswordInput.value = '';
    }

    // Clear password modal messages
    function clearPasswordModalMessages() {
        passwordModalMessage.classList.add('hidden');
        document.getElementById('currentPasswordError').classList.add('hidden');
        document.getElementById('newPasswordError').classList.add('hidden');
        document.getElementById('confirmPasswordError').classList.add('hidden');
    }

    // Confirm password change
    async function confirmPasswordChange() {
        if (!validatePasswordModal()) return;

        setPasswordModalLoading(true);
        clearPasswordModalMessages();

        const updateData = {
            currentPassword: currentPasswordInput.value.trim(),
            newPassword: newPasswordInput.value.trim()
        };

        try {
            const response = await fetch(`/api/users/${userId}/password`, {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(updateData)
            });

            if (response.ok) {
                showPasswordModalMessage('Password changed successfully!', 'success');
                
                // Hide modal after success
                setTimeout(() => {
                    hidePasswordModal();
                    showMessage('Password changed successfully!', 'success');
                }, 1500);
            } else {
                const errorData = await response.json();
                if (errorData.error === 'INVALID_CURRENT_PASSWORD') {
                    showPasswordModalMessage('Incorrect current password', 'error');
                } else if (errorData.error === 'CURRENT_PASSWORD_REQUIRED') {
                    showPasswordModalMessage('Current password is required', 'error');
                } else {
                    showPasswordModalMessage(errorData.message || 'Failed to update password', 'error');
                }
            }
        } catch (error) {
            showPasswordModalMessage('Error updating password: ' + error.message, 'error');
        } finally {
            setPasswordModalLoading(false);
        }
    }

    // Validate password modal
    function validatePasswordModal() {
        let isValid = true;
        clearPasswordModalMessages();

        // Validate current password
        if (!currentPasswordInput.value.trim()) {
            showPasswordModalFieldError('currentPasswordError', 'Current password is required');
            isValid = false;
        }

        // Validate new password
        if (!newPasswordInput.value.trim()) {
            showPasswordModalFieldError('newPasswordError', 'New password is required');
            isValid = false;
        } else {
            const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
            if (!passwordPattern.test(newPasswordInput.value)) {
                showPasswordModalFieldError('newPasswordError', 'Password must be at least 8 characters with uppercase, lowercase, number, and special character');
                isValid = false;
            }
        }

        // Validate new password confirmation
        if (!confirmNewPasswordInput.value.trim()) {
            showPasswordModalFieldError('confirmPasswordError', 'Please confirm your new password');
            isValid = false;
        } else if (confirmNewPasswordInput.value.trim() !== newPasswordInput.value.trim()) {
            showPasswordModalFieldError('confirmPasswordError', 'Passwords do not match');
            isValid = false;
        }

        return isValid;
    }

    // Show password modal field error
    function showPasswordModalFieldError(errorId, message) {
        const errorElement = document.getElementById(errorId);
        errorElement.textContent = message;
        errorElement.classList.remove('hidden');
    }

    // Show password modal message
    function showPasswordModalMessage(message, type) {
        passwordModalMessage.textContent = message;
        passwordModalMessage.className = `mb-4 p-3 rounded-lg text-center ${
            type === 'success' ? 'bg-green-600/20 text-green-400 border border-green-600/30' :
                'bg-red-600/20 text-red-400 border border-red-600/30'
        }`;
        passwordModalMessage.classList.remove('hidden');
    }

    // Set password modal loading state
    function setPasswordModalLoading(loading) {
        confirmPassword.disabled = loading;
        if (loading) {
            confirmPasswordText.classList.add('hidden');
            confirmPasswordLoading.classList.remove('hidden');
        } else {
            confirmPasswordText.classList.remove('hidden');
            confirmPasswordLoading.classList.add('hidden');
        }
    }

    // Delete account
    async function deleteAccount() {
        setDeleteLoading(true);

        try {
            const response = await fetch(`/api/users/${userId}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (response.ok) {
                localStorage.clear();
                alert('Account deleted successfully');
                window.location.href = '/';
            } else {
                const errorText = await response.text();
                showMessage(errorText || 'Failed to delete account', 'error');
                hideDeleteModal();
            }
        } catch (error) {
            showMessage('Error deleting account: ' + error.message, 'error');
            hideDeleteModal();
        } finally {
            setDeleteLoading(false);
        }
    }

    // Logout
    function logout() {
        localStorage.clear();
        window.location.href = '/';
    }

    // Form validation
    function validateForm() {
        let isValid = true;
        clearFieldErrors();

        // Validate first name
        if (!firstNameInput.value.trim()) {
            showFieldError('firstNameError', 'First name is required');
            firstNameInput.classList.add('field-invalid');
            isValid = false;
        } else {
            firstNameInput.classList.add('field-valid');
        }

        // Validate last name
        if (!lastNameInput.value.trim()) {
            showFieldError('lastNameError', 'Last name is required');
            lastNameInput.classList.add('field-invalid');
            isValid = false;
        } else {
            lastNameInput.classList.add('field-valid');
        }

        // Validate contact number
        const contactPattern = /^[\d\-\+\(\)\s]+$/;
        if (!contactNumberInput.value.trim()) {
            showFieldError('contactNumberError', 'Contact number is required');
            contactNumberInput.classList.add('field-invalid');
            isValid = false;
        } else if (!contactPattern.test(contactNumberInput.value.trim())) {
            showFieldError('contactNumberError', 'Please enter a valid contact number');
            contactNumberInput.classList.add('field-invalid');
            isValid = false;
        } else {
            contactNumberInput.classList.add('field-valid');
        }

        // Password validation is now handled in the modal

        return isValid;
    }

    // Show field error
    function showFieldError(errorId, message) {
        const errorElement = document.getElementById(errorId);
        errorElement.textContent = message;
        errorElement.classList.remove('hidden');
    }

    // Clear field errors
    function clearFieldErrors() {
        const errorElements = document.querySelectorAll('.error-message');
        const inputElements = document.querySelectorAll('.form-field');

        errorElements.forEach(element => {
            element.textContent = '';
            element.classList.add('hidden');
        });

        inputElements.forEach(element => {
            element.classList.remove('field-valid', 'field-invalid');
        });
    }

    // Show message
    function showMessage(message, type) {
        profileMessage.textContent = message;
        profileMessage.className = `mt-4 p-3 rounded-lg text-center ${
            type === 'success' ? 'bg-green-600/20 text-green-400 border border-green-600/30' :
                'bg-red-600/20 text-red-400 border border-red-600/30'
        }`;
        profileMessage.classList.remove('hidden');

        setTimeout(() => {
            profileMessage.classList.add('hidden');
        }, 5000);
    }

    // Clear messages
    function clearMessages() {
        profileMessage.classList.add('hidden');
    }

    // Set update loading state
    function setUpdateLoading(loading) {
        updateBtn.disabled = loading;
        if (loading) {
            updateBtnText.classList.add('hidden');
            updateBtnLoading.classList.remove('hidden');
        } else {
            updateBtnText.classList.remove('hidden');
            updateBtnLoading.classList.add('hidden');
        }
    }

    // Set delete loading state
    function setDeleteLoading(loading) {
        confirmDelete.disabled = loading;
        if (loading) {
            deleteConfirmText.classList.add('hidden');
            deleteConfirmLoading.classList.remove('hidden');
        } else {
            deleteConfirmText.classList.remove('hidden');
            deleteConfirmLoading.classList.add('hidden');
        }
    }

    // Hide delete modal
    function hideDeleteModal() {
        deleteModal.classList.add('hidden');
        deleteModal.classList.remove('flex');
    }
});