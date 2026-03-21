<%@page import="pms.model.BOMDTO"%>
<%@page import="pms.model.ItemDTO"%>
<%@page import="java.util.List"%>
<%@page import="pms.model.UserDTO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    String getStatusClass(String status) {
        if ("active".equals(status)) return "bg-emerald-100 text-emerald-700";
        if ("inactive".equals(status)) return "bg-slate-100 text-slate-600";
        return "bg-amber-100 text-amber-700";
    }

    String getStatusText(String status) {
        if ("active".equals(status)) return "Đang dùng";
        if ("inactive".equals(status)) return "Ngừng";
        return "Chờ duyệt";
    }
%>
<%
    List<BOMDTO> boms = (List<BOMDTO>) request.getAttribute("boms");
    List<ItemDTO> products = (List<ItemDTO>) request.getAttribute("products");
    UserDTO user = (UserDTO) session.getAttribute("user");
    String msg = (String) request.getAttribute("msg");
    String error = (String) request.getAttribute("error");
    String keyword = request.getParameter("keyword");
    String statusFilter = request.getParameter("status");

    if (boms == null) boms = new java.util.ArrayList<>();
    if (products == null) products = new java.util.ArrayList<>();

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

    String userName = user != null ? user.getUsername() : "User";
    String userRole = user != null ? user.getRole() : "user";
    String userInitial = userName.substring(0, 1).toUpperCase();
    Boolean sessionDark = (Boolean) session.getAttribute("darkMode");
    boolean isAdmin = "admin".equalsIgnoreCase(userRole);
    boolean isDarkMode = sessionDark != null ? sessionDark : false;
    String activePage = "bom";
    String pageTitle = "Quản lý định mức (BOM)";
    String lang = session.getAttribute("lang") != null ? (String) session.getAttribute("lang") : "vi";
    request.setAttribute("activePage", activePage);
    request.setAttribute("pageTitle", pageTitle);

    int totalBOMs = boms.size();
    int activeCount = 0, inactiveCount = 0, pendingCount = 0;
    for (BOMDTO bom : boms) {
        if ("active".equals(bom.getStatus())) activeCount++;
        else if ("inactive".equals(bom.getStatus())) inactiveCount++;
        else if ("pending".equals(bom.getStatus())) pendingCount++;
    }
