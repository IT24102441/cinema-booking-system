const API_URL = '/api/admins';
let admins = [];

async function loadAdmins() {
    try {
        const res = await fetch(API_URL);
        admins = await res.json();
        renderTable(admins);
    } catch (e) {
        alert('Failed to load admins');
    }
}

function renderTable(data) {
    const tbody = document.getElementById('adminTableBody');
    const noResults = document.getElementById('noResults');
    if (!data.length) {
        tbody.innerHTML = '';
        noResults.classList.remove('hidden');
        return;
    }
    noResults.classList.add('hidden');
    tbody.innerHTML = data.map(a => `
        <tr class="hover:bg-gray-800/30 transition-colors">
            <td class="px-6 py-4">${a.id}</td>
            <td class="px-6 py-4">${a.name}</td>
            <td class="px-6 py-4">${a.email}</td>
            <td class="px-6 py-4">${a.role}</td>
            <td class="px-6 py-4 text-gray-400">${a.description||'—'}</td>
            <td class="px-6 py-4 text-right">
                <button onclick="editAdmin(${a.id})" class="text-blue-400 hover:text-blue-300 mr-3"><i class="fas fa-edit"></i></button>
                <button onclick="deleteAdmin(${a.id})" class="text-red-400 hover:text-red-300"><i class="fas fa-trash"></i></button>
            </td>
        </tr>
    `).join('');
}

document.getElementById('searchInput').addEventListener('input', e => {
    const q = e.target.value.toLowerCase();
    const filtered = admins.filter(a =>
        a.name.toLowerCase().includes(q) ||
        a.email.toLowerCase().includes(q) ||
        a.role.toLowerCase().includes(q)
    );
    renderTable(filtered);
});

function validateName(v) { return /^[A-Za-z\s]{2,}$/.test(v); }
function validateEmail(v) { return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v); }
function validatePassword(v) { return v.length >= 6; }

function openCreateModal() {
    document.getElementById('modalTitle').textContent = 'Create Admin';
    document.getElementById('adminForm').reset();
    document.getElementById('adminId').value = '';
    document.getElementById('password').required = true;
    document.getElementById('adminModal').classList.remove('hidden');
}

function closeModal() {
    document.getElementById('adminModal').classList.add('hidden');
}

async function editAdmin(id) {
    const a = admins.find(x => x.id === id);
    if (!a) return;
    document.getElementById('modalTitle').textContent = 'Edit Admin';
    document.getElementById('adminId').value = a.id;
    document.getElementById('name').value = a.name;
    document.getElementById('email').value = a.email;
    document.getElementById('role').value = a.role;
    document.getElementById('description').value = a.description||'';
    document.getElementById('password').required = false;
    document.getElementById('adminModal').classList.remove('hidden');
}

async function handleSubmit(e) {
    e.preventDefault();
    const id = document.getElementById('adminId').value;
    const name = document.getElementById('name').value.trim();
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value;
    const role = document.getElementById('role').value;
    const description = document.getElementById('description').value.trim();

    // Validation
    let ok = true;
    if (!validateName(name)) { document.getElementById('nameError').classList.remove('hidden'); ok=false; } else document.getElementById('nameError').classList.add('hidden');
    if (!validateEmail(email)) { document.getElementById('emailError').classList.remove('hidden'); ok=false; } else document.getElementById('emailError').classList.add('hidden');
    if ((id==='' && !validatePassword(password)) || (id!=='' && password && !validatePassword(password))) { document.getElementById('passwordError').classList.remove('hidden'); ok=false; } else document.getElementById('passwordError').classList.add('hidden');
    if (!ok) return;

    const payload = { name, email, role, description };
    if (password) payload.password = password;

    try {
        const isCreate = id==='';
        const res = await fetch(isCreate?API_URL:`${API_URL}/${id}`, {
            method: isCreate?'POST':'PUT',
            headers: { 'Content-Type':'application/json' },
            body: JSON.stringify(payload)
        });
        if (!res.ok) throw new Error((await res.text()));
        closeModal();
        loadAdmins();
    } catch (e) {
        alert(e.message);
    }
}

async function deleteAdmin(id) {
    if (!confirm('Delete this admin?')) return;
    try {
        const res = await fetch(`${API_URL}/${id}`, { method:'DELETE' });
        if (!res.ok) throw new Error((await res.text()));
        loadAdmins();
    } catch (e) {
        alert(e.message);
    }
}

function logout() {
    localStorage.clear();
    location.href = '/';
}

loadAdmins();