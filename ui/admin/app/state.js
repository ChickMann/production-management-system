// Namespace dùng chung cho toàn bộ admin UI.
// Mục tiêu: mọi file con trong thư mục `app/` đều đọc/ghi qua object này.
window.PMS_ADMIN = window.PMS_ADMIN || {};

// Các key lưu ở localStorage.
// Đây là dữ liệu UI phía frontend, chưa phải dữ liệu thật từ backend.
window.PMS_ADMIN.STORAGE_KEYS = {
  tab: 'pms-admin-active-tab',
  theme: 'pms-theme',
  language: 'pms-language',
};

// Gom toàn bộ DOM reference ở một nơi để các file khác không phải query lặp lại.
// Đây là các phần tử thật đang có trong [`ui/admin/index.html`](ui/admin/index.html).
window.PMS_ADMIN.dom = {
  contentArea: document.getElementById('contentArea'),
  pageTitle: document.getElementById('pageTitle'),
  pageSubtitle: document.getElementById('pageSubtitle'),
  menuToggle: document.getElementById('menuToggle'),
  sidebar: document.getElementById('sidebar'),
  sidebarOverlay: document.getElementById('sidebarOverlay'),
  layoutShell: document.getElementById('layoutShell'),
  userName: document.getElementById('userName'),
  headerUser: document.getElementById('headerUser'),
  notifBadge: document.getElementById('notifBadge'),
  searchBox: document.getElementById('searchBox'),
  searchInput: document.getElementById('searchInput'),
  sidebarNav: document.querySelector('nav[role="tablist"]'),
};

// State runtime của admin UI.
// Lưu ý:
// - `currentTheme`, `currentLanguage`: lấy từ localStorage để giữ lựa chọn người dùng.
// - `activeTab`, `activeScreen`: chỉ là state điều hướng phía frontend.
// - `user`: đang là dữ liệu demo/mock, về sau cần gắn từ session hoặc backend thật.
window.PMS_ADMIN.state = {
  currentTheme: localStorage.getItem(window.PMS_ADMIN.STORAGE_KEYS.theme) || 'light',
  currentLanguage: localStorage.getItem(window.PMS_ADMIN.STORAGE_KEYS.language) || 'en',
  app: {
    user: {
      name: 'PMS Admin',
      role: 'admin',
    },
    activeTab: localStorage.getItem(window.PMS_ADMIN.STORAGE_KEYS.tab) || 'dashboard',
    activeScreen: 'main',
  },
};
