<%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.ArrayList, java.util.Map, java.util.HashMap, pms.model.BillDTO, pms.model.WorkOrderDTO, pms.model.CustomerDTO, pms.model.PaymentDTO, pms.model.UserDTO, java.text.DecimalFormat, java.text.SimpleDateFormat"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    
    ArrayList<BillDTO> billList = (ArrayList<BillDTO>) request.getAttribute("billList");
    ArrayList<WorkOrderDTO> workOrders = (ArrayList<WorkOrderDTO>) request.getAttribute("workOrders");
    ArrayList<CustomerDTO> customers = (ArrayList<CustomerDTO>) request.getAttribute("customers");
    Map<Integer, WorkOrderDTO> workOrderMap = (Map<Integer, WorkOrderDTO>) request.getAttribute("workOrderMap");
    Map<Integer, CustomerDTO> customerMap = (Map<Integer, CustomerDTO>) request.getAttribute("customerMap");
    Map<Integer, PaymentDTO> latestPaymentMap = (Map<Integer, PaymentDTO>) request.getAttribute("latestPaymentMap");
    UserDTO user = (UserDTO) session.getAttribute("user");
    
    String msg = request.getAttribute("msg") != null ? (String) request.getAttribute("msg") : request.getParameter("msg");
    String error = request.getAttribute("error") != null ? (String) request.getAttribute("error") : request.getParameter("error");
    String filterStatus = request.getParameter("filter");
    String searchKeyword = request.getParameter("keyword");
    
    if (billList == null) billList = new ArrayList<>();
    if (workOrders == null) workOrders = new ArrayList<>();
    if (customers == null) customers = new ArrayList<>();
    if (workOrderMap == null) workOrderMap = new HashMap<>();
    if (customerMap == null) customerMap = new HashMap<>();
    if (latestPaymentMap == null) latestPaymentMap = new HashMap<>();
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
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">WO</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Khách hàng</th>
                                    <th class="px-4 py-3 text-right text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Tổng tiền</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Hóa đơn</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Thanh toán</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Ngày lập</th>
                                    <th class="px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (billList.isEmpty()) { %>
                                <tr>
                                    <td colspan="8" class="px-6 py-16 text-center text-slate-400">
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
                                        WorkOrderDTO workOrder = workOrderMap.get(b.getWo_id());
                                        CustomerDTO customer = customerMap.get(b.getCustomer_id());
                                        PaymentDTO payment = latestPaymentMap.get(b.getBill_id());
                                        String statusClass = "pending".equalsIgnoreCase(b.getStatus()) ? "status-pending" :
                                                            "paid".equalsIgnoreCase(b.getStatus()) ? "status-paid" : "status-cancelled";
                                        String statusLabel = "pending".equalsIgnoreCase(b.getStatus()) ? "Chờ TT" :
                                                            "paid".equalsIgnoreCase(b.getStatus()) ? "Đã TT" : "Đã Hủy";
                                        String paymentClass = payment == null ? "bg-slate-100 text-slate-600 dark:bg-slate-800 dark:text-slate-300"
                                                : "PAID".equalsIgnoreCase(payment.getStatus()) ? "bg-emerald-100 text-emerald-700 dark:bg-emerald-500/10 dark:text-emerald-300"
                                                : "PENDING".equalsIgnoreCase(payment.getStatus()) ? "bg-amber-100 text-amber-700 dark:bg-amber-500/10 dark:text-amber-300"
                                                : "bg-red-100 text-red-700 dark:bg-red-500/10 dark:text-red-300";
                                        String paymentLabel = payment == null ? "Chưa tạo QR"
                                                : "PAID".equalsIgnoreCase(payment.getStatus()) ? "Đã thanh toán"
                                                : "PENDING".equalsIgnoreCase(payment.getStatus()) ? "Chờ thanh toán"
                                                : "Đã hết hạn";
                                        String customerName = customer != null ? customer.getCustomer_name() : (b.getCustomer_id() > 0 ? "KH-" + b.getCustomer_id() : "Khách lẻ");
                                        String customerEmail = customer != null && customer.getEmail() != null ? customer.getEmail() : "";
                                %>
                                <tr class="border-b border-slate-50 last:border-0 hover:bg-slate-50 transition-colors dark:border-slate-700 dark:hover:bg-slate-700/50">
                                    <td class="px-4 py-3 align-top text-sm font-semibold text-slate-700 dark:text-slate-300">#<%= b.getBill_id() %></td>
                                    <td class="px-4 py-3 align-top text-sm text-slate-600 dark:text-slate-400">
                                        <div class="font-semibold text-teal-600 dark:text-teal-400">WO-<%= b.getWo_id() %></div>
                                        <div class="mt-1 text-xs text-slate-400 dark:text-slate-500"><%= workOrder != null && workOrder.getProductName() != null ? workOrder.getProductName() : "Lệnh sản xuất" %></div>
                                    </td>
                                    <td class="px-4 py-3 align-top text-sm text-slate-600 dark:text-slate-400">
                                        <div class="font-medium text-slate-700 dark:text-slate-200"><%= customerName %></div>
                                        <div class="mt-1 text-xs text-slate-400 dark:text-slate-500"><%= customerEmail != null && !customerEmail.isEmpty() ? customerEmail : "Chưa có email" %></div>
                                    </td>
                                    <td class="px-4 py-3 align-top text-sm text-right font-semibold text-teal-600 dark:text-teal-400"><%= df.format(b.getTotal_amount()) %> VND</td>
                                    <td class="px-4 py-3 align-top">
                                        <div class="flex flex-col gap-2">
                                            <span class="inline-flex w-fit items-center px-2.5 py-1 rounded-full text-xs font-bold <%= statusClass %>">
                                                <%= statusLabel %>
                                            </span>
                                            <span class="text-xs text-slate-400 dark:text-slate-500">WO liên kết: <%= b.getWo_id() %></span>
                                        </div>
                                    </td>
                                    <td class="px-4 py-3 align-top">
                                        <div class="flex flex-col gap-2">
                                            <span class="inline-flex w-fit items-center rounded-full px-3 py-1 text-xs font-bold <%= paymentClass %>"><%= paymentLabel %></span>
                                            <% if (payment != null) { %>
                                            <span class="text-xs text-slate-400 dark:text-slate-500">Mã TT #<%= payment.getPaymentId() %> • <%= payment.getPaymentMethod() != null ? payment.getPaymentMethod() : "QR" %></span>
                                            <% } else { %>
                                            <span class="text-xs text-slate-400 dark:text-slate-500">Chưa có giao dịch QR cho hóa đơn này</span>
                                            <% } %>
                                        </div>
                                    </td>
                                    <td class="px-4 py-3 align-top text-sm text-slate-500 dark:text-slate-400">
                                        <%= b.getBill_date() != null ? sdf.format(b.getBill_date()) : "-" %>
                                    </td>
                                    <td class="px-4 py-3 align-top text-center">
                                        <div class="flex flex-wrap items-center justify-center gap-2">
                                            <% if (payment != null) { %>
                                            <button type="button"
                                                    data-bill-id="<%= b.getBill_id() %>"
                                                    data-amount="<%= b.getTotal_amount() %>"
                                                    data-customer-name="<%= customerName %>"
                                                    data-customer-email="<%= customerEmail %>"
                                                    onclick="openQrModal(this)"
                                                    class="rounded-xl bg-blue-600 px-3 py-1.5 text-sm font-medium text-white transition-colors hover:bg-blue-700 shadow-sm shadow-blue-500/30">Xem QR</button>
                                            <% } %>
                                            <% if (payment != null && "PENDING".equalsIgnoreCase(payment.getStatus())) { %>
                                            <form action="PaymentController" method="post" style="display:inline;" onsubmit="return confirm('Xác nhận khách hàng đã thanh toán?')">
                                                <input type="hidden" name="action" value="confirmPayment"/>
                                                <input type="hidden" name="payment_id" value="<%= payment.getPaymentId() %>"/>
                                                <input type="hidden" name="source" value="bill"/>
                                                <button type="submit" class="rounded-xl bg-emerald-600 px-3 py-1.5 text-sm font-medium text-white transition-colors hover:bg-emerald-700 shadow-sm shadow-emerald-500/30">Xác nhận</button>
                                            </form>
                                            <% } %>
                                            <% if (payment == null || !"PAID".equalsIgnoreCase(payment.getStatus())) { %>
                                            <button type="button"
                                                    data-bill-id="<%= b.getBill_id() %>"
                                                    data-amount="<%= b.getTotal_amount() %>"
                                                    data-customer-name="<%= customerName %>"
                                                    data-customer-email="<%= customerEmail %>"
                                                    onclick="openQrModal(this)"
                                                    class="rounded-xl bg-teal-600 px-3 py-1.5 text-sm font-medium text-white transition-colors hover:bg-teal-700 shadow-sm shadow-teal-500/30"><%= payment == null ? "Tạo QR" : "Tạo lại QR" %></button>
                                            <% } %>
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
            <form action="BillController" method="post" class="p-6 space-y-4">
                <input type="hidden" name="action" value="addBill"/>
                
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2 dark:text-slate-300">Lệnh Sản Xuất (WO)</label>
                    <select id="billWoSelect" name="wo_id" required class="w-full rounded-2xl border border-slate-200 px-4 py-3 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200 dark:bg-slate-800 dark:border-slate-700 dark:text-white">
                        <option value="">-- Chọn lệnh sản xuất --</option>
                        <% for (WorkOrderDTO wo : workOrders) { %>
                        <option value="<%= wo.getWo_id() %>" data-customer-id="<%= wo.getCustomerId() %>">WO-<%= wo.getWo_id() %> | <%= wo.getProductName() != null ? wo.getProductName() : "SP#" + wo.getProduct_item_id() %></option>
                        <% } %>
                    </select>
                    <p class="mt-2 text-xs text-slate-500 dark:text-slate-400">Chọn lệnh sản xuất để liên kết hóa đơn với đơn hàng tương ứng.</p>
                </div>
                
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2 dark:text-slate-300">Khách Hàng</label>
                    <select id="billCustomerSelect" name="customer_id" required class="w-full rounded-2xl border border-slate-200 px-4 py-3 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200 dark:bg-slate-800 dark:border-slate-700 dark:text-white">
                        <option value="">-- Chọn khách hàng --</option>
                        <% for (CustomerDTO c : customers) { %>
                        <option value="<%= c.getCustomer_id() %>"><%= c.getCustomer_name() %></option>
                        <% } %>
                    </select>
                    <p class="mt-2 text-xs text-slate-500 dark:text-slate-400">Nếu WO không tự điền khách hàng, hệ thống sẽ giữ sẵn khách hàng đầu tiên để bạn có thể tạo hóa đơn ngay.</p>
                </div>
                
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2 dark:text-slate-300">Tổng Tiền (VND)</label>
                    <input id="billTotalAmount" type="number" name="total_amount" required min="1000" step="1000" placeholder="VD: 5000000"
                           class="w-full rounded-2xl border border-slate-200 px-4 py-3 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200 dark:bg-slate-800 dark:border-slate-700 dark:text-white">
                    <p class="mt-2 text-xs text-slate-500 dark:text-slate-400">Nhập số tiền lớn hơn 0 để có thể tạo hóa đơn.</p>
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

    <div id="qrModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-950/60 p-4 backdrop-blur-sm">
        <div class="w-full max-w-2xl overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-2xl dark:border-slate-700 dark:bg-slate-900">
            <div class="flex items-start justify-between border-b border-slate-100 px-6 py-5 dark:border-slate-800">
                <div>
                    <h3 class="text-lg font-semibold text-slate-900 dark:text-slate-100">Tạo mã QR thanh toán</h3>
                    <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Tạo giao dịch QR trực tiếp ngay trong quản lý hóa đơn.</p>
                </div>
                <button type="button" onclick="closeQrModal()" class="rounded-2xl p-2 text-slate-400 transition-colors hover:bg-slate-100 hover:text-slate-600 dark:hover:bg-slate-800 dark:hover:text-slate-300">
                    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
            </div>
            <form id="qrCreateForm" action="PaymentController" method="post" class="space-y-5 px-6 py-6">
                <input type="hidden" name="action" value="createQr"/>
                <input type="hidden" name="source" value="bill"/>
                <input type="hidden" name="ajax" value="1"/>
                <div class="grid gap-5 md:grid-cols-2">
                    <div>
                        <label class="mb-2 block text-sm font-semibold text-slate-700 dark:text-slate-200">Mã hóa đơn *</label>
                        <input id="qrBillId" type="number" name="bill_id" required readonly class="w-full rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 dark:border-slate-700 dark:bg-slate-800 dark:text-white"/>
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-semibold text-slate-700 dark:text-slate-200">Số tiền (VND) *</label>
                        <input id="qrAmount" type="number" name="amount" step="1000" min="1000" required class="w-full rounded-2xl border border-slate-200 px-4 py-3 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200 dark:bg-slate-800 dark:border-slate-700 dark:text-white"/>
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-semibold text-slate-700 dark:text-slate-200">Thời gian hiệu lực</label>
                        <select name="expire_minutes" class="w-full rounded-2xl border border-slate-200 px-4 py-3 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200 dark:bg-slate-800 dark:border-slate-700 dark:text-white">
                            <option value="5">5 phút</option>
                            <option value="10">10 phút</option>
                            <option value="15" selected>15 phút</option>
                            <option value="30">30 phút</option>
                            <option value="60">60 phút</option>
                        </select>
                    </div>
                    <div>
                        <label class="mb-2 block text-sm font-semibold text-slate-700 dark:text-slate-200">Tên khách hàng</label>
                        <input id="qrCustomerName" type="text" name="customer_name" class="w-full rounded-2xl border border-slate-200 px-4 py-3 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200 dark:bg-slate-800 dark:border-slate-700 dark:text-white"/>
                    </div>
                    <div class="md:col-span-2">
                        <label class="mb-2 block text-sm font-semibold text-slate-700 dark:text-slate-200">Email khách hàng</label>
                        <input id="qrCustomerEmail" type="email" name="customer_email" class="w-full rounded-2xl border border-slate-200 px-4 py-3 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200 dark:bg-slate-800 dark:border-slate-700 dark:text-white"/>
                    </div>
                </div>
                <div id="qrResult" class="hidden rounded-3xl border border-slate-200 bg-slate-50 p-5 dark:border-slate-700 dark:bg-slate-800/70">
                    <div class="space-y-5">
                        <div class="rounded-3xl border border-slate-200 bg-white p-4 text-center dark:border-slate-700 dark:bg-slate-900">
                            <div id="qrImageWrap" class="flex min-h-[280px] items-center justify-center rounded-2xl bg-slate-100 p-3 dark:bg-slate-800"></div>
                        </div>
                        <div class="grid gap-4 md:grid-cols-2">
                            <div class="rounded-2xl border border-slate-200 bg-white p-4 dark:border-slate-700 dark:bg-slate-900">
                                <div class="text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Ngân hàng</div>
                                <div id="qrResultBankName" class="mt-2 text-base font-semibold text-slate-900 dark:text-white">--</div>
                            </div>
                            <div class="rounded-2xl border border-slate-200 bg-white p-4 dark:border-slate-700 dark:bg-slate-900">
                                <div class="text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Số tài khoản</div>
                                <div id="qrResultBankAccount" class="mt-2 text-base font-semibold text-slate-900 dark:text-white">--</div>
                            </div>
                            <div class="rounded-2xl border border-slate-200 bg-white p-4 dark:border-slate-700 dark:bg-slate-900">
                                <div class="text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Chủ tài khoản</div>
                                <div id="qrResultBankAccountName" class="mt-2 text-base font-semibold text-slate-900 dark:text-white">PMS Company</div>
                            </div>
                            <div class="rounded-2xl border border-slate-200 bg-white p-4 dark:border-slate-700 dark:bg-slate-900">
                                <div class="text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">Hết hạn</div>
                                <div id="qrResultExpiresAt" class="mt-2 text-base font-semibold text-amber-600 dark:text-amber-300">--</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="flex flex-col-reverse gap-3 border-t border-slate-100 pt-5 dark:border-slate-800 sm:flex-row sm:justify-end">
                    <button type="button" onclick="closeQrModal()" class="inline-flex items-center justify-center rounded-2xl border border-slate-200 bg-white px-5 py-2.5 font-semibold text-slate-600 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700">Hủy</button>
                    <button type="submit" class="inline-flex items-center justify-center gap-2 rounded-2xl bg-teal-600 px-5 py-2.5 font-semibold text-white shadow-sm shadow-teal-500/30 transition-all hover:bg-teal-700">
                        <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                        </svg>
                        Tạo mã QR
                    </button>
                </div>
            </form>
        </div>
    </div>
 
    <script>
        const billWoSelect = document.getElementById('billWoSelect');
        const billCustomerSelect = document.getElementById('billCustomerSelect');
        const billTotalAmount = document.getElementById('billTotalAmount');
        const addBillForm = document.querySelector('#addModal form');
        const addModal = document.getElementById('addModal');
        const qrModal = document.getElementById('qrModal');
        const qrCreateForm = document.getElementById('qrCreateForm');
        const qrResult = document.getElementById('qrResult');
        const qrImageWrap = document.getElementById('qrImageWrap');
        const qrResultBankName = document.getElementById('qrResultBankName');
        const qrResultBankAccount = document.getElementById('qrResultBankAccount');
        const qrResultBankAccountName = document.getElementById('qrResultBankAccountName');
        const qrResultExpiresAt = document.getElementById('qrResultExpiresAt');

        function ensureBillCustomerSelected() {
            if (!billCustomerSelect) return;
            if (!billCustomerSelect.value && billCustomerSelect.options.length > 1) {
                billCustomerSelect.selectedIndex = 1;
            }
        }

        function syncBillCustomerFromWo() {
            if (!billWoSelect || !billCustomerSelect) return;
            const selectedOption = billWoSelect.options[billWoSelect.selectedIndex];
            const customerId = selectedOption ? selectedOption.getAttribute('data-customer-id') : '';
            if (customerId && customerId !== '0') {
                billCustomerSelect.value = customerId;
            } else {
                ensureBillCustomerSelected();
            }
        }

        function openAddModal() {
            if (!addModal) return;
            addModal.classList.remove('hidden');
            addModal.classList.add('flex');
            document.body.classList.add('overflow-hidden');
            ensureBillCustomerSelected();
            if (billWoSelect) billWoSelect.focus();
        }

        function closeAddModal() {
            if (!addModal) return;
            addModal.classList.add('hidden');
            addModal.classList.remove('flex');
            document.body.classList.remove('overflow-hidden');
        }

        function resetQrResult() {
            if (!qrResult) return;
            qrResult.classList.add('hidden');
            if (qrImageWrap) {
                qrImageWrap.innerHTML = '<div class="flex h-[280px] w-[280px] items-center justify-center rounded-2xl bg-slate-200 text-slate-500 dark:bg-slate-700 dark:text-slate-300">Chưa có dữ liệu QR</div>';
            }
            if (qrResultBankName) qrResultBankName.textContent = '--';
            if (qrResultBankAccount) qrResultBankAccount.textContent = '--';
            if (qrResultBankAccountName) qrResultBankAccountName.textContent = 'PMS Company';
            if (qrResultExpiresAt) qrResultExpiresAt.textContent = '--';
        }

        function renderQrResult(result) {
            if (!qrResult) return;
            const bankCode = result.bankBin || '--';
            const bankAccount = result.bankAccount || '--';
            const bankAccountName = result.bankAccountName || 'PMS Company';
            const expiresAt = result.expiresAt || '--';
            const qrImageBase64 = result.qrImageBase64 || '';

            if (qrImageWrap) {
                qrImageWrap.innerHTML = qrImageBase64
                    ? '<img src="data:image/png;base64,' + qrImageBase64 + '" alt="QR Code" class="mx-auto max-w-[280px] rounded-2xl border border-slate-200 bg-white p-2" />'
                    : '<div class="flex h-[280px] w-[280px] items-center justify-center rounded-2xl bg-slate-200 text-slate-500 dark:bg-slate-700 dark:text-slate-300">Không có dữ liệu QR</div>';
            }

            if (qrResultBankName) qrResultBankName.textContent = bankCode;
            if (qrResultBankAccount) qrResultBankAccount.textContent = bankAccount;
            if (qrResultBankAccountName) qrResultBankAccountName.textContent = bankAccountName;
            if (qrResultExpiresAt) qrResultExpiresAt.textContent = expiresAt;

            qrResult.classList.remove('hidden');
        }

        function openQrModal(trigger) {
            if (!qrModal) return;
            const billId = trigger ? trigger.getAttribute('data-bill-id') : '';
            const amount = trigger ? trigger.getAttribute('data-amount') : '';
            const customerName = trigger ? trigger.getAttribute('data-customer-name') : '';
            const customerEmail = trigger ? trigger.getAttribute('data-customer-email') : '';
            document.getElementById('qrBillId').value = billId || '';
            document.getElementById('qrAmount').value = amount || '';
            document.getElementById('qrCustomerName').value = customerName || '';
            document.getElementById('qrCustomerEmail').value = customerEmail || '';
            resetQrResult();
            qrModal.classList.remove('hidden');
            qrModal.classList.add('flex');
            document.body.classList.add('overflow-hidden');
        }
 
        function closeQrModal() {
            if (!qrModal) return;
            qrModal.classList.add('hidden');
            qrModal.classList.remove('flex');
            document.body.classList.remove('overflow-hidden');
            resetQrResult();
        }

        if (addModal) {
            addModal.addEventListener('click', function(e) {
                if (e.target === this) closeAddModal();
            });
        }

        if (qrModal) {
            qrModal.addEventListener('click', function(e) {
                if (e.target === this) closeQrModal();
            });
        }

        if (qrCreateForm) {
            qrCreateForm.addEventListener('submit', async function(event) {
                event.preventDefault();
 
                const submitButton = qrCreateForm.querySelector('button[type="submit"]');
                const originalButtonHtml = submitButton ? submitButton.innerHTML : '';
 
                try {
                    if (submitButton) {
                        submitButton.disabled = true;
                        submitButton.classList.add('opacity-60', 'cursor-not-allowed');
                        submitButton.innerHTML = 'Đang tạo QR...';
                    }
 
                    const response = await fetch('PaymentController', {
                        method: 'POST',
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest'
                        },
                        body: new FormData(qrCreateForm)
                    });

                    let result;
                    try {
                        result = await response.json();
                    } catch (parseError) {
                        throw new Error('Phản hồi tạo QR không hợp lệ.');
                    }
 
                    if (!response.ok || !result.success) {
                        alert((result && result.message) || 'Không thể tạo mã QR.');
                        return;
                    }

                    renderQrResult(result);
                } catch (error) {
                    alert(error.message || 'Không thể tạo mã QR ngay trên trang.');
                } finally {
                    if (submitButton) {
                        submitButton.disabled = false;
                        submitButton.classList.remove('opacity-60', 'cursor-not-allowed');
                        submitButton.innerHTML = originalButtonHtml;
                    }
                }
            });
        }

        if (billWoSelect) {
            billWoSelect.addEventListener('change', syncBillCustomerFromWo);
        }

        if (billTotalAmount) {
            billTotalAmount.addEventListener('blur', function() {
                const numericValue = Number(this.value || 0);
                if (numericValue > 0 && numericValue < 1000) {
                    this.value = 1000;
                }
            });
        }

        if (addBillForm) {
            addBillForm.addEventListener('submit', function(event) {
                ensureBillCustomerSelected();
                if (!billWoSelect || !billWoSelect.value) {
                    event.preventDefault();
                    alert('Vui lòng chọn lệnh sản xuất trước khi tạo hóa đơn.');
                    if (billWoSelect) billWoSelect.focus();
                    return;
                }
                if (!billCustomerSelect || !billCustomerSelect.value) {
                    event.preventDefault();
                    alert('Vui lòng chọn khách hàng hợp lệ trước khi tạo hóa đơn.');
                    if (billCustomerSelect) billCustomerSelect.focus();
                    return;
                }
                if (!billTotalAmount || Number(billTotalAmount.value || 0) <= 0) {
                    event.preventDefault();
                    alert('Vui lòng nhập tổng tiền lớn hơn 0.');
                    if (billTotalAmount) billTotalAmount.focus();
                }
            });
        }

        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                if (qrModal && !qrModal.classList.contains('hidden')) {
                    closeQrModal();
                }
                if (addModal && !addModal.classList.contains('hidden')) {
                    closeAddModal();
                }
            }
        });
    </script>
</body>
</html>
