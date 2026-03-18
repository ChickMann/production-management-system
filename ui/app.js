const navItems = Array.from(document.querySelectorAll('.nav-item'));
const contentArea = document.getElementById('contentArea');
const pageTitle = document.getElementById('pageTitle');
const pageSubtitle = document.getElementById('pageSubtitle');
const menuToggle = document.getElementById('menuToggle');
const sidebar = document.getElementById('sidebar');
const sidebarOverlay = document.getElementById('sidebarOverlay');
const layoutShell = document.getElementById('layoutShell');
const roleBadge = document.getElementById('roleBadge');
const userName = document.getElementById('userName');
const headerUser = document.getElementById('headerUser');
const notifBadge = document.getElementById('notifBadge');
const searchBox = document.getElementById('searchBox');
const searchInput = document.getElementById('searchInput');

// i18n: Vietnamese copy standardization
const i18n = {
  tabs: {
    dashboard: 'Tổng quan',
    layouts: 'Bố cục',
    widgets: 'Tiện ích',
    courses: 'Khoá học trực tuyến',
    membership: 'Thành viên',
    helpdesk: 'Hỗ trợ',
    invoice: 'Hóa đơn',
    basic: 'Cơ bản',
    advanced: 'Nâng cao',
    animation: 'Hoạt ảnh',
    icons: 'Biểu tượng',
  },
  states: {
    loading: 'Đang tải...',
    empty: 'Không có dữ liệu',
    error: 'Lỗi khi tải dữ liệu',
  },
  common: {
    quickConfig: 'Cấu hình nhanh',
    noData: 'Chưa có dữ liệu',
  },
};

// Language translations (EN/VI)
const translations = {
  vi: {
    dashboard: 'Tổng quan',
    layouts: 'Bố cục',
    widgets: 'Tiện ích',
    courses: 'Khoá học trực tuyến',
    membership: 'Thành viên',
    helpdesk: 'Hỗ trợ',
    invoice: 'Hóa đơn',
    basic: 'Cơ bản',
    advanced: 'Nâng cao',
    animation: 'Hoạt ảnh',
    icons: 'Biểu tượng',
    loading: 'Đang tải...',
    empty: 'Không có dữ liệu',
    error: 'Lỗi khi tải dữ liệu',
    quickConfig: 'Cấu hình nhanh',
  },
  en: {
    dashboard: 'Dashboard',
    layouts: 'Layouts',
    widgets: 'Widgets',
    courses: 'Online Courses',
    membership: 'Membership',
    helpdesk: 'Helpdesk',
    invoice: 'Invoice',
    basic: 'Basic',
    advanced: 'Advanced',
    animation: 'Animation',
    icons: 'Icons',
    loading: 'Loading...',
    empty: 'No data',
    error: 'Error loading data',
    quickConfig: 'Quick config',
  },
};

// Current language state
let currentLanguage = 'en';
let currentTheme = localStorage.getItem('pms-theme') || 'light';
localStorage.setItem('pms-language', 'en');

const state = {
  user: {
    name: 'Nguyễn Văn A',
    role: 'Admin',
  },
  tabs: {
    dashboard: {
      title: i18n.tabs.dashboard,
      subtitle: 'Tổng quan tình hình sản xuất trong ngày',
    },
    layouts: {
      title: i18n.tabs.layouts,
      subtitle: 'Quản lý bố cục trang và mẫu layout',
    },
    widgets: {
      title: i18n.tabs.widgets,
      subtitle: 'Danh sách widget dùng cho dashboard',
    },
    courses: {
      title: i18n.tabs.courses,
      subtitle: 'Quản trị nội dung khoá học',
    },
    membership: {
      title: i18n.tabs.membership,
      subtitle: 'Gói thành viên và quyền truy cập',
    },
    helpdesk: {
      title: i18n.tabs.helpdesk,
      subtitle: 'Quản lý hỗ trợ và ticket',
    },
    invoice: {
      title: i18n.tabs.invoice,
      subtitle: 'Hóa đơn và thanh toán',
    },
    basic: {
      title: i18n.tabs.basic,
      subtitle: 'Thành phần UI cơ bản',
    },
    advanced: {
      title: i18n.tabs.advanced,
      subtitle: 'Thành phần UI nâng cao',
    },
    animation: {
      title: i18n.tabs.animation,
      subtitle: 'Thiết lập animation',
    },
    icons: {
      title: i18n.tabs.icons,
      subtitle: 'Thư viện biểu tượng',
    },
  },
};

