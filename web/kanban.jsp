<%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.List, pms.model.WorkOrderDTO, pms.model.UserDTO"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    List<WorkOrderDTO> newList = (List<WorkOrderDTO>) request.getAttribute("newList");
    List<WorkOrderDTO> inProgressList = (List<WorkOrderDTO>) request.getAttribute("inProgressList");
    List<WorkOrderDTO> doneList = (List<WorkOrderDTO>) request.getAttribute("doneList");
    List<WorkOrderDTO> cancelledList = (List<WorkOrderDTO>) request.getAttribute("cancelledList");
    UserDTO user = (UserDTO) session.getAttribute("user");

    if (newList == null) newList = new java.util.ArrayList<>();
    if (inProgressList == null) inProgressList = new java.util.ArrayList<>();
    if (doneList == null) doneList = new java.util.ArrayList<>();
    if (cancelledList == null) cancelledList = new java.util.ArrayList<>();

    String userName = user != null ? user.getUsername() : "User";
    String userRole = user != null ? user.getRole() : "user";
    Boolean sessionDark = (Boolean) session.getAttribute("darkMode");
    boolean isAdmin = "admin".equalsIgnoreCase(userRole);
    boolean isDarkMode = sessionDark != null ? sessionDark : false;
    String activePage = "kanban";
    String pageTitle = "Bảng tiến độ";
    String lang = session.getAttribute("lang") != null ? (String) session.getAttribute("lang") : "vi";
    int unreadCount = session.getAttribute("unreadCount") != null ? (Integer) session.getAttribute("unreadCount") : 0;

    int totalOrders = newList.size() + inProgressList.size() + doneList.size() + cancelledList.size();
