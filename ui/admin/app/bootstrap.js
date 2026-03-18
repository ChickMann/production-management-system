// File khởi động admin UI.
// File này chỉ lo việc nối các phần đã tách nhỏ lại với nhau và chạy app lần đầu.
window.PMS_ADMIN = window.PMS_ADMIN || {};

// Gắn các sự kiện toàn cục cho giao diện.
// Bao gồm: mở/đóng sidebar, đổi theme, đổi ngôn ngữ, tìm kiếm sidebar.
// Đây là logic UI phía frontend, chưa liên quan tới gọi backend.
window.PMS_ADMIN.bindGlobalEvents = function bindGlobalEvents() {
  const { dom } = window.PMS_ADMIN;

  if (dom.menuToggle) {
    dom.menuToggle.addEventListener('click', () => {
      if (window.innerWidth >= 1024) {
        if (dom.sidebar.dataset.collapsed === 'true') {
          window.PMS_ADMIN.openSidebar();
        } else {
          window.PMS_ADMIN.closeSidebar();
        }
        return;
      }

      if (dom.sidebar.classList.contains('-translate-x-full')) {
        window.PMS_ADMIN.openSidebar();
      } else {
        window.PMS_ADMIN.closeSidebar();
      }
    });
  }

  dom.sidebarOverlay?.addEventListener('click', window.PMS_ADMIN.closeSidebar);

  const themeButton = document.getElementById('themeToggle');
  themeButton?.addEventListener('click', window.PMS_ADMIN.handleThemeToggle);

  const languageButton = document.getElementById('languageToggle');
  languageButton?.addEventListener('click', window.PMS_ADMIN.handleLanguageToggle);

  dom.searchInput?.addEventListener('input', (event) => {
    window.PMS_ADMIN.buildSidebar(event.target.value);
  });
};

// Hàm khởi động chính của admin UI.
// Thứ tự chạy:
// 1. nạp thông tin user demo
// 2. dựng sidebar
// 3. apply theme/language từ localStorage
// 4. gắn event
// 5. render tab hiện tại
window.PMS_ADMIN.bootstrap = function bootstrap() {
  const { dom } = window.PMS_ADMIN;

  window.PMS_ADMIN.initUser();
  window.PMS_ADMIN.buildSidebar();
  window.PMS_ADMIN.applyTheme();
  window.PMS_ADMIN.applyLanguage();
  window.PMS_ADMIN.bindGlobalEvents();
  window.PMS_ADMIN.setActiveTab(window.PMS_ADMIN.state.app.activeTab);

  if (dom.searchBox) {
    dom.searchBox.classList.add('is-open');
  }
};

// Chạy app ngay sau khi toàn bộ script cần thiết đã được nạp xong.
window.PMS_ADMIN.bootstrap();