const templates = {
  dashboard: () => `
    <div class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
      ${card('Total Revenue', '$847,290', '+12.5% so với tháng trước')}
      ${card('Active Users', '24,689', '+8.2% so với tuần trước')}
      ${card('Orders', '1,847', '-2.1% so với hôm qua')}
      ${card('Conversion', '3.47%', '+0.3% so với tháng trước')}
    </div>
    <div class="grid gap-6 lg:grid-cols-[2fr_1fr]">
      <div class="rounded-2xl bg-white p-6 shadow-sm">
        <div class="flex items-center justify-between">
          <h3 class="text-sm font-semibold text-slate-700">Real-time Analytics</h3>
          <div class="flex items-center gap-2 text-xs text-slate-500">
            <span class="rounded-full border border-slate-200 px-2 py-1">7D</span>
            <span class="rounded-full bg-teal-500 px-2 py-1 text-white">30D</span>
            <span class="rounded-full border border-slate-200 px-2 py-1">90D</span>
          </div>
        </div>
        <div class="mt-6 grid gap-6 sm:grid-cols-2">
          ${stat('Sessions', '47,829', 'Tỉ lệ truy cập ổn định')}
          ${stat('Page Views', '186,247', 'Lượt xem tăng đều')}
        </div>
        <div class="mt-6 h-40 rounded-xl bg-gradient-to-br from-teal-100 via-sky-100 to-slate-100"></div>
      </div>
      <div class="rounded-2xl bg-white p-6 shadow-sm">
        <h3 class="text-sm font-semibold text-slate-700">Device Analytics</h3>
        <div class="mt-6 flex h-52 items-center justify-center rounded-full border-8 border-teal-100">
          <div class="text-center">
            <p class="text-2xl font-semibold text-slate-800">68%</p>
            <p class="text-xs text-slate-500">Desktop</p>
          </div>
        </div>
        <div class="mt-6 space-y-2 text-xs text-slate-500">
          <div class="flex items-center justify-between"><span>Desktop</span><span class="font-semibold text-slate-700">68%</span></div>
          <div class="flex items-center justify-between"><span>Tablet</span><span class="font-semibold text-slate-700">21%</span></div>
          <div class="flex items-center justify-between"><span>Mobile</span><span class="font-semibold text-slate-700">11%</span></div>
        </div>
      </div>
    </div>
  `,
  layouts: () => sectionTemplate(i18n.tabs.layouts, ['Grid', 'Split', 'Cards', 'Full Width']),
  widgets: () => sectionTemplate(i18n.tabs.widgets, ['KPI Cards', 'Tables', 'Charts', 'Notifications']),
  courses: () => sectionTemplate('Online Courses', ['Danh mục', 'Lộ trình', 'Học viên', 'Giảng viên']),
  membership: () => sectionTemplate('Membership', ['Gói Free', 'Gói Pro', 'Ưu đãi', 'Gia hạn']),
  helpdesk: () => sectionTemplate('Helpdesk', ['Tickets', 'SLA', 'Báo cáo', 'Trực ca']),
  invoice: () => sectionTemplate('Invoice', ['Danh sách hóa đơn', 'Xuất hóa đơn', 'Đối soát', 'Công nợ']),
  basic: () => sectionTemplate('Basic', ['Buttons', 'Forms', 'Tables', 'Badges']),
  advanced: () => sectionTemplate('Advanced', ['Charts', 'Kanban', 'Timeline', 'Data grid']),
  animation: () => sectionTemplate('Animation', ['Hover', 'Transitions', 'Skeleton', 'Loading']),
  icons: () => sectionTemplate('Icons', ['Solid', 'Outline', 'Brands', 'Custom']),
  loading: () => `
    <div class="flex h-64 items-center justify-center rounded-2xl bg-white shadow-sm">
      <div class="text-center">
        <div class="mb-4 inline-block h-8 w-8 animate-spin rounded-full border-4 border-slate-200 border-t-teal-500"></div>
        <p class="text-sm text-slate-500">${i18n.states.loading}</p>
      </div>
    </div>
  `,
  empty: () => `
    <div class="flex h-64 items-center justify-center rounded-2xl bg-white shadow-sm">
      <div class="text-center">
        <p class="text-sm text-slate-500">${i18n.states.empty}</p>
      </div>
    </div>
  `,
  error: () => `
    <div class="flex h-64 items-center justify-center rounded-2xl bg-white shadow-sm">
      <div class="text-center">
        <p class="text-sm text-red-500">${i18n.states.error}</p>
      </div>
    </div>
  `,
};

