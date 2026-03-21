<%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.List, java.util.ArrayList, pms.model.WorkOrderDTO, pms.model.UserDTO, java.text.SimpleDateFormat, java.util.Calendar, java.util.Date"%>
<%
    List<WorkOrderDTO> workOrders = (List<WorkOrderDTO>) request.getAttribute("workOrders");
    UserDTO user = (UserDTO) session.getAttribute("user");
    String msg = (String) request.getAttribute("msg");

    if (workOrders == null) workOrders = new ArrayList<>();

    String userName = user != null ? user.getUsername() : "User";
    String userRole = user != null ? user.getRole() : "user";
    Boolean sessionDark = (Boolean) session.getAttribute("darkMode");
    boolean isDarkMode = sessionDark != null ? sessionDark : false;
    String activePage = "calendar";
    String pageTitle = "Lịch sản xuất";
    String lang = session.getAttribute("lang") != null ? (String) session.getAttribute("lang") : "vi";

    request.setAttribute("activePage", activePage);
    request.setAttribute("pageTitle", pageTitle);

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat monthSdf = new SimpleDateFormat("MMMM yyyy");

    Calendar cal = Calendar.getInstance();
    int currentMonth = cal.get(Calendar.MONTH);
    int currentYear = cal.get(Calendar.YEAR);

    String monthParam = request.getParameter("month");
    String yearParam = request.getParameter("year");
    if (monthParam != null && yearParam != null) {
        try {
            currentMonth = Integer.parseInt(monthParam);
            currentYear = Integer.parseInt(yearParam);
        } catch (Exception e) {
        }
    }

    cal.set(Calendar.YEAR, currentYear);
    cal.set(Calendar.MONTH, currentMonth);
    cal.set(Calendar.DAY_OF_MONTH, 1);

    int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
    int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
