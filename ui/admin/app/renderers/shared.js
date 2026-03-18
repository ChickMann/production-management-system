// File này chứa các hàm render/helper dùng chung cho nhiều renderer.
// Mục tiêu: tránh lặp lại các đoạn xử lý HTML ở dashboard, module và sidebar.
window.PMS_ADMIN = window.PMS_ADMIN || {};

// Escape text trước khi đưa vào HTML để tránh lỗi hiển thị và giảm rủi ro chèn markup ngoài ý muốn.
window.PMS_ADMIN.escapeHtml = function escapeHtml(value) {
  return String(value ?? '').replace(/[&<>"']/g, (char) => {
    const map = {
      '&': '&amp;',
      '<': '&lt;',
      '>': '&gt;',
      '"': '&quot;',
      "'": '&#039;',
    };
    return map[char];
  });
};

// Toast notification system
// Hiển thị thông báo popup ngắn gọn
window.PMS_ADMIN.showToast = function showToast(message, type = 'info', duration = 3000) {
  const toastContainer = document.getElementById('toastContainer');
  if (!toastContainer) return;

  const toast = document.createElement('div');
  const escapeHtml = window.PMS_ADMIN.escapeHtml;

  const icons = {
    success: '<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" /></svg>',
    error: '<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" /></svg>',
    warning: '<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" /></svg>',
    info: '<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>',
  };

  const colors = {
    success: 'bg-emerald-50 border-emerald-200 text-emerald-800',
    error: 'bg-rose-50 border-rose-200 text-rose-800',
    warning: 'bg-amber-50 border-amber-200 text-amber-800',
    info: 'bg-blue-50 border-blue-200 text-blue-800',
  };

  toast.className = `flex items-center gap-3 px-4 py-3 rounded-xl border shadow-lg transform transition-all duration-300 ${colors[type]} ${colors[type]}`;
  toast.innerHTML = `
    <span class="flex-shrink-0">${icons[type]}</span>
    <span class="text-sm font-medium">${escapeHtml(message)}</span>
    <button onclick="this.parentElement.remove()" class="ml-auto flex-shrink-0 opacity-60 hover:opacity-100 transition-opacity">
      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
      </svg>
    </button>
  `;

  toastContainer.appendChild(toast);

  // Auto remove
  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateX(100%)';
    setTimeout(() => toast.remove(), 300);
  }, duration);
};

// Render card số liệu ngắn.
// Hiện đang dùng chủ yếu ở dashboard với dữ liệu demo/mock.
window.PMS_ADMIN.renderMetricCard = function renderMetricCard(title, value, note) {
  const escapeHtml = window.PMS_ADMIN.escapeHtml;

  return `
    <div class="rounded-2xl bg-white p-5 shadow-sm hover:shadow-md transition-shadow duration-200">
      <p class="text-xs uppercase tracking-wide text-slate-400">${escapeHtml(title)}</p>
      <p class="mt-3 break-words text-2xl font-semibold text-slate-800">${escapeHtml(value)}</p>
      <p class="mt-2 text-xs text-slate-500">${escapeHtml(note)}</p>
    </div>
  `;
};

// Render dòng thông tin key-value.
// Thường dùng cho phần mô tả kỹ thuật/tóm tắt module.
window.PMS_ADMIN.renderInfoRow = function renderInfoRow(label, value) {
  const escapeHtml = window.PMS_ADMIN.escapeHtml;

  return `
    <div class="flex items-center justify-between gap-4 rounded-xl border border-slate-100 px-4 py-3">
      <span class="text-sm text-slate-500">${escapeHtml(label)}</span>
      <span class="text-sm font-semibold text-slate-700 text-right">${escapeHtml(value)}</span>
    </div>
  `;
};