function card(title, value, meta) {
  return `
    <div class="rounded-2xl bg-white p-5 shadow-sm">
      <p class="text-xs text-slate-400">${title}</p>
      <div class="mt-3 flex items-end justify-between">
        <div>
          <p class="text-2xl font-semibold text-slate-800">${value}</p>
          <p class="text-xs text-teal-500">${meta}</p>
        </div>
        <div class="h-10 w-16 rounded-lg bg-gradient-to-br from-teal-200 to-sky-200"></div>
      </div>
    </div>
  `;
}

function stat(label, value, note) {
  return `
    <div class="rounded-xl border border-slate-100 p-4">
      <p class="text-xs text-slate-400">${label}</p>
      <p class="text-xl font-semibold text-slate-800">${value}</p>
      <p class="text-xs text-slate-500">${note}</p>
    </div>
  `;
}

function row(id, customer, status, progress, deadline) {
  return `
    <tr>
      <td class="py-3 font-medium text-slate-700">${id}</td>
      <td class="py-3 text-slate-600">${customer}</td>
      <td class="py-3"><span class="rounded-full bg-teal-100 px-3 py-1 text-xs text-teal-700">${status}</span></td>
      <td class="py-3 text-slate-600">${progress}</td>
      <td class="py-3 text-slate-500">${deadline}</td>
    </tr>
  `;
}

function panel(title, value, desc) {
  return `
    <div class="rounded-2xl bg-white p-6 shadow-sm">
      <p class="text-xs text-slate-400">${title}</p>
      <p class="mt-2 text-2xl font-semibold text-slate-800">${value}</p>
      <p class="mt-3 text-xs text-teal-500">${desc}</p>
    </div>
  `;
}

function metric(label, value, trend) {
  return `
    <div class="flex items-center justify-between rounded-xl border border-slate-100 px-4 py-3">
      <div>
        <p class="text-xs text-slate-400">${label}</p>
        <p class="text-lg font-semibold text-slate-800">${value}</p>
      </div>
      <span class="text-xs text-teal-500">${trend}</span>
    </div>
  `;
}

function sectionTemplate(title, items) {
  return `
    <div class="rounded-2xl bg-white p-6 shadow-sm">
      <h3 class="text-sm font-semibold text-slate-700">${title}</h3>
      <div class="mt-4 grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
        ${items
          .map(
            (item) => `
          <div class="rounded-xl border border-slate-100 p-4">
            <p class="text-sm font-semibold text-slate-700">${item}</p>
            <p class="text-xs text-slate-400">Cấu hình nhanh</p>
          </div>
        `,
          )
          .join('')}
      </div>
    </div>
  `;
}

// Safe HTML rendering: escape special characters
function escapeHtml(text) {
  const map = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;',
  };
  return String(text).replace(/[&<>"']/g, (char) => map[char]);
}

// Safe content rendering: clear and append safely
function setActiveTab(tabId) {
  navItems.forEach((item) => {
    const isActive = item.dataset.tab === tabId;
    item.classList.toggle('active', isActive);
    item.setAttribute('aria-selected', String(isActive));
    item.setAttribute('tabindex', isActive ? '0' : '-1');
  });

  const tab = state.tabs[tabId] || state.tabs.dashboard;
  pageTitle.textContent = tab.title;
  pageSubtitle.textContent = tab.subtitle;

  const template = templates[tabId] || templates.dashboard;
  contentArea.innerHTML = template();

  localStorage.setItem('pms-active-tab', tabId);
}

function closeSidebar() {
  if (window.innerWidth >= 1024) {
    sidebar.dataset.collapsed = 'true';
    sidebar.classList.add('lg:w-0', 'lg:min-w-0', 'lg:overflow-hidden', 'lg:border-r-0');
    sidebar.classList.remove('w-72');
    if (layoutShell) {
      layoutShell.classList.remove('lg:grid-cols-[280px_1fr]');
      layoutShell.classList.add('lg:grid-cols-[0px_1fr]');
    }
    return;
  }

  sidebar.classList.add('-translate-x-full');
  sidebarOverlay.classList.add('hidden');
}

function openSidebar() {
  if (window.innerWidth >= 1024) {
    sidebar.dataset.collapsed = 'false';
    sidebar.classList.remove('lg:w-0', 'lg:min-w-0', 'lg:overflow-hidden', 'lg:border-r-0');
    sidebar.classList.add('w-72');
    if (layoutShell) {
      layoutShell.classList.remove('lg:grid-cols-[0px_1fr]');
      layoutShell.classList.add('lg:grid-cols-[280px_1fr]');
    }
    return;
  }

  sidebar.classList.remove('-translate-x-full');
  sidebarOverlay.classList.remove('hidden');
}

navItems.forEach((item) => {
  item.addEventListener('click', () => {
    setActiveTab(item.dataset.tab);
    if (window.innerWidth < 1024) {
      closeSidebar();
    }
  });
});

// Keyboard navigation for tabs: ArrowLeft, ArrowRight, Home, End
document.addEventListener('keydown', (e) => {
  const tabIds = Object.keys(state.tabs);
  const activeItem = document.querySelector('.nav-item.active');
  if (!activeItem) return;
  
  const currentIndex = tabIds.indexOf(activeItem.dataset.tab);
  let nextIndex = currentIndex;
  
  if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') {
    e.preventDefault();
    nextIndex = currentIndex > 0 ? currentIndex - 1 : tabIds.length - 1;
  } else if (e.key === 'ArrowRight' || e.key === 'ArrowDown') {
    e.preventDefault();
    nextIndex = currentIndex < tabIds.length - 1 ? currentIndex + 1 : 0;
  } else if (e.key === 'Home') {
    e.preventDefault();
    nextIndex = 0;
  } else if (e.key === 'End') {
    e.preventDefault();
    nextIndex = tabIds.length - 1;
  } else {
    return;
  }
  
  const nextTab = document.querySelector(`[data-tab="${tabIds[nextIndex]}"]`);
  if (nextTab) nextTab.click();
});

