<%-- item-list.jsp - Danh sách vật phẩm --%>
<%@page import="pms.model.ItemDTO"%>
<%@page import="pms.model.ItemDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    ArrayList<ItemDTO> items = (ArrayList<ItemDTO>) request.getAttribute("items");
    if (items == null) {
        ItemDAO dao = new ItemDAO();
        items = dao.getAllItems();
    }
    Boolean lowStockOnly = (Boolean) request.getAttribute("lowStockOnly");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý vật phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f5f6fa; }
        .sidebar { min-height: 100vh; background: #2c3e50; color: white; }
        .sidebar a { color: white; text-decoration: none; padding: 12px 20px; display: block; }
        .sidebar a:hover { background: #34495e; }
        .table-responsive { background: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .low-stock { background-color: #fff3cd; }
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
                <a href="ItemController?action=list" class="active"><i class="fas fa-box me-2"></i> Vật phẩm</a>
                <a href="BOMController?action=list"><i class="fas fa-clipboard-list me-2"></i> BOM</a>
                <a href="RoutingController?action=list"><i class="fas fa-route me-2"></i> Quy trình</a>
                <a href="WorkOrderController?action=list"><i class="fas fa-industry me-2"></i> Lệnh sản xuất</a>
                <a href="SupplierController?action=list"><i class="fas fa-truck me-2"></i> Nhà cung cấp</a>
                <a href="CustomerController?action=list"><i class="fas fa-user-tie me-2"></i> Khách hàng</a>
            </div>

            <div class="col-md-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="fas fa-box me-2"></i>Quản lý vật phẩm</h2>
                    <div>
                        <a href="ItemController?action=lowStock" class="btn btn-warning me-2">
                            <i class="fas fa-exclamation-triangle me-2"></i>Tồn kho thấp
                        </a>
                        <a href="ItemController?action=addItem" class="btn btn-primary">
                            <i class="fas fa-plus me-2"></i>Thêm vật phẩm
                        </a>
                    </div>
                </div>

                <!-- Search & Filter -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="get" action="ItemController" class="row g-3">
                            <input type="hidden" name="action" value="search">
                            <div class="col-md-5">
                                <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm...">
                            </div>
                            <div class="col-md-3">
                                <select name="type" class="form-select">
                                    <option value="all">Tất cả loại</option>
                                    <option value="SanPham">Sản phẩm</option>
                                    <option value="VatTu">Vật tư</option>
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

                <!-- Item List -->
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>STT</th>
                                <th>Mã</th>
                                <th>Tên vật phẩm</th>
                                <th>Loại</th>
                                <th>Tồn kho</th>
                                <th>Tối thiểu</th>
                                <th>Đơn vị</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (items != null && !items.isEmpty()) {
                                    int stt = 1;
                                    for (ItemDTO item : items) {
                                        boolean isLowStock = item.isLowStock();
                            %>
                            <tr class="<%= isLowStock ? "low-stock" : "" %>">
                                <td><%= stt++ %></td>
                                <td><strong><%= item.getItemID() %></strong></td>
                                <td><%= item.getItemName() %></td>
                                <td>
                                    <% if ("SanPham".equals(item.getItemType())) { %>
                                        <span class="badge bg-primary">Sản phẩm</span>
                                    <% } else { %>
                                        <span class="badge bg-info">Vật tư</span>
                                    <% } %>
                                </td>
                                <td><strong><%= item.getStockQuantity() %></strong></td>
                                <td><%= item.getMinStockLevel() %></td>
                                <td><%= item.getUnit() != null ? item.getUnit() : "" %></td>
                                <td>
                                    <% if (isLowStock) { %>
                                        <span class="text-warning"><i class="fas fa-exclamation-triangle"></i> Thấp</span>
                                    <% } else { %>
                                        <span class="text-success"><i class="fas fa-check"></i> Bình thường</span>
                                    <% } %>
                                </td>
                                <td>
                                    <a href="ItemController?action=editItem&id=<%= item.getItemID() %>" class="btn btn-warning btn-sm" title="Sửa">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="ItemController?action=deleteItem&id=<%= item.getItemID() %>" 
                                       class="btn btn-danger btn-sm" title="Xóa"
                                       onclick="return confirm('Xóa vật phẩm này?')">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="9" class="text-center text-muted">Không có vật phẩm nào</td>
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