%>
<!DOCTYPE html>
<html lang="<%= lang %>" class="<%= isDarkMode ? "dark" : "" %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý định mức (BOM) - PMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', 'Segoe UI', 'Arial', 'sans-serif'],
                    }
                }
            }
        }
    </script>
    <style>
        body { font-family: Inter, "Segoe UI", Arial, sans-serif; }
        .sidebar { box-shadow: 24px 0 48px rgba(15, 23, 42, 0.16); }
        .sidebar-overlay { position: fixed; inset: 0; background: rgba(15, 23, 42, 0.48); z-index: 20; }
        .form-input {
            background: #ffffff;
            border-color: #e2e8f0;
            color: #0f172a;
            transition: all 0.2s ease;
        }
        .form-input:focus {
            border-color: #0d9488;
            box-shadow: 0 0 0 3px rgba(20, 184, 166, 0.1);
        }
        .dark .form-input {
            background: #0f172a;
            border-color: #334155;
            color: #e2e8f0;
        }
        .dark .form-input::placeholder {
            color: #64748b;
        }
        .sidebar-fixed {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            z-index: 40;
        }
        .sidebar-header {
            position: sticky;
            top: 0;
            background: #0f172a;
            z-index: 10;
        }
        .sidebar-nav {
            flex: 1;
            overflow-y: auto;
            scrollbar-width: thin;
            scrollbar-color: #475569 #1e293b;
        }
        .sidebar-nav::-webkit-scrollbar { width: 4px; }
        .sidebar-nav::-webkit-scrollbar-track { background: #1e293b; }
        .sidebar-nav::-webkit-scrollbar-thumb { background: #475569; border-radius: 2px; }
        .sidebar-footer {
            position: sticky;
            bottom: 0;
            background: #0f172a;
            z-index: 10;
        }
        .main-wrapper {
            margin-left: 0;
            transition: margin-left 0.3s ease;
        }
        @media (min-width: 1024px) {
            .main-wrapper { margin-left: 280px; }
        }
        .kpi-card { transition: all 0.2s ease; }
        .kpi-card:hover { transform: translateY(-2px); box-shadow: 0 18px 40px rgba(15, 23, 42, 0.08); }
        .dark .kpi-card:hover { box-shadow: 0 20px 45px rgba(2, 6, 23, 0.45); }
        .section-card {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(12px);
        }
        .dark .section-card {
            background: rgba(15,23,42,0.92);
        }
    </style>
    <script src="js/common.js"></script>
</head>
<body class="bg-slate-100 text-slate-900 min-h-screen antialiased <%= isDarkMode ? "dark dark-mode-init" : "" %>">
    <div class="min-h-screen flex">
        <jsp:include page="components/shared-sidebar.jsp" />
        
        <!-- Main Content -->
        <div id="mainWrapper" class="main-wrapper flex-1 flex flex-col min-h-screen min-w-0">
            <jsp:include page="components/shared-header.jsp" />

            <main class="flex-1 overflow-y-auto p-4 lg:p-6 bg-slate-100 dark:bg-slate-900">
                <!-- Page Header -->
                <div class="mb-6 flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                    <div>
                        <h1 class="text-2xl font-semibold text-slate-900 dark:text-slate-100">Quản lý định mức (BOM)</h1>
                        <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Theo dõi cấu trúc nguyên vật liệu, phiên bản áp dụng và trạng thái sử dụng cho từng sản phẩm.</p>
                    </div>
                    <div class="flex flex-wrap items-center gap-3">
                        <a href="BOMController?action=list" class="inline-flex items-center gap-2 rounded-2xl border border-slate-200 bg-white px-4 py-2.5 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700">
                            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
                            </svg>
                            Làm mới
                        </a>
                        <button type="button" onclick="openBomModal()" class="inline-flex items-center gap-2 rounded-2xl bg-teal-600 px-5 py-2.5 font-semibold text-white shadow-sm shadow-teal-500/30 transition-all hover:bg-teal-700">
                            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                            </svg>
                            Tạo BOM mới
                        </button>
                    </div>
                </div>

                <!-- Alerts -->
                <% if (msg != null && !msg.trim().isEmpty()) { %>
                <div class="mb-6 p-4 rounded-2xl bg-emerald-50 dark:bg-emerald-500/10 border border-emerald-200 dark:border-emerald-500/20 text-emerald-700 dark:text-emerald-300 flex items-center gap-3 shadow-sm">
                    <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <%= msg %>
                </div>
                <% } %>
                <% if (error != null && !error.trim().isEmpty()) { %>
                <div class="mb-6 p-4 rounded-2xl bg-red-50 dark:bg-red-500/10 border border-red-200 dark:border-red-500/20 text-red-700 dark:text-red-300 flex items-center gap-3 shadow-sm">
                    <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <%= error %>
                </div>
                <% } %>

                <!-- Stats Cards -->
                <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4 mb-6">
                    <div class="kpi-card bg-white dark:bg-slate-800 rounded-2xl p-5 shadow-sm border border-blue-200 dark:border-blue-500/30 border-t-4 border-t-blue-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Tổng BOM</p>
                                <p class="mt-2 text-3xl font-bold text-slate-800 dark:text-slate-100"><%= totalBOMs %></p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 dark:bg-blue-500/10 text-blue-600 dark:text-blue-300 text-2xl">&#129513;</div>
                        </div>
                    </div>
                    <div class="kpi-card bg-white dark:bg-slate-800 rounded-2xl p-5 shadow-sm border border-emerald-200 dark:border-emerald-500/30 border-t-4 border-t-emerald-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Đang dùng</p>
                                <p class="mt-2 text-3xl font-bold text-emerald-600 dark:text-emerald-300"><%= activeCount %></p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-emerald-50 dark:bg-emerald-500/10 text-emerald-600 dark:text-emerald-300 text-2xl">&#10004;</div>
                        </div>
                    </div>
                    <div class="kpi-card bg-white dark:bg-slate-800 rounded-2xl p-5 shadow-sm border border-amber-200 dark:border-amber-500/30 border-t-4 border-t-amber-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Chờ duyệt</p>
                                <p class="mt-2 text-3xl font-bold text-amber-600 dark:text-amber-300"><%= pendingCount %></p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-amber-50 dark:bg-amber-500/10 text-amber-600 dark:text-amber-300 text-2xl">&#9203;</div>
                        </div>
                    </div>
                    <div class="kpi-card bg-white dark:bg-slate-800 rounded-2xl p-5 shadow-sm border border-rose-200 dark:border-rose-500/30 border-t-4 border-t-rose-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Ngừng</p>
                                <p class="mt-2 text-3xl font-bold text-slate-600 dark:text-slate-300"><%= inactiveCount %></p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-slate-50 dark:bg-slate-700 text-slate-600 dark:text-slate-300 text-2xl">&#10006;</div>
                        </div>
                    </div>
                </div>

                <!-- Search & Filter -->
                <div class="section-card mb-6 rounded-3xl border border-slate-200 p-4 shadow-sm dark:border-slate-700 sm:p-5">
                    <div class="mb-4 flex flex-col gap-1 sm:flex-row sm:items-center sm:justify-between">
                        <div>
                            <h2 class="text-base font-semibold text-slate-900 dark:text-slate-100">Bộ lọc danh sách BOM</h2>
                            <p class="text-sm text-slate-500 dark:text-slate-400">Tìm nhanh theo tên sản phẩm hoặc lọc theo trạng thái áp dụng.</p>
                        </div>
                        <span class="inline-flex items-center rounded-full bg-slate-100 px-3 py-1 text-xs font-semibold text-slate-600 dark:bg-slate-800 dark:text-slate-300">
                            <%= totalBOMs %> bản ghi
                        </span>
                    </div>
                    <form method="get" action="BOMController" class="flex flex-col gap-4 xl:flex-row">
                        <input type="hidden" name="action" value="search">
                        <div class="flex-1 relative">
                            <input type="text" name="keyword" value="<%= keyword != null ? keyword : "" %>"
                                   placeholder="Tìm theo tên sản phẩm..."
                                   class="w-full rounded-2xl border border-slate-200 py-3 pl-10 pr-4 transition-all form-input dark:border-slate-700">
                            <svg class="absolute left-3 top-1/2 h-5 w-5 -translate-y-1/2 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                            </svg>
                        </div>
                        <select name="status" class="rounded-2xl border border-slate-200 px-4 py-3 transition-all form-input dark:border-slate-700 xl:min-w-[220px]">
                            <option value="">Tất cả trạng thái</option>
                            <option value="active" <%= "active".equals(statusFilter) ? "selected" : "" %>>Đang dùng</option>
                            <option value="pending" <%= "pending".equals(statusFilter) ? "selected" : "" %>>Chờ duyệt</option>
                            <option value="inactive" <%= "inactive".equals(statusFilter) ? "selected" : "" %>>Ngừng</option>
                        </select>
                        <div class="flex gap-3">
                            <button type="submit" class="inline-flex items-center justify-center rounded-2xl bg-teal-600 px-6 py-3 font-semibold text-white shadow-sm shadow-teal-500/30 transition-all hover:bg-teal-700">
                                Tìm kiếm
                            </button>
                            <a href="BOMController?action=list" class="inline-flex items-center justify-center rounded-2xl border border-slate-200 bg-white px-5 py-3 font-semibold text-slate-600 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700">
                                Xóa lọc
                            </a>
                        </div>
                    </form>
                </div>

                <!-- BOM Table -->
                <div class="section-card overflow-hidden rounded-3xl border border-slate-200 shadow-sm dark:border-slate-700">
                    <div class="flex flex-col gap-2 border-b border-slate-100 px-4 py-4 dark:border-slate-700 sm:flex-row sm:items-center sm:justify-between sm:px-6">
                        <div>
                            <h2 class="text-base font-semibold text-slate-900 dark:text-slate-100">Danh sách định mức vật tư</h2>
                            <p class="text-sm text-slate-500 dark:text-slate-400">Theo dõi phiên bản BOM, trạng thái áp dụng và thao tác nhanh trên từng sản phẩm.</p>
                        </div>
                        <span class="inline-flex items-center rounded-full bg-teal-50 px-3 py-1 text-xs font-semibold text-teal-700 dark:bg-teal-500/10 dark:text-teal-300">
                            BOM đang hiển thị: <%= boms.size() %>
                        </span>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="border-b border-slate-100 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/80">
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Mã BOM</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Sản phẩm</th>
                                    <th class="px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Phiên bản</th>
                                    <th class="px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Trạng thái</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Ngày tạo</th>
                                    <th class="px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (boms.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="px-4 py-14 text-center text-slate-400 dark:text-slate-500">
                                        <div class="mx-auto flex max-w-md flex-col items-center gap-3">
                                            <div class="flex h-16 w-16 items-center justify-center rounded-3xl bg-slate-100 text-slate-400 dark:bg-slate-800 dark:text-slate-500">
                                                <svg class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                                </svg>
                                            </div>
                                            <div>
                                                <p class="text-base font-semibold text-slate-700 dark:text-slate-200">Chưa có BOM nào</p>
                                                <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Tạo BOM mới để quản lý định mức nguyên vật liệu cho sản phẩm.</p>
                                            </div>
                                            <button type="button" onclick="openBomModal()" class="inline-flex items-center gap-2 rounded-2xl bg-teal-600 px-4 py-2.5 text-sm font-semibold text-white shadow-sm shadow-teal-500/30 transition-all hover:bg-teal-700">
                                                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                                                </svg>
                                                Tạo BOM mới
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <% } else { %>
                                    <% for (BOMDTO bom : boms) { %>
                                    <tr class="border-b border-slate-50 dark:border-slate-800 last:border-0 hover:bg-slate-50 dark:hover:bg-slate-800/60 transition-colors">
                                        <td class="px-4 py-3">
                                            <span class="font-bold text-teal-600">#BOM-<%= bom.getBomId() %></span>
                                        </td>
                                        <td class="px-4 py-3">
                                            <div class="flex items-center gap-3">
                                                <div class="w-10 h-10 rounded-2xl bg-gradient-to-br from-teal-400 to-cyan-500 flex items-center justify-center text-white font-bold text-sm shadow-sm shadow-teal-500/30">
                                                    <%= bom.getProductName() != null ? bom.getProductName().substring(0, 1).toUpperCase() : "?" %>
                                                </div>
                                                <div>
                                                    <p class="font-medium text-slate-700 dark:text-slate-200"><%= bom.getProductName() != null ? bom.getProductName() : "ID: " + bom.getProductItemId() %></p>
                                                    <p class="text-xs text-slate-400 dark:text-slate-500">Mã sản phẩm: <%= bom.getProductItemId() %></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-4 py-3 text-center">
                                            <span class="px-3 py-1 rounded-full bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-300 text-sm font-medium">
                                                <%= bom.getBomVersion() != null ? bom.getBomVersion() : "v1.0" %>
                                            </span>
                                        </td>
                                        <td class="px-4 py-3 text-center">
                                            <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold <%= getStatusClass(bom.getStatus()) %>">
                                                <%= getStatusText(bom.getStatus()) %>
                                            </span>
                                        </td>
                                        <td class="px-4 py-3 text-slate-500 dark:text-slate-400">
                                            <%= bom.getCreatedDate() != null ? sdf.format(bom.getCreatedDate()) : "-" %>
                                        </td>
                                        <td class="px-4 py-3 text-center">
                                            <div class="flex items-center justify-center gap-2">
                                                <a href="BOMController?action=viewBOM&id=<%= bom.getBomId() %>" 
                                                   class="p-2 rounded-xl text-slate-500 transition-colors hover:bg-blue-100 hover:text-blue-600 dark:text-slate-400 dark:hover:bg-blue-500/10 dark:hover:text-blue-300" title="Xem chi tiết">
                                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                                    </svg>
                                                </a>
                                                <a href="BOMController?action=editBOM&id=<%= bom.getBomId() %>" 
                                                   class="p-2 rounded-xl text-slate-500 transition-colors hover:bg-amber-100 hover:text-amber-600 dark:text-slate-400 dark:hover:bg-amber-500/10 dark:hover:text-amber-300" title="Chỉnh sửa">
                                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                                    </svg>
                                                </a>
                                                <a href="BOMController?action=cloneBOM&id=<%= bom.getBomId() %>" 
                                                   onclick="return confirm('Nhân bản BOM này thành phiên bản mới?')"
                                                   class="p-2 rounded-xl text-slate-500 transition-colors hover:bg-purple-100 hover:text-purple-600 dark:text-slate-400 dark:hover:bg-purple-500/10 dark:hover:text-purple-300" title="Nhân bản">
                                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"/>
                                                    </svg>
                                                </a>
                                                <% if ("active".equals(bom.getStatus())) { %>
                                                <a href="BOMController?action=deactivateBOM&id=<%= bom.getBomId() %>" 
                                                   onclick="return confirm('Ngừng sử dụng BOM này?')"
                                                   class="p-2 rounded-xl text-slate-500 transition-colors hover:bg-slate-100 hover:text-slate-600 dark:text-slate-400 dark:hover:bg-slate-700 dark:hover:text-slate-200" title="Ngừng">
                                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 10a1 1 0 011-1h4a1 1 0 011 1v4a1 1 0 01-1 1h-4a1 1 0 01-1-1v-4z"/>
                                                    </svg>
                                                </a>
                                                <% } else { %>
                                                <a href="BOMController?action=activateBOM&id=<%= bom.getBomId() %>" 
                                                   class="p-2 rounded-xl text-slate-500 transition-colors hover:bg-emerald-100 hover:text-emerald-600 dark:text-slate-400 dark:hover:bg-emerald-500/10 dark:hover:text-emerald-300" title="Kích hoạt">
                                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z"/>
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                                    </svg>
                                                </a>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% if (!boms.isEmpty()) { %>
                    <div class="border-t border-slate-100 bg-slate-50 px-4 py-3 text-sm text-slate-500 dark:border-slate-700 dark:bg-slate-800/80 dark:text-slate-400">
                        Tổng cộng: <span class="font-semibold"><%= boms.size() %></span> BOM
                    </div>
                    <% } %>
                </div>
            </main>
        </div>
    </div>

    <div id="bomModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-950/60 px-4 py-6 backdrop-blur-sm">
        <div class="w-full max-w-2xl overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-2xl dark:border-slate-700 dark:bg-slate-900">
            <div class="flex items-start justify-between border-b border-slate-100 px-6 py-5 dark:border-slate-800">
                <div>
                    <h3 class="text-lg font-semibold text-slate-900 dark:text-slate-100">Tạo BOM mới</h3>
                    <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Tạo nhanh định mức vật tư ngay trên màn hình danh sách.</p>
                </div>
                <button type="button" onclick="closeBomModal()" class="rounded-2xl p-2 text-slate-400 transition-colors hover:bg-slate-100 hover:text-slate-600 dark:hover:bg-slate-800 dark:hover:text-slate-300">
                    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
            </div>
            <form method="post" action="BOMController" class="space-y-6 px-6 py-6">
                <input type="hidden" name="action" value="saveAddBOM">
                <div class="grid gap-5 md:grid-cols-2">
                    <div class="md:col-span-2">
                        <label class="mb-2 block text-sm font-semibold text-slate-700 dark:text-slate-200">Sản phẩm áp dụng</label>
                        <select name="productItemId" class="form-input w-full rounded-2xl border border-slate-200 px-4 py-3 dark:border-slate-700" required>
                            <option value="">-- Chọn sản phẩm --</option>
                            <% for (ItemDTO product : products) { %>
                            <option value="<%= product.getItemID() %>"><%= product.getItemName() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-semibold text-slate-700 dark:text-slate-200">Phiên bản BOM</label>
                        <input type="text" name="version" value="v1.0" class="form-input w-full rounded-2xl border border-slate-200 px-4 py-3 dark:border-slate-700" placeholder="VD: v1.0" required>
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-semibold text-slate-700 dark:text-slate-200">Trạng thái</label>
                        <select name="status" class="form-input w-full rounded-2xl border border-slate-200 px-4 py-3 dark:border-slate-700">
                            <option value="active">Đang dùng</option>
                            <option value="pending">Chờ duyệt</option>
                            <option value="inactive">Ngừng</option>
                        </select>
                    </div>
                    <div class="md:col-span-2">
                        <label class="mb-2 block text-sm font-semibold text-slate-700 dark:text-slate-200">Ghi chú</label>
                        <textarea name="notes" rows="4" class="form-input w-full rounded-2xl border border-slate-200 px-4 py-3 dark:border-slate-700" placeholder="Thêm ghi chú cho BOM nếu cần..."></textarea>
                    </div>
                </div>
                <div class="flex flex-col-reverse gap-3 border-t border-slate-100 pt-5 dark:border-slate-800 sm:flex-row sm:justify-end">
                    <button type="button" onclick="closeBomModal()" class="inline-flex items-center justify-center rounded-2xl border border-slate-200 bg-white px-5 py-2.5 font-semibold text-slate-600 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700">Hủy</button>
                    <button type="submit" class="inline-flex items-center justify-center gap-2 rounded-2xl bg-teal-600 px-5 py-2.5 font-semibold text-white shadow-sm shadow-teal-500/30 transition-all hover:bg-teal-700">
                        <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                        </svg>
                        Tạo BOM mới
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div id="sidebarOverlay" class="sidebar-overlay hidden lg:hidden"></div>

    <script>
        // Sidebar toggle
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebarOverlay');
        const bomModal = document.getElementById('bomModal');

        function openBomModal() {
            if (!bomModal) return;
            bomModal.classList.remove('hidden');
            bomModal.classList.add('flex');
            document.body.classList.add('overflow-hidden');
        }

        function closeBomModal() {
            if (!bomModal) return;
            bomModal.classList.add('hidden');
            bomModal.classList.remove('flex');
            document.body.classList.remove('overflow-hidden');
        }

        if (menuToggle && sidebar && overlay) {
            menuToggle.addEventListener('click', function() {
                if (window.innerWidth >= 1024) {
                    const collapsed = sidebar.dataset.collapsed === 'true';
                    sidebar.dataset.collapsed = (!collapsed).toString();
                } else {
                    sidebar.classList.toggle('-translate-x-full');
                    overlay.classList.toggle('hidden');
                }
            });

            overlay.addEventListener('click', function() {
                sidebar.classList.add('-translate-x-full');
                overlay.classList.add('hidden');
            });
        }

        if (bomModal) {
            bomModal.addEventListener('click', function(event) {
                if (event.target === bomModal) {
                    closeBomModal();
                }
            });
        }

        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeBomModal();
            }
        });
    </script>
</body>
</html>
