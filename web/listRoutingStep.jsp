<%@page import="pms.model.RoutingStepDTO"%>
<%@page import="java.util.List"%>
<%@page import="pms.model.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<RoutingStepDTO> listStep = (List<RoutingStepDTO>) request.getAttribute("listStep");
    RoutingStepDTO stepEdit = (RoutingStepDTO) request.getAttribute("stepEdit");
    UserDTO user = (UserDTO) session.getAttribute("user");
    boolean isEditMode = (stepEdit != null);
    String msg = (String) request.getAttribute("msg");
    String error = (String) request.getAttribute("error");
    
    if (listStep == null) listStep = new java.util.ArrayList<>();
    
    String userName = user != null ? user.getUsername() : "User";
    String userRole = user != null ? user.getRole() : "user";
    String userInitial = userName.substring(0, 1).toUpperCase();
    
    int totalSteps = listStep.size();
    int qcCount = 0;
    for (RoutingStepDTO s : listStep) {
        if (s.isIsInspected()) qcCount++;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quan Ly Cong Doan - PMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <style>
        body { font-family: Inter, "Segoe UI", Arial, sans-serif; }
        .sidebar { box-shadow: 24px 0 48px rgba(15, 23, 42, 0.16); }
        .sidebar-overlay { position: fixed; inset: 0; background: rgba(15, 23, 42, 0.48); z-index: 20; }
        .form-input:focus {
            border-color: #0d9488;
            box-shadow: 0 0 0 3px rgba(20, 184, 166, 0.1);
        }
    </style>
</head>
<body class="bg-slate-50 min-h-screen">
    <div id="layoutShell" class="h-screen overflow-hidden lg:grid lg:grid-cols-[280px_1fr]">
        <!-- Sidebar -->
        <aside id="sidebar" data-collapsed="false" class="sidebar fixed inset-y-0 left-0 z-30 flex h-screen w-72 -translate-x-full flex-col bg-slate-900 text-white transition-transform duration-300 lg:static lg:translate-x-0">
            <div class="flex h-16 shrink-0 items-center gap-3 border-b border-slate-800 px-6">
                <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-teal-500/10 text-lg text-teal-200">&#9881;</div>
                <div class="sidebar-brand-text">
                    <p class="text-sm font-semibold tracking-wide">PMS System</p>
                    <p class="text-xs text-slate-400">Production Management</p>
                </div>
            </div>
            <nav class="flex-1 overflow-y-auto space-y-6 px-4 py-6">
                <section class="space-y-3">
                    <p class="nav-group-label px-2 text-xs font-semibold uppercase tracking-wider text-slate-400">Tong quan</p>
                    <div class="space-y-1">
                        <a href="DashboardController" class="flex w-full items-center gap-3 rounded-xl px-3 py-2 text-left text-sm font-medium text-slate-200 hover:bg-slate-800">
                            <span class="flex h-8 w-8 items-center justify-center rounded-lg bg-teal-500/20 text-sm">&#128200;</span>
                            <span class="nav-label">Dashboard</span>
                        </a>
                        <a href="BangDieuKien.jsp" class="flex w-full items-center gap-3 rounded-xl px-3 py-2 text-left text-sm font-medium text-slate-200 hover:bg-slate-800">
                            <span class="flex h-8 w-8 items-center justify-center rounded-lg bg-slate-800 text-sm">&#9881;</span>
                            <span class="nav-label">Man hinh chinh</span>
                        </a>
                    </div>
                </section>
                <section class="space-y-3">
                    <p class="nav-group-label px-2 text-xs font-semibold uppercase tracking-wider text-slate-400">San xuat</p>
                    <div class="space-y-1">
                        <a href="MainController?action=listRouting" class="flex w-full items-center gap-3 rounded-xl px-3 py-2 text-left text-sm font-medium text-slate-200 hover:bg-slate-800">
                            <span class="flex h-8 w-8 items-center justify-center rounded-lg bg-slate-800 text-sm">&#128260;</span>
                            <span class="nav-label">Quy Trinh</span>
                        </a>
                        <a href="MainController?action=listRoutingStep" class="flex w-full items-center gap-3 rounded-xl px-3 py-2 text-left text-sm font-medium bg-teal-500/20 text-white shadow-sm">
                            <span class="flex h-8 w-8 items-center justify-center rounded-lg bg-teal-500/20 text-sm">&#9878;</span>
                            <span class="nav-label">Cong Doan</span>
                        </a>
                    </div>
                </section>
            </nav>
            <div class="shrink-0 border-t border-slate-800 px-6 py-4">
                <div class="flex items-center gap-3">
                    <div class="h-10 w-10 rounded-full bg-teal-500/20 text-center text-sm leading-10 text-teal-200 font-bold"><%= userInitial %></div>
                    <div class="sidebar-user-text">
                        <p class="text-sm font-semibold"><%= userName %></p>
                        <p class="text-xs text-slate-400"><%= userRole %></p>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Content -->
        <div class="flex min-h-screen flex-col overflow-hidden">
            <header class="sticky top-0 z-20 flex h-16 items-center justify-between gap-4 border-b border-slate-200 bg-white/90 px-4 backdrop-blur sm:px-6">
                <div class="flex items-center gap-3">
                    <button id="menuToggle" class="flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200 text-slate-600 hover:bg-slate-100" type="button">&#9776;</button>
                </div>
                <div class="flex items-center gap-3">
                    <a href="UserController?action=viewProfile" class="flex items-center gap-2 px-3 py-2 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors">
                        <div class="w-8 h-8 rounded-full bg-teal-500/20 text-teal-600 flex items-center justify-center text-sm font-bold"><%= userInitial %></div>
                        <span class="text-sm font-medium text-slate-700 hidden sm:block"><%= userName %></span>
                    </a>
                    <a href="MainController?action=logoutUser" class="rounded-xl border border-rose-200 px-4 py-2 text-sm font-semibold text-rose-600 hover:bg-rose-50">Dang Xuat</a>
                </div>
            </header>

            <main class="flex-1 overflow-y-auto p-4 sm:p-6 lg:p-8">
                <!-- Page Header -->
                <div class="mb-6 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                    <div>
                        <h1 class="text-2xl font-semibold text-slate-900">Quan Ly Cong Doan San Xuat</h1>
                        <p class="text-sm text-slate-500 mt-1">Quan ly cac buoc thuc hien trong quy trinh</p>
                    </div>
                    <a href="MainController?action=listRouting" class="inline-flex items-center gap-2 px-5 py-2.5 rounded-xl bg-slate-600 text-white font-semibold hover:bg-slate-700 transition-all shadow-sm">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                        </svg>
                        Them Cong Doan
                    </a>
                </div>

                <!-- Alerts -->
                <% if (msg != null && !msg.trim().isEmpty()) { %>
                <div class="mb-6 p-4 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-700 flex items-center gap-3">
                    <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <%= msg %>
                </div>
                <% } %>
                <% if (error != null && !error.trim().isEmpty()) { %>
                <div class="mb-6 p-4 rounded-xl bg-red-50 border border-red-200 text-red-700 flex items-center gap-3">
                    <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <%= error %>
                </div>
                <% } %>

                <!-- Stats Cards -->
                <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3 mb-6">
                    <div class="bg-white rounded-2xl p-5 shadow-sm border-l-4 border-blue-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase text-slate-500">Tong Cong Doan</p>
                                <p class="mt-2 text-3xl font-bold text-slate-800"><%= totalSteps %></p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-2xl">&#9878;</div>
                        </div>
                    </div>
                    <div class="bg-white rounded-2xl p-5 shadow-sm border-l-4 border-emerald-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase text-slate-500">Co Kiem Tra QC</p>
                                <p class="mt-2 text-3xl font-bold text-emerald-600"><%= qcCount %></p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-emerald-50 text-2xl">&#10004;</div>
                        </div>
                    </div>
                    <div class="bg-white rounded-2xl p-5 shadow-sm border-l-4 border-amber-500">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase text-slate-500">Khong Kiem Tra</p>
                                <p class="mt-2 text-3xl font-bold text-amber-600"><%= totalSteps - qcCount %></p>
                            </div>
                            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-amber-50 text-2xl">&#10006;</div>
                        </div>
                    </div>
                </div>

                <!-- Routing Steps Table -->
                <div class="bg-white rounded-2xl shadow-sm overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="border-b border-slate-100 bg-slate-50">
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500">Ma CD</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500">Ten Cong Doan</th>
                                    <th class="px-4 py-3 text-right text-xs font-semibold uppercase tracking-wide text-slate-500">Thoi Gian (phut)</th>
                                    <th class="px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-500">Kiem Tra QC</th>
                                    <th class="px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-500">Hanh Dong</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (listStep.isEmpty()) { %>
                                <tr>
                                    <td colspan="5" class="px-4 py-12 text-center text-slate-400">
                                        <div class="flex flex-col items-center gap-2">
                                            <svg class="w-12 h-12 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                                            </svg>
                                            <p>Chua co cong doan nao</p>
                                            <p class="text-sm">Tao cong doan moi de bat dau</p>
                                        </div>
                                    </td>
                                </tr>
                                <% } else { %>
                                    <% for (RoutingStepDTO s : listStep) { %>
                                    <tr class="border-b border-slate-50 last:border-0 hover:bg-slate-50 transition-colors">
                                        <td class="px-4 py-3">
                                            <span class="font-bold text-teal-600">#CD-<%= s.getStepId() %></span>
                                        </td>
                                        <td class="px-4 py-3">
                                            <div class="flex items-center gap-3">
                                                <div class="w-10 h-10 rounded-lg bg-gradient-to-br from-teal-400 to-teal-600 flex items-center justify-center text-white font-bold text-sm">
                                                    <%= s.getStepName() != null ? s.getStepName().substring(0, 1).toUpperCase() : "?" %>
                                                </div>
                                                <span class="font-medium text-slate-700"><%= s.getStepName() != null ? s.getStepName() : "-" %></span>
                                            </div>
                                        </td>
                                        <td class="px-4 py-3 text-right font-semibold text-slate-700"><%= s.getEstimatedTime() %> phut</td>
                                        <td class="px-4 py-3 text-center">
                                            <% if (s.isIsInspected()) { %>
                                            <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold bg-emerald-100 text-emerald-700">
                                                <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                                                </svg>
                                                Co QC
                                            </span>
                                            <% } else { %>
                                            <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold bg-slate-100 text-slate-600">
                                                Khong
                                            </span>
                                            <% } %>
                                        </td>
                                        <td class="px-4 py-3 text-center">
                                            <div class="flex items-center justify-center gap-2">
                                                <a href="MainController?action=loadUpdateRoutingStep&stepId=<%= s.getStepId() %>" 
                                                   class="p-2 rounded-lg text-slate-500 hover:bg-amber-100 hover:text-amber-600 transition-colors" title="Chinh sua">
                                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                                    </svg>
                                                </a>
                                                <a href="MainController?action=deleteRoutingStep&stepId=<%= s.getStepId() %>" 
                                                   onclick="return confirm('Ban co chac chan muon xoa cong doan nay?')"
                                                   class="p-2 rounded-lg text-slate-500 hover:bg-red-100 hover:text-red-600 transition-colors" title="Xoa">
                                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                                    </svg>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% if (!listStep.isEmpty()) { %>
                    <div class="px-4 py-3 border-t border-slate-100 bg-slate-50 text-sm text-slate-500">
                        Tong cong: <span class="font-semibold"><%= listStep.size() %></span> cong doan
                    </div>
                    <% } %>
                </div>
            </main>
        </div>
    </div>

    <div id="sidebarOverlay" class="sidebar-overlay hidden lg:hidden"></div>

    <script>
        // Sidebar toggle
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebarOverlay');

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
    </script>
</body>
</html>
