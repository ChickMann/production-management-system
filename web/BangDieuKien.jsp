<%@page contentType="text/html" pageEncoding="UTF-8" import="pms.model.UserDTO"%>
<%
    UserDTO user = (UserDTO) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = user.getUsername() != null ? user.getUsername() : "User";
    String userRole = user.getRole() != null ? user.getRole() : "user";
    boolean isAdmin = "admin".equalsIgnoreCase(userRole);
    String userInitial = userName.isEmpty() ? "U" : userName.substring(0, 1).toUpperCase();
%>
<!DOCTYPE html>
<!--
  Trang dashboard thật sau khi login.
  - Không dùng JSTL để tránh lỗi thiếu thư viện trên Tomcat hiện tại.
  - User lấy trực tiếp từ session backend.
  - Layout admin mới đã được gắn vào JSP thật.
  - Dữ liệu trong các tab hiện vẫn là UI demo/mock để chuẩn bị map dần sang backend thật.
  - Các link backend cũ vẫn được giữ lại ở cuối trang để không gãy flow hiện tại.
-->
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
        <style>
            body {
                font-family: Inter, "Segoe UI", Arial, sans-serif;
            }

            .sidebar {
                box-shadow: 24px 0 48px rgba(15, 23, 42, 0.16);
            }

            .sidebar-overlay {
                position: fixed;
                inset: 0;
                background: rgba(15, 23, 42, 0.48);
                z-index: 20;
            }

            .sidebar[data-collapsed="true"] {
                width: 88px;
            }

            .sidebar[data-collapsed="true"] .sidebar-brand-text,
            .sidebar[data-collapsed="true"] .sidebar-user-text,
            .sidebar[data-collapsed="true"] .nav-group-label,
            .sidebar[data-collapsed="true"] .nav-label,
            .sidebar[data-collapsed="true"] .nav-trailing {
                display: none;
            }

            .sidebar[data-collapsed="true"] .nav-item {
                justify-content: center;
            }

            .nav-item.active {
                background: rgba(20, 184, 166, 0.16);
                color: #ffffff;
                box-shadow: inset 0 0 0 1px rgba(45, 212, 191, 0.22);
            }

            .search-box {
                width: 100%;
                max-width: 440px;
            }

            .search-input {
                width: 100%;
            }

            .quick-links-card a {
                transition: background 0.2s ease, border-color 0.2s ease, transform 0.2s ease;
            }

            .quick-links-card a:hover {
                transform: translateY(-1px);
                background: #f8fafc;
                border-color: #cbd5e1;
            }

            body.dark-mode {
                background: #020617;
                color: #e2e8f0;
            }

            body.dark-mode header {
                background: rgba(15, 23, 42, 0.9);
                border-color: rgba(51, 65, 85, 0.9);
            }

            body.dark-mode main {
                background: #020617;
            }

            body.dark-mode #pageTitle,
            body.dark-mode .panel-title,
            body.dark-mode .panel-value,
            body.dark-mode .panel-heading,
            body.dark-mode .table-head,
            body.dark-mode .table-cell,
            body.dark-mode .form-input,
            body.dark-mode .summary-value,
            body.dark-mode .legacy-link,
            body.dark-mode #headerUser {
                color: #e2e8f0 !important;
            }

            body.dark-mode #pageSubtitle,
            body.dark-mode .panel-subtitle,
            body.dark-mode .summary-label,
            body.dark-mode .quick-links-note,
            body.dark-mode .search-input,
            body.dark-mode .search-input::placeholder {
                color: #94a3b8 !important;
            }

            body.dark-mode .toolbar-btn,
            body.dark-mode .toolbar-user,
            body.dark-mode .module-card,
            body.dark-mode .quick-links-card,
            body.dark-mode .form-input,
            body.dark-mode .form-back,
            body.dark-mode .table-action,
            body.dark-mode .legacy-link,
            body.dark-mode .table-shell {
                background: #0f172a !important;
                border-color: #1e293b !important;
            }

            body.dark-mode .table-head-row {
                background: #111827 !important;
            }

            body.dark-mode .table-row {
                border-color: #1e293b !important;
            }

            body.dark-mode .form-input {
                background: #020617 !important;
            }

            @media (max-width: 1023px) {
                .sidebar[data-collapsed="true"] {
                    width: 18rem;
                }

                .sidebar[data-collapsed="true"] .sidebar-brand-text,
                .sidebar[data-collapsed="true"] .sidebar-user-text,
                .sidebar[data-collapsed="true"] .nav-group-label,
                .sidebar[data-collapsed="true"] .nav-label,
                .sidebar[data-collapsed="true"] .nav-trailing {
                    display: block;
                }
            }
        </style>
    </head>
    <body class="overflow-hidden bg-slate-50 text-slate-900 antialiased">
        <div id="layoutShell" class="h-screen overflow-hidden lg:grid lg:grid-cols-[280px_1fr]">
            <aside
                id="sidebar"
                data-collapsed="false"
                class="sidebar fixed inset-y-0 left-0 z-30 flex h-screen w-72 -translate-x-full flex-col bg-slate-900 text-white transition-transform duration-300 lg:static lg:translate-x-0"
            >
                <div class="flex h-16 shrink-0 items-center gap-3 border-b border-slate-800 px-6">
                    <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-teal-500/10 text-lg text-teal-200">⚙</div>
                    <div class="sidebar-brand-text">
                        <p class="text-sm font-semibold tracking-wide">Admin Workspace</p>
                        <p class="text-xs text-slate-400">Classic layout with simpler content</p>
                    </div>
                </div>

                <nav id="sidebarNav" class="flex-1 overflow-y-auto space-y-6 px-4 py-6" role="tablist"></nav>

                <div class="shrink-0 border-t border-slate-800 px-6 py-4">
                    <div class="flex items-center gap-3">
                        <div class="h-10 w-10 rounded-full bg-teal-500/20 text-center text-sm leading-10 text-teal-200"><%= userInitial %></div>
                        <div class="sidebar-user-text">
                            <p id="userName" class="text-sm font-semibold"><%= userName %></p>
                            <p id="userRoleText" class="text-xs text-slate-400"><%= userRole %></p>
                        </div>
                    </div>
                </div>
            </aside>

            <div class="flex min-h-screen flex-col overflow-hidden">
                <header class="sticky top-0 z-20 flex h-16 items-center justify-between gap-4 border-b border-slate-200 bg-white/90 px-4 backdrop-blur sm:px-6">
                    <div class="flex items-center gap-3">
                        <button id="menuToggle" class="toolbar-btn flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 text-slate-600 hover:bg-slate-100" type="button">☰</button>
                    </div>

                    <div class="flex flex-1 items-center justify-center px-2 sm:px-6">
                        <div id="searchBox" class="search-box relative flex items-center">
                            <input
                                id="searchInput"
                                type="text"
                                placeholder="Search modules or features..."
                                class="search-input rounded-full border border-slate-200 bg-slate-50 py-2 pl-4 pr-4 text-sm text-slate-700 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200"
                            />
                        </div>
                    </div>

                    <div class="flex items-center gap-3">
                        <button id="themeToggle" class="toolbar-btn hidden h-10 w-10 items-center justify-center rounded-full border border-slate-200 text-slate-600 hover:bg-slate-100 sm:flex" title="Theme" type="button">☼</button>
                        <button id="languageToggle" class="toolbar-btn hidden h-10 w-10 items-center justify-center rounded-full border border-slate-200 text-slate-600 hover:bg-slate-100 sm:flex" title="Language" type="button">🌐</button>
                        <button class="toolbar-btn relative flex h-10 w-10 items-center justify-center rounded-full border border-slate-200 text-slate-600 hover:bg-slate-100" title="Notifications" type="button">
                            🔔
                            <span id="notifBadge" class="absolute -right-1 -top-1 flex h-5 w-5 items-center justify-center rounded-full bg-rose-500 text-[10px] text-white">5</span>
                        </button>
                        <div class="toolbar-user hidden text-right sm:block">
                            <p class="text-xs text-slate-500">Welcome,</p>
                            <p id="headerUser" class="text-sm font-semibold text-slate-800"><%= userName %></p>
                        </div>
                    </div>
                </header>

                <main class="flex-1 overflow-y-auto p-4 sm:p-6 lg:p-8">
                    <div class="mb-6 flex flex-col gap-2">
                        <h1 id="pageTitle" class="text-2xl font-semibold text-slate-900">Admin overview</h1>
                        <p id="pageSubtitle" class="text-sm text-slate-500">Classic admin shell with cleaner content inside each tab.</p>
                    </div>

                    <section id="contentArea" class="space-y-6"></section>

                    <section class="quick-links-card mt-6 rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
                        <div class="mb-4 flex flex-wrap items-start justify-between gap-3">
                            <div>
                                <h2 class="text-lg font-semibold text-slate-800">Management pages</h2>
                                <p class="quick-links-note mt-1 text-sm text-slate-500">Chọn phân hệ bạn muốn quản lý để mở màn hình thao tác trực tiếp.</p>
                            </div>
                            <a href="MainController?action=logoutUser" class="legacy-link inline-flex items-center rounded-xl border border-rose-200 px-4 py-2 text-sm font-semibold text-rose-600">Logout</a>
                        </div>

                        <div class="grid gap-3 sm:grid-cols-2 xl:grid-cols-3">
                            <% if (isAdmin) { %>
                                <a href="MainController?action=addUser" class="legacy-link rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium text-slate-700">Add employee</a>
                            <% } %>
                            <a href="MainController?action=searchItem" class="legacy-link rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium text-slate-700">Items</a>
                            <a href="MainController?action=listBOM" class="legacy-link rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium text-slate-700">BOM</a>
                            <a href="MainController?action=listRouting" class="legacy-link rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium text-slate-700">Routing</a>
                            <a href="MainController?action=listRoutingStep" class="legacy-link rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium text-slate-700">Routing Steps</a>
                            <a href="MainController?action=listDefectReason" class="legacy-link rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium text-slate-700">Defect Reasons</a>
                            <a href="MainController?action=searchSupplier" class="legacy-link rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium text-slate-700">Suppliers</a>
                            <a href="MainController?action=searchPurchaseOrder" class="legacy-link rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium text-slate-700">Purchase Orders</a>
                            <a href="MainController?action=listBill" class="legacy-link rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium text-slate-700">Bills</a>
                            <a href="MainController?action=searchCustomer" class="legacy-link rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium text-slate-700">Customers</a>
                            <a href="MainController?action=listProduction" class="legacy-link rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium text-slate-700">Production Logs</a>
                            <a href="MainController?action=listWorkOrder" class="legacy-link rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium text-slate-700">Work Orders</a>
                        </div>
                    </section>
                </main>
            </div>
        </div>

        <div id="sidebarOverlay" class="sidebar-overlay hidden lg:hidden"></div>

        <script>
            window.PMS_ADMIN = {
                SERVER_USER: {
                    name: '<%= userName %>',
                    role: '<%= userRole %>'
                }
            };

            window.PMS_ADMIN.STORAGE_KEYS = {
                tab: "pms-admin-active-tab",
                theme: "pms-theme",
                language: "pms-language"
            };

            window.PMS_ADMIN.dom = {
                contentArea: document.getElementById("contentArea"),
                pageTitle: document.getElementById("pageTitle"),
                pageSubtitle: document.getElementById("pageSubtitle"),
                menuToggle: document.getElementById("menuToggle"),
                sidebar: document.getElementById("sidebar"),
                sidebarOverlay: document.getElementById("sidebarOverlay"),
                userName: document.getElementById("userName"),
                headerUser: document.getElementById("headerUser"),
                notifBadge: document.getElementById("notifBadge"),
                searchBox: document.getElementById("searchBox"),
                searchInput: document.getElementById("searchInput"),
                sidebarNav: document.getElementById("sidebarNav")
            };

            window.PMS_ADMIN.state = {
                currentTheme: localStorage.getItem(window.PMS_ADMIN.STORAGE_KEYS.theme) || "light",
                currentLanguage: localStorage.getItem(window.PMS_ADMIN.STORAGE_KEYS.language) || "en",
                app: {
                    user: {
                        name: window.PMS_ADMIN.SERVER_USER.name || "User",
                        role: window.PMS_ADMIN.SERVER_USER.role || "user"
                    },
                    activeTab: localStorage.getItem(window.PMS_ADMIN.STORAGE_KEYS.tab) || "dashboard",
                    activeScreen: "main",
                    activeRecordId: null
                }
            };

            window.PMS_ADMIN.storage = {
                setTheme: function(value) {
                    localStorage.setItem(window.PMS_ADMIN.STORAGE_KEYS.theme, value);
                },
                setLanguage: function(value) {
                    localStorage.setItem(window.PMS_ADMIN.STORAGE_KEYS.language, value);
                },
                setActiveTab: function(value) {
                    localStorage.setItem(window.PMS_ADMIN.STORAGE_KEYS.tab, value);
                }
            };

            window.PMS_ADMIN.escapeHtml = function(value) {
                return String(value == null ? '' : value)
                    .replace(/&/g, '&')
                    .replace(/</g, '<')
                    .replace(/>/g, '>')
                    .replace(/"/g, '"');
            };

            window.PMS_ADMIN.getText = function(value) {
                if (value && typeof value === "object") {
                    return value[window.PMS_ADMIN.state.currentLanguage] || value.en || "";
                }
                return value || "";
            };

            window.PMS_ADMIN.t = function(key) {
                var dictionary = {
                    en: {
                        dashboardTitle: "Admin overview",
                        dashboardSubtitle: "Classic admin shell with cleaner content inside each tab.",
                        foundation: "Foundation",
                        production: "Production",
                        finance: "Finance",
                        tableTitle: "Records",
                        formView: "Create",
                        status: "Status",
                        save: "Save",
                        reset: "Cancel",
                        summaryTitle: "Module summary",
                        controller: "Controller",
                        dependencies: "Dependencies",
                        actions: "Actions",
                        noDependency: "None",
                        list: "List",
                        create: "Create",
                        edit: "Edit",
                        back: "Back to list",
                        editAction: "Edit",
                        deleteAction: "Delete",
                        createTitle: "Create new record",
                        editTitle: "Update record",
                        noRecord: "No matching record found.",
                        welcomeText: "This dashboard is now mounted inside the real JSP flow. The data in the tabs is still demo UI prepared for backend mapping.",
                        sessionUser: "User",
                        sessionRole: "Role",
                        sessionSource: "Data source",
                        sessionSourceValue: "Loaded from real JSP session"
                    },
                    vi: {
                        dashboardTitle: "Tổng quan quản trị",
                        dashboardSubtitle: "Giữ layout admin cũ nhưng nội dung trong từng tab gọn hơn.",
                        foundation: "Danh mục gốc",
                        production: "Sản xuất",
                        finance: "Tài chính",
                        tableTitle: "Danh sách dữ liệu",
                        formView: "Tạo mới",
                        status: "Trạng thái",
                        save: "Lưu",
                        reset: "Hủy",
                        summaryTitle: "Tóm tắt module",
                        controller: "Controller",
                        dependencies: "Phụ thuộc",
                        actions: "Chức năng",
                        noDependency: "Không có",
                        list: "Danh sách",
                        create: "Tạo mới",
                        edit: "Chỉnh sửa",
                        back: "Quay lại danh sách",
                        editAction: "Sửa",
                        deleteAction: "Xóa",
                        createTitle: "Tạo bản ghi mới",
                        editTitle: "Cập nhật bản ghi",
                        noRecord: "Không tìm thấy bản ghi phù hợp.",
                        welcomeText: "Dashboard này đã nối vào luồng JSP thật. Dữ liệu trong các tab hiện vẫn là UI demo để chuẩn bị map backend.",
                        sessionUser: "Người dùng",
                        sessionRole: "Vai trò",
                        sessionSource: "Nguồn dữ liệu",
                        sessionSourceValue: "Lấy từ session JSP thật"
                    }
                };
                return dictionary[window.PMS_ADMIN.state.currentLanguage][key] || dictionary.en[key] || key;
            };

            window.PMS_ADMIN.renderInfoRow = function(label, value) {
                return "<div class=\"flex flex-col gap-1 border-b border-slate-100 pb-3 last:border-0 last:pb-0\">"
                    + "<span class=\"summary-label text-xs font-semibold uppercase tracking-wide text-slate-500\">" + window.PMS_ADMIN.escapeHtml(label) + "</span>"
                    + "<span class=\"summary-value text-sm text-slate-700\">" + window.PMS_ADMIN.escapeHtml(value) + "</span>"
                    + "</div>";
            };

            window.PMS_ADMIN.moduleGroups = [
                {
                    labelKey: "foundation",
                    items: [
                        { id: "dashboard", type: "dashboard", icon: "🏠", title: { en: "Dashboard", vi: "Bảng điều khiển" }, subtitle: { en: "Overview and quick access.", vi: "Tổng quan và truy cập nhanh." } },
                        { id: "users", icon: "👤", title: { en: "Users", vi: "Người dùng" }, subtitle: { en: "Manage user records.", vi: "Quản lý người dùng." }, controller: "UserController", actions: ["listUser", "addUser", "updateUser"], dependencies: ["Session user"], rows: [
                            { id: "U001", name: "Admin", type: "Administrator", status: "Active" },
                            { id: "U002", name: "Operator", type: "Employee", status: "Active" }
                        ] },
                        { id: "items", icon: "📦", title: { en: "Items", vi: "Vật tư" }, subtitle: { en: "Track items and material codes.", vi: "Theo dõi vật tư và mã hàng." }, controller: "ItemController", actions: ["listItem", "addItem", "updateItem"], dependencies: ["None"], rows: [
                            { id: "I001", name: "Steel Sheet", type: "Raw Material", status: "Ready" },
                            { id: "I002", name: "Bolt Set", type: "Component", status: "Ready" }
                        ] },
                        { id: "suppliers", icon: "🚚", title: { en: "Suppliers", vi: "Nhà cung cấp" }, subtitle: { en: "Supplier list and maintenance.", vi: "Danh sách và bảo trì nhà cung cấp." }, controller: "SupplierController", actions: ["listSupplier", "addSupplier", "updateSupplier"], dependencies: ["None"], rows: [
                            { id: "S001", name: "North Steel", type: "Material", status: "Approved" },
                            { id: "S002", name: "Fastener Hub", type: "Parts", status: "Approved" }
                        ] }
                    ]
                },
                {
                    labelKey: "production",
                    items: [
                        { id: "bom", icon: "🧩", title: { en: "BOM", vi: "BOM" }, subtitle: { en: "Manage bill of materials.", vi: "Quản lý định mức vật tư." }, controller: "BomController", actions: ["listBOM", "addBOM", "updateBOM"], dependencies: ["Items"], rows: [
                            { id: "B001", name: "Bike Frame", type: "Assembly", status: "Draft" },
                            { id: "B002", name: "Control Box", type: "Assembly", status: "Released" }
                        ] },
                        { id: "routing", icon: "🛣", title: { en: "Routing", vi: "Routing" }, subtitle: { en: "Production routes and steps.", vi: "Tuyến sản xuất và công đoạn." }, controller: "RoutingController", actions: ["listRouting", "addRouting", "updateRouting"], dependencies: ["None"], rows: [
                            { id: "R001", name: "Welding Route", type: "Manufacturing", status: "Ready" },
                            { id: "R002", name: "Assembly Route", type: "Manufacturing", status: "Ready" }
                        ] },
                        { id: "work-orders", icon: "🧾", title: { en: "Work Orders", vi: "Lệnh sản xuất" }, subtitle: { en: "Work order execution.", vi: "Theo dõi lệnh sản xuất." }, controller: "WorkOrderController", actions: ["search", "insert", "update"], dependencies: ["Items, Routing"], rows: [
                            { id: "WO01", name: "Frame Batch", type: "Batch", status: "In progress" },
                            { id: "WO02", name: "Control Box Batch", type: "Batch", status: "Planned" }
                        ] },
                        { id: "production-logs", icon: "📋", title: { en: "Production Logs", vi: "Nhật ký sản xuất" }, subtitle: { en: "Capture shop-floor updates.", vi: "Ghi nhận cập nhật sản xuất." }, controller: "ProductionLogController", actions: ["listProduction", "insert", "update"], dependencies: ["Work Orders, Users"], rows: [
                            { id: "PL01", name: "Morning Shift", type: "Log", status: "Submitted" },
                            { id: "PL02", name: "Evening Shift", type: "Log", status: "Draft" }
                        ] }
                    ]
                },
                {
                    labelKey: "finance",
                    items: [
                        { id: "purchase-orders", icon: "🛒", title: { en: "Purchase Orders", vi: "Đơn mua hàng" }, subtitle: { en: "Supplier purchase requests.", vi: "Yêu cầu mua hàng với nhà cung cấp." }, controller: "PurchaseOrderController", actions: ["listPurchaseOrder", "addPurchaseOrder", "updatePurchaseOrder"], dependencies: ["Suppliers, Items"], rows: [
                            { id: "PO01", name: "Steel Material PO", type: "Procurement", status: "Pending" },
                            { id: "PO02", name: "Fastener PO", type: "Procurement", status: "Approved" }
                        ] },
                        { id: "bills", icon: "💳", title: { en: "Bills", vi: "Hóa đơn" }, subtitle: { en: "Billing records and payment state.", vi: "Quản lý hóa đơn và trạng thái thanh toán." }, controller: "BillController", actions: ["listBill", "addBill", "updateBill"], dependencies: ["Customers"], rows: [
                            { id: "BL01", name: "Invoice April", type: "Invoice", status: "Open" },
                            { id: "BL02", name: "Invoice May", type: "Invoice", status: "Paid" }
                        ] }
                    ]
                }
            ];

            window.PMS_ADMIN.moduleMap = {};
            window.PMS_ADMIN.moduleGroups.forEach(function(group) {
                group.items.forEach(function(item) {
                    window.PMS_ADMIN.moduleMap[item.id] = item;
                });
            });

            window.PMS_ADMIN.openModuleScreen = function(screen, recordId) {
                window.PMS_ADMIN.state.app.activeScreen = screen;
                window.PMS_ADMIN.state.app.activeRecordId = recordId || null;
                var current = window.PMS_ADMIN.moduleMap[window.PMS_ADMIN.state.app.activeTab];
                if (current) {
                    window.PMS_ADMIN.renderContent(current);
                }
            };

            window.PMS_ADMIN.matchesKeyword = function(item, keyword) {
                if (!keyword) {
                    return true;
                }
                var searchBlob = [
                    window.PMS_ADMIN.getText(item.title),
                    window.PMS_ADMIN.getText(item.subtitle),
                    item.controller || "",
                    (item.actions || []).join(" ")
                ].join(" ").toLowerCase();
                return searchBlob.indexOf(keyword) >= 0;
            };

            window.PMS_ADMIN.renderSidebarButton = function(item) {
                var isActive = item.id === window.PMS_ADMIN.state.app.activeTab;
                return "<button data-tab=\"" + window.PMS_ADMIN.escapeHtml(item.id) + "\" class=\"nav-item " + (isActive ? "active " : "") + "flex w-full items-center gap-3 rounded-xl px-3 py-2 text-left text-sm font-medium text-slate-200 hover:bg-slate-800\" role=\"tab\" aria-selected=\"" + isActive + "\" aria-controls=\"contentArea\" tabindex=\"" + (isActive ? "0" : "-1") + "\" type=\"button\">"
                    + "<span class=\"flex h-8 w-8 items-center justify-center rounded-lg bg-slate-800 text-teal-300\">" + window.PMS_ADMIN.escapeHtml(item.icon) + "</span>"
                    + "<span class=\"nav-label min-w-0 flex-1 truncate\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.getText(item.title)) + "</span>"
                    + "<span class=\"nav-trailing ml-auto text-xs text-slate-400\">›</span>"
                    + "</button>";
            };

            window.PMS_ADMIN.buildSidebar = function(filterText) {
                var keyword = (filterText || "").trim().toLowerCase();
                var html = window.PMS_ADMIN.moduleGroups.map(function(group) {
                    var visibleItems = group.items.filter(function(item) {
                        return window.PMS_ADMIN.matchesKeyword(item, keyword);
                    });
                    if (!visibleItems.length) {
                        return "";
                    }
                    return "<section class=\"space-y-3\">"
                        + "<p class=\"nav-group-label px-2 text-xs font-semibold uppercase tracking-wider text-slate-400\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t(group.labelKey)) + "</p>"
                        + "<div class=\"space-y-1\">" + visibleItems.map(window.PMS_ADMIN.renderSidebarButton).join("") + "</div>"
                        + "</section>";
                }).join("");
                window.PMS_ADMIN.dom.sidebarNav.innerHTML = html;
                Array.prototype.slice.call(document.querySelectorAll(".nav-item")).forEach(function(item) {
                    item.addEventListener("click", function() {
                        window.PMS_ADMIN.setActiveTab(item.dataset.tab);
                        if (window.innerWidth < 1024) {
                            window.PMS_ADMIN.closeSidebar();
                        }
                    });
                });
            };

            window.PMS_ADMIN.renderDashboard = function() {
                return "<section class=\"grid gap-6 xl:grid-cols-[1.6fr_0.8fr]\">"
                    + "<article class=\"space-y-6\">"
                    + "<div class=\"module-card rounded-2xl bg-white p-6 shadow-sm\">"
                    + "<h3 class=\"panel-heading text-2xl font-semibold text-slate-800\">Welcome, " + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.state.app.user.name) + "</h3>"
                    + "<p class=\"panel-subtitle mt-2 text-sm text-slate-500\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t("welcomeText")) + "</p>"
                    + "</div>"
                    + "<div class=\"grid gap-4 md:grid-cols-3\">"
                    + "<div class=\"module-card rounded-2xl bg-white p-5 shadow-sm\"><p class=\"panel-subtitle text-sm text-slate-500\">Users</p><p class=\"panel-value mt-2 text-2xl font-semibold text-slate-800\">2</p></div>"
                    + "<div class=\"module-card rounded-2xl bg-white p-5 shadow-sm\"><p class=\"panel-subtitle text-sm text-slate-500\">Orders</p><p class=\"panel-value mt-2 text-2xl font-semibold text-slate-800\">5</p></div>"
                    + "<div class=\"module-card rounded-2xl bg-white p-5 shadow-sm\"><p class=\"panel-subtitle text-sm text-slate-500\">Logs</p><p class=\"panel-value mt-2 text-2xl font-semibold text-slate-800\">8</p></div>"
                    + "</div>"
                    + "</article>"
                    + "<aside class=\"space-y-6\">"
                    + "<article class=\"module-card rounded-2xl bg-white p-6 shadow-sm\">"
                    + "<h3 class=\"panel-title text-lg font-semibold text-slate-800\">Session</h3>"
                    + "<div class=\"mt-4 space-y-3\">"
                    + window.PMS_ADMIN.renderInfoRow(window.PMS_ADMIN.t("sessionUser"), window.PMS_ADMIN.state.app.user.name)
                    + window.PMS_ADMIN.renderInfoRow(window.PMS_ADMIN.t("sessionRole"), window.PMS_ADMIN.state.app.user.role)
                    + window.PMS_ADMIN.renderInfoRow(window.PMS_ADMIN.t("sessionSource"), window.PMS_ADMIN.t("sessionSourceValue"))
                    + "</div>"
                    + "</article>"
                    + "</aside>"
                    + "</section>";
            };

            window.PMS_ADMIN.renderListTable = function(module) {
                var rows = module.rows.map(function(row) {
                    return "<tr class=\"table-row border-b border-slate-100 last:border-0\">"
                        + "<td class=\"table-cell px-4 py-3 text-sm text-slate-700\">" + window.PMS_ADMIN.escapeHtml(row.id) + "</td>"
                        + "<td class=\"table-cell px-4 py-3 text-sm text-slate-600\">" + window.PMS_ADMIN.escapeHtml(row.name) + "</td>"
                        + "<td class=\"table-cell px-4 py-3 text-sm text-slate-600\">" + window.PMS_ADMIN.escapeHtml(row.type) + "</td>"
                        + "<td class=\"table-cell px-4 py-3 text-sm text-slate-600\">" + window.PMS_ADMIN.escapeHtml(row.status) + "</td>"
                        + "<td class=\"table-cell px-4 py-3 text-sm text-slate-600\">"
                        + "<div class=\"flex gap-2\">"
                        + "<button class=\"table-action rounded-lg border border-slate-200 px-3 py-1.5 text-xs font-semibold text-slate-700\" type=\"button\" onclick=\"window.PMS_ADMIN.openModuleScreen('edit', '" + window.PMS_ADMIN.escapeHtml(row.id) + "')\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t("editAction")) + "</button>"
                        + "<button class=\"table-action rounded-lg border border-rose-200 px-3 py-1.5 text-xs font-semibold text-rose-600\" type=\"button\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t("deleteAction")) + "</button>"
                        + "</div>"
                        + "</td>"
                        + "</tr>";
                }).join("");

                return "<div class=\"table-shell overflow-hidden rounded-2xl border border-slate-100 bg-white shadow-sm\">"
                    + "<div class=\"flex items-center justify-between border-b border-slate-100 px-4 py-4\">"
                    + "<div><p class=\"panel-title text-sm font-semibold text-slate-800\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t("tableTitle")) + "</p><p class=\"panel-subtitle text-xs text-slate-500\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t("list")) + "</p></div>"
                    + "<button class=\"rounded-xl bg-teal-600 px-4 py-2 text-sm font-semibold text-white\" type=\"button\" onclick=\"window.PMS_ADMIN.openModuleScreen('create')\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t("formView")) + "</button>"
                    + "</div>"
                    + "<div class=\"overflow-x-auto\">"
                    + "<table class=\"min-w-full\">"
                    + "<thead class=\"table-head-row bg-slate-50\"><tr><th class=\"table-head px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500\">ID</th><th class=\"table-head px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500\">Name</th><th class=\"table-head px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500\">Type</th><th class=\"table-head px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t("status")) + "</th><th class=\"table-head px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t("actions")) + "</th></tr></thead>"
                    + "<tbody>" + rows + "</tbody>"
                    + "</table>"
                    + "</div>"
                    + "</div>";
            };

            window.PMS_ADMIN.renderModuleForm = function(module, mode) {
                var record = { id: "", name: "", type: "", status: "" };
                var i;
                for (i = 0; i < module.rows.length; i += 1) {
                    if (module.rows[i].id === window.PMS_ADMIN.state.app.activeRecordId) {
                        record = module.rows[i];
                        break;
                    }
                }

                return "<div class=\"module-card rounded-2xl border border-slate-100 bg-white p-6 shadow-sm\">"
                    + "<div class=\"mb-6 flex items-center justify-between gap-3\">"
                    + "<div><p class=\"panel-subtitle text-xs font-semibold uppercase tracking-wide text-teal-600\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t(mode)) + "</p><h3 class=\"panel-heading mt-1 text-xl font-semibold text-slate-800\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t(mode === "edit" ? "editTitle" : "createTitle")) + "</h3></div>"
                    + "<button class=\"form-back rounded-xl border border-slate-200 px-4 py-2 text-sm font-semibold text-slate-700\" type=\"button\" onclick=\"window.PMS_ADMIN.openModuleScreen('list')\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t("back")) + "</button>"
                    + "</div>"
                    + "<div class=\"grid gap-4 md:grid-cols-2\">"
                    + "<label class=\"block\"><span class=\"panel-subtitle mb-1 block text-xs font-medium uppercase tracking-wide text-slate-500\">ID</span><input class=\"form-input w-full rounded-xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm text-slate-700\" type=\"text\" value=\"" + window.PMS_ADMIN.escapeHtml(record.id) + "\" /></label>"
                    + "<label class=\"block\"><span class=\"panel-subtitle mb-1 block text-xs font-medium uppercase tracking-wide text-slate-500\">Name</span><input class=\"form-input w-full rounded-xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm text-slate-700\" type=\"text\" value=\"" + window.PMS_ADMIN.escapeHtml(record.name) + "\" /></label>"
                    + "<label class=\"block\"><span class=\"panel-subtitle mb-1 block text-xs font-medium uppercase tracking-wide text-slate-500\">Type</span><input class=\"form-input w-full rounded-xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm text-slate-700\" type=\"text\" value=\"" + window.PMS_ADMIN.escapeHtml(record.type) + "\" /></label>"
                    + "<label class=\"block\"><span class=\"panel-subtitle mb-1 block text-xs font-medium uppercase tracking-wide text-slate-500\">Status</span><input class=\"form-input w-full rounded-xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm text-slate-700\" type=\"text\" value=\"" + window.PMS_ADMIN.escapeHtml(record.status) + "\" /></label>"
                    + "</div>"
                    + "<div class=\"mt-6 flex gap-3\">"
                    + "<button class=\"rounded-xl bg-teal-600 px-4 py-2.5 text-sm font-semibold text-white\" type=\"button\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t("save")) + "</button>"
                    + "<button class=\"form-back rounded-xl border border-slate-200 px-4 py-2.5 text-sm font-semibold text-slate-600\" type=\"button\" onclick=\"window.PMS_ADMIN.openModuleScreen('list')\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t("reset")) + "</button>"
                    + "</div>"
                    + "</div>";
            };

            window.PMS_ADMIN.renderModule = function(module) {
                var screen = window.PMS_ADMIN.state.app.activeScreen || "list";
                var isForm = screen === "create" || screen === "edit";
                return "<section class=\"grid gap-6 xl:grid-cols-[1.6fr_0.8fr]\">"
                    + "<article class=\"space-y-6\">"
                    + "<div class=\"module-card rounded-2xl bg-white p-6 shadow-sm\">"
                    + "<div class=\"flex flex-wrap items-start justify-between gap-4\">"
                    + "<div class=\"flex items-center gap-3\">"
                    + "<span class=\"inline-flex h-11 w-11 items-center justify-center rounded-2xl bg-teal-500/10 text-lg text-teal-700\">" + window.PMS_ADMIN.escapeHtml(module.icon) + "</span>"
                    + "<div><h3 class=\"panel-heading text-xl font-semibold text-slate-800\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.getText(module.title)) + "</h3><p class=\"panel-subtitle mt-1 text-sm text-slate-500\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.getText(module.subtitle)) + "</p></div>"
                    + "</div>"
                    + "<div class=\"rounded-full bg-slate-100 px-3 py-1 text-xs font-semibold text-slate-600\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t(isForm ? screen : "list")) + "</div>"
                    + "</div>"
                    + "</div>"
                    + (isForm ? window.PMS_ADMIN.renderModuleForm(module, screen) : window.PMS_ADMIN.renderListTable(module))
                    + "</article>"
                    + "<aside class=\"space-y-6\">"
                    + "<article class=\"module-card rounded-2xl bg-white p-6 shadow-sm\">"
                    + "<h3 class=\"panel-title text-lg font-semibold text-slate-800\">" + window.PMS_ADMIN.escapeHtml(window.PMS_ADMIN.t("summaryTitle")) + "</h3>"
                    + "<div class=\"mt-4 space-y-3\">"
                    + window.PMS_ADMIN.renderInfoRow(window.PMS_ADMIN.t("controller"), module.controller)
                    + window.PMS_ADMIN.renderInfoRow(window.PMS_ADMIN.t("dependencies"), (module.dependencies || []).join(", ") || window.PMS_ADMIN.t("noDependency"))
                    + window.PMS_ADMIN.renderInfoRow(window.PMS_ADMIN.t("actions"), (module.actions || []).join(", "))
                    + "</div>"
                    + "</article>"
                    + "</aside>"
                    + "</section>";
            };

            window.PMS_ADMIN.updatePageHeading = function(current) {
                var title = current.id === "dashboard" ? window.PMS_ADMIN.t("dashboardTitle") : window.PMS_ADMIN.getText(current.title);
                var subtitle = current.id === "dashboard" ? window.PMS_ADMIN.t("dashboardSubtitle") : window.PMS_ADMIN.getText(current.subtitle);
                window.PMS_ADMIN.dom.pageTitle.textContent = title;
                window.PMS_ADMIN.dom.pageSubtitle.textContent = subtitle;
            };

            window.PMS_ADMIN.renderContent = function(current) {
                window.PMS_ADMIN.dom.contentArea.innerHTML = current.type === "dashboard"
                    ? window.PMS_ADMIN.renderDashboard()
                    : window.PMS_ADMIN.renderModule(current);
            };

            window.PMS_ADMIN.setActiveTab = function(tabId) {
                var fallbackTab = window.PMS_ADMIN.moduleMap[tabId] ? tabId : "dashboard";
                var current = window.PMS_ADMIN.moduleMap[fallbackTab] || window.PMS_ADMIN.moduleMap.dashboard;
                window.PMS_ADMIN.state.app.activeTab = fallbackTab;
                window.PMS_ADMIN.state.app.activeScreen = "main";
                window.PMS_ADMIN.storage.setActiveTab(fallbackTab);
                window.PMS_ADMIN.updatePageHeading(current);
                window.PMS_ADMIN.buildSidebar(window.PMS_ADMIN.dom.searchInput.value || "");
                window.PMS_ADMIN.renderContent(current);
            };

            window.PMS_ADMIN.initUser = function() {
                var roleText = window.PMS_ADMIN.state.app.user.role;
                if (roleText === "admin") {
                    roleText = "Administrator";
                }
                window.PMS_ADMIN.dom.userName.textContent = window.PMS_ADMIN.state.app.user.name;
                window.PMS_ADMIN.dom.headerUser.textContent = window.PMS_ADMIN.state.app.user.name;
                document.getElementById("userRoleText").textContent = roleText;
            };

            window.PMS_ADMIN.closeSidebar = function() {
                if (window.innerWidth >= 1024) {
                    window.PMS_ADMIN.dom.sidebar.dataset.collapsed = "true";
                    return;
                }
                window.PMS_ADMIN.dom.sidebar.classList.add("-translate-x-full");
                window.PMS_ADMIN.dom.sidebarOverlay.classList.add("hidden");
            };

            window.PMS_ADMIN.openSidebar = function() {
                if (window.innerWidth >= 1024) {
                    window.PMS_ADMIN.dom.sidebar.dataset.collapsed = "false";
                    return;
                }
                window.PMS_ADMIN.dom.sidebar.classList.remove("-translate-x-full");
                window.PMS_ADMIN.dom.sidebarOverlay.classList.remove("hidden");
            };

            window.PMS_ADMIN.applyTheme = function() {
                document.body.classList.toggle("dark-mode", window.PMS_ADMIN.state.currentTheme === "dark");
            };

            window.PMS_ADMIN.handleThemeToggle = function() {
                window.PMS_ADMIN.state.currentTheme = window.PMS_ADMIN.state.currentTheme === "dark" ? "light" : "dark";
                window.PMS_ADMIN.storage.setTheme(window.PMS_ADMIN.state.currentTheme);
                window.PMS_ADMIN.applyTheme();
            };

            window.PMS_ADMIN.applyLanguage = function() {
                var current = window.PMS_ADMIN.moduleMap[window.PMS_ADMIN.state.app.activeTab] || window.PMS_ADMIN.moduleMap.dashboard;
                window.PMS_ADMIN.buildSidebar(window.PMS_ADMIN.dom.searchInput.value || "");
                window.PMS_ADMIN.updatePageHeading(current);
                window.PMS_ADMIN.renderContent(current);
            };

            window.PMS_ADMIN.handleLanguageToggle = function() {
                window.PMS_ADMIN.state.currentLanguage = window.PMS_ADMIN.state.currentLanguage === "en" ? "vi" : "en";
                window.PMS_ADMIN.storage.setLanguage(window.PMS_ADMIN.state.currentLanguage);
                window.PMS_ADMIN.applyLanguage();
            };

            window.PMS_ADMIN.bindGlobalEvents = function() {
                window.PMS_ADMIN.dom.menuToggle.addEventListener("click", function() {
                    if (window.innerWidth >= 1024) {
                        if (window.PMS_ADMIN.dom.sidebar.dataset.collapsed === "true") {
                            window.PMS_ADMIN.openSidebar();
                        } else {
                            window.PMS_ADMIN.closeSidebar();
                        }
                        return;
                    }
                    if (window.PMS_ADMIN.dom.sidebar.classList.contains("-translate-x-full")) {
                        window.PMS_ADMIN.openSidebar();
                    } else {
                        window.PMS_ADMIN.closeSidebar();
                    }
                });
                window.PMS_ADMIN.dom.sidebarOverlay.addEventListener("click", window.PMS_ADMIN.closeSidebar);
                document.getElementById("themeToggle").addEventListener("click", window.PMS_ADMIN.handleThemeToggle);
                document.getElementById("languageToggle").addEventListener("click", window.PMS_ADMIN.handleLanguageToggle);
                window.PMS_ADMIN.dom.searchInput.addEventListener("input", function(event) {
                    window.PMS_ADMIN.buildSidebar(event.target.value);
                });
            };

            window.PMS_ADMIN.bootstrap = function() {
                window.PMS_ADMIN.initUser();
                window.PMS_ADMIN.buildSidebar("");
                window.PMS_ADMIN.applyTheme();
                window.PMS_ADMIN.bindGlobalEvents();
                window.PMS_ADMIN.setActiveTab(window.PMS_ADMIN.state.app.activeTab);
            };

            window.PMS_ADMIN.bootstrap();
        </script>
    </body>
</html>
