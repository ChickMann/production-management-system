// File này chứa metadata của toàn bộ module admin.
// Đây là lớp cấu hình giao diện, chưa phải dữ liệu thật từ backend.
window.PMS_ADMIN = window.PMS_ADMIN || {};

// Tạo metadata cho một màn hình con trong module.
// Ví dụ: list / create / edit.
// Hiện tại đây là cấu hình điều hướng frontend demo.
// Sau này có thể map sang route thật hoặc JSP riêng.
function createFeatureScreen(id, title, description) {
  return {
    id,
    title,
    description,
  };
}

// Tạo metadata cho một module.
// Các trường như `controller`, `actions`, `dependencies` đang mang tính mô tả kỹ thuật.
// `rows` là dữ liệu demo/mock để dựng bảng khi chưa nối backend thật.
// `screens` mô tả các màn con dự kiến của module để sau này mở rộng dễ hơn.
// `urls` chứa URL mapping đến các trang JSP thật.
// `columns` định nghĩa các cột hiển thị trong bảng danh sách.
function createModule(id, icon, title, controller, actions, dependencies, rows, screens, urls, columns) {
  return {
    id,
    icon,
    title,
    subtitle: {
      en: `${title.en} with a simpler tab content`,
      vi: `${title.vi} với phần nội dung được đơn giản hóa`,
    },
    type: 'module',
    badge: '',
    controller,
    actions,
    dependencies,
    rows,
    screens,
    urls: urls || {},
    columns: columns || null,
  };
}

// Chia module theo nhóm nghiệp vụ để sidebar dễ nhìn hơn.
// Lưu ý: phần title/subtitle của từng module là dữ liệu hiển thị UI.
// Các `rows` bên dưới đa số là dữ liệu demo/mock và cần thay bằng dữ liệu thật khi gắn backend.

