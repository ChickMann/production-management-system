<%@page import="pms.model.BOMDTO"%>
<%@page import="pms.model.ItemDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String mode = (String) request.getAttribute("mode");
    BOMDTO bom = (BOMDTO) request.getAttribute("bom");
    List<ItemDTO> products = (List<ItemDTO>) request.getAttribute("products");
    boolean isAdd = "add".equals(mode);

    if (products == null) {
        products = new java.util.ArrayList<>();
    }

    String msg = (String) request.getAttribute("msg");
    String error = (String) request.getAttribute("error");

    Boolean sessionDark = (Boolean) session.getAttribute("darkMode");
    boolean isDarkMode = sessionDark != null ? sessionDark : false;
    String activePage = "bom";
    String pageTitle = isAdd ? "Thêm BOM" : "Sửa BOM";
    String lang = session.getAttribute("lang") != null ? (String) session.getAttribute("lang") : "vi";

    request.setAttribute("activePage", activePage);
    request.setAttribute("pageTitle", pageTitle);

    String selectedStatus = bom != null && bom.getStatus() != null ? bom.getStatus() : "active";
    String versionValue = bom != null && bom.getBomVersion() != null ? bom.getBomVersion() : "v1.0";
    String notesValue = bom != null && bom.getNotes() != null ? bom.getNotes() : "";
%>
<!DOCTYPE html>
<html lang="<%= lang %>" class="<%= isDarkMode ? "dark" : "" %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> - PMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class'
        };
    </script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <style>
        * { font-family: 'Inter', 'Segoe UI', Arial, sans-serif; }
        body { overflow-x: hidden; }

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
        .sidebar-nav::-webkit-scrollbar {
            width: 4px;
        }
        .sidebar-nav::-webkit-scrollbar-track {
            background: #1e293b;
        }
        .sidebar-nav::-webkit-scrollbar-thumb {
            background: #475569;
            border-radius: 2px;
        }

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
            .main-wrapper {
                margin-left: 280px;
            }
        }

        .dark .sidebar-fixed,
        .dark .sidebar-header,
        .dark .sidebar-footer {
            background: #0f172a;
        }

        .section-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(14px);
        }
        .dark .section-card {
            background: rgba(15, 23, 42, 0.88);
        }
    </style>
    <script src="js/common.js"></script>