if (searchInput) {
  searchInput.focus();
}

sidebarOverlay.addEventListener('click', closeSidebar);

// Theme toggle: Light/Dark mode
const handleThemeToggle = () => {
  currentTheme = currentTheme === 'light' ? 'dark' : 'light';
  localStorage.setItem('pms-theme', currentTheme);
  applyTheme();
};

// Language toggle: EN/VI
const handleLanguageToggle = () => {
  currentLanguage = currentLanguage === 'vi' ? 'en' : 'vi';
  localStorage.setItem('pms-language', currentLanguage);
  applyLanguage();
  initTab();
};

// Apply theme to document
function applyTheme() {
  const themeButton = document.getElementById('themeToggle');
  if (currentTheme === 'dark') {
    document.documentElement.classList.add('dark');
    if (themeButton) themeButton.textContent = '☀️';
  } else {
    document.documentElement.classList.remove('dark');
    if (themeButton) themeButton.textContent = '☼';
  }
}

// Apply language to UI
function applyLanguage() {
  const t = translations[currentLanguage] || translations.en;
  const languageButton = document.getElementById('languageToggle');

  localStorage.setItem('pms-language', currentLanguage);
  document.documentElement.lang = currentLanguage;

  if (languageButton) {
    languageButton.textContent = currentLanguage === 'vi' ? '🇬🇧' : '🇻🇳';
    languageButton.title = currentLanguage === 'vi' ? 'Switch to English' : 'Chuyển sang tiếng Việt';
  }

  navItems.forEach((item) => {
    const tabId = item.dataset.tab;
    if (!t[tabId]) return;

    const labelNode = Array.from(item.childNodes).find(
      (node) => node.nodeType === Node.TEXT_NODE && node.textContent.trim(),
    );

    if (labelNode) {
      labelNode.textContent = ` ${t[tabId]} `;
    }
  });

  Object.keys(state.tabs).forEach((tabId) => {
    if (state.tabs[tabId] && t[tabId]) {
      state.tabs[tabId].title = t[tabId];
    }
  });

  const currentTab = document.querySelector('.nav-item.active')?.dataset.tab || 'dashboard';
  if (t[currentTab]) {
    pageTitle.textContent = t[currentTab];
  }
}

function initUser() {
  if (roleBadge) {
    roleBadge.textContent = state.user.role;
  }

  if (userName) {
    userName.textContent = state.user.name;
  }

  if (headerUser) {
    headerUser.textContent = state.user.name;
  }

  if (notifBadge) {
    notifBadge.textContent = '5';
  }
}

function initTab() {
  const savedTab = localStorage.getItem('pms-active-tab') || 'dashboard';
  setActiveTab(savedTab);
}

if (menuToggle) {
  menuToggle.addEventListener('click', () => {
    if (window.innerWidth >= 1024) {
      if (sidebar.dataset.collapsed === 'true') {
        openSidebar();
      } else {
        closeSidebar();
      }
      return;
    }

    if (sidebar.classList.contains('-translate-x-full')) {
      openSidebar();
    } else {
      closeSidebar();
    }
  });
}

const themeButton = document.getElementById('themeToggle');
if (themeButton) {
  themeButton.addEventListener('click', handleThemeToggle);
}

const languageButton = document.getElementById('languageToggle');
if (languageButton) {
  languageButton.addEventListener('click', handleLanguageToggle);
}

initUser();
applyTheme();
applyLanguage();
initTab();
