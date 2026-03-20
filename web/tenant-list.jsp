<%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.List, pms.model.TenantDTO, pms.model.UserDTO, java.text.SimpleDateFormat, java.text.DecimalFormat"%>
<%
    List<TenantDTO> tenants = (List<TenantDTO>) request.getAttribute("tenants");
    UserDTO user = (UserDTO) session.getAttribute("user");
    
    String msg = (String) request.getAttribute("msg");
    String error = (String) request.getAttribute("error");
    String filterStatus = request.getParameter("filter");
    
    if (tenants == null) tenants = new java.util.ArrayList<>();
    if (filterStatus == null) filterStatus = "all";
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    
    int countActive = 0;
    int countExpired = 0;
    int countTrial = 0;
    
    for (TenantDTO t : tenants) {
        if (t.isActive() && !t.isExpired()) countActive++;
        else if (t.isExpired()) countExpired++;
        if ("trial".equalsIgnoreCase(t.getSubscriptionPlan())) countTrial++;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quan Ly Tenant - PMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <style>
        body { font-family: Inter, "Segoe UI", Arial, sans-serif; }
        .sidebar { box-shadow: 24px 0 48px rgba(15, 23, 42, 0.16); }
        .status-active { background: #d1fae5; color: #047857; }
        .status-expired { background: #fee2e2; color: #b91c1c; }
        .status-inactive { background: #f3f4f6; color: #6b7280; }
        .plan-badge { display: inline-flex; padding: 4px 12px; border-radius: 999px; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; }
        .plan-enterprise { background: #f3e8ff; color: #7c3aed; }
        .plan-professional { background: #dbeafe; color: #1d4ed8; }
        .plan-basic { background: #d1fae5; color: #047857; }
        .plan-trial { background: #fef3c7; color: #b45309; }
    </style>
</head>
<body class="bg-slate-50 min-h-screen">
    <div class="max-w-7xl mx-auto px-4 py-8">
        <!-- Header -->
        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
            <div>
                <h1 class="text-2xl font-bold text-slate-900">Quan Ly Tenant</h1>
                <p class="text-sm text-slate-500 mt-1">Quan ly cac tenant trong he thong</p>
            </div>
            <div class="flex items-center gap-3">
                <a href="BangDieuKien.jsp" class="flex items-center gap-2 px-4 py-2 rounded-xl border border-slate-200 text-slate-600 hover:bg-slate-50 transition-colors">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                    </svg>
                    Quay lai
                </a>
            </div>
        </div>

        <!-- Alerts -->
        <% if (msg != null && !msg.isEmpty()) { %>
        <div class="mb-6 p-4 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-700 flex items-center gap-3">
            <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            <%= msg %>
        </div>
        <% } %>
        <% if (error != null && !error.isEmpty()) { %>
        <div class="mb-6 p-4 rounded-xl bg-red-50 border border-red-200 text-red-700 flex items-center gap-3">
            <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            <%= error %>
        </div>
        <% } %>

        <!-- Stats Cards -->
        <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4 mb-6">
            <div class="bg-white rounded-2xl p-5 shadow-sm border-l-4 border-emerald-500">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-xs font-semibold uppercase text-slate-500">Dang Hoat Dong</p>
                        <p class="mt-2 text-3xl font-bold text-emerald-600"><%= countActive %></p>
                        <p class="mt-1 text-xs text-slate-400">Tenant active</p>
                    </div>
                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-emerald-50 text-2xl">&#10004;</div>
                </div>
            </div>
            <div class="bg-white rounded-2xl p-5 shadow-sm border-l-4 border-red-500">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-xs font-semibold uppercase text-slate-500">Da Het Han</p>
                        <p class="mt-2 text-3xl font-bold text-red-600"><%= countExpired %></p>
                        <p class="mt-1 text-xs text-slate-400">Can gia han</p>
                    </div>
                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-red-50 text-2xl">&#9203;</div>
                </div>
            </div>
            <div class="bg-white rounded-2xl p-5 shadow-sm border-l-4 border-amber-500">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-xs font-semibold uppercase text-slate-500">Dang Trial</p>
                        <p class="mt-2 text-3xl font-bold text-amber-600"><%= countTrial %></p>
                        <p class="mt-1 text-xs text-slate-400">Chua mua goi</p>
                    </div>
                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-amber-50 text-2xl">&#9888;</div>
                </div>
            </div>
            <div class="bg-white rounded-2xl p-5 shadow-sm border-l-4 border-blue-500">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-xs font-semibold uppercase text-slate-500">Tong Tenant</p>
                        <p class="mt-2 text-3xl font-bold text-slate-800"><%= tenants.size() %></p>
                        <p class="mt-1 text-xs text-slate-400">Tat ca tenant</p>
                    </div>
                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-2xl">&#128101;</div>
                </div>
            </div>
        </div>

        <!-- Tenants Grid -->
        <div class="grid gap-6 md:grid-cols-2 xl:grid-cols-3">
            <% if (tenants.isEmpty()) { %>
            <div class="col-span-full bg-white rounded-2xl p-12 shadow-sm text-center">
                <svg class="w-16 h-16 mx-auto mb-4 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4H6m4 0h4m4 0h1m-1 4v4m0 0a2 2 0 100 4 2 2 0 000-4z"/>
                </svg>
                <h3 class="text-lg font-semibold text-slate-700 mb-2">Chua co tenant nao</h3>
                <p class="text-slate-500">Tao tenant moi de bat dau su dung he thong</p>
            </div>
            <% } else { %>
                <% for (TenantDTO t : tenants) { %>
                    <% 
                        String planClass = "";
                        if ("enterprise".equalsIgnoreCase(t.getSubscriptionPlan())) planClass = "plan-enterprise";
                        else if ("professional".equalsIgnoreCase(t.getSubscriptionPlan())) planClass = "plan-professional";
                        else if ("basic".equalsIgnoreCase(t.getSubscriptionPlan())) planClass = "plan-basic";
                        else if ("trial".equalsIgnoreCase(t.getSubscriptionPlan())) planClass = "plan-trial";
                        else planClass = "bg-slate-100 text-slate-600";
                        
                        String statusClass = "";
                        String statusText = "";
                        if (t.isExpired()) {
                            statusClass = "status-expired";
                            statusText = "Da het han";
                        } else if (t.isActive()) {
                            statusClass = "status-active";
                            statusText = "Hoat dong";
                        } else {
                            statusClass = "status-inactive";
                            statusText = "Khong hoat dong";
                        }
                    %>
                    <div class="bg-white rounded-2xl shadow-sm overflow-hidden hover:shadow-md transition-shadow">
                        <!-- Header -->
                        <div class="bg-gradient-to-r from-slate-800 to-slate-700 p-5">
                            <div class="flex items-start justify-between">
                                <div>
                                    <h3 class="text-white font-semibold text-lg"><%= t.getTenantName() != null ? t.getTenantName() : "Tenant" %></h3>
                                    <p class="text-slate-300 text-sm mt-1"><%= t.getTenantCode() != null ? t.getTenantCode() : "" %></p>
                                </div>
                                <span class="plan-badge <%= planClass %>"><%= t.getSubscriptionPlan() != null ? t.getSubscriptionPlan() : "N/A" %></span>
                            </div>
                        </div>
                        
                        <!-- Content -->
                        <div class="p-5 space-y-4">
                            <!-- Status -->
                            <div class="flex items-center justify-between">
                                <span class="text-sm text-slate-500">Trang thai</span>
                                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold <%= statusClass %>">
                                    <% if (!t.isExpired() && t.isActive()) { %>
                                    <span class="w-1.5 h-1.5 rounded-full bg-current"></span>
                                    <% } %>
                                    <%= statusText %>
                                </span>
                            </div>
                            
                            <!-- Contact -->
                            <div class="space-y-2">
                                <div class="flex items-center gap-2 text-sm">
                                    <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                                    </svg>
                                    <span class="text-slate-600 truncate"><%= t.getContactEmail() != null ? t.getContactEmail() : "Chua co" %></span>
                                </div>
                                <div class="flex items-center gap-2 text-sm">
                                    <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                                    </svg>
                                    <span class="text-slate-600"><%= t.getContactPhone() != null ? t.getContactPhone() : "Chua co" %></span>
                                </div>
                            </div>
                            
                            <!-- Expiration -->
                            <div class="pt-3 border-t border-slate-100">
                                <div class="flex items-center justify-between text-sm">
                                    <span class="text-slate-500">Het han</span>
                                    <span class="<%= t.isExpired() ? "text-red-600 font-semibold" : "text-slate-700" %>">
                                        <%= t.getExpirationDate() != null ? sdf.format(t.getExpirationDate()) : "Khong gioi han" %>
                                    </span>
                                </div>
                            </div>
                            
                            <!-- Actions -->
                            <div class="flex gap-2 pt-3 border-t border-slate-100">
                                <a href="TenantController?action=view&id=<%= t.getTenantId() %>" class="flex-1 px-3 py-2 rounded-lg bg-slate-100 text-slate-700 text-sm font-medium text-center hover:bg-slate-200 transition-colors">
                                    Chi tiet
                                </a>
                                <% if (t.isExpired()) { %>
                                <a href="TenantController?action=renew&id=<%= t.getTenantId() %>" class="flex-1 px-3 py-2 rounded-lg bg-teal-600 text-white text-sm font-medium text-center hover:bg-teal-700 transition-colors">
                                    Gia han
                                </a>
                                <% } else { %>
                                <a href="TenantController?action=edit&id=<%= t.getTenantId() %>" class="flex-1 px-3 py-2 rounded-lg bg-teal-600 text-white text-sm font-medium text-center hover:bg-teal-700 transition-colors">
                                    Chinh sua
                                </a>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>
    </div>
</body>
</html>
