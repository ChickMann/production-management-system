<%-- bom-detail.jsp - Chi tiết BOM --%>
<%@page import="pms.model.BOMDTO"%>
<%@page import="pms.model.BOMDetailDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    BOMDTO bom = (BOMDTO) request.getAttribute("bom");
    List<BOMDetailDTO> details = bom != null ? bom.getDetails() : null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết BOM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f5f6fa; }
        .sidebar { min-height: 100vh; background: #2c3e50; color: white; }
        .sidebar a { color: white; text-decoration: none; padding: 12px 20px; display: block; }
        .sidebar a:hover { background: #34495e; }
        .detail-card { background: white; border-radius: 8px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-2 sidebar p-0">
                <div class="text-center py-3 border-bottom">
                    <h5>PMS</h5>
                </div>
                <a href="DashboardController"><i class="fas fa-home me-2"></i> Trang chủ</a>
                <a href="UserController?action=list"><i class="fas fa-users me-2"></i> Người dùng</a>
                <a href="ItemController?action=list"><i class="fas fa-box me-2"></i> Vật phẩm</a>
                <a href="BOMController?action=list" class="active"><i class="fas fa-clipboard-list me-2"></i> BOM</a>
                <a href="RoutingController?action=list"><i class="fas fa-route me-2"></i> Quy trình</a>
                <a href="WorkOrderController?action=list"><i class="fas fa-industry me-2"></i> Lệnh sản xuất</a>
                <a href="SupplierController?action=list"><i class="fas fa-truck me-2"></i> Nhà cung cấp</a>
                <a href="CustomerController?action=list"><i class="fas fa-user-tie me-2"></i> Khách hàng</a>
            </div>

            <div class="col-md-10 p-4">
                <div class="mb-3">
                    <a href="BOMController?action=list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                </div>

                <div class="detail-card mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2><i class="fas fa-clipboard-list me-2"></i>Chi tiết BOM</h2>
                        <div>
                            <a href="BOMController?action=editBOM&id=<%= bom.getBomId() %>" class="btn btn-warning">
                                <i class="fas fa-edit me-2"></i>Sửa thông tin
                            </a>
                            <a href="BOMController?action=cloneBOM&id=<%= bom.getBomId() %>" class="btn btn-primary"
                               onclick="return confirm('Clone BOM này thành bản mới?')">
                                <i class="fas fa-copy me-2"></i>Clone BOM
                            </a>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <table class="table table-borderless">
                                <tr>
                                    <th width="40%">Mã BOM:</th>
                                    <td><strong>BOM-<%= bom.getBomId() %></strong></td>
                                </tr>
                                <tr>
                                    <th>Sản phẩm:</th>
                                    <td><%= bom.getProductName() != null ? bom.getProductName() : "ID: " + bom.getProductItemId() %></td>
                                </tr>
                                <tr>
                                    <th>Version:</th>
                                    <td><%= bom.getBomVersion() != null ? bom.getBomVersion() : "v1.0" %></td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <table class="table table-borderless">
                                <tr>
                                    <th width="40%">Trạng thái:</th>
                                    <td>
                                        <% if ("active".equals(bom.getStatus())) { %>
                                            <span class="badge bg-success">Đang dùng</span>
                                        <% } else if ("inactive".equals(bom.getStatus())) { %>
                                            <span class="badge bg-secondary">Ngưng</span>
                                        <% } else { %>
                                            <span class="badge bg-warning">Chờ duyệt</span>
                                        <% } %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Ngày tạo:</th>
                                    <td><%= bom.getCreatedDate() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(bom.getCreatedDate()) : "Chưa có" %></td>
                                </tr>
                                <tr>
                                    <th>Ghi chú:</th>
                                    <td><%= bom.getNotes() != null ? bom.getNotes() : "Không có" %></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Danh sách nguyên liệu -->
                <div class="detail-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4><i class="fas fa-list me-2"></i>Danh sách nguyên liệu</h4>
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addMaterialModal">
                            <i class="fas fa-plus me-2"></i>Thêm nguyên liệu
                        </button>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>STT</th>
                                    <th>Nguyên liệu</th>
                                    <th>Số lượng</th>
                                    <th>Đơn vị tính</th>
                                    <th>Hao hụt (%)</th>
                                    <th>Ghi chú</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (details != null && !details.isEmpty()) {
                                        int stt = 1;
                                        for (BOMDetailDTO detail : details) {
                                %>
                                <tr>
                                    <td><%= stt++ %></td>
                                    <td><%= detail.getMaterialName() != null ? detail.getMaterialName() : "ID: " + detail.getMaterialItemId() %></td>
                                    <td><%= detail.getQuantityRequired() %></td>
                                    <td><%= detail.getUnit() != null ? detail.getUnit() : "" %></td>
                                    <td><%= detail.getWastePercent() %>%</td>
                                    <td><%= detail.getNotes() != null ? detail.getNotes() : "" %></td>
                                    <td>
                                        <button class="btn btn-warning btn-sm" data-bs-toggle="modal" 
                                                data-bs-target="#editMaterialModal<%= detail.getBomDetailId() %>">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <a href="BOMController?action=deleteDetail&id=<%= detail.getBomDetailId() %>&bomId=<%= bom.getBomId() %>" 
                                           class="btn btn-danger btn-sm" onclick="return confirm('Xóa nguyên liệu này?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                                <% 
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="7" class="text-center text-muted">Chưa có nguyên liệu nào</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Thêm nguyên liệu -->
    <div class="modal fade" id="addMaterialModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="post" action="BOMController">
                    <input type="hidden" name="action" value="addDetail">
                    <input type="hidden" name="bomId" value="<%= bom.getBomId() %>">
                    <div class="modal-header">
                        <h5 class="modal-title">Thêm nguyên liệu vào BOM</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Nguyên liệu <span class="text-danger">*</span></label>
                            <select name="materialItemId" class="form-select" required>
                                <option value="">-- Chọn nguyên liệu --</option>
                                <jsp:include page="item-options.jsp">
                                    <jsp:param name="type" value="VatTu"/>
                                </jsp:include>
                            </select>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số lượng <span class="text-danger">*</span></label>
                                <input type="number" name="quantity" class="form-control" step="0.01" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Đơn vị tính</label>
                                <input type="text" name="unit" class="form-control" placeholder="VD: cái, kg, m...">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Hao hụt (%)</label>
                                <input type="number" name="wastePercent" class="form-control" step="0.01" value="0">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Ghi chú</label>
                                <input type="text" name="notes" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Thêm</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
