<%-- 
    Document   : production-log
    
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Nhật Ký Xưởng & KPI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f4f7fa; padding: 20px; font-family: 'Segoe UI', sans-serif; }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="mb-3"><a href="MainController?action=loginUser" class="btn btn-secondary shadow-sm"><i class="fa-solid fa-arrow-left me-1"></i> Dashboard</a></div>
    
    <div class="row">
        
        <c:if test="${user.role ne 'Sep' and user.role ne 'admin'}">
            <div class="col-md-4 mb-4">
                <div class="card shadow border-0">
                    <div class="card-header bg-success text-white fw-bold">
                        <i class="fa-solid fa-clipboard-user me-2"></i> BÁO CÁO SẢN LƯỢNG
                    </div>
                    <div class="card-body">
                        <form action="MainController" method="post">
                            <input type="hidden" name="action" value="addLog">
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold">Chọn Lệnh (Work Order) <span class="text-danger">*</span></label>
                                <select name="workOrderId" class="form-select border-primary" required>
                                    <option value="">-- Click để chọn mã lệnh --</option>
                                    <c:forEach items="${listWO}" var="wo">
                                        <c:if test="${wo.status ne 'Completed'}">
                                            <option value="${wo.workOrderID}">Mã: WO-${wo.workOrderID} (Cần làm: ${wo.quantity})</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Công Đoạn <span class="text-danger">*</span></label>
                                <select name="stepId" class="form-select border-primary" required>
                                    <option value="">-- Chọn công đoạn --</option>
                                    <c:forEach items="${listSteps}" var="s">
                                        <option value="${s.stepId}">${s.stepName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="row">
                                <div class="col-6 mb-3"><label class="text-success fw-bold">Đạt (OK)</label><input type="number" name="quantityDone" class="form-control" value="0" min="0" required></div>
                                <div class="col-6 mb-3"><label class="text-danger fw-bold">Lỗi (NG)</label><input type="number" name="quantityDefective" class="form-control" value="0" min="0" required></div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold">Lý Do Lỗi (Nếu có)</label>
                                <select name="defectId" class="form-select">
                                    <option value="0">-- Không có lỗi --</option>
                                    <c:forEach items="${listDefects}" var="d">
                                        <option value="${d.defectId}">${d.reasonName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-success w-100 fw-bold shadow-sm">GỬI BÁO CÁO</button>
                        </form>
                    </div>
                </div>
            </div>
        </c:if>


        <div class="${(user.role eq 'Sep' or user.role eq 'admin') ? 'col-md-12' : 'col-md-8'}">
            
            <c:if test="${user.role ne 'Sep' and user.role ne 'admin'}">
                <div class="card shadow border-0 mb-4">
                    <div class="card-header bg-warning text-dark fw-bold">
                        <i class="fa-solid fa-list-check me-2"></i> VIỆC CẦN LÀM (LỆNH SX ĐANG CHỜ / ĐANG CHẠY)
                    </div>
                    <div class="card-body">
                        <div class="table-responsive" style="max-height: 250px; overflow-y: auto;">
                            <table class="table table-hover align-middle border">
                                <thead class="table-light text-center sticky-top">
                                    <tr>
                                        <th>Mã Lệnh</th>
                                        <th>Khách Hàng (ID)</th>
                                        <th>Sản Phẩm (ID)</th>
                                        <th>Số Lượng Yêu Cầu</th>
                                        <th>Trạng Thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listWO}" var="wo">
                                        <c:if test="${wo.status ne 'Completed'}">
                                            <tr class="text-center">
                                                <td class="fw-bold text-primary">#WO-${wo.workOrderID}</td>
                                                <td><i class="fa-solid fa-user text-muted me-1"></i> ${wo.customerID}</td>
                                                <td><span class="badge bg-secondary fs-6">SP-${wo.productItemID}</span></td>
                                                <td><b class="text-danger fs-5">${wo.quantity}</b> cái</td>
                                                <td>
                                                    <span class="badge ${wo.status == 'New' ? 'bg-info text-dark' : 'bg-primary'}">
                                                        ${wo.status == 'New' ? 'Chờ sản xuất' : 'Đang chạy'}
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>

            <div class="card shadow border-0">
                <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
                    <span><i class="fa-solid fa-clock-rotate-left me-2"></i> NHẬT KÝ SẢN LƯỢNG & TỶ LỆ LỖI</span>
                    <c:if test="${user.role eq 'Sep' or user.role eq 'admin'}">
                        <span class="badge bg-light text-dark"><i class="fa-solid fa-eye text-primary"></i> Chế độ xem của Quản lý</span>
                    </c:if>
                </div>
                <div class="card-body">
                    <div class="table-responsive" style="max-height: ${user.role eq 'Sep' or user.role eq 'admin' ? '600px' : '400px'}; overflow-y: auto;">
                        <table class="table table-hover align-middle border">
                            <thead class="table-light text-center sticky-top">
                                <tr><th>Ngày Báo Cáo</th><th>Mã Lệnh</th><th>Công Đoạn</th><th>Đạt (OK)</th><th>Lỗi (NG)</th><th>Ghi Chú Lỗi</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${listLogs}" var="l">
                                    <tr class="text-center">
                                        <td class="small text-muted">${l.logDate}</td>
                                        <td class="fw-bold text-primary">#WO-${l.workOrderId}</td>
                                        <td><span class="badge bg-info text-dark">${l.stepName}</span></td>
                                        <td><b class="text-success fs-5">${l.quantityDone}</b></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${l.quantityDefective > 0}"><b class="text-danger fs-5">${l.quantityDefective}</b></c:when>
                                                <c:otherwise><span class="text-muted">0</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-start">
                                            <c:if test="${not empty l.defectName and l.defectName ne 'OK'}">
                                                <span class="text-danger small"><i class="fa-solid fa-triangle-exclamation"></i> ${l.defectName}</span>
                                            </c:if>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>