<%-- 
    Document   : customer
    Created on : Mar 15, 2026, 5:15:09 PM
    Author     : HP
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Khách Hàng</title>
    
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
                    <i class="fa-solid ${mode == 'update' ? 'fa-pen-to-square' : 'fa-user-plus'} me-2"></i> 
                    ${mode == 'update' ? 'Cập Nhật Khách Hàng' : 'Thêm Khách Hàng Mới'}
                </div>
                <div class="card-body">
                    <form action="CustomerController" method="post">
                        <input type="hidden" name="action" value="${mode == 'update' ? 'saveUpdateCustomer' : 'saveAddCustomer'}">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">ID Khách Hàng</label>
                            <input type="text" class="form-control bg-light" name="id" value="${customer.customer_id}" readonly placeholder="Hệ thống tự tạo">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên Khách Hàng <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="customer_name" value="${customer.customer_name}" required placeholder="Nhập họ và tên...">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Số Điện Thoại</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-phone"></i></span>
                                <input type="text" class="form-control" name="phone" value="${customer.phone}" placeholder="Nhập SĐT...">
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold">Email</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                                <input type="email" class="form-control" name="email" value="${customer.email}" placeholder="Nhập Email...">
                            </div>
                        </div>
                        
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn ${mode == 'update' ? 'btn-warning fw-bold text-dark' : 'btn-success fw-bold'}">
                                <i class="fa-solid fa-floppy-disk me-1"></i> ${mode == 'update' ? 'Lưu Thay Đổi' : 'Lưu Khách Hàng'}
                            </button>
                            <c:if test="${mode == 'update'}">
                                <a href="CustomerController?action=searchCustomer" class="btn btn-outline-secondary">Hủy Sửa</a>
                            </c:if>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-dark text-white">
                    <i class="fa-solid fa-users me-2"></i> Danh sách Khách Hàng
                </div>
                <div class="card-body">
                    
                    <form action="CustomerController" method="get" class="mb-4 d-flex">
                        <input type="hidden" name="action" value="searchCustomer">
                        <input type="search" class="form-control me-2" name="keyword" value="${keyword}" placeholder="Nhập ID khách hàng để tìm kiếm...">
                        <button type="submit" class="btn btn-outline-primary text-nowrap shadow-sm">
                            <i class="fa-solid fa-magnifying-glass me-1"></i> Tìm Kiếm
                        </button>
                    </form>

                    <div class="table-responsive">
                        <c:choose>
                            <c:when test="${empty customerList}">
                                <div class="text-center text-muted py-5">
                                    <i class="fa-regular fa-folder-open fa-4x mb-3 d-block text-secondary"></i>
                                    <h5>Chưa có dữ liệu khách hàng nào!</h5>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="table table-bordered table-hover align-middle text-center">
                                    <thead class="table-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên Khách Hàng</th>
                                            <th>Số Điện Thoại</th>
                                            <th>Email</th>
                                            <th>Hành Động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${customerList}" var="c">
                                            <tr>
                                                <td class="fw-bold text-primary">${c.customer_id}</td>
                                                <td class="text-start fw-semibold">${c.customer_name}</td>
                                                <td>${c.phone}</td>
                                                <td>${c.email}</td>
                                                <td class="text-nowrap">
                                                    <a href="CustomerController?action=updateCustomer&id=${c.customer_id}" class="btn btn-warning btn-sm text-dark shadow-sm" title="Sửa">
                                                        <i class="fa-solid fa-pen-to-square"></i>
                                                    </a>
                                                    <a href="CustomerController?action=removeCustomer&id=${c.customer_id}" onclick="return confirm('Bạn có chắc chắn muốn xóa khách hàng [${c.customer_name}] không?')" class="btn btn-danger btn-sm shadow-sm" title="Xóa">
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