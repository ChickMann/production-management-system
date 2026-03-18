// File này chứa toàn bộ text đa ngôn ngữ cho admin UI.
// Hiện tại hỗ trợ `en` và `vi`.
// Đây là text hiển thị phía frontend, không phải dữ liệu thật từ backend.
window.PMS_ADMIN = window.PMS_ADMIN || {};

window.PMS_ADMIN.translations = {
  en: {
    searchPlaceholder: 'Search modules or features...',
    welcome: 'Welcome,',
    dashboardTitle: 'Admin overview',
    dashboardSubtitle: 'Classic admin shell with cleaner content inside each tab.',
    modulesSection: 'Core modules',
    quickActionsTitle: 'Quick actions',
    summaryTitle: 'System summary',
    recentActivity: 'Recent activity',
    overview: 'Overview',
    status: 'Status',
    controller: 'Controller',
    actions: 'Actions',
    dependencies: 'Dependencies',
    listView: 'View list',
    formView: 'Create new',
    tableTitle: 'Sample records',
    formTitle: 'Quick form preview',
    ready: 'Ready',
    noDependency: 'Standalone',
    dashboardMetric1: 'Open work orders',
    dashboardMetric2: 'Items in stock',
    dashboardMetric3: 'Production logs today',
    dashboardMetric4: 'Pending bills',
    dashboardNote1: 'Need follow-up today',
    dashboardNote2: 'Low stock items included',
    dashboardNote3: 'Shift reports received',
    dashboardNote4: 'Waiting for review',
    quickAction1: 'Review work orders',
    quickAction2: 'Create production log',
    quickAction3: 'Check low stock items',
    summary1: '12 core modules are visible in the admin workspace',
    summary2: 'Language toggle is available in EN/VI',
    summary3: 'Each tab uses a shorter layout and less demo content',
    activityModule: 'Module',
    activityDetail: 'Detail',
    activityTime: 'Time',
    moduleDescription: 'This tab keeps the old admin layout but simplifies the content for faster reading.',
    formHint: 'Short form preview for future JSP or backend integration.',
    reset: 'Reset',
    save: 'Save changes',
    groupGeneral: 'General',
    groupMasterData: 'Master data',
    groupEngineering: 'Engineering',
    groupExecution: 'Execution',
    groupCommercial: 'Commercial',
  },
  vi: {
    searchPlaceholder: 'Tìm module hoặc chức năng...',
    welcome: 'Xin chào,',
    dashboardTitle: 'Tổng quan quản trị',
    dashboardSubtitle: 'Giữ layout admin cũ nhưng nội dung trong từng tab gọn hơn.',
    modulesSection: 'Module chính',
    quickActionsTitle: 'Thao tác nhanh',
    summaryTitle: 'Tóm tắt hệ thống',
    recentActivity: 'Hoạt động gần đây',
    overview: 'Tổng quan',
    status: 'Trạng thái',
    controller: 'Bộ xử lý',
    actions: 'Thao tác',
    dependencies: 'Phụ thuộc',
    listView: 'Xem danh sách',
    formView: 'Tạo mới',
    tableTitle: 'Dữ liệu mẫu',
    formTitle: 'Biểu mẫu nhanh',
    ready: 'Sẵn sàng',
    noDependency: 'Độc lập',
    dashboardMetric1: 'Lệnh sản xuất mở',
    dashboardMetric2: 'Vật tư tồn kho',
    dashboardMetric3: 'Nhật ký trong ngày',
    dashboardMetric4: 'Hóa đơn chờ xử lý',
    dashboardNote1: 'Cần theo dõi hôm nay',
    dashboardNote2: 'Bao gồm mục sắp thiếu',
    dashboardNote3: 'Đã nhận báo cáo ca',
    dashboardNote4: 'Đang chờ rà soát',
    quickAction1: 'Kiểm tra lệnh sản xuất',
    quickAction2: 'Tạo nhật ký sản xuất',
    quickAction3: 'Xem vật tư sắp thiếu',
    summary1: '12 module chính đang hiển thị trong khu vực admin',
    summary2: 'Có thể chuyển đổi ngôn ngữ EN/VI',
    summary3: 'Mỗi tab đã được rút gọn để dễ đọc hơn',
    activityModule: 'Module',
    activityDetail: 'Chi tiết',
    activityTime: 'Thời gian',
    moduleDescription: 'Tab này giữ layout admin cũ nhưng đơn giản phần nội dung để dễ theo dõi.',
    formHint: 'Biểu mẫu rút gọn cho giai đoạn nối JSP hoặc backend sau này.',
    reset: 'Đặt lại',
    save: 'Lưu thay đổi',
    groupGeneral: 'Chung',
    groupMasterData: 'Dữ liệu gốc',
    groupEngineering: 'Kỹ thuật',
    groupExecution: 'Điều hành',
    groupCommercial: 'Thương mại',
  },
};

// Hàm lấy text theo ngôn ngữ hiện tại.
// Nếu không tìm thấy key ở ngôn ngữ hiện tại thì fallback về chính key đó.
window.PMS_ADMIN.t = function t(key) {
  const language = window.PMS_ADMIN.state.currentLanguage;
  return (window.PMS_ADMIN.translations[language] || window.PMS_ADMIN.translations.en)[key] || key;
};

// Hàm đọc text từ object song ngữ dạng `{ en, vi }`.
// Dùng nhiều trong metadata module để không phải hard-code text theo từng nơi render.
window.PMS_ADMIN.getText = function getText(value) {
  if (typeof value === 'string') {
    return value;
  }

  const language = window.PMS_ADMIN.state.currentLanguage;
  return value?.[language] || value?.en || '';
};