</head>
<body class="bg-slate-100 text-slate-900 min-h-screen antialiased dark:bg-slate-900 dark:text-slate-100 <%= isDarkMode ? "dark dark-mode-init" : "" %>">
    <div class="min-h-screen flex">
        <jsp:include page="components/shared-sidebar.jsp" />

        <div id="mainWrapper" class="main-wrapper flex-1 flex flex-col min-h-screen min-w-0">
            <jsp:include page="components/shared-header.jsp" />

            <main class="flex-1 overflow-y-auto bg-slate-100 p-4 dark:bg-slate-900 sm:p-6 lg:p-8">
                <div class="mb-6 flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                    <div>
                        <h1 class="text-2xl font-semibold text-slate-900 dark:text-slate-100"><%= isAdd ? "Thêm BOM mới" : "Sửa BOM" %></h1>
                        <p class="mt-1 text-sm text-slate-500 dark:text-slate-400"><%= isAdd ? "Tạo cấu hình BOM mới cho sản phẩm." : "Cập nhật thông tin BOM theo giao diện đồng bộ với danh sách." %></p>
                    </div>
                    <div class="flex flex-wrap gap-2">
                        <a href="BOMController?action=list" class="rounded-2xl border border-slate-200 bg-white px-4 py-2.5 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700">← Danh sách BOM</a>
                        <% if (!isAdd && bom != null) { %>
                        <a href="BOMController?action=viewBOM&id=<%= bom.getBomId() %>" class="rounded-2xl border border-teal-200 bg-teal-50 px-4 py-2.5 text-sm font-medium text-teal-700 transition-colors hover:bg-teal-100 dark:border-teal-500/30 dark:bg-teal-500/10 dark:text-teal-300 dark:hover:bg-teal-500/20">Xem chi tiết</a>
                        <% } %>
                    </div>
                </div>

                <% if (msg != null && !msg.trim().isEmpty()) { %>
                <div class="mb-6 flex items-center gap-3 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-4 text-emerald-700 dark:border-emerald-500/30 dark:bg-emerald-500/10 dark:text-emerald-300">
                    <svg class="h-5 w-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <span><%= msg %></span>
                </div>
                <% } %>

                <% if (error != null && !error.trim().isEmpty()) { %>
                <div class="mb-6 flex items-center gap-3 rounded-2xl border border-rose-200 bg-rose-50 px-4 py-4 text-rose-700 dark:border-rose-500/30 dark:bg-rose-500/10 dark:text-rose-300">
                    <svg class="h-5 w-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <span><%= error %></span>
                </div>
                <% } %>

                <section class="section-card rounded-3xl border border-slate-200/70 p-6 shadow-sm dark:border-slate-700/60">
                    <div class="mb-6 flex items-start justify-between gap-4">
                        <div>
                            <h2 class="text-lg font-semibold text-slate-900 dark:text-slate-100"><%= isAdd ? "Thông tin BOM mới" : "Thông tin BOM cần chỉnh sửa" %></h2>
                            <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Nhập dữ liệu cần thiết rồi lưu lại.</p>
                        </div>
                        <% if (!isAdd && bom != null) { %>
                        <span class="inline-flex items-center rounded-full bg-slate-100 px-3 py-1 text-xs font-semibold text-slate-700 ring-1 ring-slate-200 dark:bg-slate-800 dark:text-slate-300 dark:ring-slate-700">BOM #<%= bom.getBomId() %></span>
                        <% } %>
                    </div>

                    <form method="post" action="BOMController" class="space-y-6">
                        <input type="hidden" name="action" value="<%= isAdd ? "saveAddBOM" : "saveUpdateBOM" %>">
                        <% if (!isAdd && bom != null) { %>
                        <input type="hidden" name="id" value="<%= bom.getBomId() %>">
                        <% } %>

                        <div class="grid gap-5 md:grid-cols-2">
                            <div class="md:col-span-2">
                                <label for="productItemId" class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-200">Sản phẩm áp dụng</label>
                                <select id="productItemId" name="productItemId" required class="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-700 outline-none transition focus:border-teal-500 focus:ring-2 focus:ring-teal-500/20 dark:border-slate-700 dark:bg-slate-900 dark:text-slate-100 dark:focus:border-teal-400">
                                    <option value="">-- Chọn sản phẩm --</option>
                                    <% for (ItemDTO p : products) { %>
                                    <option value="<%= p.getItemID() %>" <%= bom != null && bom.getProductItemId() == p.getItemID() ? "selected" : "" %>><%= p.getItemName() %></option>
                                    <% } %>
                                </select>
                            </div>

                            <div>
                                <label for="version" class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-200">Phiên bản BOM</label>
                                <input id="version" type="text" name="version" required value="<%= versionValue %>" placeholder="VD: v1.0, v2.0" class="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-700 outline-none transition focus:border-teal-500 focus:ring-2 focus:ring-teal-500/20 dark:border-slate-700 dark:bg-slate-900 dark:text-slate-100 dark:focus:border-teal-400">
                            </div>

                            <div>
                                <label for="status" class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-200">Trạng thái</label>
                                <select id="status" name="status" class="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-700 outline-none transition focus:border-teal-500 focus:ring-2 focus:ring-teal-500/20 dark:border-slate-700 dark:bg-slate-900 dark:text-slate-100 dark:focus:border-teal-400">
                                    <option value="active" <%= "active".equals(selectedStatus) ? "selected" : "" %>>Đang dùng</option>
                                    <option value="pending" <%= "pending".equals(selectedStatus) ? "selected" : "" %>>Chờ duyệt</option>
                                    <option value="inactive" <%= "inactive".equals(selectedStatus) ? "selected" : "" %>>Ngưng dùng</option>
                                </select>
                            </div>

                            <div class="md:col-span-2">
                                <label for="notes" class="mb-2 block text-sm font-medium text-slate-700 dark:text-slate-200">Ghi chú</label>
                                <textarea id="notes" name="notes" rows="5" placeholder="Nhập ghi chú cho BOM" class="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-700 outline-none transition focus:border-teal-500 focus:ring-2 focus:ring-teal-500/20 dark:border-slate-700 dark:bg-slate-900 dark:text-slate-100 dark:focus:border-teal-400"><%= notesValue %></textarea>
                            </div>
                        </div>

                        <div class="flex flex-wrap items-center gap-3 border-t border-slate-200 pt-5 dark:border-slate-700">
                            <button type="submit" class="rounded-2xl bg-teal-600 px-5 py-3 text-sm font-medium text-white shadow-sm shadow-teal-500/30 transition-colors hover:bg-teal-700"><%= isAdd ? "Lưu BOM mới" : "Lưu thay đổi" %></button>
                            <% if (!isAdd && bom != null) { %>
                            <a href="BOMController?action=viewBOM&id=<%= bom.getBomId() %>" class="rounded-2xl border border-slate-200 bg-white px-5 py-3 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700">Hủy</a>
                            <% } else { %>
                            <a href="BOMController?action=list" class="rounded-2xl border border-slate-200 bg-white px-5 py-3 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700">Hủy</a>
                            <% } %>
                        </div>
                    </form>
                </section>
            </main>
        </div>
    </div>
</body>
</html>