%>
<!DOCTYPE html>
<html lang="<%= lang %>" class="<%= isDarkMode ? "dark" : "" %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sản xuất - PMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class'
        };
    </script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <style>
        body { font-family: Inter, "Segoe UI", Arial, sans-serif; }
        .sidebar { box-shadow: 24px 0 48px rgba(15, 23, 42, 0.16); }
        .sidebar-overlay { position: fixed; inset: 0; background: rgba(15, 23, 42, 0.48); z-index: 20; }
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
        .section-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(14px);
        }
        .dark .section-card {
            background: rgba(15, 23, 42, 0.88);
        }
        .calendar-day {
            min-height: 120px;
            transition: background-color 0.2s ease, border-color 0.2s ease;
        }
        .calendar-day:hover { background-color: #f8fafc; }
        .dark .calendar-day:hover { background-color: rgba(30, 41, 59, 0.75); }
        .calendar-day.today {
            background-color: #f0fdfa;
            box-shadow: inset 0 0 0 1px rgba(13, 148, 136, 0.18);
        }
        .dark .calendar-day.today {
            background-color: rgba(13, 148, 136, 0.12);
        }
        .wo-item {
            font-size: 10px;
            padding: 2px 6px;
            border-radius: 999px;
            margin-bottom: 4px;
            cursor: pointer;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            font-weight: 600;
        }
        .wo-new { background-color: #dbeafe; color: #1d4ed8; }
        .wo-progress { background-color: #fef3c7; color: #b45309; }
        .wo-done { background-color: #d1fae5; color: #047857; }
        .wo-cancelled { background-color: #fee2e2; color: #b91c1c; text-decoration: line-through; }
        .dark .wo-new { background-color: rgba(59, 130, 246, 0.18); color: #93c5fd; }
        .dark .wo-progress { background-color: rgba(245, 158, 11, 0.18); color: #fcd34d; }
        .dark .wo-done { background-color: rgba(16, 185, 129, 0.18); color: #6ee7b7; }
        .dark .wo-cancelled { background-color: rgba(239, 68, 68, 0.18); color: #fca5a5; }
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
                        <h1 class="text-2xl font-semibold text-slate-900 dark:text-slate-100">Lịch sản xuất</h1>
                        <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Xem lịch sản xuất theo ngày hoặc theo tháng để theo dõi kế hoạch tổng thể.</p>
                    </div>
                    <div class="flex gap-2">
                        <a href="production-calendar.jsp" class="rounded-2xl bg-teal-600 px-4 py-2.5 text-sm font-medium text-white shadow-sm shadow-teal-500/30 transition-colors hover:bg-teal-700">Lịch</a>
                        <a href="production-gantt.jsp" class="rounded-2xl border border-slate-200 bg-white px-4 py-2.5 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700">Gantt</a>
                    </div>
                </div>

                <!-- Alerts -->
                <% if (msg != null && !msg.trim().isEmpty()) { %>
                <div class="mb-6 flex items-center gap-3 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-4 text-emerald-700 dark:border-emerald-500/30 dark:bg-emerald-500/10 dark:text-emerald-300">
                    <svg class="h-5 w-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <%= msg %>
                </div>
                <% } %>

                <!-- Calendar Header -->
                <div class="section-card mb-6 overflow-hidden rounded-3xl border border-slate-200/70 shadow-sm dark:border-slate-700/60">
                    <div class="flex items-center justify-between border-b border-slate-100 px-4 py-4 dark:border-slate-700/60 sm:px-6">
                        <a href="?month=<%= (currentMonth - 1 + 12) % 12 %>&year=<%= currentMonth == 0 ? currentYear - 1 : currentYear %>"
                           class="rounded-2xl border border-slate-200 p-2 text-slate-600 transition-colors hover:bg-slate-100 dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-800">
                            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                            </svg>
                        </a>
                        <div class="text-center">
                            <p class="text-xs font-semibold uppercase tracking-[0.2em] text-slate-400 dark:text-slate-500">Tháng đang xem</p>
                            <h2 class="mt-1 text-xl font-semibold text-slate-800 dark:text-slate-100"><%= monthSdf.format(cal.getTime()) %></h2>
                        </div>
                        <a href="?month=<%= (currentMonth + 1) % 12 %>&year=<%= currentMonth == 11 ? currentYear + 1 : currentYear %>"
                           class="rounded-2xl border border-slate-200 p-2 text-slate-600 transition-colors hover:bg-slate-100 dark:border-slate-700 dark:text-slate-300 dark:hover:bg-slate-800">
                            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                            </svg>
                        </a>
                    </div>

                    <div class="grid grid-cols-7">
                        <div class="border-b border-slate-100 bg-slate-50 p-3 text-center text-xs font-semibold uppercase text-slate-500 dark:border-slate-700/60 dark:bg-slate-800/80 dark:text-slate-400">CN</div>
                        <div class="border-b border-slate-100 bg-slate-50 p-3 text-center text-xs font-semibold uppercase text-slate-500 dark:border-slate-700/60 dark:bg-slate-800/80 dark:text-slate-400">T2</div>
                        <div class="border-b border-slate-100 bg-slate-50 p-3 text-center text-xs font-semibold uppercase text-slate-500 dark:border-slate-700/60 dark:bg-slate-800/80 dark:text-slate-400">T3</div>
                        <div class="border-b border-slate-100 bg-slate-50 p-3 text-center text-xs font-semibold uppercase text-slate-500 dark:border-slate-700/60 dark:bg-slate-800/80 dark:text-slate-400">T4</div>
                        <div class="border-b border-slate-100 bg-slate-50 p-3 text-center text-xs font-semibold uppercase text-slate-500 dark:border-slate-700/60 dark:bg-slate-800/80 dark:text-slate-400">T5</div>
                        <div class="border-b border-slate-100 bg-slate-50 p-3 text-center text-xs font-semibold uppercase text-slate-500 dark:border-slate-700/60 dark:bg-slate-800/80 dark:text-slate-400">T6</div>
                        <div class="border-b border-slate-100 bg-slate-50 p-3 text-center text-xs font-semibold uppercase text-slate-500 dark:border-slate-700/60 dark:bg-slate-800/80 dark:text-slate-400">T7</div>

                        <%
                        int startDay = firstDayOfWeek;

                        for (int i = 1; i < startDay; i++) {
                        %>
                        <div class="calendar-day border-r border-b border-slate-100 bg-slate-50/70 dark:border-slate-700/60 dark:bg-slate-800/40"></div>
                        <% } %>

                        <%
                        Calendar dayCal = Calendar.getInstance();
                        dayCal.set(Calendar.YEAR, currentYear);
                        dayCal.set(Calendar.MONTH, currentMonth);
                        boolean isToday = false;

                        for (int day = 1; day <= daysInMonth; day++) {
                            dayCal.set(Calendar.DAY_OF_MONTH, day);
                            isToday = (dayCal.get(Calendar.YEAR) == Calendar.getInstance().get(Calendar.YEAR) &&
                                       dayCal.get(Calendar.MONTH) == Calendar.getInstance().get(Calendar.MONTH) &&
                                       dayCal.get(Calendar.DAY_OF_MONTH) == Calendar.getInstance().get(Calendar.DAY_OF_MONTH));
                        %>
                        <div class="calendar-day border-r border-b border-slate-100 p-3 dark:border-slate-700/60 <%= isToday ? "today" : "" %>">
                            <div class="mb-3 flex items-center justify-between">
                                <span class="text-sm font-semibold <%= isToday ? "flex h-8 w-8 items-center justify-center rounded-full bg-teal-500 text-white" : "text-slate-700 dark:text-slate-200" %>"><%= day %></span>
                            </div>
                            <div class="space-y-1">
                                <%
                                int count = 0;
                                for (WorkOrderDTO wo : workOrders) {
                                    if (count >= 3) break;
                                    String statusClass = "New".equals(wo.getStatus()) ? "wo-new" :
                                                        "In Progress".equals(wo.getStatus()) || "InProgress".equals(wo.getStatus()) ? "wo-progress" :
                                                        "Completed".equals(wo.getStatus()) || "Done".equals(wo.getStatus()) ? "wo-done" : "wo-cancelled";
                                %>
                                <div class="wo-item <%= statusClass %>" title="<%= wo.getProductName() != null ? wo.getProductName() : "WO#" + wo.getWo_id() %> - <%= wo.getOrder_quantity() %> sản phẩm">
                                    <%= wo.getProductName() != null ? wo.getProductName().substring(0, Math.min(wo.getProductName().length(), 8)) : "WO" + wo.getWo_id() %>
                                </div>
                                <%
                                count++;
                                }
                                if (count == 0) {
                                %>
                                <p class="text-xs text-slate-400 dark:text-slate-500">Chưa có lệnh</p>
                                <% } %>
                            </div>
                        </div>
                        <% } %>

                        <%
                        int totalCells = startDay - 1 + daysInMonth;
                        int remainingCells = 7 - (totalCells % 7);
                        if (remainingCells < 7) {
                            for (int i = 0; i < remainingCells; i++) {
                        %>
                        <div class="calendar-day border-r border-b border-slate-100 bg-slate-50/70 dark:border-slate-700/60 dark:bg-slate-800/40"></div>
                        <% } } %>
                    </div>
                </div>

                <!-- Legend -->
                <div class="section-card rounded-3xl border border-slate-200/70 p-5 shadow-sm dark:border-slate-700/60">
                    <div class="flex flex-wrap items-center justify-center gap-4 sm:gap-6">
                        <div class="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-300">
                            <span class="h-4 w-4 rounded-full bg-blue-100 ring-1 ring-blue-200 dark:bg-blue-500/20 dark:ring-blue-400/30"></span>
                            Mới tạo
                        </div>
                        <div class="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-300">
                            <span class="h-4 w-4 rounded-full bg-amber-100 ring-1 ring-amber-200 dark:bg-amber-500/20 dark:ring-amber-400/30"></span>
                            Đang sản xuất
                        </div>
                        <div class="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-300">
                            <span class="h-4 w-4 rounded-full bg-emerald-100 ring-1 ring-emerald-200 dark:bg-emerald-500/20 dark:ring-emerald-400/30"></span>
                            Hoàn thành
                        </div>
                        <div class="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-300">
                            <span class="h-4 w-4 rounded-full bg-red-100 ring-1 ring-red-200 dark:bg-red-500/20 dark:ring-red-400/30"></span>
                            Đã hủy
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
