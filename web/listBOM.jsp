<%-- 
    Document   : listBOM
    
--%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý BOM (Công thức Sản phẩm)</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            body {
                background-color: #f4f7fa;
                padding-top: 2rem;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .card-header {
                background-color: #2c3e50;
                color: white;
                font-weight: bold;
            }
            .table-hover tbody tr:hover {
                background-color: #f1f4f8;
            }
        </style>
    </head>
    <body>

        <c:set var="mode" value="${not empty bomEdit ? 'update' : 'add'}" />

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

            <div class="row">
                <div class="col-lg-4 mb-4">
                    <div class="card shadow-sm border-0">
                        <div class="card-header ${mode == 'update' ? 'bg-warning text-dark' : 'bg-primary text-white'}">
                            <i class="fa-solid ${mode == 'update' ? 'fa-pen-to-square' : 'fa-clipboard-list'} me-2"></i> 
                            ${mode == 'update' ? 'Cập Nhật Công Thức (BOM)' : 'Thêm Công Thức Mới'}
                        </div>
                        <div class="card-body">
                            <form action="MainController" method="post">
                                <input type="hidden" name="action" value="${mode == 'update' ? 'saveUpdateBom' : 'addBom'}">

                                <div class="mb-3">
                                    <label class="form-label fw-bold">Mã BOM</label>
                                    <input type="text" class="form-control bg-light" name="bomId" value="${bomEdit.bomId}" readonly placeholder="Hệ thống tự tạo">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold text-success">Chọn Sản Phẩm Cần Chế Tạo <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fa-solid fa-couch"></i></span>
                                        <select class="form-select" name="productItemId" required>
                                            <option value="">-- Click để chọn Sản Phẩm --</option>
                                            <c:forEach items="${itemList}" var="item">
                                                <c:if test="${item.itemType == 'SanPham'}">
                                                    <option value="${item.itemID}" ${bomEdit.productItemId == item.itemID ? 'selected' : ''}>
                                                        [Mã ${item.itemID}] - ${item.itemName}
                                                    </option>
                                                </c:if>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold text-warning text-dark">Chọn Vật Tư Cấu Thành <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fa-solid fa-hammer"></i></span>
                                        <select class="form-select" name="materialItemId" required>
                                            <option value="">-- Click để chọn Vật Tư --</option>
                                            <c:forEach items="${itemList}" var="item">
                                                <c:if test="${item.itemType == 'VatTu'}">
                                                    <option value="${item.itemID}" ${bomEdit.materialItemId == item.itemID ? 'selected' : ''}>
                                                        [Mã ${item.itemID}] - ${item.itemName} (Kho: ${item.stockQuantity})
                                                    </option>
                                                </c:if>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-bold">Số Lượng Cần Dùng <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fa-solid fa-cubes"></i></span>
                                        <input type="number" class="form-control" name="quantityRequired" value="${bomEdit.quantityRequired}" required placeholder="VD: 4 (chân bàn)...">
                                    </div>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn ${mode == 'update' ? 'btn-warning fw-bold text-dark' : 'btn-success fw-bold'}">
                                        <i class="fa-solid fa-floppy-disk me-1"></i> ${mode == 'update' ? 'Lưu Cập Nhật' : 'Lưu Công Thức'}
                                    </button>
                                    <c:if test="${mode == 'update'}">
                                        <a href="MainController?action=listBOM" class="btn btn-outline-secondary">Hủy Sửa</a>
                                    </c:if>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-8">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-dark text-white">
                            <i class="fa-solid fa-list-check me-2"></i> Danh sách Công Thức BOM
                        </div>
                        <div class="card-body">

                            <form action="MainController" method="get" class="mb-4 d-flex">
                                <input type="hidden" name="action" value="searchBom">
                                <input type="search" class="form-control me-2" name="keyword" value="${param.keyword}" placeholder="Tìm kiếm...">
                                <button type="submit" class="btn btn-outline-primary text-nowrap shadow-sm">
                                    <i class="fa-solid fa-magnifying-glass me-1"></i> Tìm Kiếm
                                </button>
                            </form>

                            <div class="table-responsive">
                                <c:choose>
                                    <c:when test="${empty danhSachBOM}">
                                        <div class="text-center text-muted py-5">
                                            <i class="fa-solid fa-folder-open fa-4x mb-3 d-block text-secondary"></i>
                                            <h5>Chưa có công thức BOM nào!</h5>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <table class="table table-bordered table-hover align-middle text-center">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Mã BOM</th>
                                                    <th class="text-success">Sản Phẩm (Thành Phẩm)</th>
                                                    <th class="text-warning text-dark">Vật Tư (Nguyên Liệu)</th>
                                                    <th>Số Lượng Cần</th>
                                                    <th>Hành Động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${danhSachBOM}" var="bom">
                                                    <tr>
                                                        <td class="fw-bold text-primary">${bom.bomId}</td>

                                                        <td class="text-start fw-semibold text-success">
                                                            <c:forEach items="${itemList}" var="i">
                                                                <c:if test="${i.itemID == bom.productItemId}">
                                                                    <c:choose>
                                                                        <c:when test="${i.itemName.toLowerCase().contains('ghế')}">
                                                                            <i class="fa-solid fa-chair me-1"></i>
                                                                        </c:when>
                                                                        <c:when test="${i.itemName.toLowerCase().contains('bàn')}">
                                                                            <i class="fa-solid fa-table me-1"></i>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <i class="fa-solid fa-box-open me-1"></i>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    ${i.itemName}
                                                                </c:if>
                                                            </c:forEach>
                                                        </td>

                                                        <td class="text-start fw-semibold text-warning text-dark">
                                                            <c:forEach items="${itemList}" var="i">
                                                                <c:if test="${i.itemID == bom.materialItemId}">
                                                                    <i class="fa-solid fa-screw-nail me-1"></i> ${i.itemName}
                                                                </c:if>
                                                            </c:forEach>
                                                        </td>

                                                        <td><span class="badge bg-info text-dark fs-6">${bom.quantityRequired}</span></td>

                                                        <td class="text-nowrap">
                                                            <a href="MainController?action=loadUpdateBom&bomId=${bom.bomId}" class="btn btn-warning btn-sm text-dark shadow-sm" title="Sửa">
                                                                <i class="fa-solid fa-pen-to-square"></i>
                                                            </a>
                                                            <a href="MainController?action=deleteBom&bomId=${bom.bomId}" onclick="return confirm('Bạn có chắc chắn muốn xóa Mã BOM [${bom.bomId}] không?')" class="btn btn-danger btn-sm shadow-sm" title="Xóa">
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