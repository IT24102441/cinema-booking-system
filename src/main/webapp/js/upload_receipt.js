document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('upload-form');
  const fileInput = document.getElementById('receipt-file');
  const messageEl = document.getElementById('upload-message');
  const submitBtn = document.getElementById('upload-btn');

  // New UI hooks
  const dropzone = document.getElementById('dropzone');
  const previewWrap = document.getElementById('file-preview');
  const previewThumb = document.getElementById('preview-thumb');
  const previewName = document.getElementById('preview-name');
  const previewMeta = document.getElementById('preview-meta');
  const changeFileBtn = document.getElementById('change-file');
  const progressWrap = document.getElementById('progress-wrapper');
  const progressBar = document.getElementById('progress-bar');
  const progressText = document.getElementById('progress-text');

  let selectedFile = null;

  function showMessage(text, type = 'info') {
    messageEl.textContent = text;
    messageEl.className = `mt-4 text-sm ${type === 'error' ? 'text-red-400' : type === 'success' ? 'text-green-400' : 'text-gray-300'}`;
  }

  function bytesToSize(bytes) {
    if (bytes === 0) return '0 B';
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(1024));
    return (bytes / Math.pow(1024, i)).toFixed(2) + ' ' + sizes[i];
  }

  function isAllowedFile(file) {
    const allowed = ['image/jpeg', 'image/png', 'application/pdf'];
    const maxSize = 10 * 1024 * 1024; // 10MB
    if (!allowed.includes(file.type)) {
      showMessage('Invalid file type. Please upload JPG, PNG, or PDF.', 'error');
      return false;
    }
    if (file.size > maxSize) {
      showMessage('File too large. Maximum size is 10MB.', 'error');
      return false;
    }
    return true;
  }

  function updatePreview(file) {
    if (!file) return;
    previewWrap.classList.remove('hidden');
    previewName.textContent = file.name;
    previewMeta.textContent = `${file.type || 'unknown'} • ${bytesToSize(file.size)}`;

    // Reset thumb
    previewThumb.innerHTML = '<i class="far fa-file text-2xl text-gray-400"></i>';
    if (file.type.startsWith('image/')) {
      const img = document.createElement('img');
      img.src = URL.createObjectURL(file);
      img.alt = 'Preview';
      img.className = 'w-full h-full object-cover';
      previewThumb.innerHTML = '';
      previewThumb.appendChild(img);
    }
  }

  function setSelectedFile(file) {
    if (!isAllowedFile(file)) return;
    selectedFile = file;
    // Try to reflect into input (some browsers allow assigning FileList via DataTransfer)
    try {
      const dt = new DataTransfer();
      dt.items.add(file);
      fileInput.files = dt.files;
    } catch (e) {
      // ignore if not supported
    }
    updatePreview(file);
    showMessage('Ready to upload.', 'info');
  }

  // Dropzone interactions
  if (dropzone) {
    dropzone.addEventListener('click', () => fileInput.click());
    ['dragenter', 'dragover'].forEach(evt => {
      dropzone.addEventListener(evt, e => {
        e.preventDefault();
        e.stopPropagation();
        dropzone.classList.add('border-red-500');
      });
    });
    ;['dragleave', 'drop'].forEach(evt => {
      dropzone.addEventListener(evt, e => {
        e.preventDefault();
        e.stopPropagation();
        dropzone.classList.remove('border-red-500');
      });
    });
    dropzone.addEventListener('drop', e => {
      const files = e.dataTransfer.files;
      if (files && files[0]) {
        setSelectedFile(files[0]);
      }
    });
  }

  // Input change
  fileInput.addEventListener('change', () => {
    const f = fileInput.files && fileInput.files[0];
    if (f) setSelectedFile(f);
  });

  // Change file button
  if (changeFileBtn) changeFileBtn.addEventListener('click', () => fileInput.click());

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const bookingId = form.getAttribute('data-booking-id');
    if (!bookingId) {
      showMessage('Invalid booking id.', 'error');
      return;
    }
    const file = selectedFile || (fileInput.files && fileInput.files[0]);
    if (!file) {
      showMessage('Please choose a receipt file to upload.', 'error');
      return;
    }
    if (!isAllowedFile(file)) return;

    const fd = new FormData();
    fd.append('receipt', file);

    submitBtn.disabled = true;
    submitBtn.textContent = 'Uploading...';
    showMessage('Uploading receipt...', 'info');
    // Show progress UI
    if (progressWrap) progressWrap.classList.remove('hidden');
    if (progressBar) progressBar.style.width = '0%';
    if (progressText) progressText.textContent = '0%';

    try {
      // Use XHR to get upload progress
      await new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        xhr.open('POST', `/api/bookings/${bookingId}/receipt`);
        xhr.upload.onprogress = (evt) => {
          if (!evt.lengthComputable) return;
          const percent = Math.round((evt.loaded / evt.total) * 100);
          if (progressBar) progressBar.style.width = percent + '%';
          if (progressText) progressText.textContent = percent + '%';
        };
        xhr.onload = () => {
          if (xhr.status >= 200 && xhr.status < 300) {
            resolve();
          } else {
            reject(new Error(xhr.responseText || 'Upload failed'));
          }
        };
        xhr.onerror = () => reject(new Error('Network error during upload'));
        xhr.send(fd);
      });

      showMessage('Receipt uploaded successfully. We will verify it shortly.', 'success');
      submitBtn.textContent = 'Uploaded';
      // Redirect to My Bookings page
      setTimeout(() => {
        window.location.href = '/my-bookings';
      }, 800);
    } catch (err) {
      console.error('Upload error:', err);
      showMessage(err.message || 'Failed to upload receipt.', 'error');
      submitBtn.disabled = false;
      submitBtn.textContent = 'Upload Receipt';
    }
  });
});