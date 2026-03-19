<%-- user-form.jsp - Thêm/Sửa người dùng --%>
<%@page import="pms.model.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String mode = (String) request.getAttribute("mode");
    UserDTO u = (UserDTO) request.getAttribute("u");
    boolean isAdd = "add".equals(mode);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isAdd ? "Thêm" : "Sửa" %> người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f5f6fa; }
        .sidebar { min-height: 100vh; background: #2c3e50; color: white; }
        .sidebar a { color: white; text-decoration: none; padding: 12px 20px; display: block; }
        .sidebar a:hover { background: #34495e; }
        .form-card { background: white; border-radius: 8px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
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

            <div class="col-md-10 p-4">
                <div class="mb-3">
                    <a href="UserController?action=list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                </div>

                <div class="form-card" style="max-width: 700px; margin: 0 auto;">
                    <h2 class="mb-4">
                        <i class="fas fa-user<%= isAdd ? "-plus" : "-edit" %> me-2"></i>
                        <%= isAdd ? "Thêm" : "Sửa" %> người dùng
                    </h2>

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

                    <form method="post" action="UserController">
                        <input type="hidden" name="action" value="<%= isAdd ? "saveAddUser" : "saveUpdateUser" %>">
                        <% if (!isAdd) { %>
                            <input type="hidden" name="id" value="<%= u.getId() %>">
                        <% } %>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Username <span class="text-danger">*</span></label>
                                <input type="text" name="username" class="form-control" required
                                       value="<%= u != null ? u.getUsername() : "" %>">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                                <input type="password" name="password" class="form-control" 
                                       <%= isAdd ? "required" : "" %> 
                                       placeholder="<%= isAdd ? "Nhập mật khẩu" : "Để trống nếu không đổi" %>">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Họ tên</label>
                                <input type="text" name="fullName" class="form-control"
                                       value="<%= u != null ? (u.getFullName() != null ? u.getFullName() : "") : "" %>">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Vai trò <span class="text-danger">*</span></label>
                                <select name="role" class="form-select" required>
                                    <option value="">-- Chọn vai trò --</option>
                                    <option value="admin" <%= u != null && "admin".equals(u.getRole()) ? "selected" : "" %>>Admin</option>
                                    <option value="employee" <%= u != null && "employee".equals(u.getRole()) ? "selected" : "" %>>Công nhân</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" class="form-control"
                                       value="<%= u != null ? (u.getEmail() != null ? u.getEmail() : "") : "" %>">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Điện thoại</label>
                                <input type="text" name="phone" class="form-control"
                                       value="<%= u != null ? (u.getPhone() != null ? u.getPhone() : "") : "" %>">
                            </div>
                        </div>

                        <% if (!isAdd) { %>
                        <div class="mb-3">
                            <label class="form-label">Trạng thái <span class="text-danger">*</span></label>
                            <select name="status" class="form-select" required>
                                <option value="active" <%= u != null && "active".equals(u.getStatus()) ? "selected" : "" %>>Hoạt động</option>
                                <option value="inactive" <%= u != null && "inactive".equals(u.getStatus()) ? "selected" : "" %>>Khóa</option>
                            </select>
                        </div>
                        <% } %>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Lưu
                            </button>
                            <a href="UserController?action=list" class="btn btn-secondary">Hủy</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
