<%-- 
    Document   : SearchItem
    
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Kho Hàng (Item)</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body { background-color: #f4f7fa; padding-top: 2rem; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .card-header { background-color: #2c3e50; color: white; font-weight: bold; }
        .table-hover tbody tr:hover { background-color: #f1f4f8; }
    </style>
</head>
<body>

<div class="container-fluid px-4">
    <div class="mb-3">
        <a href="MainController?action=loginUser" class="btn btn-secondary shadow-sm">
            <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Bảng Điều Khiển
        </a>
    </div>

    <c:if test="${not empty msg}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> <strong>${msg}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i> <strong>${error}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="row">
        <div class="col-lg-4 mb-4">
            <div class="card shadow-sm border-0">
                <div class="card-header ${mode == 'update' ? 'bg-warning text-dark' : 'bg-primary text-white'}">
                    <i class="fa-solid ${mode == 'update' ? 'fa-pen-to-square' : 'fa-box-open'} me-2"></i> 
                    ${mode == 'update' ? 'Cập Nhật Vật Phẩm' : 'Thêm Vật Phẩm Mới'}
                </div>
                <div class="card-body">
                    <form action="MainController" method="post">
                        <input type="hidden" name="action" value="${mode == 'update' ? 'saveUpdateItem' : 'saveAddItem'}">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">ID Vật Phẩm</label>
                            <input type="text" class="form-control bg-light" name="id" value="${mode == 'update' ? item.itemID : index}" readonly>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên Vật Phẩm <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" value="${item.itemName}" required placeholder="VD: Gỗ Sồi, Bàn Tròn...">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Phân Loại <span class="text-danger">*</span></label>
                            <select class="form-select" name="type" required>
                                <option value="SanPham" ${item.itemType == 'SanPham' ? 'selected' : ''}>Sản Phẩm (Bàn, Ghế...)</option>
                                <option value="VatTu" ${item.itemType == 'VatTu' ? 'selected' : ''}>Vật Tư (Gỗ, Ốc vít...)</option>
                            </select>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold">Số Lượng Tồn Kho <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-cubes"></i></span>
                                <input type="number" step="1" min="0" class="form-control" name="stockQuantity" value="${item.stockQuantity}" required placeholder="Nhập số lượng...">
                            </div>
                        </div>
                        
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn ${mode == 'update' ? 'btn-warning fw-bold text-dark' : 'btn-success fw-bold'}">
                                <i class="fa-solid fa-floppy-disk me-1"></i> ${mode == 'update' ? 'Lưu Thay Đổi' : 'Thêm Vào Kho'}
                            </button>
                            <c:if test="${mode == 'update'}">
                                <a href="MainController?action=searchItem" class="btn btn-outline-secondary">Hủy Sửa</a>
                            </c:if>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-dark text-white">
                    <i class="fa-solid fa-boxes-stacked me-2"></i> Kho Master Data (Sản Phẩm & Vật Tư)
                </div>
                <div class="card-body">
                    
                    <form action="MainController" method="post" class="mb-4 d-flex">
                        <input type="hidden" name="action" value="searchItem">
                        <input type="search" class="form-control me-2" name="keyword" value="${keyword}" placeholder="Nhập tên vật phẩm để tìm kiếm...">
                        <button type="submit" class="btn btn-outline-primary text-nowrap shadow-sm">
                            <i class="fa-solid fa-magnifying-glass me-1"></i> Tìm Kiếm
                        </button>
                    </form>

                    <div class="table-responsive">
                        <c:choose>
                            <c:when test="${empty itemList}">
                                <div class="text-center text-muted py-5">
                                    <i class="fa-regular fa-folder-open fa-4x mb-3 d-block text-secondary"></i>
                                    <h5>Kho hàng đang trống hoặc không tìm thấy vật phẩm!</h5>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="table table-bordered table-hover align-middle text-center">
                                    <thead class="table-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên Vật Phẩm</th>
                                            <th>Phân Loại</th>
                                            <th>Tồn Kho</th>
                                            <th>Hành Động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${itemList}" var="i">
                                            <tr>
                                                <td class="fw-bold text-primary">${i.itemID}</td>
                                                <td class="text-start fw-semibold">${i.itemName}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${i.itemType == 'SanPham'}">
                                                            <span class="badge bg-success rounded-pill px-3 py-2"><i class="fa-solid fa-couch me-1"></i> Sản Phẩm</span>
                                                        </c:when>
                                                        <c:when test="${i.itemType == 'VatTu'}">
                                                            <span class="badge bg-warning text-dark rounded-pill px-3 py-2"><i class="fa-solid fa-screw-nail me-1"></i> Vật Tư</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary rounded-pill px-3 py-2">${i.itemType}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><span class="badge bg-info text-dark fs-6">${i.stockQuantity}</span></td>
                                                <td class="text-nowrap">
                                                    <a href="MainController?action=updateItem&id=${i.itemID}" class="btn btn-warning btn-sm text-dark shadow-sm" title="Sửa">
                                                        <i class="fa-solid fa-pen-to-square"></i>
                                                    </a>
                                                    <a href="MainController?action=removeItem&id=${i.itemID}" onclick="return confirm('Bạn có chắc chắn muốn xóa [${i.itemName}] không?')" class="btn btn-danger btn-sm shadow-sm" title="Xóa">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>