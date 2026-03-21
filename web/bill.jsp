<%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.ArrayList, pms.model.BillDTO, pms.model.WorkOrderDTO, pms.model.CustomerDTO, pms.model.UserDTO, java.text.DecimalFormat, java.text.SimpleDateFormat"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    
    ArrayList<BillDTO> billList = (ArrayList<BillDTO>) request.getAttribute("billList");
    ArrayList<WorkOrderDTO> workOrders = (ArrayList<WorkOrderDTO>) request.getAttribute("workOrders");
    ArrayList<CustomerDTO> customers = (ArrayList<CustomerDTO>) request.getAttribute("customers");
    UserDTO user = (UserDTO) session.getAttribute("user");
    
    String msg = (String) request.getAttribute("msg");
    String error = (String) request.getAttribute("error");
    String filterStatus = request.getParameter("filter");
    String searchKeyword = request.getParameter("keyword");
    
    if (billList == null) billList = new ArrayList<>();
    if (workOrders == null) workOrders = new ArrayList<>();
    if (customers == null) customers = new ArrayList<>();
    if (filterStatus == null) filterStatus = "all";
    
    DecimalFormat df = new DecimalFormat("#,###");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    
    String userName = user != null ? user.getUsername() : "User";
    String userRole = user != null ? user.getRole() : "user";
    Boolean sessionDark = (Boolean) session.getAttribute("darkMode");
    boolean isAdmin = "admin".equalsIgnoreCase(userRole);
    boolean isDarkMode = sessionDark != null ? sessionDark : false;
    String activePage = "bill";
    String pageTitle = "Quản lý hóa đơn";
    String lang = session.getAttribute("lang") != null ? (String) session.getAttribute("lang") : "vi";
    int unreadCount = session.getAttribute("unreadCount") != null ? (Integer) session.getAttribute("unreadCount") : 0;
    request.setAttribute("activePage", activePage);
    request.setAttribute("pageTitle", pageTitle);
    
    double totalAmount = 0;
    int countPaid = 0;
    int countPending = 0;
    
    for (BillDTO b : billList) {
        if (b.getTotal_amount() > 0) totalAmount += b.getTotal_amount();
        if ("paid".equalsIgnoreCase(b.getStatus())) countPaid++;
        else if ("pending".equalsIgnoreCase(b.getStatus())) countPending++;
    }
