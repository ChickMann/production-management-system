<%@page import="java.util.ArrayList, java.util.List"%>
<%@page import="pms.model.WorkOrderDTO"%>
<%@page import="pms.model.ItemDTO"%>
<%@page import="pms.model.RoutingDTO"%>
<%@page import="pms.model.UserDTO"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    
    WorkOrderDTO wo = (WorkOrderDTO) request.getAttribute("WORKORDER");
    List<WorkOrderDTO> workOrders = (List<WorkOrderDTO>) request.getAttribute("workOrders");
    List<ItemDTO> items = (List<ItemDTO>) request.getAttribute("items");
    List<RoutingDTO> routings = (List<RoutingDTO>) request.getAttribute("routings");
    UserDTO user = (UserDTO) session.getAttribute("user");
    List<pms.utils.NotificationService.Notification> notifications = (List<pms.utils.NotificationService.Notification>) session.getAttribute("notifications");
    
    String msg = (String) request.getAttribute("msg");
    String error = (String) request.getAttribute("error");
    String searchKeyword = request.getParameter("keyword");
    String filterStatus = request.getParameter("status");
    
    if (workOrders == null) workOrders = new ArrayList<>();
    if (items == null) items = new ArrayList<>();
    if (routings == null) routings = new ArrayList<>();
    if (notifications == null) notifications = new ArrayList<>();
    
    String activePage = "workorder"; // Trang hiện tại cho sidebar
    String userName = user != null ? user.getUsername() : "User";
    String userRole = user != null ? user.getRole() : "user";
    String userInitial = userName.substring(0, 1).toUpperCase();
    boolean isAdmin = "admin".equalsIgnoreCase(userRole);
    
    Boolean sessionDark = (Boolean) session.getAttribute("darkMode");
    boolean isDarkMode = sessionDark != null ? sessionDark : false;
    
    String lang = session.getAttribute("lang") != null ? (String) session.getAttribute("lang") : "vi";
    String pageTitle = "Quản Lý Lệnh Sản Xuất"; // Tiêu đề cho header
    int unreadCount = 0;
    for (pms.utils.NotificationService.Notification n : notifications) {
        if (!n.isRead()) unreadCount++;
    }
    
    // Stats
    int totalWO = workOrders.size();
    int newCount = 0, inProgressCount = 0, completedCount = 0;
    for (WorkOrderDTO w : workOrders) {
        if (w.getStatus() != null) {
            if (w.getStatus().equalsIgnoreCase("New")) newCount++;
            else if (w.getStatus().equalsIgnoreCase("In Progress") || w.getStatus().equalsIgnoreCase("InProgress")) inProgressCount++;
            else if (w.getStatus().equalsIgnoreCase("Completed")) completedCount++;
        }
    }
    
    request.setAttribute("activePage", activePage);
    request.setAttribute("pageTitle", pageTitle);
