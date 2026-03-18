// File này xử lý phần header text của khu vực nội dung chính.
// Bao gồm: tiêu đề trang, mô tả trang, breadcrumbs và thông tin user hiển thị ở header/sidebar.
// Dữ liệu user hiện tại vẫn là dữ liệu demo/mock trong state frontend.
window.PMS_ADMIN = window.PMS_ADMIN || {};

// Cập nhật breadcrumbs theo tab đang chọn.
window.PMS_ADMIN.updateBreadcrumbs = function updateBreadcrumbs(current) {
  const breadcrumbEl = document.getElementById('breadcrumbCurrent');
  if (breadcrumbEl) {
    if (current.id === 'dashboard') {
      breadcrumbEl.textContent = 'Dashboard';
    } else {
      breadcrumbEl.textContent = window.PMS_ADMIN.getText(current.title);
    }
  }
};

// Cập nhật tiêu đề và mô tả theo tab đang chọn.
// Dashboard dùng text riêng, còn các module CRUD sẽ lấy từ metadata module.
window.PMS_ADMIN.updatePageHeading = function updatePageHeading(current) {
  const { dom } = window.PMS_ADMIN;
  const title = current.id === 'dashboard' ? window.PMS_ADMIN.t('dashboardTitle') : window.PMS_ADMIN.getText(current.title);
  const subtitle = current.id === 'dashboard' ? window.PMS_ADMIN.t('dashboardSubtitle') : window.PMS_ADMIN.getText(current.subtitle);

  if (dom.pageTitle) {
    dom.pageTitle.textContent = title;
  }

  if (dom.pageSubtitle) {
    dom.pageSubtitle.textContent = subtitle;
  }

  // Cập nhật breadcrumbs
  window.PMS_ADMIN.updateBreadcrumbs(current);
};

// Đổ thông tin user lên UI khi app khởi động.
// Lưu ý: tên user và badge thông báo hiện vẫn là dữ liệu demo/mock.
// Khi gắn backend cần thay bằng dữ liệu session/user thật.
window.PMS_ADMIN.initUser = function initUser() {
  const { dom, state } = window.PMS_ADMIN;

  if (dom.userName) {
    dom.userName.textContent = state.app.user.name;
  }

  if (dom.headerUser) {
    dom.headerUser.textContent = state.app.user.name;
  }

  if (dom.notifBadge) {
    dom.notifBadge.textContent = '5';
  }
};
