// /js/admin_login.js

const API_URL = '/api/admins/login';

function validateEmail(v) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v);
}

function validatePassword(v) {
    return v.length >= 6;
}

document.getElementById('loginForm').addEventListener('submit', async (e) => {
    e.preventDefault();

    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value;

    let ok = true;

    // Email validation
    if (!validateEmail(email)) {
        document.getElementById('emailError').classList.remove('hidden');
        ok = false;
    } else {
        document.getElementById('emailError').classList.add('hidden');
    }

    // Password validation
    if (!validatePassword(password)) {
        document.getElementById('passwordError').classList.remove('hidden');
        ok = false;
    } else {
        document.getElementById('passwordError').classList.add('hidden');
    }

    if (!ok) return;

    try {
        const res = await fetch(API_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, password })
        });

        if (!res.ok) throw new Error(await res.text());

        const data = await res.json();

        window.location.replace('/admin-dashboard');
    } catch (e) {
        const err = document.getElementById('loginError');
        err.textContent = e.message.replace('Error: ', '');
        err.classList.remove('hidden');
    }
});