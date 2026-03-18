// File này bọc thao tác với localStorage.
// Mục đích: gom việc đọc/ghi tab, theme, language vào một nơi.
// Đây chỉ là lưu state UI phía frontend trên trình duyệt, không phải lưu backend/database.
window.PMS_ADMIN = window.PMS_ADMIN || {};

window.PMS_ADMIN.storage = {
  getTheme() {
    return localStorage.getItem(window.PMS_ADMIN.STORAGE_KEYS.theme) || 'light';
  },

  setTheme(value) {
    localStorage.setItem(window.PMS_ADMIN.STORAGE_KEYS.theme, value);
  },

  getLanguage() {
    return localStorage.getItem(window.PMS_ADMIN.STORAGE_KEYS.language) || 'en';
  },

  setLanguage(value) {
    localStorage.setItem(window.PMS_ADMIN.STORAGE_KEYS.language, value);
  },

  getActiveTab() {
    return localStorage.getItem(window.PMS_ADMIN.STORAGE_KEYS.tab) || 'dashboard';
  },

  setActiveTab(value) {
    localStorage.setItem(window.PMS_ADMIN.STORAGE_KEYS.tab, value);
  },
};