%>
<!DOCTYPE html>
<html lang="<%= lang %>" class="<%= isDarkMode ? "dark" : "" %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Hóa Đơn - PMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', 'Segoe UI', 'Arial', 'sans-serif']
                    }
                }
            }
        };
    </script>
    <style>
        * { font-family: 'Inter', 'Segoe UI', Arial, sans-serif; }
        body { overflow-x: hidden; }
        .sidebar-fixed { position: fixed; top: 0; left: 0; height: 100vh; z-index: 40; }
        .sidebar-header { position: sticky; top: 0; background: #0f172a; z-index: 10; }
        .sidebar-nav { flex: 1; overflow-y: auto; scrollbar-width: thin; scrollbar-color: #475569 #1e293b; }
        .sidebar-nav::-webkit-scrollbar { width: 4px; }
        .sidebar-nav::-webkit-scrollbar-track { background: #1e293b; }
        .sidebar-nav::-webkit-scrollbar-thumb { background: #475569; border-radius: 2px; }
        .sidebar-footer { position: sticky; bottom: 0; background: #0f172a; z-index: 10; }
        .main-wrapper { margin-left: 0; transition: margin-left 0.3s ease; }
        @media (min-width: 1024px) { .main-wrapper { margin-left: 280px; } }
        .kpi-card { transition: all 0.2s ease; }
        .kpi-card:hover { transform: translateY(-2px); box-shadow: 0 8px 30px rgba(0,0,0,0.1); }
        .dark .kpi-card { background: #1e293b; border-color: #334155; }
        .status-paid { background: #d1fae5; color: #047857; }
        .status-pending { background: #fef3c7; color: #b45309; }
        .status-cancelled { background: #fee2e2; color: #b91c1c; }
        .filter-btn { transition: all 0.2s; }
        .filter-btn:hover { transform: translateY(-1px); }
        .dark body, .dark .main-header, .dark .bg-white { background-color: #1e293b !important; }
        .dark .text-slate-900, .dark .text-slate-800, .dark .text-slate-700 { color: #e2e8f0 !important; }
        .dark .border-slate-200 { border-color: #334155 !important; }
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
                        <h1 class="text-2xl font-semibold text-slate-900 dark:text-slate-100">Quản lý hóa đơn</h1>
                        <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Theo dõi hóa đơn, trạng thái thanh toán và tổng doanh thu từ đơn sản xuất.</p>
                    </div>
                    <div class="flex flex-wrap items-center gap-3">
                        <a href="MainController?action=listBill&filter=all" class="inline-flex items-center gap-2 rounded-2xl border border-slate-200 bg-white px-4 py-2.5 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700">
                            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
                            </svg>
                            Làm mới
                        </a>
                        <button type="button" onclick="openAddModal()" class="inline-flex items-center gap-2 rounded-2xl bg-teal-600 px-5 py-2.5 font-semibold text-white shadow-sm shadow-teal-500/30 transition-all hover:bg-teal-700">
                            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                            </svg>
                            Tạo hóa đơn mới
                        </button>
                    </div>
                </div>

                <!-- Alerts -->
                <% if (msg != null && !msg.isEmpty()) { %>
                <div class="mb-6 p-4 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-700 flex items-center gap-3 dark:bg-emerald-900/30 dark:border-emerald-700 dark:text-emerald-300">
                    <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <%= msg %>
                </div>
                <% } %>
                <% if (error != null && !error.isEmpty()) { %>
                <div class="mb-6 p-4 rounded-xl bg-red-50 border border-red-200 text-red-700 flex items-center gap-3 dark:bg-red-900/30 dark:border-red-700 dark:text-red-300">
                    <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <%= error %>
                </div>
                <% } %>

                <!-- Stats Cards -->
                <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
                    <div class="kpi-card bg-white rounded-2xl p-5 shadow-sm border-t-4 border-blue-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase text-slate-500">Tổng Số Hóa Đơn</p>
                                <p class="mt-2 text-3xl font-bold text-slate-800"><%= billList.size() %></p>
                                <p class="mt-1 text-xs text-slate-400">Tất cả hóa đơn</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-blue-600">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
                            </div>
                        </div>
                    </div>
                    <div class="kpi-card bg-white rounded-2xl p-5 shadow-sm border-t-4 border-emerald-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase text-slate-500">Đã Thanh Toán</p>
                                <p class="mt-2 text-3xl font-bold text-emerald-600"><%= countPaid %></p>
                                <p class="mt-1 text-xs text-slate-400">Hóa đơn đã thanh toán</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-emerald-50 text-emerald-600">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                            </div>
                        </div>
                    </div>
                    <div class="kpi-card bg-white rounded-2xl p-5 shadow-sm border-t-4 border-amber-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase text-slate-500">Chờ Thanh Toán</p>
                                <p class="mt-2 text-3xl font-bold text-amber-600"><%= countPending %></p>
                                <p class="mt-1 text-xs text-slate-400">Hóa đơn chưa thanh toán</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-amber-50 text-amber-600">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                            </div>
                        </div>
                    </div>
                    <div class="kpi-card bg-white rounded-2xl p-5 shadow-sm border-t-4 border-teal-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase text-slate-500">Tổng Tiền</p>
                                <p class="mt-2 text-2xl font-bold text-teal-600"><%= df.format(totalAmount) %></p>
                                <p class="mt-1 text-xs text-slate-400">VND</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-teal-50 text-teal-600">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Actions Row -->
                <div class="section-card mb-6 rounded-3xl border border-slate-200 p-4 shadow-sm dark:border-slate-700">
                    <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
                        <div class="flex flex-wrap gap-2">
                            <a href="MainController?action=listBill&filter=all" class="filter-btn rounded-2xl border px-4 py-2 text-sm font-medium <%= "all".equals(filterStatus) ? "border-teal-600 bg-teal-600 text-white" : "border-slate-200 bg-white text-slate-600 hover:bg-slate-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700" %>">
                                Tất cả
                            </a>
                            <a href="MainController?action=listBill&filter=paid" class="filter-btn rounded-2xl border px-4 py-2 text-sm font-medium <%= "paid".equals(filterStatus) ? "border-emerald-600 bg-emerald-600 text-white" : "border-slate-200 bg-white text-slate-600 hover:bg-slate-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700" %>">
                                Đã thanh toán
                            </a>
                            <a href="MainController?action=listBill&filter=pending" class="filter-btn rounded-2xl border px-4 py-2 text-sm font-medium <%= "pending".equals(filterStatus) ? "border-amber-500 bg-amber-500 text-white" : "border-slate-200 bg-white text-slate-600 hover:bg-slate-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700" %>">
                                Chờ thanh toán
                            </a>
                        </div>
                        <form action="MainController" method="get" class="flex w-full flex-col gap-2 sm:w-auto sm:flex-row">
                            <input type="hidden" name="action" value="listBill"/>
                            <input type="hidden" name="filter" value="<%= filterStatus %>"/>
                            <input type="text" name="keyword" value="<%= searchKeyword != null ? searchKeyword : "" %>"
                                   placeholder="Tìm theo mã hóa đơn hoặc khách hàng..."
                                   class="min-w-[260px] rounded-2xl border border-slate-200 px-4 py-2.5 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200 dark:bg-slate-800 dark:border-slate-700 dark:text-white">
                            <button type="submit" class="rounded-2xl bg-slate-900 px-4 py-2.5 text-sm font-semibold text-white transition-colors hover:bg-slate-700 dark:bg-slate-700 dark:hover:bg-slate-600">
                                Tìm kiếm
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Bills Table -->
                <div class="section-card overflow-hidden rounded-3xl border border-slate-200 shadow-sm dark:border-slate-700">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="border-b border-slate-100 bg-slate-50 dark:bg-slate-700/50 dark:border-slate-700">
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Mã HD</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Khách Hàng</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Sản Phẩm</th>
                                    <th class="px-4 py-3 text-right text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Tổng Tiền</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Trạng Thái</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Ngày Lập</th>
                                    <th class="px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (billList.isEmpty()) { %>
                                <tr>
                                    <td colspan="7" class="px-6 py-16 text-center text-slate-400">
                                        <div class="mx-auto flex max-w-md flex-col items-center gap-3">
                                            <div class="flex h-16 w-16 items-center justify-center rounded-2xl bg-slate-100 text-slate-400 dark:bg-slate-700/60 dark:text-slate-500">
                                                <svg class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                                </svg>
                                            </div>
                                            <div>
                                                <p class="text-base font-semibold text-slate-700 dark:text-slate-200">Chưa có hóa đơn nào</p>
                                                <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Tạo hóa đơn đầu tiên để theo dõi thanh toán và doanh thu ngay trên bảng điều khiển này.</p>
                                            </div>
                                            <button type="button" onclick="openAddModal()" class="inline-flex items-center gap-2 rounded-2xl bg-teal-600 px-4 py-2.5 text-sm font-semibold text-white shadow-sm shadow-teal-500/30 transition-all hover:bg-teal-700">
                                                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                                                </svg>
                                                Tạo hóa đơn mới
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <% } else { 
                                    for (BillDTO b : billList) {
                                        String statusClass = "pending".equalsIgnoreCase(b.getStatus()) ? "status-pending" : 
                                                            "paid".equalsIgnoreCase(b.getStatus()) ? "status-paid" : "status-cancelled";
                                        String statusLabel = "pending".equalsIgnoreCase(b.getStatus()) ? "Chờ TT" : 
                                                            "paid".equalsIgnoreCase(b.getStatus()) ? "Đã TT" : "Đã Hủy";
                                %>
                                <tr class="border-b border-slate-50 last:border-0 hover:bg-slate-50 transition-colors dark:border-slate-700 dark:hover:bg-slate-700/50">
                                    <td class="px-4 py-3 text-sm font-semibold text-slate-700 dark:text-slate-300">#<%= b.getBill_id() %></td>
                                    <td class="px-4 py-3 text-sm text-slate-600 dark:text-slate-400">
                                        <%= b.getCustomerName() != null ? b.getCustomerName() : "ID: " + b.getCustomer_id() %>
                                    </td>
                                    <td class="px-4 py-3 text-sm text-slate-600 dark:text-slate-400">
                                        <a href="MainController?action=listWorkOrder" class="text-teal-600 hover:text-teal-800 font-semibold dark:text-teal-400"><%= b.getProductName() != null ? b.getProductName() : "WO-" + b.getWo_id() %></a>
                                    </td>
                                    <td class="px-4 py-3 text-sm text-right font-semibold text-teal-600 dark:text-teal-400"><%= df.format(b.getTotal_amount()) %> VND</td>
                                    <td class="px-4 py-3">
                                        <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold <%= statusClass %>">
                                            <%= statusLabel %>
                                        </span>
                                    </td>
                                    <td class="px-4 py-3 text-sm text-slate-500 dark:text-slate-400">
                                        <%= b.getBill_date() != null ? sdf.format(b.getBill_date()) : "-" %>
                                    </td>
                                    <td class="px-4 py-3 text-center">
                                        <div class="flex items-center justify-center gap-2">
                                            <% if (!"paid".equalsIgnoreCase(b.getStatus())) { %>
                                            <a href="PaymentController?action=createQr&bill_id=<%= b.getBill_id() %>&amount=<%= b.getTotal_amount() %>" class="p-2 rounded-lg text-slate-500 hover:bg-emerald-100 hover:text-emerald-600 dark:hover:bg-emerald-900/30" title="Tạo QR Thanh toán">
                                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                                                </svg>
                                            </a>
                                            <% } %>
                                            <button type="button" onclick="openEditModal('<%= b.getBill_id() %>', '<%= b.getWo_id() %>', '<%= b.getCustomer_id() %>', '<%= b.getTotal_amount() %>')" class="p-2 rounded-lg text-slate-500 hover:bg-amber-100 hover:text-amber-600 dark:hover:bg-amber-900/30" title="Sửa">
                                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                                </svg>
                                            </button>
                                            <a href="MainController?action=deleteBill&bill_id=<%= b.getBill_id() %>" onclick="return confirm('Bạn có chắc xoá hóa đơn này?');" class="p-2 rounded-lg text-slate-500 hover:bg-red-100 hover:text-red-600 dark:hover:bg-red-900/30" title="Xóa">
                                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                                </svg>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <% }} %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Add Bill Modal -->
    <div id="addModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-950/60 p-4 backdrop-blur-sm">
        <div class="w-full max-w-lg overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-2xl dark:border-slate-700 dark:bg-slate-900">
            <div class="flex items-center justify-between border-b border-slate-100 p-6 dark:border-slate-800">
                <div>
                    <h3 class="text-lg font-semibold text-slate-900 dark:text-slate-100">Tạo hóa đơn mới</h3>
                    <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Lập nhanh hóa đơn từ lệnh sản xuất và gắn khách hàng tương ứng.</p>
                </div>
                <button onclick="closeAddModal()" class="text-slate-400 hover:text-slate-600 dark:hover:text-slate-300">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
            </div>
            <form action="MainController" method="post" class="p-6 space-y-4">
                <input type="hidden" name="action" value="addBill"/>
                
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2 dark:text-slate-300">Lệnh Sản Xuất (WO)</label>
                    <select name="wo_id" required class="w-full rounded-2xl border border-slate-200 px-4 py-3 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200 dark:bg-slate-800 dark:border-slate-700 dark:text-white">
                        <option value="">-- Chọn lệnh sản xuất --</option>
                        <% for (WorkOrderDTO wo : workOrders) { %>
                        <option value="<%= wo.getWo_id() %>">WO-<%= wo.getWo_id() %> | <%= wo.getProductName() != null ? wo.getProductName() : "SP#" + wo.getProduct_item_id() %></option>
                        <% } %>
                    </select>
                </div>
                
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2 dark:text-slate-300">Khách Hàng</label>
                    <select name="customer_id" class="w-full rounded-2xl border border-slate-200 px-4 py-3 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200 dark:bg-slate-800 dark:border-slate-700 dark:text-white">
                        <option value="0">-- Khách hàng văn phòng --</option>
                        <% for (CustomerDTO c : customers) { %>
                        <option value="<%= c.getCustomer_id() %>"><%= c.getCustomer_name() %></option>
                        <% } %>
                    </select>
                </div>
                
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2 dark:text-slate-300">Tổng Tiền (VND)</label>
                    <input type="number" name="total_amount" required min="0" step="1000" placeholder="VD: 5000000"
                           class="w-full rounded-2xl border border-slate-200 px-4 py-3 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200 dark:bg-slate-800 dark:border-slate-700 dark:text-white">
                </div>
                
                <div class="flex gap-3 pt-4">
                    <button type="submit" class="flex-1 py-3 rounded-xl bg-teal-600 text-white font-semibold hover:bg-teal-700">
                        Tạo Hóa Đơn
                    </button>
                    <button type="button" onclick="closeAddModal()" class="px-6 py-3 rounded-xl border border-slate-200 text-slate-600 font-semibold hover:bg-slate-50 dark:border-slate-600 dark:text-slate-300 dark:hover:bg-slate-700">
                        Hủy
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Bill Modal -->
    <div id="editModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-950/60 p-4 backdrop-blur-sm">
        <div class="w-full max-w-lg overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-2xl dark:border-slate-700 dark:bg-slate-900">
            <div class="flex items-center justify-between border-b border-slate-100 p-6 dark:border-slate-800">
                <div>
                    <h3 class="text-lg font-semibold text-slate-900 dark:text-slate-100">Sửa hóa đơn</h3>
                    <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Từ đây bạn có thể cập nhật thông tin hóa đơn.</p>
                </div>
                <button onclick="closeEditModal()" class="text-slate-400 hover:text-slate-600 dark:hover:text-slate-300">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
            </div>
            <form action="MainController" method="post" class="p-6 space-y-4">
                <input type="hidden" name="action" value="updateBill"/>
                <input type="hidden" name="bill_id" id="edit_bill_id"/>
                
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2 dark:text-slate-300">Lệnh Sản Xuất (WO)</label>
                    <select name="wo_id" id="edit_wo_id" required class="w-full rounded-2xl border border-slate-200 px-4 py-3 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200 dark:bg-slate-800 dark:border-slate-700 dark:text-white">
                        <option value="">-- Chọn lệnh sản xuất --</option>
                        <% for (WorkOrderDTO wo : workOrders) { %>
                        <option value="<%= wo.getWo_id() %>">WO-<%= wo.getWo_id() %> | <%= wo.getProductName() != null ? wo.getProductName() : "SP#" + wo.getProduct_item_id() %></option>
                        <% } %>
                    </select>
                </div>
                
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2 dark:text-slate-300">Khách Hàng</label>
                    <select name="customer_id" id="edit_customer_id" class="w-full rounded-2xl border border-slate-200 px-4 py-3 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200 dark:bg-slate-800 dark:border-slate-700 dark:text-white">
                        <option value="0">-- Khách hàng văn phòng --</option>
                        <% for (CustomerDTO c : customers) { %>
                        <option value="<%= c.getCustomer_id() %>"><%= c.getCustomer_name() %></option>
                        <% } %>
                    </select>
                </div>
                
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2 dark:text-slate-300">Tổng Tiền (VND)</label>
                    <input type="number" name="total_amount" id="edit_total_amount" required min="0" step="1000" placeholder="VD: 5000000"
                           class="w-full rounded-2xl border border-slate-200 px-4 py-3 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200 dark:bg-slate-800 dark:border-slate-700 dark:text-white">
                </div>
                
                <div class="flex gap-3 pt-4">
                    <button type="submit" class="flex-1 py-3 rounded-xl bg-teal-600 text-white font-semibold hover:bg-teal-700">
                        Cập Nhật
                    </button>
                    <button type="button" onclick="closeEditModal()" class="px-6 py-3 rounded-xl border border-slate-200 text-slate-600 font-semibold hover:bg-slate-50 dark:border-slate-600 dark:text-slate-300 dark:hover:bg-slate-700">
                        Hủy
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Sidebar toggle
        let sidebarOpen = window.innerWidth >= 1024;
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const overlay = document.getElementById('sidebarOverlay');
            sidebarOpen = !sidebarOpen;
            if (sidebarOpen) {
                sidebar.classList.remove('-translate-x-full');
                overlay.classList.add('hidden');
            } else {
                sidebar.classList.add('-translate-x-full');
                if (window.innerWidth < 1024) overlay.classList.remove('hidden');
            }
            localStorage.setItem('sidebar_open', sidebarOpen ? '1' : '0');
        }
        document.addEventListener('DOMContentLoaded', function() {
            const saved = localStorage.getItem('sidebar_open');
            if (saved === '0') toggleSidebar();
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
        document.getElementById('addModal').addEventListener('click', function(e) {
            if (e.target === this) closeAddModal();
        });

        function openEditModal(billId, woId, customerId, amount) {
            document.getElementById('edit_bill_id').value = billId;
            document.getElementById('edit_wo_id').value = woId;
            document.getElementById('edit_customer_id').value = customerId;
            document.getElementById('edit_total_amount').value = parseFloat(amount);
            document.getElementById('editModal').classList.remove('hidden');
            document.getElementById('editModal').classList.add('flex');
        }
        function closeEditModal() {
            document.getElementById('editModal').classList.add('hidden');
            document.getElementById('editModal').classList.remove('flex');
        }
        document.getElementById('editModal').addEventListener('click', function(e) {
            if (e.target === this) closeEditModal();
        });

        // User dropdown
        function toggleUserDropdown() {
            const dd = document.getElementById('userDropdown');
            const notif = document.getElementById('notifPanel');
            if (notif) notif.classList.add('hidden');
            dd.classList.toggle('hidden');
        }
        function toggleNotificationPanel() {
            const notif = document.getElementById('notifPanel');
            const dd = document.getElementById('userDropdown');
            if (dd) dd.classList.add('hidden');
            notif.classList.toggle('hidden');
        }
        document.addEventListener('click', function(e) {
            const notif = document.getElementById('notifPanel');
            const notifBtn = e.target.closest('[onclick*="toggleNotificationPanel"]');
            const dd = document.getElementById('userDropdown');
            const ddBtn = e.target.closest('[onclick*="toggleUserDropdown"]');
            if (notif && !notif.contains(e.target) && !notifBtn) notif.classList.add('hidden');
            if (dd && !dd.contains(e.target) && !ddBtn) dd.classList.add('hidden');
        });

        // Global search
        function handleGlobalSearch(event) {
            if (event.key === 'Enter') {
                const q = event.target.value.trim();
                if (q) window.location.href = 'AutoCompleteSearchServlet?action=search&q=' + encodeURIComponent(q);
            }
        }
    </script>
</body>
</html>
