<%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.ArrayList, pms.model.UserDTO, pms.utils.FileService$FileRecord, java.text.SimpleDateFormat"%>
<%!
    class FileRecordWrapper {
        public int fileId;
        public String originalName;
        public String fileExtension;
        public String fileSize;
        public String uploaderName;
        public String description;
        public String uploadedAt;
        public String relatedTable;
        public int relatedId;
        public String contentType;

        public FileRecordWrapper(int fileId, String originalName, String fileExtension,
                String fileSize, String uploaderName, String description,
                String uploadedAt, String relatedTable, int relatedId, String contentType) {
            this.fileId = fileId;
            this.originalName = originalName;
            this.fileExtension = fileExtension;
            this.fileSize = fileSize;
            this.uploaderName = uploaderName;
            this.description = description;
            this.uploadedAt = uploadedAt;
            this.relatedTable = relatedTable;
            this.relatedId = relatedId;
            this.contentType = contentType;
        }
    }
%>
<%
    ArrayList<FileRecordWrapper> fileList = (ArrayList<FileRecordWrapper>) request.getAttribute("fileList");
    String msg = (String) request.getAttribute("msg");
    String error = (String) request.getAttribute("error");
    UserDTO user = (UserDTO) session.getAttribute("user");
    String downloadError = (String) request.getAttribute("downloadError");
    String downloadSuccess = (String) request.getAttribute("downloadSuccess");

    if (fileList == null) fileList = new ArrayList<>();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    String selectedTable = request.getParameter("table");
    if (selectedTable == null) selectedTable = "";
    
    String userName = user != null ? user.getUsername() : "User";
    String userRole = user != null ? user.getRole() : "user";
    String userInitial = userName.substring(0, 1).toUpperCase();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quan Ly File Ma Hoa - PMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <style>
        body { font-family: Inter, "Segoe UI", Arial, sans-serif; }
        .sidebar { box-shadow: 24px 0 48px rgba(15, 23, 42, 0.16); }
        .sidebar-overlay { position: fixed; inset: 0; background: rgba(15, 23, 42, 0.48); z-index: 20; }
        .upload-zone { border: 2px dashed #e2e8f0; transition: all 0.2s; }
        .upload-zone.dragover { border-color: #0d9488; background: #f0fdfa; }
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
                        <a href="DashboardController" class="flex w-full items-center gap-3 rounded-xl px-3 py-2 text-left text-sm font-medium text-slate-200 hover:bg-slate-800">
                            <span class="flex h-8 w-8 items-center justify-center rounded-lg bg-slate-800 text-sm">&#9881;</span>
                            <span class="nav-label">Man hinh chinh</span>
                        </a>
                    </div>
                </section>
                <section class="space-y-3">
                    <p class="nav-group-label px-2 text-xs font-semibold uppercase tracking-wider text-slate-400">He thong</p>
                    <div class="space-y-1">
                        <a href="FileController?action=list" class="flex w-full items-center gap-3 rounded-xl px-3 py-2 text-left text-sm font-medium bg-teal-500/20 text-white shadow-sm">
                            <span class="flex h-8 w-8 items-center justify-center rounded-lg bg-teal-500/20 text-sm">&#128196;</span>
                            <span class="nav-label">Quan Ly File</span>
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
                        <h1 class="text-2xl font-semibold text-slate-900">Quan Ly File Ma Hoa</h1>
                        <p class="text-sm text-slate-500 mt-1">Upload, ma hoa va quan ly tai lieu</p>
                    </div>
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

                <!-- Upload Zone -->
                <div class="bg-white rounded-2xl shadow-sm overflow-hidden mb-6">
                    <div class="bg-gradient-to-r from-teal-500 to-teal-600 p-4 text-white">
                        <h3 class="text-lg font-semibold">Upload File Ma Hoa</h3>
                        <p class="text-teal-100 text-sm mt-1">Keo tha hoac chon file de upload</p>
                    </div>
                    <div class="upload-zone rounded-xl p-8 m-4" id="uploadZone">
                        <form action="FileController" method="post" enctype="multipart/form-data" id="uploadForm">
                            <input type="hidden" name="action" value="upload"/>
                            <input type="hidden" name="uploader_id" value="<%= user != null ? user.getId() : 0 %>"/>
                            <div class="text-center">
                                <input type="file" id="fileInput" name="file" accept=".pdf,.doc,.docx,.xls,.xlsx,.txt,.jpg,.jpeg,.png,.zip,.rar" class="hidden"/>
                                <label for="fileInput" class="cursor-pointer inline-flex items-center gap-2 px-6 py-3 bg-teal-600 text-white rounded-xl font-semibold hover:bg-teal-700 transition-all">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"/>
                                    </svg>
                                    Chon File
                                </label>
                                <p class="mt-4 text-sm text-slate-500">PDF, DOC, DOCX, XLS, XLSX, TXT, JPG, PNG, ZIP, RAR (toi da 10MB)</p>
                            </div>
                            <div id="filePreview" style="display:none;" class="mt-6 max-w-md mx-auto">
                                <div class="bg-slate-50 rounded-xl p-4 border border-slate-200">
                                    <div id="previewName" class="font-semibold text-slate-700 mb-4 text-center"></div>
                                    <div class="space-y-3">
                                        <div>
                                            <label class="block text-sm font-semibold text-slate-700 mb-1">Mat khau ma hoa *</label>
                                            <input type="password" id="encryptPassword" name="password" placeholder="Nhap mat khau" required
                                                   class="w-full px-4 py-2 rounded-xl border border-slate-200">
                                        </div>
                                        <div class="grid grid-cols-2 gap-3">
                                            <div>
                                                <label class="block text-sm font-semibold text-slate-700 mb-1">Lien quan bang</label>
                                                <select name="related_table" id="relatedTable" class="w-full px-4 py-2 rounded-xl border border-slate-200">
                                                    <option value="">-- Chon bang --</option>
                                                    <option value="Bill">Bill (Hoa don)</option>
                                                    <option value="Work_Order">Work_Order</option>
                                                    <option value="Purchase_Order">Purchase_Order</option>
                                                    <option value="Customer">Customer</option>
                                                    <option value="Item">Item</option>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="block text-sm font-semibold text-slate-700 mb-1">ID lien quan</label>
                                                <input type="number" name="related_id" id="relatedId" placeholder="ID"
                                                       class="w-full px-4 py-2 rounded-xl border border-slate-200">
                                            </div>
                                        </div>
                                        <div>
                                            <label class="block text-sm font-semibold text-slate-700 mb-1">Mo ta</label>
                                            <textarea name="description" placeholder="Mo ta file..." rows="2"
                                                      class="w-full px-4 py-2 rounded-xl border border-slate-200"></textarea>
                                        </div>
                                        <button type="submit" class="w-full py-3 rounded-xl bg-teal-600 text-white font-semibold hover:bg-teal-700 transition-all">
                                            Tai Len Va Ma Hoa
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- File List -->
                <div class="bg-white rounded-2xl shadow-sm overflow-hidden">
                    <div class="p-4 border-b border-slate-100 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                        <div>
                            <h3 class="text-lg font-semibold text-slate-900">Danh Sach File</h3>
                            <p class="text-sm text-slate-500 mt-1"><%= fileList.size() %> files</p>
                        </div>
                        <div class="flex gap-3">
                            <select id="filterTable" onchange="filterByTable()" class="px-4 py-2 rounded-xl border border-slate-200 text-sm">
                                <option value="">Tat ca bang</option>
                                <option value="Bill">Bill</option>
                                <option value="Work_Order">Work_Order</option>
                                <option value="Purchase_Order">Purchase_Order</option>
                                <option value="Customer">Customer</option>
                                <option value="Item">Item</option>
                            </select>
                        </div>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="border-b border-slate-100 bg-slate-50">
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500">File</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500">Dinh Dang</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500">Kich Thuoc</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500">Lien Quan</th>
                                    <th class="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500">Upload Boi</th>
                                    <th class="px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-500">Hanh Dong</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (fileList.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="px-4 py-12 text-center text-slate-400">
                                        <div class="flex flex-col items-center gap-2">
                                            <svg class="w-12 h-12 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                            </svg>
                                            <p>Chua co file nao</p>
                                        </div>
                                    </td>
                                </tr>
                                <% } else { %>
                                    <% for (FileRecordWrapper f : fileList) { %>
                                    <tr class="border-b border-slate-50 last:border-0 hover:bg-slate-50 transition-colors">
                                        <td class="px-4 py-3">
                                            <div class="flex items-center gap-3">
                                                <div class="w-10 h-10 rounded-lg bg-slate-100 flex items-center justify-center text-xl">
                                                    <% if ("pdf".equals(f.fileExtension)) { %>&#128196;
                                                    <% } else if ("doc".equals(f.fileExtension) || "docx".equals(f.fileExtension)) { %>&#128221;
                                                    <% } else if ("xls".equals(f.fileExtension) || "xlsx".equals(f.fileExtension)) { %>&#128202;
                                                    <% } else if ("jpg".equals(f.fileExtension) || "jpeg".equals(f.fileExtension) || "png".equals(f.fileExtension)) { %>&#128247;
                                                    <% } else if ("zip".equals(f.fileExtension) || "rar".equals(f.fileExtension)) { %>&#128230;
                                                    <% } else { %>&#128196;<% } %>
                                                </div>
                                                <div>
                                                    <p class="font-semibold text-slate-700"><%= f.originalName %></p>
                                                    <% if (f.description != null && !f.description.isEmpty()) { %>
                                                    <p class="text-xs text-slate-500"><%= f.description %></p>
                                                    <% } %>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-4 py-3">
                                            <span class="px-2 py-1 rounded bg-slate-100 text-slate-600 text-xs font-bold uppercase"><%= f.fileExtension %></span>
                                        </td>
                                        <td class="px-4 py-3 text-slate-600"><%= f.fileSize %></td>
                                        <td class="px-4 py-3">
                                            <% if (f.relatedTable != null && !f.relatedTable.isEmpty()) { %>
                                            <span class="px-2 py-1 rounded bg-blue-100 text-blue-700 text-xs font-bold">#<%= f.relatedTable %>-<%= f.relatedId %></span>
                                            <% } else { %>
                                            <span class="text-slate-400">-</span>
                                            <% } %>
                                        </td>
                                        <td class="px-4 py-3 text-slate-600"><%= f.uploaderName != null ? f.uploaderName : "-" %></td>
                                        <td class="px-4 py-3 text-center">
                                            <div class="flex items-center justify-center gap-2">
                                                <button onclick="openDownloadModal(<%= f.fileId %>, '<%= f.originalName.replace("'", "\\'") %>')"
                                                        class="px-3 py-1.5 rounded-lg bg-blue-600 text-white text-sm font-medium hover:bg-blue-700 transition-colors">
                                                    Tai Xuong
                                                </button>
                                                <% if (user != null && "admin".equals(user.getRole())) { %>
                                                <form action="FileController" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete"/>
                                                    <input type="hidden" name="file_id" value="<%= f.fileId %>"/>
                                                    <button type="submit" onclick="return confirm('Xoa file nay?')"
                                                            class="px-3 py-1.5 rounded-lg bg-red-600 text-white text-sm font-medium hover:bg-red-700 transition-colors">
                                                        Xoa
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
                </div>
            </main>
        </div>
    </div>

    <!-- Download Password Modal -->
    <div id="downloadModal" class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4 hidden">
        <div class="bg-white rounded-2xl p-6 max-w-md w-full">
            <h3 id="modalTitle" class="text-lg font-semibold text-slate-900 mb-4">Tai Xuong File</h3>
            <input type="password" id="downloadPassword" placeholder="Nhap mat khau giai ma"
                   class="w-full px-4 py-3 rounded-xl border border-slate-200 mb-3">
            <div id="modalError" class="text-red-600 text-sm mb-3 hidden"></div>
            <div class="flex gap-3 justify-end">
                <button onclick="closeDownloadModal()" class="px-4 py-2 rounded-xl border border-slate-200 text-slate-600 font-medium hover:bg-slate-50">Huy</button>
                <button onclick="confirmDownload()" class="px-4 py-2 rounded-xl bg-teal-600 text-white font-medium hover:bg-teal-700">Tai Xuong</button>
            </div>
        </div>
    </div>

    <div id="sidebarOverlay" class="sidebar-overlay hidden lg:hidden"></div>

    <script>
        var currentDownloadId = null;

        // File upload preview
        document.getElementById('fileInput').addEventListener('change', function(e) {
            var file = e.target.files[0];
            if (file) {
                document.getElementById('previewName').textContent = file.name + ' (' + formatSize(file.size) + ')';
                document.getElementById('filePreview').style.display = 'block';
            }
        });

        // Drag and drop
        var uploadZone = document.getElementById('uploadZone');
        uploadZone.addEventListener('dragover', function(e) {
            e.preventDefault();
            uploadZone.classList.add('dragover');
        });
        uploadZone.addEventListener('dragleave', function(e) {
            uploadZone.classList.remove('dragover');
        });
        uploadZone.addEventListener('drop', function(e) {
            e.preventDefault();
            uploadZone.classList.remove('dragover');
            var file = e.dataTransfer.files[0];
            if (file) {
                document.getElementById('fileInput').files = e.dataTransfer.files;
                document.getElementById('previewName').textContent = file.name + ' (' + formatSize(file.size) + ')';
                document.getElementById('filePreview').style.display = 'block';
            }
        });

        function formatSize(bytes) {
            if (bytes < 1024) return bytes + ' B';
            if (bytes < 1048576) return (bytes / 1024).toFixed(1) + ' KB';
            return (bytes / 1048576).toFixed(1) + ' MB';
        }

        function openDownloadModal(fileId, fileName) {
            currentDownloadId = fileId;
            document.getElementById('modalTitle').textContent = 'Tai Xuong: ' + fileName;
            document.getElementById('downloadPassword').value = '';
            document.getElementById('modalError').classList.add('hidden');
            document.getElementById('downloadModal').classList.remove('hidden');
            setTimeout(function() { document.getElementById('downloadPassword').focus(); }, 100);
        }

        function closeDownloadModal() {
            document.getElementById('downloadModal').classList.add('hidden');
            currentDownloadId = null;
        }

        function confirmDownload() {
            var password = document.getElementById('downloadPassword').value;
            var errorDiv = document.getElementById('modalError');
            if (!password) {
                errorDiv.textContent = 'Vui long nhap mat khau!';
                errorDiv.classList.remove('hidden');
                return;
            }
            if (!currentDownloadId) return;

            var form = document.createElement('form');
            form.method = 'POST';
            form.action = 'FileController';
            form.innerHTML = '<input type="hidden" name="action" value="download"/>' +
                '<input type="hidden" name="file_id" value="' + currentDownloadId + '"/>' +
                '<input type="hidden" name="password" value="' + password + '"/>';
            document.body.appendChild(form);
            form.submit();
            document.body.removeChild(form);
            closeDownloadModal();
        }

        document.getElementById('downloadPassword').addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                confirmDownload();
            }
        });

        function filterByTable() {
            var table = document.getElementById('filterTable').value;
            window.location.href = 'FileController?action=list' + (table ? '&table=' + table : '');
        }

        // Set selected table filter
        var selectedTable = '<%= selectedTable %>';
        if (selectedTable) {
            document.getElementById('filterTable').value = selectedTable;
        }

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
