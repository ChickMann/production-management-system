<%-- user-list.jsp - Danh sách người dùng --%>
<%@page import="pms.model.UserDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f5f6fa; }
        .sidebar { min-height: 100vh; background: #2c3e50; color: white; }
        .sidebar a { color: white; text-decoration: none; padding: 12px 20px; display: block; }
        .sidebar a:hover { background: #34495e; }
        .sidebar a.active { background: #3498db; }
        .table-responsive { background: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .status-active { color: #27ae60; font-weight: bold; }
        .status-inactive { color: #e74c3c; font-weight: bold; }
        .action-btn { padding: 5px 10px; margin: 0 2px; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar p-0">
                <div class="text-center py-3 border-bottom">
                    <h5>PMS</h5>
                </div>
                <a href="BangDieuKien.jsp"><i class="fas fa-home me-2"></i> Trang chủ</a>
                <a href="UserController?action=list" class="active"><i class="fas fa-users me-2"></i> Người dùng</a>
                <a href="ItemController?action=list"><i class="fas fa-box me-2"></i> Vật phẩm</a>
                <a href="BOMController?action=list"><i class="fas fa-clipboard-list me-2"></i> BOM</a>
                <a href="RoutingController?action=list"><i class="fas fa-route me-2"></i> Quy trình</a>
                <a href="WorkOrderController?action=list"><i class="fas fa-industry me-2"></i> Lệnh sản xuất</a>
                <a href="SupplierController?action=list"><i class="fas fa-truck me-2"></i> Nhà cung cấp</a>
                <a href="CustomerController?action=list"><i class="fas fa-user-tie me-2"></i> Khách hàng</a>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="fas fa-users me-2"></i>Quản lý người dùng</h2>
                    <a href="UserController?action=addUser" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Thêm người dùng
                    </a>
                </div>

                <!-- Search & Filter -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="get" action="UserController" class="row g-3">
                            <input type="hidden" name="action" value="search">
                            <div class="col-md-4">
                                <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm..." 
                                       value="${keyword}">
                            </div>
                            <div class="col-md-3">
                                <select name="role" class="form-select">
                                    <option value="all">Tất cả vai trò</option>
                                    <option value="admin" ${roleFilter == 'admin' ? 'selected' : ''}>Admin</option>
                                    <option value="employee" ${roleFilter == 'employee' ? 'selected' : ''}>Công nhân</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <select name="status" class="form-select">
                                    <option value="all">Tất cả trạng thái</option>
                                    <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Khóa</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-secondary w-100">
                                    <i class="fas fa-search"></i> Tìm
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Messages -->
                <% if (request.getAttribute("msg") != null) { %>
                    <div class="alert alert-success alert-dismissible fade show">
                        <%= request.getAttribute("msg") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show">
                        <%= request.getAttribute("error") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <!-- User List -->
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>STT</th>
                                <th>Mã user</th>
                                <th>Username</th>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Điện thoại</th>
                                <th>Vai trò</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                ArrayList<UserDTO> users = (ArrayList<UserDTO>) request.getAttribute("users");
                                if (users != null && !users.isEmpty()) {
                                    int stt = 1;
                                    for (UserDTO u : users) {
                            %>
                            <tr>
                                <td><%= stt++ %></td>
                                <td><%= u.getId() %></td>
                                <td><strong><%= u.getUsername() %></strong></td>
                                <td><%= u.getFullName() != null ? u.getFullName() : "" %></td>
                                <td><%= u.getEmail() != null ? u.getEmail() : "" %></td>
                                <td><%= u.getPhone() != null ? u.getPhone() : "" %></td>
                                <td>
                                    <% if ("admin".equals(u.getRole())) { %>
                                        <span class="badge bg-danger">Admin</span>
                                    <% } else { %>
                                        <span class="badge bg-primary">Công nhân</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if ("active".equals(u.getStatus())) { %>
                                        <span class="status-active"><i class="fas fa-check-circle"></i> Hoạt động</span>
                                    <% } else { %>
                                        <span class="status-inactive"><i class="fas fa-lock"></i> Khóa</span>
                                    <% } %>
                                </td>
                                <td><%= u.getCreatedDate() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(u.getCreatedDate()) : "" %></td>
                                <td>
                                    <a href="UserController?action=viewUser&id=<%= u.getId() %>" class="btn btn-info btn-sm action-btn" title="Xem">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="UserController?action=updateUser&id=<%= u.getId() %>" class="btn btn-warning btn-sm action-btn" title="Sửa">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <% if ("active".equals(u.getStatus())) { %>
                                        <a href="UserController?action=lockUser&id=<%= u.getId() %>" 
                                           class="btn btn-secondary btn-sm action-btn" title="Khóa"
                                           onclick="return confirm('Khóa tài khoản này?')">
                                            <i class="fas fa-lock"></i>
                                        </a>
                                    <% } else { %>
                                        <a href="UserController?action=unlockUser&id=<%= u.getId() %>" 
                                           class="btn btn-success btn-sm action-btn" title="Mở khóa">
                                            <i class="fas fa-unlock"></i>
                                        </a>
                                    <% } %>
                                    <a href="UserController?action=resetPassword&id=<%= u.getId() %>" 
                                       class="btn btn-dark btn-sm action-btn" title="Reset mật khẩu"
                                       onclick="return confirm('Reset mật khẩu về 123456?')">
                                        <i class="fas fa-key"></i>
                                    </a>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="10" class="text-center text-muted">Không có người dùng nào</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
