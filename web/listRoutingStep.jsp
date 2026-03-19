<%-- 
    Document   : listRoutingStep
    
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Chi Tiết Công Đoạn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f4f7fa; padding-top: 2rem; font-family: 'Segoe UI', sans-serif; }
        .card-header { background-color: #2c3e50; color: white; font-weight: bold; }
        .table-hover tbody tr:hover { background-color: #f1f4f8; }
        .sticky-form { position: sticky; top: 2rem; }
    </style>
</head>
<body>

<c:set var="mode" value="${not empty stepEdit ? 'update' : 'add'}" />

<div class="container-fluid px-4">
    <div class="mb-3">
        <a href="MainController?action=loginUser" class="btn btn-secondary shadow-sm">
            <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Dashboard
        </a>
    </div>

    <div class="row">
        <div class="col-lg-4 mb-4">
            <div class="card shadow-sm border-0 sticky-form">
                <div class="card-header ${mode == 'update' ? 'bg-warning text-dark' : 'bg-primary text-white'}">
                    <i class="fa-solid ${mode == 'update' ? 'fa-pen-to-square' : 'fa-list-check'} me-2"></i>
                    ${mode == 'update' ? 'Cập Nhật Công Đoạn' : 'Thêm Công Đoạn Mới'}
                </div>
                <div class="card-body">
                    <form action="MainController" method="post">
                        <input type="hidden" name="action" value="${mode == 'update' ? 'saveUpdateRoutingStep' : 'addRoutingStep'}">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Mã Công Đoạn</label>
                            <input type="text" class="form-control bg-light" name="stepId" value="${stepEdit.stepId}" readonly placeholder="Tự động tạo">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Thuộc Quy Trình</label>
                            <select class="form-select" name="routingId" required>
                                <option value="">-- Chọn Quy trình tổng --</option>
                                <c:forEach items="${listRouting}" var="r">
                                    <option value="${r.routingId}" ${stepEdit.routingId == r.routingId ? 'selected' : ''}>
                                        ${r.routingName} (ID: ${r.routingId})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên Công Đoạn</label>
                            <input type="text" class="form-control" name="stepName" value="${stepEdit.stepName}" required placeholder="VD: Cắt phôi, Chà nhám...">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Thời gian ước tính (Phút)</label>
                            <input type="number" class="form-control" name="estimatedTime" value="${stepEdit.estimatedTime}" required min="1">
                        </div>

                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="checkInsp" name="isInspected" ${stepEdit.isInspected ? 'checked' : ''}>
                            <label class="form-check-label fw-bold text-danger" for="checkInsp">Yêu cầu kiểm định chất lượng?</label>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn ${mode == 'update' ? 'btn-warning fw-bold' : 'btn-success fw-bold'}">
                                <i class="fa-solid fa-floppy-disk me-1"></i> ${mode == 'update' ? 'Lưu Thay Đổi' : 'Xác Nhận Thêm'}
                            </button>
                            <c:if test="${mode == 'update'}">
                                <a href="MainController?action=listRoutingStep" class="btn btn-outline-secondary text-dark">Hủy Bỏ</a>
                            </c:if>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-dark text-white">
                    <i class="fa-solid fa-table me-2"></i> Danh Sách Chi Tiết Các Công Đoạn
                </div>
                <div class="card-body">
                    
                    <form action="MainController" method="get" class="mb-4 d-flex gap-2">
                        <input type="hidden" name="action" value="searchRoutingStep">
                        
                        <select class="form-select w-auto border-primary" name="searchRoutingId">
                            <option value="">-- Tất cả Quy trình --</option>
                            <c:forEach items="${listRouting}" var="r">
                                <option value="${r.routingId}" ${param.searchRoutingId == r.routingId ? 'selected' : ''}>
                                    ${r.routingName}
                                </option>
                            </c:forEach>
                        </select>

                        <input type="search" class="form-control" name="keyword" value="${param.keyword}" placeholder="Tìm tên công đoạn...">
                        
                        <button type="submit" class="btn btn-primary px-4 shadow-sm">
                            <i class="fa-solid fa-filter me-1"></i> Lọc
                        </button>
                    </form>

                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle">
                            <thead class="table-light text-center">
                                <tr>
                                    <th>Mã</th>
                                    <th>Tên Quy Trình</th>
                                    <th>Tên Công Đoạn</th>
                                    <th>TG (Phút)</th>
                                    <th>Kiểm Định</th>
                                    <th>Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${listStep}" var="s">
                                    <tr>
                                        <td class="text-center">${s.stepId}</td>
                                        <td class="fw-bold">
                                            <c:forEach items="${listRouting}" var="r">
                                                <c:if test="${r.routingId == s.routingId}">${r.routingName}</c:if>
                                            </c:forEach>
                                        </td>
                                        <td>${s.stepName}</td>
                                        <td class="text-center">${s.estimatedTime}</td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${s.isInspected}">
                                                    <span class="badge bg-danger"><i class="fa-solid fa-check"></i> Có</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Không</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <a href="MainController?action=loadUpdateRoutingStep&stepId=${s.stepId}" class="btn btn-warning btn-sm shadow-sm"><i class="fa-solid fa-pen"></i></a>
                                            <a href="MainController?action=deleteRoutingStep&stepId=${s.stepId}" class="btn btn-danger btn-sm shadow-sm" onclick="return confirm('Xóa công đoạn này?')"><i class="fa-solid fa-trash"></i></a>
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