%>
<%!
    String getProductName(WorkOrderDTO w, List<ItemDTO> items) {
        if (w.getProductName() != null && !w.getProductName().isEmpty()) return w.getProductName();
        for (ItemDTO item : items) {
            if (item.getItemID() == w.getProduct_item_id()) {
                return item.getItemName() != null ? item.getItemName() : "SP#" + item.getItemID();
            }
        }
        return "SP#" + w.getProduct_item_id();
    }

    String getRoutingName(WorkOrderDTO w, List<RoutingDTO> routings) {
        if (w.getRoutingName() != null && !w.getRoutingName().isEmpty()) return w.getRoutingName();
        for (RoutingDTO r : routings) {
            if (r.getRoutingId() == w.getRouting_id()) {
                return r.getRoutingName() != null ? r.getRoutingName() : "Routing#" + r.getRoutingId();
            }
        }
        return "Routing#" + w.getRouting_id();
    }

    String getStatusClass(String status) {
        if (status == null) return "bg-slate-100 text-slate-600 dark:bg-slate-700/70 dark:text-slate-300";
        if (status.equalsIgnoreCase("New")) return "bg-blue-100 text-blue-700 dark:bg-blue-500/10 dark:text-blue-300";
        if (status.equalsIgnoreCase("In Progress") || status.equalsIgnoreCase("InProgress")) return "bg-amber-100 text-amber-700 dark:bg-amber-500/10 dark:text-amber-300";
        if (status.equalsIgnoreCase("Completed") || status.equalsIgnoreCase("Done")) return "bg-emerald-100 text-emerald-700 dark:bg-emerald-500/10 dark:text-emerald-300";
        if (status.equalsIgnoreCase("Cancelled")) return "bg-red-100 text-red-700 dark:bg-red-500/10 dark:text-red-300";
        return "bg-slate-100 text-slate-600 dark:bg-slate-700/70 dark:text-slate-300";
    }

    String getStatusLabel(String status) {
        if (status == null) return "N/A";
        if (status.equalsIgnoreCase("New")) return "Mới";
        if (status.equalsIgnoreCase("In Progress") || status.equalsIgnoreCase("InProgress")) return "Đang SX";
        if (status.equalsIgnoreCase("Completed") || status.equalsIgnoreCase("Done")) return "Hoàn Thành";
        if (status.equalsIgnoreCase("Cancelled")) return "Đã Hủy";
        return status;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Lệnh Sản Xuất - PMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class'
        };
    </script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <style>
        body { font-family: Inter, "Segoe UI", Arial, sans-serif; }
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
        .form-input {
            width: 100%;
            border-radius: 1rem;
            border: 1px solid rgb(226 232 240);
            background: rgb(255 255 255 / 0.92);
            padding: 0.75rem 1rem;
            color: rgb(15 23 42);
            transition: all 0.2s ease;
        }
        .dark .form-input {
            border-color: rgb(51 65 85);
            background: rgb(15 23 42 / 0.75);
            color: rgb(241 245 249);
        }
        .form-input:focus {
            border-color: #0d9488;
            box-shadow: 0 0 0 3px rgba(20, 184, 166, 0.1);
            outline: none;
        }
        .kpi-card {
            position: relative;
            overflow: hidden;
        }
        .section-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(14px);
        }
        .dark .section-card {
            background: rgba(15, 23, 42, 0.88);
        }
        .table-row:hover td {
            background: rgba(248, 250, 252, 0.85);
        }
        .dark .table-row:hover td {
            background: rgba(30, 41, 59, 0.72);
        }
    </style>
    <script src="js/common.js"></script>
