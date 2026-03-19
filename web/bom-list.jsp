<%-- bom-list.jsp - Danh sách BOM --%>
<%@page import="pms.model.BOMDTO"%>
<%@page import="pms.model.BomDAO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<BOMDTO> boms = (List<BOMDTO>) request.getAttribute("boms");
    if (boms == null) {
        BomDAO dao = new BomDAO();
        boms = dao.getAllBOMS();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý BOM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f5f6fa; }
        .sidebar { min-height: 100vh; background: #2c3e50; color: white; }
        .sidebar a { color: white; text-decoration: none; padding: 12px 20px; display: block; }
        .sidebar a:hover { background: #34495e; }
        .table-responsive { background: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
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
                <a href="UserController?action=list"><i class="fas fa-users me-2"></i> Người dùng</a>
                <a href="ItemController?action=list"><i class="fas fa-box me-2"></i> Vật phẩm</a>
                <a href="BOMController?action=list" class="active"><i class="fas fa-clipboard-list me-2"></i> BOM</a>
                <a href="RoutingController?action=list"><i class="fas fa-route me-2"></i> Quy trình</a>
                <a href="WorkOrderController?action=list"><i class="fas fa-industry me-2"></i> Lệnh sản xuất</a>
                <a href="SupplierController?action=list"><i class="fas fa-truck me-2"></i> Nhà cung cấp</a>
                <a href="CustomerController?action=list"><i class="fas fa-user-tie me-2"></i> Khách hàng</a>
            </div>

            <div class="col-md-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="fas fa-clipboard-list me-2"></i>Quản lý BOM</h2>
                    <a href="BOMController?action=addBOM" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Thêm BOM mới
                    </a>
                </div>

                <!-- Search & Filter -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="get" action="BOMController" class="row g-3">
                            <input type="hidden" name="action" value="search">
                            <div class="col-md-4">
                                <input type="text" name="keyword" class="form-control" placeholder="Tìm theo tên sản phẩm...">
                            </div>
                            <div class="col-md-3">
                                <select name="status" class="form-select">
                                    <option value="all">Tất cả trạng thái</option>
                                    <option value="active">Đang dùng</option>
                                    <option value="inactive">Ngưng</option>
                                    <option value="pending">Chờ duyệt</option>
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

                <!-- BOM List -->
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>STT</th>
                                <th>Mã BOM</th>
                                <th>Sản phẩm</th>
                                <th>Version</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (boms != null && !boms.isEmpty()) {
                                    int stt = 1;
                                    for (BOMDTO bom : boms) {
                            %>
                            <tr>
                                <td><%= stt++ %></td>
                                <td><strong>BOM-<%= bom.getBomId() %></strong></td>
                                <td><%= bom.getProductName() != null ? bom.getProductName() : "ID: " + bom.getProductItemId() %></td>
                                <td><%= bom.getBomVersion() != null ? bom.getBomVersion() : "v1.0" %></td>
                                <td>
                                    <% if ("active".equals(bom.getStatus())) { %>
                                        <span class="badge bg-success">Đang dùng</span>
                                    <% } else if ("inactive".equals(bom.getStatus())) { %>
                                        <span class="badge bg-secondary">Ngưng</span>
                                    <% } else { %>
                                        <span class="badge bg-warning">Chờ duyệt</span>
                                    <% } %>
                                </td>
                                <td><%= bom.getCreatedDate() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(bom.getCreatedDate()) : "" %></td>
                                <td>
                                    <a href="BOMController?action=viewBOM&id=<%= bom.getBomId() %>" class="btn btn-info btn-sm" title="Xem chi tiết">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="BOMController?action=editBOM&id=<%= bom.getBomId() %>" class="btn btn-warning btn-sm" title="Sửa">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="BOMController?action=cloneBOM&id=<%= bom.getBomId() %>" class="btn btn-primary btn-sm" title="Clone BOM" onclick="return confirm('Clone BOM này thành bản mới?')">
                                        <i class="fas fa-copy"></i>
                                    </a>
                                    <% if ("active".equals(bom.getStatus())) { %>
                                        <a href="BOMController?action=deactivateBOM&id=<%= bom.getBomId() %>" 
                                           class="btn btn-secondary btn-sm" title="Ngưng sử dụng"
                                           onclick="return confirm('Ngưng sử dụng BOM này?')">
                                            <i class="fas fa-pause"></i>
                                        </a>
                                    <% } else { %>
                                        <a href="BOMController?action=activateBOM&id=<%= bom.getBomId() %>" 
                                           class="btn btn-success btn-sm" title="Kích hoạt">
                                            <i class="fas fa-play"></i>
                                        </a>
                                    <% } %>
                                    <a href="BOMController?action=deleteBOM&id=<%= bom.getBomId() %>" 
                                       class="btn btn-danger btn-sm" title="Xóa"
                                       onclick="return confirm('Xóa BOM này?')">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="7" class="text-center text-muted">Không có BOM nào</td>
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
