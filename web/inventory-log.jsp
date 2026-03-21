<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="pms.model.InventoryLogDTO"%>
<%@page import="pms.model.ItemDTO"%>
<%@page import="pms.model.UserDTO"%>
<%
    List<InventoryLogDTO> logs = (List<InventoryLogDTO>) request.getAttribute("logs");
    String mode = (String) request.getAttribute("mode");
    ItemDTO item = (ItemDTO) request.getAttribute("item");
    String pageTitle = "Lịch sử Tồn Kho" + (item != null ? (" - " + item.getItemName()) : "");
    request.setAttribute("pageTitle", pageTitle);
    request.setAttribute("activePage", "inventory");
    
    UserDTO u = (UserDTO) session.getAttribute("user");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    boolean isAdmin = "admin".equalsIgnoreCase(u.getRole());
    String userName = u.getUsername();
    String userRole = u.getRole();
    Boolean sessionDark = (Boolean) session.getAttribute("darkMode");
    boolean isDarkMode = sessionDark != null ? sessionDark : false;
%>
<!DOCTYPE html>
<html lang="vi" class="<%= isDarkMode ? "dark" : "" %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> - PMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter', 'Segoe UI', 'Arial', 'sans-serif'] }
                }
            }
        }
    </script>
    <style>
        body { font-family: Inter, "Segoe UI", Arial, sans-serif; }
        .sidebar-fixed { position: fixed; top: 0; left: 0; height: 100vh; z-index: 40; }
        .sidebar-header { position: sticky; top: 0; background: #0f172a; z-index: 10; }
        .sidebar-nav { flex: 1; overflow-y: auto; scrollbar-width: thin; scrollbar-color: #475569 #1e293b; }
        .sidebar-nav::-webkit-scrollbar { width: 4px; }
        .sidebar-nav::-webkit-scrollbar-track { background: #1e293b; }
        .sidebar-nav::-webkit-scrollbar-thumb { background: #475569; border-radius: 2px; }
        .sidebar-footer { position: sticky; bottom: 0; background: #0f172a; z-index: 10; }
        .main-wrapper { margin-left: 0; transition: margin-left 0.3s ease; }
        @media (min-width: 1024px) { .main-wrapper { margin-left: 280px; } }
    </style>
    <script src="js/common.js"></script>
</head>
<body class="bg-slate-100 text-slate-900 min-h-screen antialiased <%= isDarkMode ? "dark dark-mode-init" : "" %>">
    <div class="min-h-screen flex">
        <jsp:include page="components/shared-sidebar.jsp" />

        <div id="mainWrapper" class="main-wrapper flex-1 flex flex-col min-h-screen min-w-0">
            <jsp:include page="components/shared-header.jsp" />

            <main class="flex-1 overflow-y-auto p-4 lg:p-6 bg-slate-100 dark:bg-slate-900">
                <% String cmsg = (String) request.getAttribute("msg");
                   String cerror = (String) request.getAttribute("error");
                   if (cmsg != null) { %>
                    <div class="mb-4 bg-teal-50 border-l-4 border-teal-500 p-4 rounded-r-xl shadow-sm dark:bg-teal-900/30 dark:border-teal-400">
                        <div class="flex items-center">
                            <svg class="h-5 w-5 text-teal-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                            <p class="text-sm text-teal-700 dark:text-teal-300 font-medium"><%= cmsg %></p>
                        </div>
                    </div>
                <% }
                   if (cerror != null) { %>
                    <div class="mb-4 bg-rose-50 border-l-4 border-rose-500 p-4 rounded-r-xl shadow-sm dark:bg-rose-900/30 dark:border-rose-400">
                        <div class="flex items-center">
                            <svg class="h-5 w-5 text-rose-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                            <p class="text-sm text-rose-700 dark:text-rose-300 font-medium"><%= cerror %></p>
                        </div>
                    </div>
                <% } %>

                <!-- Page Header -->
                <div class="mb-6 rounded-3xl border border-slate-200 bg-gradient-to-br from-white via-slate-50 to-teal-50/70 p-6 shadow-sm dark:border-slate-700 dark:from-slate-900 dark:via-slate-900 dark:to-teal-950/30">
                    <div class="flex flex-col gap-5 lg:flex-row lg:items-center lg:justify-between">
                        <div class="max-w-3xl">
                            <div class="inline-flex items-center gap-2 rounded-full border border-teal-200 bg-teal-50 px-3 py-1 text-xs font-semibold uppercase tracking-[0.2em] text-teal-700 dark:border-teal-500/30 dark:bg-teal-500/10 dark:text-teal-300">
                                Kho hàng
                            </div>
                            <h1 class="mt-3 text-2xl font-semibold text-slate-900 dark:text-slate-100"><%= pageTitle %></h1>
                            <p class="mt-2 text-sm leading-6 text-slate-600 dark:text-slate-400">Theo dõi lịch sử nhập, xuất, điều chỉnh tồn kho của vật tư và sản phẩm.</p>
                        </div>
                        <div class="flex flex-wrap items-center gap-3">
                            <a href="InventoryController?action=list" class="inline-flex items-center gap-2 rounded-2xl <%= "all".equals(mode) ? "bg-teal-600 text-white shadow-sm shadow-teal-500/30" : "bg-white text-slate-600 border border-slate-200 hover:bg-slate-50 dark:bg-slate-800 dark:text-slate-300 dark:border-slate-700" %> px-5 py-3 text-sm font-semibold transition-all hover:-translate-y-0.5">
                                Tất cả
                            </a>
                            <% if("byItem".equals(mode) && item != null) { %>
                                <span class="inline-flex items-center gap-2 rounded-2xl bg-teal-600 text-white px-5 py-3 text-sm font-semibold shadow-sm shadow-teal-500/30">Lọc: <%= item.getItemName() %></span>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Table Card -->
                <div class="bg-white dark:bg-slate-800 rounded-3xl shadow-sm border border-slate-200 dark:border-slate-700 overflow-hidden">
                    <div class="p-5 border-b border-slate-100 dark:border-slate-700/50 flex flex-col sm:flex-row items-center justify-between gap-4">
                        <h2 class="text-lg font-bold text-slate-800 dark:text-white flex items-center gap-2">
                            <svg class="w-5 h-5 text-teal-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
                            Nhật ký nhập/xuất/điều chỉnh
                        </h2>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-slate-50 dark:bg-slate-800/80 text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
                                    <th class="px-6 py-4 border-b border-slate-200 dark:border-slate-700">Thời gian</th>
                                    <th class="px-6 py-4 border-b border-slate-200 dark:border-slate-700">Vật tư / Sản phẩm</th>
                                    <th class="px-6 py-4 border-b border-slate-200 dark:border-slate-700 text-center">Biến động</th>
                                    <th class="px-6 py-4 border-b border-slate-200 dark:border-slate-700">Loại tham chiếu</th>
                                    <th class="px-6 py-4 border-b border-slate-200 dark:border-slate-700">Lý do</th>
                                    <th class="px-6 py-4 border-b border-slate-200 dark:border-slate-700 text-right">Người thực hiện</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100 dark:divide-slate-700/50">
                                <% if (logs == null || logs.isEmpty()) { %>
                                    <tr>
                                        <td colspan="6" class="px-6 py-12 text-center text-slate-500">Chưa có dữ liệu biến động tồn kho.</td>
                                    </tr>
                                <% } else {
                                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
                                    for (InventoryLogDTO log : logs) { 
                                        String cType = log.getChangeType();
                                        String badgeClass = "bg-slate-100 text-slate-600";
                                        String icon = "";
                                        if ("IN".equals(cType) || log.getQuantityChange() > 0) {
                                            badgeClass = "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400";
                                            icon = "+";
                                        } else if ("OUT".equals(cType) || log.getQuantityChange() < 0) {
                                            badgeClass = "bg-rose-100 text-rose-700 dark:bg-rose-900/30 dark:text-rose-400";
                                            icon = "";
                                        } else {
                                            badgeClass = "bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400";
                                            icon = "";
                                        }
                                %>
                                <tr class="hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors">
                                    <td class="px-6 py-4 text-sm whitespace-nowrap text-slate-600 dark:text-slate-300"><%= log.getLogDate() != null ? sdf.format(log.getLogDate()) : "" %></td>
                                    <td class="px-6 py-4 font-medium text-slate-800 dark:text-slate-200"><%= log.getItemName() %></td>
                                    <td class="px-6 py-4 text-center">
                                        <div class="flex flex-col items-center">
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium <%= badgeClass %>">
                                                <%= icon %><%= log.getQuantityChange() %>
                                            </span>
                                            <span class="text-[10px] text-slate-400 mt-1"><%= log.getQuantityBefore() %> &rarr; <%= log.getQuantityAfter() %></span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-slate-600 dark:text-slate-300">
                                        <span class="font-medium text-slate-700 dark:text-slate-300 border border-slate-200 dark:border-slate-600 px-2 py-1 rounded text-xs">
                                            <%= log.getReferenceType() %> <%= log.getReferenceId() > 0 ? "#" + log.getReferenceId() : "" %>
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-slate-500 italic max-w-xs truncate"><%= log.getReason() != null ? log.getReason() : "" %></td>
                                    <td class="px-6 py-4 text-sm text-slate-600 dark:text-slate-300 text-right"><%= log.getPerformerName() != null ? log.getPerformerName() : "Admin" %></td>
                                </tr>
                                <%  }
                                } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