%>
<!DOCTYPE html>
<html lang="<%= lang %>" class="<%= isDarkMode ? "dark" : "" %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng tiến độ - PMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class'
        };
    </script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <style>
        * { font-family: 'Inter', 'Segoe UI', Arial, sans-serif; }
        .sidebar-fixed { position: fixed; top: 0; left: 0; height: 100vh; z-index: 40; }
        .sidebar-header { position: sticky; top: 0; background: #0f172a; z-index: 10; }
        .sidebar-nav { flex: 1; overflow-y: auto; scrollbar-width: thin; scrollbar-color: #475569 #1e293b; }
        .sidebar-nav::-webkit-scrollbar { width: 4px; }
        .sidebar-nav::-webkit-scrollbar-track { background: #1e293b; }
        .sidebar-nav::-webkit-scrollbar-thumb { background: #475569; border-radius: 2px; }
        .sidebar-footer { position: sticky; bottom: 0; background: #0f172a; z-index: 10; }
        .main-wrapper { margin-left: 0; transition: margin-left 0.3s ease; }
        @media (min-width: 1024px) {
            .main-wrapper { margin-left: 280px; }
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
        .kanban-col {
            min-height: 520px;
        }
        .wo-card {
            cursor: grab;
            transition: all 0.2s ease;
        }
        .wo-card:hover {
            transform: translateY(-2px);
        }
        .wo-card:active {
            cursor: grabbing;
        }
        .wo-card.dragging {
            opacity: 0.5;
            transform: rotate(2deg);
        }
        .drop-zone {
            min-height: 280px;
            transition: all 0.2s ease;
        }
        .drop-zone.drag-over {
            background-color: rgba(16, 185, 129, 0.08);
            box-shadow: inset 0 0 0 2px rgba(16, 185, 129, 0.45);
        }
        .status-new { border-left: 4px solid #3b82f6; }
        .status-inprogress { border-left: 4px solid #f59e0b; }
        .status-done { border-left: 4px solid #10b981; }
        .status-cancelled { border-left: 4px solid #ef4444; }
    </style>
    <script src="js/common.js"></script>
</head>
<body class="bg-slate-100 text-slate-900 min-h-screen antialiased dark:bg-slate-900 dark:text-slate-100">
    <div class="min-h-screen flex">
        <jsp:include page="components/shared-sidebar.jsp" />

        <div class="main-wrapper flex-1 flex flex-col min-h-screen min-w-0">
            <jsp:include page="components/shared-header.jsp" />

            <main class="flex-1 overflow-y-auto p-4 sm:p-6 lg:p-8">
                <div class="mb-6 flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                    <div>
                        <h1 class="text-2xl font-semibold text-slate-900 dark:text-slate-100">Bảng tiến độ</h1>
                        <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Theo dõi lệnh sản xuất theo từng trạng thái và kéo thả để cập nhật nhanh</p>
                    </div>
                    <div class="rounded-2xl bg-white px-4 py-3 text-sm font-medium text-slate-600 shadow-sm border border-slate-200 dark:bg-slate-800 dark:border-slate-700 dark:text-slate-300">
                        Tổng lệnh sản xuất: <span class="font-semibold text-slate-900 dark:text-slate-100"><%= totalOrders %></span>
                    </div>
                </div>

                <div class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4 mb-6">
                    <div class="kpi-card rounded-2xl border border-slate-200 border-t-4 border-t-blue-500 bg-white p-5 shadow-sm dark:border-slate-700 dark:bg-slate-800">
                        <div class="flex items-start justify-between gap-4">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.2em] text-slate-500 dark:text-slate-400">Mới</p>
                                <p class="mt-3 text-3xl font-bold text-slate-900 dark:text-slate-100"><%= newList.size() %></p>
                                <p class="mt-2 text-sm text-slate-500 dark:text-slate-400">Lệnh chờ bắt đầu</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-blue-50 text-blue-600 dark:bg-blue-500/10 dark:text-blue-300">
                                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                                </svg>
                            </div>
                        </div>
                    </div>
                    <div class="kpi-card rounded-2xl border border-slate-200 border-t-4 border-t-amber-500 bg-white p-5 shadow-sm dark:border-slate-700 dark:bg-slate-800">
                        <div class="flex items-start justify-between gap-4">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.2em] text-slate-500 dark:text-slate-400">Đang sản xuất</p>
                                <p class="mt-3 text-3xl font-bold text-slate-900 dark:text-slate-100"><%= inProgressList.size() %></p>
                                <p class="mt-2 text-sm text-slate-500 dark:text-slate-400">Lệnh đang thực hiện</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-amber-50 text-amber-600 dark:bg-amber-500/10 dark:text-amber-300">
                                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                </svg>
                            </div>
                        </div>
                    </div>
                    <div class="kpi-card rounded-2xl border border-slate-200 border-t-4 border-t-emerald-500 bg-white p-5 shadow-sm dark:border-slate-700 dark:bg-slate-800">
                        <div class="flex items-start justify-between gap-4">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.2em] text-slate-500 dark:text-slate-400">Hoàn thành</p>
                                <p class="mt-3 text-3xl font-bold text-slate-900 dark:text-slate-100"><%= doneList.size() %></p>
                                <p class="mt-2 text-sm text-slate-500 dark:text-slate-400">Lệnh đã kết thúc</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-emerald-50 text-emerald-600 dark:bg-emerald-500/10 dark:text-emerald-300">
                                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                                </svg>
                            </div>
                        </div>
                    </div>
                    <div class="kpi-card rounded-2xl border border-slate-200 border-t-4 border-t-red-500 bg-white p-5 shadow-sm dark:border-slate-700 dark:bg-slate-800">
                        <div class="flex items-start justify-between gap-4">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.2em] text-slate-500 dark:text-slate-400">Đã hủy</p>
                                <p class="mt-3 text-3xl font-bold text-slate-900 dark:text-slate-100"><%= cancelledList.size() %></p>
                                <p class="mt-2 text-sm text-slate-500 dark:text-slate-400">Lệnh bị dừng</p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-red-50 text-red-600 dark:bg-red-500/10 dark:text-red-300">
                                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-1 gap-5 xl:grid-cols-4">
                    <div class="section-card kanban-col rounded-3xl border border-slate-200 p-4 shadow-sm dark:border-slate-700">
                        <div class="mb-4 flex items-center justify-between rounded-2xl bg-blue-50 px-4 py-3 dark:bg-blue-500/10">
                            <div class="flex items-center gap-3">
                                <span class="h-3 w-3 rounded-full bg-blue-500"></span>
                                <div>
                                    <h3 class="font-semibold text-slate-900 dark:text-slate-100">Mới</h3>
                                    <p class="text-xs text-slate-500 dark:text-slate-400">Sẵn sàng tiếp nhận</p>
                                </div>
                            </div>
                            <span class="rounded-full bg-white px-3 py-1 text-xs font-semibold text-blue-700 shadow-sm dark:bg-slate-800 dark:text-blue-300"><%= newList.size() %></span>
                        </div>
                        <div id="col-new" class="drop-zone space-y-3 rounded-2xl border border-dashed border-slate-200 bg-slate-50/80 p-2 dark:border-slate-700 dark:bg-slate-800/40"
                             ondrop="handleDrop(event, 'New')" ondragover="handleDragOver(event)" ondragleave="handleDragLeave(event)">
                            <% for (WorkOrderDTO wo : newList) { %>
                            <div class="wo-card status-new rounded-2xl border border-slate-200 bg-white p-4 shadow-sm dark:border-slate-700 dark:bg-slate-800"
                                 draggable="true"
                                 data-id="<%= wo.getWo_id() %>"
                                 data-status="New"
                                 ondragstart="handleDragStart(event)"
                                 ondragend="handleDragEnd(event)">
                                <div class="mb-3 flex items-start justify-between gap-3">
                                    <span class="inline-flex items-center rounded-full bg-blue-50 px-3 py-1 text-xs font-semibold text-blue-700 dark:bg-blue-500/10 dark:text-blue-300">#<%= wo.getWo_id() %></span>
                                    <span class="rounded-full bg-blue-100 px-2.5 py-1 text-xs font-semibold text-blue-700 dark:bg-blue-500/10 dark:text-blue-300">Mới</span>
                                </div>
                                <p class="text-sm font-semibold text-slate-900 dark:text-slate-100"><%= wo.getProductName() != null ? wo.getProductName() : "Sản phẩm #" + wo.getProduct_item_id() %></p>
                                <p class="mt-1 text-xs text-slate-500 dark:text-slate-400">Quy trình: <%= wo.getRoutingName() != null ? wo.getRoutingName() : "-" %></p>
                                <div class="mt-4 flex items-center justify-between gap-3">
                                    <span class="rounded-xl bg-slate-100 px-3 py-1.5 text-xs font-semibold text-slate-700 dark:bg-slate-700 dark:text-slate-200">Số lượng: <%= wo.getOrder_quantity() %></span>
                                    <a href="MainController?action=updateWorkOrder&id=<%= wo.getWo_id() %>" class="text-xs font-semibold text-teal-600 transition-colors hover:text-teal-700 dark:text-teal-400 dark:hover:text-teal-300">Chi tiết</a>
                                </div>
                            </div>
                            <% } %>
                            <% if (newList.isEmpty()) { %>
                            <div class="flex min-h-[220px] items-center justify-center rounded-2xl border border-dashed border-slate-200 px-4 text-center text-sm text-slate-400 dark:border-slate-700 dark:text-slate-500">Chưa có lệnh nào</div>
                            <% } %>
                        </div>
                    </div>

                    <div class="section-card kanban-col rounded-3xl border border-slate-200 p-4 shadow-sm dark:border-slate-700">
                        <div class="mb-4 flex items-center justify-between rounded-2xl bg-amber-50 px-4 py-3 dark:bg-amber-500/10">
                            <div class="flex items-center gap-3">
                                <span class="h-3 w-3 rounded-full bg-amber-500"></span>
                                <div>
                                    <h3 class="font-semibold text-slate-900 dark:text-slate-100">Đang sản xuất</h3>
                                    <p class="text-xs text-slate-500 dark:text-slate-400">Đang được xử lý</p>
                                </div>
                            </div>
                            <span class="rounded-full bg-white px-3 py-1 text-xs font-semibold text-amber-700 shadow-sm dark:bg-slate-800 dark:text-amber-300"><%= inProgressList.size() %></span>
                        </div>
                        <div id="col-inprogress" class="drop-zone space-y-3 rounded-2xl border border-dashed border-slate-200 bg-slate-50/80 p-2 dark:border-slate-700 dark:bg-slate-800/40"
                             ondrop="handleDrop(event, 'InProgress')" ondragover="handleDragOver(event)" ondragleave="handleDragLeave(event)">
                            <% for (WorkOrderDTO wo : inProgressList) { %>
                            <div class="wo-card status-inprogress rounded-2xl border border-slate-200 bg-white p-4 shadow-sm dark:border-slate-700 dark:bg-slate-800"
                                 draggable="true"
                                 data-id="<%= wo.getWo_id() %>"
                                 data-status="InProgress"
                                 ondragstart="handleDragStart(event)"
                                 ondragend="handleDragEnd(event)">
                                <div class="mb-3 flex items-start justify-between gap-3">
                                    <span class="inline-flex items-center rounded-full bg-amber-50 px-3 py-1 text-xs font-semibold text-amber-700 dark:bg-amber-500/10 dark:text-amber-300">#<%= wo.getWo_id() %></span>
                                    <span class="rounded-full bg-amber-100 px-2.5 py-1 text-xs font-semibold text-amber-700 dark:bg-amber-500/10 dark:text-amber-300">Đang SX</span>
                                </div>
                                <p class="text-sm font-semibold text-slate-900 dark:text-slate-100"><%= wo.getProductName() != null ? wo.getProductName() : "Sản phẩm #" + wo.getProduct_item_id() %></p>
                                <p class="mt-1 text-xs text-slate-500 dark:text-slate-400">Quy trình: <%= wo.getRoutingName() != null ? wo.getRoutingName() : "-" %></p>
                                <div class="mt-4 flex items-center justify-between gap-3">
                                    <span class="rounded-xl bg-slate-100 px-3 py-1.5 text-xs font-semibold text-slate-700 dark:bg-slate-700 dark:text-slate-200">Số lượng: <%= wo.getOrder_quantity() %></span>
                                    <a href="MainController?action=updateWorkOrder&id=<%= wo.getWo_id() %>" class="text-xs font-semibold text-teal-600 transition-colors hover:text-teal-700 dark:text-teal-400 dark:hover:text-teal-300">Chi tiết</a>
                                </div>
                            </div>
                            <% } %>
                            <% if (inProgressList.isEmpty()) { %>
                            <div class="flex min-h-[220px] items-center justify-center rounded-2xl border border-dashed border-slate-200 px-4 text-center text-sm text-slate-400 dark:border-slate-700 dark:text-slate-500">Chưa có lệnh nào</div>
                            <% } %>
                        </div>
                    </div>

                    <div class="section-card kanban-col rounded-3xl border border-slate-200 p-4 shadow-sm dark:border-slate-700">
                        <div class="mb-4 flex items-center justify-between rounded-2xl bg-emerald-50 px-4 py-3 dark:bg-emerald-500/10">
                            <div class="flex items-center gap-3">
                                <span class="h-3 w-3 rounded-full bg-emerald-500"></span>
                                <div>
                                    <h3 class="font-semibold text-slate-900 dark:text-slate-100">Hoàn thành</h3>
                                    <p class="text-xs text-slate-500 dark:text-slate-400">Đã hoàn tất sản xuất</p>
                                </div>
                            </div>
                            <span class="rounded-full bg-white px-3 py-1 text-xs font-semibold text-emerald-700 shadow-sm dark:bg-slate-800 dark:text-emerald-300"><%= doneList.size() %></span>
                        </div>
                        <div id="col-done" class="drop-zone space-y-3 rounded-2xl border border-dashed border-slate-200 bg-slate-50/80 p-2 dark:border-slate-700 dark:bg-slate-800/40"
                             ondrop="handleDrop(event, 'Done')" ondragover="handleDragOver(event)" ondragleave="handleDragLeave(event)">
                            <% for (WorkOrderDTO wo : doneList) { %>
                            <div class="wo-card status-done rounded-2xl border border-slate-200 bg-white p-4 shadow-sm dark:border-slate-700 dark:bg-slate-800"
                                 draggable="true"
                                 data-id="<%= wo.getWo_id() %>"
                                 data-status="Done"
                                 ondragstart="handleDragStart(event)"
                                 ondragend="handleDragEnd(event)">
                                <div class="mb-3 flex items-start justify-between gap-3">
                                    <span class="inline-flex items-center rounded-full bg-emerald-50 px-3 py-1 text-xs font-semibold text-emerald-700 dark:bg-emerald-500/10 dark:text-emerald-300">#<%= wo.getWo_id() %></span>
                                    <span class="rounded-full bg-emerald-100 px-2.5 py-1 text-xs font-semibold text-emerald-700 dark:bg-emerald-500/10 dark:text-emerald-300">Hoàn tất</span>
                                </div>
                                <p class="text-sm font-semibold text-slate-900 dark:text-slate-100"><%= wo.getProductName() != null ? wo.getProductName() : "Sản phẩm #" + wo.getProduct_item_id() %></p>
                                <p class="mt-1 text-xs text-slate-500 dark:text-slate-400">Quy trình: <%= wo.getRoutingName() != null ? wo.getRoutingName() : "-" %></p>
                                <div class="mt-4 flex items-center justify-between gap-3">
                                    <span class="rounded-xl bg-slate-100 px-3 py-1.5 text-xs font-semibold text-slate-700 dark:bg-slate-700 dark:text-slate-200">Số lượng: <%= wo.getOrder_quantity() %></span>
                                    <a href="MainController?action=updateWorkOrder&id=<%= wo.getWo_id() %>" class="text-xs font-semibold text-teal-600 transition-colors hover:text-teal-700 dark:text-teal-400 dark:hover:text-teal-300">Chi tiết</a>
                                </div>
                            </div>
                            <% } %>
                            <% if (doneList.isEmpty()) { %>
                            <div class="flex min-h-[220px] items-center justify-center rounded-2xl border border-dashed border-slate-200 px-4 text-center text-sm text-slate-400 dark:border-slate-700 dark:text-slate-500">Chưa có lệnh nào</div>
                            <% } %>
                        </div>
                    </div>

                    <div class="section-card kanban-col rounded-3xl border border-slate-200 p-4 shadow-sm dark:border-slate-700">
                        <div class="mb-4 flex items-center justify-between rounded-2xl bg-red-50 px-4 py-3 dark:bg-red-500/10">
                            <div class="flex items-center gap-3">
                                <span class="h-3 w-3 rounded-full bg-red-500"></span>
                                <div>
                                    <h3 class="font-semibold text-slate-900 dark:text-slate-100">Đã hủy</h3>
                                    <p class="text-xs text-slate-500 dark:text-slate-400">Lệnh không tiếp tục</p>
                                </div>
                            </div>
                            <span class="rounded-full bg-white px-3 py-1 text-xs font-semibold text-red-700 shadow-sm dark:bg-slate-800 dark:text-red-300"><%= cancelledList.size() %></span>
                        </div>
                        <div id="col-cancelled" class="drop-zone space-y-3 rounded-2xl border border-dashed border-slate-200 bg-slate-50/80 p-2 dark:border-slate-700 dark:bg-slate-800/40"
                             ondrop="handleDrop(event, 'Cancelled')" ondragover="handleDragOver(event)" ondragleave="handleDragLeave(event)">
                            <% for (WorkOrderDTO wo : cancelledList) { %>
                            <div class="wo-card status-cancelled rounded-2xl border border-slate-200 bg-white p-4 shadow-sm dark:border-slate-700 dark:bg-slate-800"
                                 draggable="true"
                                 data-id="<%= wo.getWo_id() %>"
                                 data-status="Cancelled"
                                 ondragstart="handleDragStart(event)"
                                 ondragend="handleDragEnd(event)">
                                <div class="mb-3 flex items-start justify-between gap-3">
                                    <span class="inline-flex items-center rounded-full bg-red-50 px-3 py-1 text-xs font-semibold text-red-700 dark:bg-red-500/10 dark:text-red-300">#<%= wo.getWo_id() %></span>
                                    <span class="rounded-full bg-red-100 px-2.5 py-1 text-xs font-semibold text-red-700 dark:bg-red-500/10 dark:text-red-300">Hủy</span>
                                </div>
                                <p class="text-sm font-semibold text-slate-900 dark:text-slate-100"><%= wo.getProductName() != null ? wo.getProductName() : "Sản phẩm #" + wo.getProduct_item_id() %></p>
                                <p class="mt-1 text-xs text-slate-500 dark:text-slate-400">Quy trình: <%= wo.getRoutingName() != null ? wo.getRoutingName() : "-" %></p>
                                <div class="mt-4 flex items-center justify-between gap-3">
                                    <span class="rounded-xl bg-slate-100 px-3 py-1.5 text-xs font-semibold text-slate-700 dark:bg-slate-700 dark:text-slate-200">Số lượng: <%= wo.getOrder_quantity() %></span>
                                    <a href="MainController?action=updateWorkOrder&id=<%= wo.getWo_id() %>" class="text-xs font-semibold text-teal-600 transition-colors hover:text-teal-700 dark:text-teal-400 dark:hover:text-teal-300">Chi tiết</a>
                                </div>
                            </div>
                            <% } %>
                            <% if (cancelledList.isEmpty()) { %>
                            <div class="flex min-h-[220px] items-center justify-center rounded-2xl border border-dashed border-slate-200 px-4 text-center text-sm text-slate-400 dark:border-slate-700 dark:text-slate-500">Chưa có lệnh nào</div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script>
        let draggedElement = null;
        let draggedId = null;
        let draggedStatus = null;

        function handleDragStart(event) {
            draggedElement = event.currentTarget;
            draggedId = event.currentTarget.dataset.id;
            draggedStatus = event.currentTarget.dataset.status;
            event.currentTarget.classList.add('dragging');
            event.dataTransfer.effectAllowed = 'move';
        }

        function handleDragEnd(event) {
            event.currentTarget.classList.remove('dragging');
            document.querySelectorAll('.drop-zone').forEach(function (el) {
                el.classList.remove('drag-over');
            });
        }

        function handleDragOver(event) {
            event.preventDefault();
            event.dataTransfer.dropEffect = 'move';
            event.currentTarget.classList.add('drag-over');
        }

        function handleDragLeave(event) {
            event.currentTarget.classList.remove('drag-over');
        }

        function handleDrop(event, newStatus) {
            event.preventDefault();
            event.currentTarget.classList.remove('drag-over');

            if (!draggedId || !newStatus) return;
            if (draggedStatus === newStatus) return;

            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'KanbanController', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200 && xhr.responseText.trim() === 'OK') {
                        location.reload();
                    } else {
                        alert('Lỗi cập nhật trạng thái: ' + xhr.responseText);
                    }
                }
            };
            xhr.send('action=updateStatus&id=' + draggedId + '&status=' + encodeURIComponent(newStatus));
        }
    </script>
</body>
</html>
