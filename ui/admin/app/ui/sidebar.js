// File này xử lý sidebar và điều hướng tab chính của admin UI.
// Phần này là điều hướng frontend nội bộ, chưa phải route thật từ backend/JSP.
window.PMS_ADMIN = window.PMS_ADMIN || {};

// Lấy toàn bộ module từ các nhóm nghiệp vụ.
// Dùng khi cần duyệt nhanh toàn bộ tab hiện có.
window.PMS_ADMIN.getAllModules = function getAllModules() {
  return window.PMS_ADMIN.moduleGroups.flatMap((group) => group.items);
};

// So khớp từ khóa tìm kiếm trên sidebar.
// Hiện tại đang tìm trên title, subtitle, controller, action và tên màn hình con.
// Đây là tìm kiếm demo phía frontend, chưa nối API search thật.
window.PMS_ADMIN.matchesKeyword = function matchesKeyword(item, keyword) {
  if (!keyword) {
    return true;
  }

  const searchBlob = [
    window.PMS_ADMIN.getText(item.title),
    window.PMS_ADMIN.getText(item.subtitle),
    item.controller,
    ...(item.actions || []),
    ...(item.screens || []).map((screen) => window.PMS_ADMIN.getText(screen.title)),
  ]
    .join(' ')
    .toLowerCase();

  return searchBlob.includes(keyword);
};

// Render một nút tab trong sidebar.
// Mỗi nút tương ứng với một module như Users, Items, BOM...
window.PMS_ADMIN.renderSidebarButton = function renderSidebarButton(item) {
  const isActive = item.id === window.PMS_ADMIN.state.app.activeTab;
  const badge = item.badge
    ? `<span class="ml-auto rounded-full bg-teal-500/20 px-2 py-0.5 text-xs text-teal-200">${window.PMS_ADMIN.escapeHtml(item.badge)}</span>`
    : '<span class="ml-auto text-xs text-slate-400">›</span>';

  return `
    <button
      data-tab="${window.PMS_ADMIN.escapeHtml(item.id)}"
      class="nav-item ${isActive ? 'active' : ''} flex w-full items-center gap-3 rounded-xl px-3 py-2 text-left text-sm font-medium text-slate-200 hover:bg-slate-800"
      role="tab"
      aria-selected="${isActive}"
      aria-controls="contentArea"
      tabindex="${isActive ? '0' : '-1'}"
      type="button"
    >
      <span class="flex h-8 w-8 items-center justify-center rounded-lg bg-slate-800 text-teal-300">${window.PMS_ADMIN.escapeHtml(item.icon)}</span>
      <span class="min-w-0 flex-1 truncate">${window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.getText(item.title))}</span>
      ${badge}
    </button>
  `;
};

// Gắn sự kiện click cho các tab sau khi sidebar được render lại.
window.PMS_ADMIN.bindNavEvents = function bindNavEvents() {
  const navItems = Array.from(document.querySelectorAll('.nav-item'));
  navItems.forEach((item) => {
    item.addEventListener('click', () => {
      window.PMS_ADMIN.setActiveTab(item.dataset.tab);
      if (window.innerWidth < 1024) {
        window.PMS_ADMIN.closeSidebar();
      }
    });
  });
};

// Dựng toàn bộ sidebar theo nhóm module.
// Nếu có filter thì chỉ hiện các tab phù hợp với từ khóa.
window.PMS_ADMIN.buildSidebar = function buildSidebar(filterText = '') {
  const { dom, moduleGroups, t, escapeHtml } = window.PMS_ADMIN;

  if (!dom.sidebarNav) {
    return;
  }

  const keyword = filterText.trim().toLowerCase();
  const groupsMarkup = moduleGroups
    .map((group) => {
      const visibleItems = group.items.filter((item) => window.PMS_ADMIN.matchesKeyword(item, keyword));
      if (!visibleItems.length) {
        return '';
      }

      return `
        <section class="space-y-3">
          <p class="px-2 text-xs font-semibold uppercase tracking-wider text-slate-400">${escapeHtml(t(group.labelKey))}</p>
          <div class="space-y-1">
            ${visibleItems.map(window.PMS_ADMIN.renderSidebarButton).join('')}
          </div>
        </section>
      `;
    })
    .join('');

  dom.sidebarNav.innerHTML = groupsMarkup;
  window.PMS_ADMIN.bindNavEvents();
};

// Render nội dung chính theo tab hiện tại.
// Dashboard dùng renderer riêng, các module CRUD dùng renderer module.
window.PMS_ADMIN.renderContent = function renderContent(current) {
  const { dom } = window.PMS_ADMIN;
  if (!dom.contentArea) {
    return;
  }

  dom.contentArea.innerHTML = current.type === 'dashboard' ? window.PMS_ADMIN.renderDashboard() : window.PMS_ADMIN.renderModule(current);
};

// Đổi tab hiện tại và render lại nội dung tương ứng.
// Khi đổi tab sẽ reset màn con về mặc định để tránh giữ trạng thái cũ.
window.PMS_ADMIN.setActiveTab = function setActiveTab(tabId) {
  const fallbackTab = window.PMS_ADMIN.moduleMap[tabId] ? tabId : 'dashboard';
  const { state, storage, dom } = window.PMS_ADMIN;

  state.app.activeTab = fallbackTab;
  state.app.activeScreen = 'main';
  storage.setActiveTab(fallbackTab);

  const current = window.PMS_ADMIN.moduleMap[fallbackTab] || window.PMS_ADMIN.moduleMap.dashboard;
  window.PMS_ADMIN.updatePageHeading(current);
  window.PMS_ADMIN.buildSidebar(dom.searchInput?.value || '');
  window.PMS_ADMIN.renderContent(current);
};