</head>
<body class="bg-slate-100 text-slate-900 min-h-screen antialiased dark:bg-slate-900 dark:text-slate-100 <%= isDarkMode ? "dark dark-mode-init" : "" %>">
    <div class="min-h-screen flex">
        <jsp:include page="components/shared-sidebar.jsp" />
        
        <!-- Main Content -->
        <div id="mainWrapper" class="main-wrapper flex-1 flex flex-col min-h-screen min-w-0">
            <jsp:include page="components/shared-header.jsp" />
            
            <main class="flex-1 overflow-y-auto bg-slate-100 p-4 dark:bg-slate-900 sm:p-6 lg:p-8">
                <div class="mb-6 flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                    <div>
                        <h1 class="text-2xl font-semibold text-slate-900 dark:text-slate-100">Lệnh sản xuất</h1>
                        <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Tạo, tìm kiếm và theo dõi toàn bộ lệnh sản xuất trên cùng một màn hình</p>
                    </div>
                    <% if (isAdmin) { %>
                    <button onclick="openAddModal()" class="inline-flex items-center gap-2 rounded-2xl bg-teal-600 px-5 py-3 text-sm font-semibold text-white shadow-sm shadow-teal-500/30 transition-all hover:bg-teal-700">
                        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                        </svg>
                        Thêm lệnh mới
                    </button>
                    <% } %>
                </div>

                <% if (msg != null && !msg.trim().isEmpty()) { %>
                <div class="mb-6 flex items-center gap-3 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-4 text-emerald-700 dark:border-emerald-500/30 dark:bg-emerald-500/10 dark:text-emerald-300">
                    <svg class="h-5 w-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <%= msg %>
                </div>
                <% } %>
                <% if (error != null && !error.trim().isEmpty()) { %>
                <div class="mb-6 flex items-center gap-3 rounded-2xl border border-red-200 bg-red-50 px-4 py-4 text-red-700 dark:border-red-500/30 dark:bg-red-500/10 dark:text-red-300">
                    <svg class="h-5 w-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <%= error %>
                </div>
                <% } %>

                <div class="mb-6 grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
                    <div class="kpi-card rounded-2xl border border-slate-200 border-t-4 border-t-blue-500 bg-white p-5 shadow-sm dark:border-slate-700 dark:bg-slate-800">
                        <div class="flex items-start justify-between gap-4">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.2em] text-slate-500 dark:text-slate-400">Tổng lệnh</p>
                                <p class="mt-3 text-3xl font-bold text-slate-900 dark:text-slate-100"><%= totalWO %></p>
                                <p class="mt-2 text-sm text-slate-500 dark:text-slate-400">Số lượng lệnh sản xuất hiện có</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-blue-50 text-blue-600 dark:bg-blue-500/10 dark:text-blue-300">
                                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                            </div>
                        </div>
                    </div>
                    <div class="kpi-card rounded-2xl border border-slate-200 border-t-4 border-t-sky-500 bg-white p-5 shadow-sm dark:border-slate-700 dark:bg-slate-800">
                        <div class="flex items-start justify-between gap-4">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.2em] text-slate-500 dark:text-slate-400">Mới</p>
                                <p class="mt-3 text-3xl font-bold text-slate-900 dark:text-slate-100"><%= newCount %></p>
                                <p class="mt-2 text-sm text-slate-500 dark:text-slate-400">Lệnh chờ bắt đầu</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-sky-50 text-sky-600 dark:bg-sky-500/10 dark:text-sky-300">
                                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/></svg>
                            </div>
                        </div>
                    </div>
                    <div class="kpi-card rounded-2xl border border-slate-200 border-t-4 border-t-amber-500 bg-white p-5 shadow-sm dark:border-slate-700 dark:bg-slate-800">
                        <div class="flex items-start justify-between gap-4">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.2em] text-slate-500 dark:text-slate-400">Đang sản xuất</p>
                                <p class="mt-3 text-3xl font-bold text-slate-900 dark:text-slate-100"><%= inProgressCount %></p>
                                <p class="mt-2 text-sm text-slate-500 dark:text-slate-400">Lệnh đang được xử lý</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-amber-50 text-amber-600 dark:bg-amber-500/10 dark:text-amber-300">
                                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                            </div>
                        </div>
                    </div>
                    <div class="kpi-card rounded-2xl border border-slate-200 border-t-4 border-t-emerald-500 bg-white p-5 shadow-sm dark:border-slate-700 dark:bg-slate-800">
                        <div class="flex items-start justify-between gap-4">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.2em] text-slate-500 dark:text-slate-400">Hoàn thành</p>
                                <p class="mt-3 text-3xl font-bold text-slate-900 dark:text-slate-100"><%= completedCount %></p>
                                <p class="mt-2 text-sm text-slate-500 dark:text-slate-400">Lệnh đã hoàn tất</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-emerald-50 text-emerald-600 dark:bg-emerald-500/10 dark:text-emerald-300">
                                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="section-card mb-6 rounded-3xl border border-slate-200 p-5 shadow-sm dark:border-slate-700">
                    <form action="MainController" method="get" class="grid gap-4 lg:grid-cols-[1fr_220px_auto] lg:items-center">
                        <input type="hidden" name="action" value="listWorkOrder">
                        <div class="relative">
                            <input type="text" name="keyword" value="<%= searchKeyword != null ? searchKeyword : "" %>" placeholder="Tìm kiếm theo mã lệnh, sản phẩm, quy trình..." class="form-input pl-11">
                            <svg class="absolute left-4 top-1/2 h-5 w-5 -translate-y-1/2 text-slate-400 dark:text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                            </svg>
                        </div>
                        <select name="status" class="form-input">
                            <option value="">Tất cả trạng thái</option>
                            <option value="New" <%= "New".equals(filterStatus) ? "selected" : "" %>>Mới</option>
                            <option value="In Progress" <%= "In Progress".equals(filterStatus) ? "selected" : "" %>>Đang sản xuất</option>
                            <option value="Completed" <%= "Completed".equals(filterStatus) ? "selected" : "" %>>Hoàn thành</option>
                            <option value="Cancelled" <%= "Cancelled".equals(filterStatus) ? "selected" : "" %>>Đã hủy</option>
                        </select>
                        <button type="submit" class="rounded-2xl bg-teal-600 px-6 py-3 text-sm font-semibold text-white shadow-sm shadow-teal-500/30 transition-all hover:bg-teal-700">Tìm kiếm</button>
                    </form>
                </div>

                <div class="section-card overflow-hidden rounded-3xl border border-slate-200 shadow-sm dark:border-slate-700">
                    <div class="flex flex-col gap-3 border-b border-slate-200 px-6 py-5 dark:border-slate-700 sm:flex-row sm:items-center sm:justify-between">
                        <div>
                            <h2 class="text-lg font-semibold text-slate-900 dark:text-slate-100">Danh sách lệnh sản xuất</h2>
                            <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Theo dõi mã lệnh, sản phẩm, quy trình và trạng thái xử lý</p>
                        </div>
                        <div class="rounded-2xl bg-slate-100 px-4 py-2 text-sm font-medium text-slate-600 dark:bg-slate-700/70 dark:text-slate-300">
                            Tổng cộng: <span class="font-semibold text-slate-900 dark:text-slate-100"><%= workOrders.size() %></span>
                        </div>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="min-w-full">
                            <thead>
                                <tr class="border-b border-slate-200 bg-slate-50 dark:border-slate-700 dark:bg-slate-800/80">
                                    <th class="px-6 py-4 text-left text-xs font-semibold uppercase tracking-[0.2em] text-slate-500 dark:text-slate-400">Mã LSX</th>
                                    <th class="px-6 py-4 text-left text-xs font-semibold uppercase tracking-[0.2em] text-slate-500 dark:text-slate-400">Sản phẩm</th>
                                    <th class="px-6 py-4 text-left text-xs font-semibold uppercase tracking-[0.2em] text-slate-500 dark:text-slate-400">Quy trình</th>
                                    <th class="px-6 py-4 text-right text-xs font-semibold uppercase tracking-[0.2em] text-slate-500 dark:text-slate-400">Số lượng</th>
                                    <th class="px-6 py-4 text-center text-xs font-semibold uppercase tracking-[0.2em] text-slate-500 dark:text-slate-400">Trạng thái</th>
                                    <th class="px-6 py-4 text-center text-xs font-semibold uppercase tracking-[0.2em] text-slate-500 dark:text-slate-400">Hành động</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100 dark:divide-slate-800">
                                <% if (workOrders.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="px-6 py-14 text-center text-slate-500 dark:text-slate-400">
                                        <div class="flex flex-col items-center gap-4">
                                            <div class="flex h-16 w-16 items-center justify-center rounded-2xl bg-slate-100 text-slate-400 dark:bg-slate-800 dark:text-slate-500">
                                                <svg class="h-9 w-9" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                                </svg>
                                            </div>
                                            <div>
                                                <p class="font-medium text-slate-700 dark:text-slate-200">Chưa có lệnh sản xuất nào</p>
                                                <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Tạo lệnh sản xuất mới để bắt đầu</p>
                                            </div>
                                            <button type="button" onclick="openAddModal()" class="inline-flex items-center gap-2 rounded-2xl bg-teal-600 px-4 py-2.5 text-sm font-semibold text-white shadow-sm shadow-teal-500/30 transition-all hover:bg-teal-700">
                                                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                                                </svg>
                                                Tạo lệnh sản xuất
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <% } else { %>
                                    <% for (WorkOrderDTO w : workOrders) { %>
                                    <tr class="table-row transition-colors">
                                        <td class="px-6 py-4 align-middle">
                                            <span class="inline-flex items-center rounded-full bg-teal-50 px-3 py-1 text-sm font-semibold text-teal-700 dark:bg-teal-500/10 dark:text-teal-300">#WO-<%= w.getWo_id() %></span>
                                        </td>
                                        <td class="px-6 py-4 align-middle">
                                            <div class="flex items-center gap-3">
                                                <div class="flex h-11 w-11 items-center justify-center rounded-2xl bg-teal-50 text-sm font-bold text-teal-600 dark:bg-teal-500/10 dark:text-teal-300">
                                                    <%= getProductName(w, items).substring(0, Math.min(2, getProductName(w, items).length())).toUpperCase() %>
                                                </div>
                                                <div>
                                                    <p class="font-semibold text-slate-800 dark:text-slate-100"><%= getProductName(w, items) %></p>
                                                    <p class="text-sm text-slate-500 dark:text-slate-400">Mã sản phẩm: <%= w.getProduct_item_id() %></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 align-middle text-slate-600 dark:text-slate-300"><%= getRoutingName(w, routings) %></td>
                                        <td class="px-6 py-4 text-right align-middle font-semibold text-slate-800 dark:text-slate-100"><%= w.getOrder_quantity() %></td>
                                        <td class="px-6 py-4 text-center align-middle">
                                            <span class="inline-flex items-center rounded-full px-3 py-1 text-xs font-bold <%= getStatusClass(w.getStatus()) %>">
                                                <%= getStatusLabel(w.getStatus()) %>
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 text-center align-middle">
                                            <div class="flex items-center justify-center gap-2">
                                                <a href="MainController?action=listWorkOrder&search=<%= w.getWo_id() %>" class="rounded-xl p-2.5 text-slate-500 transition-colors hover:bg-blue-100 hover:text-blue-600 dark:text-slate-400 dark:hover:bg-blue-500/10 dark:hover:text-blue-300" title="Xem chi tiết">
                                                    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                                    </svg>
                                                </a>
                                                <% if (isAdmin) { %>
                                                <a href="WorkOrderController?action=loadUpdate&wo_id=<%= w.getWo_id() %>" class="rounded-xl p-2.5 text-slate-500 transition-colors hover:bg-amber-100 hover:text-amber-600 dark:text-slate-400 dark:hover:bg-amber-500/10 dark:hover:text-amber-300" title="Chỉnh sửa">
                                                    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
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
                    <% if (!workOrders.isEmpty()) { %>
                    <div class="border-t border-slate-200 bg-slate-50 px-6 py-4 text-sm text-slate-500 dark:border-slate-700 dark:bg-slate-800/80 dark:text-slate-400">
                        Tổng cộng: <span class="font-semibold text-slate-700 dark:text-slate-200"><%= workOrders.size() %></span> lệnh sản xuất
                    </div>
                    <% } %>
                </div>
            </main>
        </div>
    </div>

    <!-- Mobile Bottom Navigation -->
    <jsp:include page="mobile-nav.jsp" />

    <!-- Add Work Order Modal -->
    <div id="addModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-950/50 p-4 backdrop-blur-sm">
        <div class="section-card max-h-[90vh] w-full max-w-lg overflow-y-auto rounded-3xl border border-slate-200 shadow-2xl dark:border-slate-700">
            <div class="flex items-center justify-between border-b border-slate-200 px-6 py-5 dark:border-slate-700">
                <div>
                    <h3 class="text-lg font-semibold text-slate-900 dark:text-slate-100">Thêm lệnh sản xuất mới</h3>
                    <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Điền thông tin cơ bản để tạo lệnh</p>
                </div>
                <button onclick="closeAddModal()" class="rounded-xl p-2 text-slate-400 transition-colors hover:bg-slate-100 hover:text-slate-600 dark:hover:bg-slate-800 dark:hover:text-slate-300">
                    <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
            </div>
            <form action="WorkOrderController" method="post" class="space-y-5 p-6">
                <input type="hidden" name="action" value="insert">
                <div>
                    <label class="mb-2 block text-sm font-semibold text-slate-700 dark:text-slate-200">Sản phẩm</label>
                    <select name="product_item_id" required class="form-input">
                        <option value="">-- Chọn sản phẩm --</option>
                        <% for (ItemDTO item : items) { %>
                        <option value="<%= item.getItemID() %>"><%= item.getItemName() %> (ID: <%= item.getItemID() %>)</option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label class="mb-2 block text-sm font-semibold text-slate-700 dark:text-slate-200">Quy trình sản xuất</label>
                    <select name="routing_id" required class="form-input">
                        <option value="">-- Chọn quy trình --</option>
                        <% for (RoutingDTO r : routings) { %>
                        <option value="<%= r.getRoutingId() %>"><%= r.getRoutingName() %> (ID: <%= r.getRoutingId() %>)</option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label class="mb-2 block text-sm font-semibold text-slate-700 dark:text-slate-200">Số lượng</label>
                    <input type="number" name="order_quantity" required min="1" placeholder="VD: 100" class="form-input">
                </div>
                <div>
                    <label class="mb-2 block text-sm font-semibold text-slate-700 dark:text-slate-200">Trạng thái</label>
                    <select name="status" required class="form-input">
                        <option value="New">Mới</option>
                        <option value="In Progress">Đang sản xuất</option>
                    </select>
                </div>
                <div class="flex gap-3 pt-2">
                    <button type="submit" class="flex-1 rounded-2xl bg-teal-600 py-3 text-sm font-semibold text-white shadow-sm shadow-teal-500/30 transition-all hover:bg-teal-700">Tạo lệnh</button>
                    <button type="button" onclick="closeAddModal()" class="rounded-2xl border border-slate-200 px-6 py-3 text-sm font-semibold text-slate-600 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-800">Hủy</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // User Dropdown
        function toggleUserDropdown() {
            const dropdown = document.getElementById('userDropdown');
            const notifPanel = document.getElementById('notifPanel');
            if (notifPanel) notifPanel.classList.add('hidden');
            dropdown.classList.toggle('hidden');
        }
        
        // Notification Panel
        function toggleNotificationPanel() {
            const panel = document.getElementById('notifPanel');
            const userDropdown = document.getElementById('userDropdown');
            if (userDropdown) userDropdown.classList.add('hidden');
            panel.classList.toggle('hidden');
        }

        // Dark mode được xử lý tập trung bởi [common.js](web/js/common.js)

        // Global Search Handler
        function handleGlobalSearch(event) {
            if (event.key === 'Enter') {
                const query = event.target.value.trim();
                if (query) {
                    window.location.href = 'AutoCompleteSearchServlet?action=search&q=' + encodeURIComponent(query);
                }
            }
        }
        
        // Close dropdowns when clicking outside
        document.addEventListener('click', function(e) {
            const notifPanel = document.getElementById('notifPanel');
            const notifBtn = e.target.closest('[onclick*="toggleNotificationPanel"]');
            const userDropdown = document.getElementById('userDropdown');
            const userBtn = e.target.closest('[onclick*="toggleUserDropdown"]');
            
            if (notifPanel && !notifPanel.contains(e.target) && !notifBtn) {
                notifPanel.classList.add('hidden');
            }
            if (userDropdown && !userDropdown.contains(e.target) && !userBtn) {
                userDropdown.classList.add('hidden');
            }
        });
        
        // Modal functions
        function openAddModal() {
            document.getElementById('addModal').classList.remove('hidden');
            document.getElementById('addModal').classList.add('flex');
        }

        function closeAddModal() {
            document.getElementById('addModal').classList.add('hidden');
            document.getElementById('addModal').classList.remove('flex');
        }

        // Close modal on backdrop click
        document.getElementById('addModal').addEventListener('click', function(e) {
            if (e.target === this) closeAddModal();
        });
    </script>
</body>
</html>
