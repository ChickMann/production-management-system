<%-- 
    Document   : purchase-order

    
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đề Nghị Nhập Vật Tư (PO)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light p-4">
    <div class="container-fluid">
        
        <div class="mb-3">
            <a href="MainController?action=loginUser" class="btn btn-secondary shadow-sm">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Dashboard
            </a>
        </div>

        <div class="alert alert-warning shadow-sm border-warning">
            <h5 class="alert-heading text-dark fw-bold"><i class="fa-solid fa-bell text-danger me-2"></i> CẢNH BÁO TỒN KHO!</h5>
            <p class="mb-0 text-dark">Dưới đây là danh sách các vật tư đang bị thiếu hụt để chạy Lệnh Sản Xuất. Yêu cầu Quản lý duyệt mua gấp!</p>
        </div>

        <div class="row">
            <div class="col-md-4">
                <div class="card shadow border-0">
                    <div class="card-header bg-primary text-white fw-bold"><i class="fa-solid fa-cart-plus me-2"></i> Tạo Đề Nghị Nhập Kho</div>
                    <div class="card-body">
                        <form action="MainController" method="post">
                            <input type="hidden" name="action" value="addPurchaseOrder">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Chọn Vật Tư Cần Mua</label>
                                <select name="itemId" class="form-select border-primary" required>
                                    <option value="">-- Click để chọn vật tư --</option>
                                    <c:forEach items="${listItems}" var="i">
                                        <c:if test="${i.itemType == 'VatTu'}">
                                            <option value="${i.itemID}">[Mã ${i.itemID}] ${i.itemName} (Tồn: ${i.stockQuantity})</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Số Lượng Cần Nhập</label>
                                <input type="number" name="quantity" class="form-control border-primary" min="1" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 fw-bold shadow-sm">GỬI YÊU CẦU MUA (PO)</button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card shadow border-0">
                    <div class="card-header bg-dark text-white fw-bold">Danh Sách Yêu Cầu Nhập Vật Tư</div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table align-middle table-hover border text-center">
                                <thead class="table-light">
                                    <tr>
                                        <th>Mã Đơn (PO)</th>
                                        <th>Tên Vật Tư</th>
                                        <th>Số Lượng Cần</th>
                                        <th>Ngày Yêu Cầu</th>
                                        <th>Trạng Thái</th>
                                        <th>Xử Lý (Sếp)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listPO}" var="po">
                                        <tr>
                                            <td class="fw-bold text-primary">PO-#${po.poId}</td>
                                            <td class="text-start fw-bold text-dark"><i class="fa-solid fa-screw-nail text-muted me-1"></i> ${po.itemName}</td>
                                            <td><b class="text-danger fs-5">${po.quantityRequested}</b></td>
                                            <td class="small text-muted">${po.orderDate}</td>
                                            <td>
                                                <span class="badge ${po.status == 'Received' ? 'bg-success' : (po.status == 'Ordered' ? 'bg-info text-dark' : 'bg-warning text-dark')}">
                                                    ${po.status}
                                                </span>
                                            </td>
                                            <td>
                                                <form action="MainController" method="post" class="d-inline">
                                                    <input type="hidden" name="action" value="updateStatusPurchaseOrder">
                                                    <input type="hidden" name="poId" value="${po.poId}">
                                                    <select name="status" class="form-select form-select-sm d-inline-block w-auto" onchange="this.form.submit()">
                                                        <option value="Pending" ${po.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                                        <option value="Ordered" ${po.status == 'Ordered' ? 'selected' : ''}>Duyệt Mua</option>
                                                        <option value="Received" ${po.status == 'Received' ? 'selected' : ''}>Đã Nhập Kho</option>
                                                    </select>
                                                </form>
                                                <a href="MainController?action=deletePurchaseOrder&poId=${po.poId}" class="btn btn-sm btn-danger ms-1" onclick="return confirm('Hủy yêu cầu mua vật tư này?')" title="Hủy Yêu Cầu"><i class="fa-solid fa-xmark"></i></a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
    </div>
</body>
</html>