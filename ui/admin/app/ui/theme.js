// File này xử lý các hành vi giao diện mang tính toàn cục:
// - mở / đóng sidebar
// - đổi theme sáng / tối
// - đổi ngôn ngữ en / vi
// Các phần này là logic UI phía frontend, chưa liên quan tới dữ liệu backend thật.
window.PMS_ADMIN = window.PMS_ADMIN || {};

// Đóng sidebar.
// Trên desktop: thu gọn sidebar bằng class layout.
// Trên mobile: ẩn sidebar trượt và hiện overlay phù hợp.
window.PMS_ADMIN.closeSidebar = function closeSidebar() {
  const { dom } = window.PMS_ADMIN;

  if (window.innerWidth >= 1024) {
    dom.sidebar.dataset.collapsed = 'true';
    dom.sidebar.classList.add('lg:w-0', 'lg:min-w-0', 'lg:overflow-hidden', 'lg:border-r-0');
    dom.sidebar.classList.remove('w-72');
    if (dom.layoutShell) {
      dom.layoutShell.classList.remove('lg:grid-cols-[280px_1fr]');
      dom.layoutShell.classList.add('lg:grid-cols-[0px_1fr]');
    }
    return;
  }

  dom.sidebar.classList.add('-translate-x-full');
  dom.sidebarOverlay?.classList.add('hidden');
};

// Mở lại sidebar.
// Hành vi khác nhau giữa desktop và mobile để giữ layout cũ ổn định.
window.PMS_ADMIN.openSidebar = function openSidebar() {
  const { dom } = window.PMS_ADMIN;

  if (window.innerWidth >= 1024) {
    dom.sidebar.dataset.collapsed = 'false';
    dom.sidebar.classList.remove('lg:w-0', 'lg:min-w-0', 'lg:overflow-hidden', 'lg:border-r-0');
    dom.sidebar.classList.add('w-72');
    if (dom.layoutShell) {
      dom.layoutShell.classList.remove('lg:grid-cols-[0px_1fr]');
      dom.layoutShell.classList.add('lg:grid-cols-[280px_1fr]');
    }
    return;
  }

  dom.sidebar.classList.remove('-translate-x-full');
  dom.sidebarOverlay?.classList.remove('hidden');
};

// Apply theme hiện tại lên toàn bộ trang.
// Giá trị theme lấy từ state/localStorage.
// Đây là theme demo ở mức UI, chưa đồng bộ với backend hay profile người dùng thật.
window.PMS_ADMIN.applyTheme = function applyTheme() {
  const themeButton = document.getElementById('themeToggle');
  const { state } = window.PMS_ADMIN;

  if (state.currentTheme === 'dark') {
    document.documentElement.classList.add('dark');
    if (themeButton) {
      themeButton.textContent = '☀️';
    }
  } else {
    document.documentElement.classList.remove('dark');
    if (themeButton) {
      themeButton.textContent = '☼';
    }
  }
};

// Đổi theme khi người dùng bấm nút toggle.
// Sau khi đổi sẽ lưu lại vào localStorage.
window.PMS_ADMIN.handleThemeToggle = function handleThemeToggle() {
  const { state, storage } = window.PMS_ADMIN;
  state.currentTheme = state.currentTheme === 'light' ? 'dark' : 'light';
  storage.setTheme(state.currentTheme);
  window.PMS_ADMIN.applyTheme();
};

// Apply ngôn ngữ hiện tại lên giao diện.
// Phần này chỉ đổi text phía frontend như placeholder, tiêu đề, tab.
// Dữ liệu record trong bảng hiện vẫn là dữ liệu demo/mock.
window.PMS_ADMIN.applyLanguage = function applyLanguage() {
  const languageButton = document.getElementById('languageToggle');
  const { dom, state, storage, t } = window.PMS_ADMIN;

  document.documentElement.lang = state.currentLanguage;
  storage.setLanguage(state.currentLanguage);

  if (dom.searchInput) {
    dom.searchInput.placeholder = t('searchPlaceholder');
  }

  if (languageButton) {
    languageButton.textContent = state.currentLanguage === 'vi' ? '🇬🇧' : '🇻🇳';
    languageButton.title = state.currentLanguage === 'vi' ? 'Switch to English' : 'Chuyển sang tiếng Việt';
  }

  const welcomeNode = document.querySelector('header .text-xs.text-slate-500');
  if (welcomeNode) {
    welcomeNode.textContent = t('welcome');
  }

  window.PMS_ADMIN.buildSidebar(dom.searchInput?.value || '');
  window.PMS_ADMIN.setActiveTab(state.app.activeTab);
};

// Đổi ngôn ngữ giữa `en` và `vi` khi người dùng bấm nút.
window.PMS_ADMIN.handleLanguageToggle = function handleLanguageToggle() {
  const { state } = window.PMS_ADMIN;
  state.currentLanguage = state.currentLanguage === 'vi' ? 'en' : 'vi';
  window.PMS_ADMIN.applyLanguage();
};
