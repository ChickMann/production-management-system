<%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.List, pms.model.UserDTO, pms.utils.NotificationService.Notification"%>
<%
    List<UserDTO> users = (List<UserDTO>) request.getAttribute("users");
    UserDTO currentUser = (UserDTO) session.getAttribute("user");
    List<Notification> notifications = (List<Notification>) session.getAttribute("notifications");
    
    String msg = (String) request.getAttribute("msg");
    String error = (String) request.getAttribute("error");
    String filterRole = request.getParameter("role");
    String keyword = request.getParameter("keyword");
    boolean showModal = request.getAttribute("showModal") != null && (Boolean) request.getAttribute("showModal");
    
    // For edit modal
    UserDTO editUser = (UserDTO) request.getAttribute("editUser");
    boolean showEditModal = editUser != null || (request.getAttribute("showEditModal") != null && (Boolean) request.getAttribute("showEditModal"));
    
    if (users == null) users = new java.util.ArrayList<>();
    if (notifications == null) notifications = new java.util.ArrayList<>();
    if (filterRole == null) filterRole = "all";
    if (keyword == null) keyword = "";
    
    int countAdmin = 0;
    int countEmployee = 0;
    int countActive = 0;
    int countInactive = 0;
    
    for (UserDTO u : users) {
        if ("admin".equalsIgnoreCase(u.getRole())) countAdmin++;
        else if ("employee".equalsIgnoreCase(u.getRole())) countEmployee++;
        if ("active".equalsIgnoreCase(u.getStatus())) countActive++;
        else if ("inactive".equalsIgnoreCase(u.getStatus())) countInactive++;
    }
    
    int unreadCount = 0;
    for (Notification n : notifications) {
        if (!n.isRead()) unreadCount++;
    }
    
    String userName = currentUser != null ? currentUser.getUsername() : "User";
    String userRole = currentUser != null ? currentUser.getRole() : "user";
    boolean isAdmin = "admin".equalsIgnoreCase(userRole);
    String pageTitle = "Quản Lý Người Dùng";
    String pageSubtitle = "Quản lý tài khoản và phân quyền người dùng";
    request.setAttribute("activePage", "user");
    
    Boolean sessionDark = (Boolean) session.getAttribute("darkMode");
    boolean isDarkMode = sessionDark != null ? sessionDark : false;
    String lang = session.getAttribute("lang") != null ? (String) session.getAttribute("lang") : "vi";
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Người Dùng - PMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', 'Segoe UI', 'Arial', 'sans-serif'],
                    },
                }
            }
        }
    </script>
    <style>
        * { font-family: 'Inter', 'Segoe UI', Arial, sans-serif; }
        body { overflow-x: hidden; }
        
        .main-wrapper {
            margin-left: 0;
            transition: margin-left 0.3s ease;
        }
        @media (min-width: 1024px) {
            .main-wrapper {
                margin-left: 280px;
            }
        }
        
        .kpi-card {
            transition: all 0.2s ease;
        }
        .kpi-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.1);
        }
        
        .action-btn {
            transition: all 0.2s ease;
        }
        .action-btn:hover {
            transform: scale(1.1);
        }
        
        .role-badge {
            display: inline-flex;
            padding: 4px 12px;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .role-admin { background: #f3e8ff; color: #7c3aed; }
        .role-employee { background: #dbeafe; color: #1d4ed8; }
        
        .status-active { background: #d1fae5; color: #047857; }
        .status-inactive { background: #fee2e2; color: #b91c1c; }
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
                <div class="mb-6 rounded-3xl border border-slate-200 bg-gradient-to-br from-white via-slate-50 to-teal-50/70 p-6 shadow-sm dark:border-slate-700 dark:from-slate-900 dark:via-slate-900 dark:to-teal-950/30">
                    <div class="flex flex-col gap-5 lg:flex-row lg:items-center lg:justify-between">
                        <div class="max-w-3xl">
                            <div class="inline-flex items-center gap-2 rounded-full border border-teal-200 bg-teal-50 px-3 py-1 text-xs font-semibold uppercase tracking-[0.2em] text-teal-700 dark:border-teal-500/30 dark:bg-teal-500/10 dark:text-teal-300">
                                Quản trị hệ thống
                            </div>
                            <h1 class="mt-3 text-2xl font-bold text-slate-900 dark:text-slate-100">Quản Lý Người Dùng</h1>
                            <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Quản lý tài khoản và phân quyền người dùng trong hệ thống</p>
                        </div>
                        <div class="flex items-center gap-3">
                            <form action="UserController" method="get" class="flex items-center gap-2">
                                <input type="hidden" name="action" value="search"/>
                                <div class="relative">
                                    <input type="text" name="keyword" value="<%= keyword %>"
                                           placeholder="Tìm kiếm..."
                                           class="w-full pl-10 pr-4 py-2.5 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-sm focus:border-teal-500 focus:ring-2 focus:ring-teal-200 dark:focus:ring-teal-800 transition-all">
                                    <svg class="w-5 h-5 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                                    </svg>
                                </div>
                                <select name="role" onchange="this.form.submit()" class="px-4 py-2.5 rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-sm">
                                    <option value="all" <%= "all".equals(filterRole) ? "selected" : "" %>>Tất cả</option>
                                    <option value="admin" <%= "admin".equals(filterRole) ? "selected" : "" %>>Admin</option>
                                    <option value="employee" <%= "employee".equals(filterRole) ? "selected" : "" %>>Công nhân</option>
                                </select>
                                <a href="UserController?action=list" class="px-4 py-2.5 rounded-xl border border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 font-medium hover:bg-slate-50 dark:hover:bg-slate-800 transition-all">
                                    Tất cả
                                </a>
                            </form>
                            <button type="button" onclick="openUserModal()" class="px-4 py-2.5 rounded-xl bg-teal-600 text-white font-medium hover:bg-teal-700 transition-colors flex items-center gap-2 shadow-lg shadow-teal-600/20">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                                </svg>
                                Thêm người dùng
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Alerts -->
                <% if (msg != null && !msg.isEmpty()) { %>
                <div class="mb-6 p-4 rounded-xl bg-emerald-50 border border-emerald-200 dark:bg-emerald-900/30 dark:border-emerald-800 text-emerald-700 dark:text-emerald-300 flex items-center gap-3">
                    <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <%= msg %>
                </div>
                <% } %>
                <% if (error != null && !error.isEmpty()) { %>
                <div class="mb-6 p-4 rounded-xl bg-red-50 border border-red-200 dark:bg-red-900/30 dark:border-red-800 text-red-700 dark:text-red-300 flex items-center gap-3">
                    <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <%= error %>
                </div>
                <% } %>

                <!-- Stats Cards -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
                    <div class="kpi-card rounded-2xl bg-white dark:bg-slate-800 p-5 shadow-sm border-t-4 border-purple-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase text-slate-500 dark:text-slate-400">Tổng Người Dùng</p>
                                <p class="mt-2 text-3xl font-bold text-slate-800 dark:text-slate-100"><%= users.size() %></p>
                                <p class="mt-1 text-xs text-slate-400 dark:text-slate-500">Tài khoản</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-purple-50 dark:bg-purple-900/30 text-purple-600 dark:text-purple-400">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                                </svg>
                            </div>
                        </div>
                    </div>
                    <div class="kpi-card rounded-2xl bg-white dark:bg-slate-800 p-5 shadow-sm border-t-4 border-violet-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase text-slate-500 dark:text-slate-400">Admin</p>
                                <p class="mt-2 text-3xl font-bold text-violet-600 dark:text-violet-400"><%= countAdmin %></p>
                                <p class="mt-1 text-xs text-slate-400 dark:text-slate-500">Quản trị viên</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-violet-50 dark:bg-violet-900/30 text-violet-600 dark:text-violet-400">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>
                                </svg>
                            </div>
                        </div>
                    </div>
                    <div class="kpi-card rounded-2xl bg-white dark:bg-slate-800 p-5 shadow-sm border-t-4 border-blue-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase text-slate-500 dark:text-slate-400">Công Nhân</p>
                                <p class="mt-2 text-3xl font-bold text-blue-600 dark:text-blue-400"><%= countEmployee %></p>
                                <p class="mt-1 text-xs text-slate-400 dark:text-slate-500">Nhân viên</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                                </svg>
                            </div>
                        </div>
                    </div>
                    <div class="kpi-card rounded-2xl bg-white dark:bg-slate-800 p-5 shadow-sm border-t-4 border-emerald-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase text-slate-500 dark:text-slate-400">Đang Hoạt Động</p>
                                <p class="mt-2 text-3xl font-bold text-emerald-600 dark:text-emerald-400"><%= countActive %></p>
                                <p class="mt-1 text-xs text-slate-400 dark:text-slate-500">Tài khoản active</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-emerald-50 dark:bg-emerald-900/30 text-emerald-600 dark:text-emerald-400">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Users List -->
                <div class="bg-white dark:bg-slate-800 rounded-3xl shadow-sm border border-slate-200 dark:border-slate-700 overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="border-b border-slate-100 dark:border-slate-700 bg-slate-50 dark:bg-slate-900/50">
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Người Dùng</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Vai Trò</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Email</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Điện Thoại</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Trạng Thái</th>
                                    <th class="px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (users.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="px-4 py-14 text-center text-slate-400 dark:text-slate-500">
                                        <div class="mx-auto flex max-w-md flex-col items-center gap-3">
                                            <div class="flex h-16 w-16 items-center justify-center rounded-3xl bg-slate-100 text-slate-400 dark:bg-slate-800 dark:text-slate-500">
                                                <svg class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                                                </svg>
                                            </div>
                                            <div>
                                                <p class="text-base font-semibold text-slate-700 dark:text-slate-200">Chưa có người dùng nào</p>
                                                <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Bắt đầu bằng cách tạo người dùng mới trực tiếp ngay trên trang này.</p>
                                            </div>
                                            <button type="button" onclick="openUserModal()" class="mt-2 inline-flex items-center gap-2 rounded-xl bg-teal-600 px-4 py-2 text-sm font-medium text-white shadow-sm shadow-teal-500/30 transition hover:bg-teal-700">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                                                </svg>
                                                Thêm người dùng đầu tiên
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <% } else { %>
                                    <% for (UserDTO u : users) { %>
                                        <% 
                                            String roleClass = "role-employee";
                                            if ("admin".equalsIgnoreCase(u.getRole())) roleClass = "role-admin";
                                            
                                            String statusClass = "status-active dark:bg-emerald-900/30 dark:text-emerald-400";
                                            String statusText = "Hoạt động";
                                            if (!"active".equalsIgnoreCase(u.getStatus())) {
                                                statusClass = "status-inactive dark:bg-red-900/30 dark:text-red-400";
                                                statusText = "Khóa";
                                            }
                                            
                                            boolean isCurrentUser = currentUser != null && currentUser.getId() == u.getId();
                                        %>
                                        <tr class="border-b border-slate-50 dark:border-slate-800 last:border-0 hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors">
                                            <td class="px-4 py-3">
                                                <div class="flex items-center gap-3">
                                                    <div class="w-10 h-10 rounded-full bg-gradient-to-br from-teal-500 to-teal-600 flex items-center justify-center text-white font-bold text-sm shadow-sm shadow-teal-500/30">
                                                        <%= u.getUsername() != null && !u.getUsername().isEmpty() ? u.getUsername().substring(0,1).toUpperCase() : "U" %>
                                                    </div>
                                                    <div>
                                                        <p class="font-semibold text-slate-700 dark:text-slate-200 flex items-center gap-2">
                                                            <%= u.getFullName() != null ? u.getFullName() : u.getUsername() %>
                                                            <% if (isCurrentUser) { %>
                                                            <span class="px-1.5 py-0.5 rounded text-[10px] bg-teal-100 dark:bg-teal-900/30 text-teal-700 dark:text-teal-400 font-medium">Bạn</span>
                                                            <% } %>
                                                        </p>
                                                        <p class="text-xs text-slate-500 dark:text-slate-400">@<%= u.getUsername() %></p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="px-4 py-3">
                                                <span class="role-badge <%= roleClass %>"><%= u.getRole() %></span>
                                            </td>
                                            <td class="px-4 py-3 text-slate-600 dark:text-slate-400">
                                                <%= u.getEmail() != null ? u.getEmail() : "-" %>
                                            </td>
                                            <td class="px-4 py-3 text-slate-600 dark:text-slate-400">
                                                <%= u.getPhone() != null ? u.getPhone() : "-" %>
                                            </td>
                                            <td class="px-4 py-3">
                                                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold <%= statusClass %>">
                                                    <span class="w-1.5 h-1.5 rounded-full bg-current"></span>
                                                    <%= statusText %>
                                                </span>
                                            </td>
                                            <td class="px-4 py-3">
                                                <div class="flex items-center justify-center gap-1">
                                                    <!-- Chi tiết -->
                                                    <a href="UserController?action=view&id=<%= u.getId() %>" 
                                                       class="action-btn p-2 rounded-xl text-slate-500 dark:text-slate-400 hover:bg-blue-100 dark:hover:bg-blue-500/10 hover:text-blue-600 dark:hover:text-blue-300 transition-colors" title="Chi tiết">
                                                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                                        </svg>
                                                    </a>
                                                    
                                                    <% if (isAdmin || isCurrentUser) { %>
                                                    <!-- Sửa -->
                                                    <button type="button" onclick="openEditModal(<%= u.getId() %>, '<%= u.getUsername() %>', '<%= u.getFullName() != null ? u.getFullName() : "" %>', '<%= u.getRole() %>', '<%= u.getEmail() != null ? u.getEmail() : "" %>', '<%= u.getPhone() != null ? u.getPhone() : "" %>', '<%= u.getStatus() %>')"
                                                       class="action-btn p-2 rounded-xl text-slate-500 dark:text-slate-400 hover:bg-blue-100 dark:hover:bg-blue-500/10 hover:text-blue-600 dark:hover:text-blue-300 transition-colors" title="Chỉnh sửa">
                                                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                                        </svg>
                                                    </button>
                                                    <% } %>
                                                    
                                                    <% if (isAdmin && !isCurrentUser) { %>
                                                    <!-- Khóa/Mở khóa -->
                                                    <form action="UserController" method="post" style="display:inline;">
                                                        <input type="hidden" name="action" value="<%= "active".equalsIgnoreCase(u.getStatus()) ? "lockUser" : "unlockUser" %>"/>
                                                        <input type="hidden" name="id" value="<%= u.getId() %>"/>
                                                        <button type="submit" onclick="return confirm('<%= "active".equalsIgnoreCase(u.getStatus()) ? "Khóa tài khoản này?" : "Mở khóa tài khoản này?" %>')"
                                                                class="action-btn p-2 rounded-xl <%= "active".equalsIgnoreCase(u.getStatus()) ? "text-amber-500 hover:bg-amber-100 dark:hover:bg-amber-500/10" : "text-emerald-500 hover:bg-emerald-100 dark:hover:bg-emerald-500/10" %> transition-colors" title="<%= "active".equalsIgnoreCase(u.getStatus()) ? "Khóa" : "Mở khóa" %>">
                                                            <% if ("active".equalsIgnoreCase(u.getStatus())) { %>
                                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                                                            </svg>
                                                            <% } else { %>
                                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 11V7a4 4 0 118 0m-4 8v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2z"/>
                                                            </svg>
                                                            <% } %>
                                                        </button>
                                                    </form>
                                                    <% } %>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% if (!users.isEmpty()) { %>
                    <div class="px-4 py-3 border-t border-slate-100 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/80 text-sm text-slate-500 dark:text-slate-400">
                        Tổng cộng: <span class="font-semibold"><%= users.size() %></span> người dùng
                    </div>
                    <% } %>
                </div>
            </main>
        </div>
    </div>

    <!-- Add User Modal -->
    <div id="userModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-950/60 p-4 backdrop-blur-sm overflow-y-auto py-8">
        <div class="w-full max-w-2xl my-auto overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-2xl dark:border-slate-700 dark:bg-slate-900">
            <div class="flex items-start justify-between border-b border-slate-200 px-6 py-5 dark:border-slate-700">
                <div>
                    <p class="text-xs font-semibold uppercase tracking-[0.2em] text-teal-600 dark:text-teal-300">Thao tác nhanh</p>
                    <h3 class="mt-2 text-xl font-semibold text-slate-900 dark:text-slate-100">Thêm người dùng mới</h3>
                    <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Tạo tài khoản người dùng mới trực tiếp trên trang.</p>
                </div>
                <button type="button" onclick="closeUserModal()" class="rounded-2xl p-2 text-slate-400 transition hover:bg-slate-100 hover:text-slate-600 dark:hover:bg-slate-800 dark:hover:text-slate-300">
                    <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
            </div>
            <form action="UserController" method="post" class="space-y-5 px-6 py-6">
                <input type="hidden" name="action" value="saveAddUser"/>
                <div class="grid gap-5 sm:grid-cols-2">
                    <div>
                        <label class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-300">Username <span class="text-red-500">*</span></label>
                        <input type="text" name="username" required class="w-full rounded-xl border border-slate-200 px-4 py-2.5 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 focus:border-teal-500 focus:ring-2 focus:ring-teal-200 dark:focus:ring-teal-800 transition-all" placeholder="Nhập username">
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-300">Mật khẩu <span class="text-red-500">*</span></label>
                        <input type="password" name="password" required class="w-full rounded-xl border border-slate-200 px-4 py-2.5 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 focus:border-teal-500 focus:ring-2 focus:ring-teal-200 dark:focus:ring-teal-800 transition-all" placeholder="Nhập mật khẩu">
                    </div>
                </div>
                <div class="grid gap-5 sm:grid-cols-2">
                    <div>
                        <label class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-300">Họ tên</label>
                        <input type="text" name="fullName" class="w-full rounded-xl border border-slate-200 px-4 py-2.5 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 focus:border-teal-500 focus:ring-2 focus:ring-teal-200 dark:focus:ring-teal-800 transition-all" placeholder="Nhập họ tên">
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-300">Vai trò <span class="text-red-500">*</span></label>
                        <select name="role" required class="w-full rounded-xl border border-slate-200 px-4 py-2.5 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 focus:border-teal-500 focus:ring-2 focus:ring-teal-200 dark:focus:ring-teal-800 transition-all">
                            <option value="">-- Chọn vai trò --</option>
                            <option value="admin">Admin</option>
                            <option value="employee">Công nhân</option>
                        </select>
                    </div>
                </div>
                <div class="grid gap-5 sm:grid-cols-2">
                    <div>
                        <label class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-300">Email</label>
                        <input type="email" name="email" class="w-full rounded-xl border border-slate-200 px-4 py-2.5 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 focus:border-teal-500 focus:ring-2 focus:ring-teal-200 dark:focus:ring-teal-800 transition-all" placeholder="email@example.com">
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-300">Điện thoại</label>
                        <input type="text" name="phone" class="w-full rounded-xl border border-slate-200 px-4 py-2.5 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 focus:border-teal-500 focus:ring-2 focus:ring-teal-200 dark:focus:ring-teal-800 transition-all" placeholder="0912345678">
                    </div>
                </div>
                <div class="flex flex-col-reverse gap-3 border-t border-slate-200 pt-5 sm:flex-row sm:justify-end dark:border-slate-700">
                    <button type="button" onclick="closeUserModal()" class="rounded-xl border border-slate-200 px-5 py-2.5 text-sm font-semibold text-slate-600 transition hover:bg-slate-50 dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-800">Hủy</button>
                    <button type="submit" class="rounded-xl bg-teal-600 px-5 py-2.5 text-sm font-semibold text-white shadow-sm shadow-teal-500/30 transition hover:bg-teal-700">Lưu người dùng</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div id="editModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-950/60 p-4 backdrop-blur-sm overflow-y-auto py-8">
        <div class="w-full max-w-2xl my-auto overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-2xl dark:border-slate-700 dark:bg-slate-900">
            <div class="flex items-start justify-between border-b border-slate-200 px-6 py-5 dark:border-slate-700">
                <div>
                    <p class="text-xs font-semibold uppercase tracking-[0.2em] text-blue-600 dark:text-blue-300">Chỉnh sửa</p>
                    <h3 class="mt-2 text-xl font-semibold text-slate-900 dark:text-slate-100">Cập nhật người dùng</h3>
                    <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Cập nhật thông tin tài khoản người dùng.</p>
                </div>
                <button type="button" onclick="closeEditModal()" class="rounded-2xl p-2 text-slate-400 transition hover:bg-slate-100 hover:text-slate-600 dark:hover:bg-slate-800 dark:hover:text-slate-300">
                    <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
            </div>
            <form action="UserController" method="post" class="space-y-5 px-6 py-6">
                <input type="hidden" name="action" value="saveUpdateUser"/>
                <input type="hidden" name="id" id="editUserId"/>
                <div class="grid gap-5 sm:grid-cols-2">
                    <div>
                        <label class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-300">Username</label>
                        <input type="text" name="username" id="editUsername" readonly class="w-full cursor-not-allowed rounded-xl border border-slate-200 bg-slate-100 px-4 py-2.5 text-slate-500 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-400" placeholder="Username">
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-300">Mật khẩu mới <span class="text-slate-400 text-xs">(để trống nếu không đổi)</span></label>
                        <input type="password" name="password" class="w-full rounded-xl border border-slate-200 px-4 py-2.5 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 dark:focus:ring-blue-800 transition-all" placeholder="Nhập mật khẩu mới">
                    </div>
                </div>
                <div class="grid gap-5 sm:grid-cols-2">
                    <div>
                        <label class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-300">Họ tên</label>
                        <input type="text" name="fullName" id="editFullName" class="w-full rounded-xl border border-slate-200 px-4 py-2.5 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 dark:focus:ring-blue-800 transition-all" placeholder="Nhập họ tên">
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-300">Vai trò <span class="text-red-500">*</span></label>
                        <select name="role" id="editRole" required class="w-full rounded-xl border border-slate-200 px-4 py-2.5 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 dark:focus:ring-blue-800 transition-all">
                            <option value="admin">Admin</option>
                            <option value="employee">Công nhân</option>
                        </select>
                    </div>
                </div>
                <div class="grid gap-5 sm:grid-cols-2">
                    <div>
                        <label class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-300">Email</label>
                        <input type="email" name="email" id="editEmail" class="w-full rounded-xl border border-slate-200 px-4 py-2.5 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 dark:focus:ring-blue-800 transition-all" placeholder="email@example.com">
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-300">Điện thoại</label>
                        <input type="text" name="phone" id="editPhone" class="w-full rounded-xl border border-slate-200 px-4 py-2.5 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 dark:focus:ring-blue-800 transition-all" placeholder="0912345678">
                    </div>
                </div>
                <div class="grid gap-5 sm:grid-cols-2">
                    <div>
                        <label class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-300">Trạng thái</label>
                        <select name="status" id="editStatus" class="w-full rounded-xl border border-slate-200 px-4 py-2.5 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 dark:focus:ring-blue-800 transition-all">
                            <option value="active">Hoạt động</option>
                            <option value="inactive">Khóa</option>
                        </select>
                    </div>
                </div>
                <div class="flex flex-col-reverse gap-3 border-t border-slate-200 pt-5 sm:flex-row sm:justify-end dark:border-slate-700">
                    <button type="button" onclick="closeEditModal()" class="rounded-xl border border-slate-200 px-5 py-2.5 text-sm font-semibold text-slate-600 transition hover:bg-slate-50 dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-800">Hủy</button>
                    <button type="submit" class="rounded-xl bg-blue-600 px-5 py-2.5 text-sm font-semibold text-white shadow-sm shadow-blue-500/30 transition hover:bg-blue-700">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const userModal = document.getElementById('userModal');
        const editModal = document.getElementById('editModal');

        function openUserModal() {
            if (!userModal) return;
            userModal.classList.remove('hidden');
            userModal.classList.add('flex');
            document.body.classList.add('overflow-hidden');
        }

        function closeUserModal() {
            if (!userModal) return;
            userModal.classList.add('hidden');
            userModal.classList.remove('flex');
            document.body.classList.remove('overflow-hidden');
        }

        function openEditModal(id, username, fullName, role, email, phone, status) {
            if (!editModal) return;
            document.getElementById('editUserId').value = id;
            document.getElementById('editUsername').value = username;
            document.getElementById('editFullName').value = fullName;
            document.getElementById('editRole').value = role;
            document.getElementById('editEmail').value = email;
            document.getElementById('editPhone').value = phone;
            document.getElementById('editStatus').value = status;
            editModal.classList.remove('hidden');
            editModal.classList.add('flex');
            document.body.classList.add('overflow-hidden');
        }

        function closeEditModal() {
            if (!editModal) return;
            editModal.classList.add('hidden');
            editModal.classList.remove('flex');
            document.body.classList.remove('overflow-hidden');
        }

        // Close on outside click
        [userModal, editModal].forEach(modal => {
            if (modal) {
                modal.addEventListener('click', function(event) {
                    if (event.target === modal) {
                        modal.classList.add('hidden');
                        modal.classList.remove('flex');
                        document.body.classList.remove('overflow-hidden');
                    }
                });
            }
        });

        // Close on Escape
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeUserModal();
                closeEditModal();
            }
        });

        // Auto-open add modal if showModal flag
        <% if (showModal) { %>
        document.addEventListener('DOMContentLoaded', function() {
            openUserModal();
        });
        <% } %>
        
        // Auto-open edit modal if showEditModal flag
        <% if (showEditModal && editUser != null) { %>
        document.addEventListener('DOMContentLoaded', function() {
            openEditModal(<%= editUser.getId() %>, '<%= editUser.getUsername() %>', '<%= editUser.getFullName() != null ? editUser.getFullName() : "" %>', '<%= editUser.getRole() %>', '<%= editUser.getEmail() != null ? editUser.getEmail() : "" %>', '<%= editUser.getPhone() != null ? editUser.getPhone() : "" %>', '<%= editUser.getStatus() %>');
        });
        <% } %>
    </script>
</body>
</html>