// Tên module theo chức năng nghiệp vụ, KHÔNG dùng tên bảng database
window.PMS_ADMIN.moduleGroups = [
  {
    id: 'overview',
    labelKey: 'groupGeneral',
    items: [
      {
        id: 'dashboard',
        icon: '⌂',
        title: { en: 'Dashboard', vi: 'Tổng quan' },
        subtitle: {
          en: 'Short overview of the main production modules',
          vi: 'Tổng quan ngắn gọn về các module sản xuất chính',
        },
        type: 'dashboard',
        badge: '12',
        screens: [createFeatureScreen('main', { en: 'Overview', vi: 'Tổng quan' }, { en: 'Main dashboard screen', vi: 'Màn hình tổng quan chính' })],
      },
    ],
  },
  {
    id: 'master-data',
    labelKey: 'groupMasterData',
    items: [
      createModule('users', '👤', { en: 'Users', vi: 'Người dùng' }, 'UserController', ['listUser', 'addUser', 'updateUser'], ['Session user'], [
        { id: 'U01', name: 'John Admin', type: 'Admin', status: 'Active' },
        { id: 'U02', name: 'Lan Tran', type: 'Supervisor', status: 'Active' },
        { id: 'U03', name: 'Minh Le', type: 'Worker', status: 'Inactive' },
      ], [
        createFeatureScreen('list', { en: 'User list', vi: 'Danh sách người dùng' }, { en: 'Main list screen', vi: 'Màn hình danh sách chính' }),
        createFeatureScreen('create', { en: 'Create user', vi: 'Tạo người dùng' }, { en: 'Create page', vi: 'Trang tạo mới' }),
        createFeatureScreen('edit', { en: 'Edit user', vi: 'Sửa người dùng' }, { en: 'Edit page', vi: 'Trang chỉnh sửa' }),
      ], {
        list: 'user-form.jsp',
        create: 'user-form.jsp',
        edit: 'user-form.jsp',
      }),
      createModule('items', '📦', { en: 'Items / Products', vi: 'Vật tư / Hàng hóa' }, 'ItemController', ['listItem', 'addItem', 'updateItem'], ['None'], [
        { id: 'IT01', name: 'Steel Sheet', type: 'Material', status: 'Available' },
        { id: 'IT02', name: 'Motor Housing', type: 'Finished good', status: 'Available' },
        { id: 'IT03', name: 'Bearing Kit', type: 'Component', status: 'Low stock' },
      ], [
        createFeatureScreen('list', { en: 'Item list', vi: 'Danh sách vật tư' }, { en: 'Main list screen', vi: 'Màn hình danh sách chính' }),
        createFeatureScreen('create', { en: 'Create item', vi: 'Tạo vật tư' }, { en: 'Create page', vi: 'Trang tạo mới' }),
        createFeatureScreen('edit', { en: 'Edit item', vi: 'Sửa vật tư' }, { en: 'Edit page', vi: 'Trang chỉnh sửa' }),
      ], {
        list: 'MainController?action=searchItem',
        create: 'item-form.jsp',
        edit: 'MainController?action=loadUpdateItem',
      }),
      createModule('suppliers', '🚚', { en: 'Suppliers', vi: 'Nhà cung cấp' }, 'SupplierController', ['listSupplier', 'addSupplier', 'updateSupplier'], ['None'], [
        { id: 'S01', name: 'ABC Metals', type: 'Raw material', status: 'Approved' },
        { id: 'S02', name: 'Fast Parts Co.', type: 'Component', status: 'Approved' },
        { id: 'S03', name: 'Delta Pack', type: 'Packaging', status: 'Review' },
      ], [
        createFeatureScreen('list', { en: 'Supplier list', vi: 'Danh sách nhà cung cấp' }, { en: 'Main list screen', vi: 'Màn hình danh sách chính' }),
        createFeatureScreen('create', { en: 'Create supplier', vi: 'Tạo nhà cung cấp' }, { en: 'Create page', vi: 'Trang tạo mới' }),
        createFeatureScreen('edit', { en: 'Edit supplier', vi: 'Sửa nhà cung cấp' }, { en: 'Edit page', vi: 'Trang chỉnh sửa' }),
      ], {
        list: 'MainController?action=searchSupplier',
        create: 'supplier-form.jsp',
        edit: 'MainController?action=loadUpdateSupplier',
      }),
      createModule('customers', '🏢', { en: 'Customers', vi: 'Khách hàng' }, 'CustomerController', ['listCustomer', 'addCustomer', 'updateCustomer'], ['None'], [
        { id: 'C01', name: 'ABC Corp', type: 'Corporate', status: 'Active' },
        { id: 'C02', name: 'XYZ Ltd', type: 'Corporate', status: 'Active' },
        { id: 'C03', name: 'Retail Shop A', type: 'Retail', status: 'Inactive' },
      ], [
        createFeatureScreen('list', { en: 'Customer list', vi: 'Danh sách khách hàng' }, { en: 'Main list screen', vi: 'Màn hình danh sách chính' }),
        createFeatureScreen('create', { en: 'Create customer', vi: 'Tạo khách hàng' }, { en: 'Create page', vi: 'Trang tạo mới' }),
        createFeatureScreen('edit', { en: 'Edit customer', vi: 'Sửa khách hàng' }, { en: 'Edit page', vi: 'Trang chỉnh sửa' }),
      ], {
        list: 'customer.jsp',
        create: 'customer.jsp',
        edit: 'customer.jsp',
      }),
    ],
  },
  {
    id: 'engineering',
    labelKey: 'groupEngineering',
    items: [
      // BOM: Bill of Materials - Định mức vật tư/sản phẩm
      createModule('bill-of-materials', '🧩', { en: 'Bill of Materials', vi: 'Định mức vật tư' }, 'BomController', ['listBOM', 'addBOM', 'updateBOM'], ['Items'], [
        { id: 'BOM01', name: 'Motor Set', type: 'Assembly', status: 'Ready' },
        { id: 'BOM02', name: 'Fan Unit', type: 'Assembly', status: 'Draft' },
        { id: 'BOM03', name: 'Panel Kit', type: 'Sub assembly', status: 'Ready' },
      ], [
        createFeatureScreen('list', { en: 'BOM list', vi: 'Danh sách định mức' }, { en: 'Main list screen', vi: 'Màn hình danh sách chính' }),
        createFeatureScreen('create', { en: 'Create BOM', vi: 'Tạo định mức' }, { en: 'Create page', vi: 'Trang tạo mới' }),
        createFeatureScreen('edit', { en: 'Edit BOM', vi: 'Sửa định mức' }, { en: 'Edit page', vi: 'Trang chỉnh sửa' }),
      ], {
        list: 'MainController?action=listBOM',
        create: 'addBOM.jsp',
        edit: 'MainController?action=loadUpdateBom',
      }),
      // Routing: Quy trình sản xuất (đường đi của sản phẩm)
      createModule('production-process', '🛣', { en: 'Production Process', vi: 'Quy trình sản xuất' }, 'RoutingController', ['listRouting', 'addRouting', 'updateRouting'], ['None'], [
        { id: 'R01', name: 'Assembly Line A', type: 'Line', status: 'Ready' },
        { id: 'R02', name: 'Packaging Route', type: 'Route', status: 'Ready' },
        { id: 'R03', name: 'Inspection Route', type: 'Route', status: 'Review' },
      ], [
        createFeatureScreen('list', { en: 'Process list', vi: 'Danh sách quy trình' }, { en: 'Main list screen', vi: 'Màn hình danh sách chính' }),
        createFeatureScreen('create', { en: 'Create process', vi: 'Tạo quy trình' }, { en: 'Create page', vi: 'Trang tạo mới' }),
        createFeatureScreen('edit', { en: 'Edit process', vi: 'Sửa quy trình' }, { en: 'Edit page', vi: 'Trang chỉnh sửa' }),
      ], {
        list: 'MainController?action=listRouting',
        create: 'MainController?action=listRouting', // Same as list, has inline form
        edit: 'MainController?action=loadUpdateRouting',
      }),
      // Routing Steps: Các bước trong quy trình sản xuất
      createModule('process-steps', '⚙️', { en: 'Process Steps', vi: 'Các bước sản xuất' }, 'RoutingStepController', ['listRoutingStep', 'addRoutingStep', 'updateRoutingStep'], ['Production Process'], [
        { id: 'RS01', name: 'Cutting', type: 'Operation', status: 'Ready' },
        { id: 'RS02', name: 'Welding', type: 'Operation', status: 'Ready' },
        { id: 'RS03', name: 'Painting', type: 'Operation', status: 'Pending' },
      ], [
        createFeatureScreen('list', { en: 'Step list', vi: 'Danh sách bước' }, { en: 'Main list screen', vi: 'Màn hình danh sách chính' }),
        createFeatureScreen('create', { en: 'Create step', vi: 'Tạo bước' }, { en: 'Create page', vi: 'Trang tạo mới' }),
        createFeatureScreen('edit', { en: 'Edit step', vi: 'Sửa bước' }, { en: 'Edit page', vi: 'Trang chỉnh sửa' }),
      ], {
        list: 'MainController?action=listRoutingStep',
        create: 'addRoutingStep.jsp',
        edit: 'MainController?action=loadUpdateRoutingStep',
      }),
      // Defect Reasons: Nguyên nhân lỗi sản xuất
      createModule('defect-reasons', '⚠️', { en: 'Defect Reasons', vi: 'Nguyên nhân lỗi' }, 'DefectReasonController', ['listDefectReason', 'addDefectReason', 'updateDefectReason'], ['None'], [
        { id: 'DR01', name: 'Material defect', type: 'Quality', status: 'Active' },
        { id: 'DR02', name: 'Machine error', type: 'Equipment', status: 'Active' },
        { id: 'DR03', name: 'Human error', type: '操作', status: 'Active' },
      ], [
        createFeatureScreen('list', { en: 'Reason list', vi: 'Danh sách nguyên nhân' }, { en: 'Main list screen', vi: 'Màn hình danh sách chính' }),
        createFeatureScreen('create', { en: 'Create reason', vi: 'Tạo nguyên nhân' }, { en: 'Create page', vi: 'Trang tạo mới' }),
        createFeatureScreen('edit', { en: 'Edit reason', vi: 'Sửa nguyên nhân' }, { en: 'Edit page', vi: 'Trang chỉnh sửa' }),
      ], {
        list: 'MainController?action=listDefectReason',
        create: 'MainController?action=listDefectReason', // Same as list, has inline form
        edit: 'MainController?action=loadUpdateDefectReason',
      }),
    ],
  },
  {
    id: 'execution',
    labelKey: 'groupExecution',
    items: [
      // Work Orders: Lệnh sản xuất
      createModule('production-orders', '🧾', { en: 'Production Orders', vi: 'Lệnh sản xuất' }, 'WorkOrderController', ['search', 'insert', 'update'], ['Items', 'Production Process'], [
        { id: 'WO01', name: 'Motor Batch 01', type: 'Production', status: 'Running' },
        { id: 'WO02', name: 'Panel Batch 04', type: 'Production', status: 'Planned' },
        { id: 'WO03', name: 'Repair Batch 02', type: 'Rework', status: 'On hold' },
      ], [
        createFeatureScreen('list', { en: 'Order list', vi: 'Danh sách lệnh' }, { en: 'Main list screen', vi: 'Màn hình danh sách chính' }),
        createFeatureScreen('create', { en: 'Create order', vi: 'Tạo lệnh' }, { en: 'Create page', vi: 'Trang tạo mới' }),
        createFeatureScreen('edit', { en: 'Edit order', vi: 'Sửa lệnh' }, { en: 'Edit page', vi: 'Trang chỉnh sửa' }),
      ], {
        list: 'workorder.jsp',
        create: 'workorder.jsp',
        edit: 'workorder.jsp',
      }),
      // Production Logs: Nhật ký sản xuất
      createModule('production-logs', '📋', { en: 'Production Logs', vi: 'Nhật ký sản xuất' }, 'ProductionLogController', ['listProduction', 'insert', 'update'], ['Production Orders', 'Users'], [
        { id: 'PL01', name: 'Shift A / WO01', type: 'Daily log', status: 'Submitted' },
        { id: 'PL02', name: 'Shift B / WO02', type: 'Daily log', status: 'Pending' },
        { id: 'PL03', name: 'Shift A / WO03', type: 'Issue log', status: 'Reviewed' },
      ], [
        createFeatureScreen('list', { en: 'Log list', vi: 'Danh sách nhật ký' }, { en: 'Main list screen', vi: 'Màn hình danh sách chính' }),
        createFeatureScreen('create', { en: 'Create log', vi: 'Tạo nhật ký' }, { en: 'Create page', vi: 'Trang tạo mới' }),
        createFeatureScreen('edit', { en: 'Edit log', vi: 'Sửa nhật ký' }, { en: 'Edit page', vi: 'Trang chỉnh sửa' }),
      ], {
        list: 'productionlog.jsp',
        create: 'productionlog.jsp',
        edit: 'productionlog.jsp',
      }),
    ],
  },
  {
    id: 'commercial',
    labelKey: 'groupCommercial',
    items: [
      // Purchase Orders: Đơn mua hàng
      createModule('purchase-orders', '🛒', { en: 'Purchase Orders', vi: 'Đơn mua hàng' }, 'PurchaseOrderController', ['listPurchaseOrder', 'addPurchaseOrder', 'updatePurchaseOrder'], ['Suppliers', 'Items'], [
        { id: 'PO01', name: 'Steel Sheet Refill', type: 'Material order', status: 'Open' },
        { id: 'PO02', name: 'Bearing Kit Order', type: 'Component order', status: 'Approved' },
        { id: 'PO03', name: 'Packing Cartons', type: 'Packaging order', status: 'Draft' },
      ], [
        createFeatureScreen('list', { en: 'PO list', vi: 'Danh sách đơn mua' }, { en: 'Main list screen', vi: 'Màn hình danh sách chính' }),
        createFeatureScreen('create', { en: 'Create purchase order', vi: 'Tạo đơn mua' }, { en: 'Create page', vi: 'Trang tạo mới' }),
        createFeatureScreen('edit', { en: 'Edit purchase order', vi: 'Sửa đơn mua' }, { en: 'Edit page', vi: 'Trang chỉnh sửa' }),
      ], {
        list: 'SearchPurchaseOrder.jsp',
        create: 'po-form.jsp',
        edit: 'po-form.jsp',
      }),
      // Bills: Hóa đơn bán hàng
      createModule('sales-invoices', '💳', { en: 'Sales Invoices', vi: 'Hóa đơn bán hàng' }, 'BillController', ['listBill', 'addBill', 'updateBill'], ['Customers'], [
        { id: 'B01', name: 'Invoice 2026-001', type: 'Sales bill', status: 'Pending' },
        { id: 'B02', name: 'Invoice 2026-002', type: 'Sales bill', status: 'Paid' },
        { id: 'B03', name: 'Invoice 2026-003', type: 'Sales bill', status: 'Review' },
      ], [
        createFeatureScreen('list', { en: 'Invoice list', vi: 'Danh sách hóa đơn' }, { en: 'Main list screen', vi: 'Màn hình danh sách chính' }),
        createFeatureScreen('create', { en: 'Create invoice', vi: 'Tạo hóa đơn' }, { en: 'Create page', vi: 'Trang tạo mới' }),
        createFeatureScreen('edit', { en: 'Edit invoice', vi: 'Sửa hóa đơn' }, { en: 'Edit page', vi: 'Trang chỉnh sửa' }),
      ], {
        list: 'bill.jsp',
        create: 'bill.jsp',
        edit: 'bill.jsp',
      }),
    ],
  },
];

// Tạo map tra cứu nhanh module theo `id`.
// Các file sidebar/render sẽ dùng object này thay vì phải duyệt mảng nhiều lần.
window.PMS_ADMIN.moduleMap = window.PMS_ADMIN.moduleGroups
  .flatMap((group) => group.items)
  .reduce((acc, item) => {
    acc[item.id] = item;
    return acc;
  }, {});
