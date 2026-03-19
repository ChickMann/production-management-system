<%-- 
    Document   : listRouting
    
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quy Trình Tổng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; padding-top: 2rem; font-family: 'Segoe UI', sans-serif; }
        .card-header { background-color: #34495e; color: white; font-weight: bold; }
    </style>
</head>
<body>
<c:set var="mode" value="${not empty routingEdit ? 'update' : 'add'}" />
<div class="container">
    <div class="mb-3"><a href="MainController?action=loginUser" class="btn btn-secondary"><i class="fa-solid fa-arrow-left"></i> Quay lại</a></div>
    <div class="row">
        <div class="col-md-4">
            <div class="card shadow-sm border-0">
                <div class="card-header ${mode == 'update' ? 'bg-warning text-dark' : 'bg-primary text-white'}">
                    ${mode == 'update' ? 'Sửa Quy Trình' : 'Thêm Quy Trình Mới'}
                </div>
                <div class="card-body">
                    <form action="MainController" method="post">
                        <input type="hidden" name="action" value="${mode == 'update' ? 'saveUpdateRouting' : 'addRouting'}">
                        <div class="mb-3">
                            <label class="form-label fw-bold">ID</label>
                            <input type="text" name="routingId" class="form-control bg-light" value="${routingEdit.routingId}" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên Quy Trình</label>
                            <input type="text" name="routingName" class="form-control" value="${routingEdit.routingName}" required>
                        </div>
                        <button class="btn ${mode == 'update' ? 'btn-warning' : 'btn-success'} w-100 fw-bold">LƯU QUY TRÌNH</button>
                        <c:if test="${mode == 'update'}"><a href="MainController?action=listRouting" class="btn btn-link w-100 text-decoration-none mt-2">Hủy sửa</a></c:if>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-md-8">
            <div class="card shadow-sm border-0">
                <div class="card-body">
                    <form action="MainController" method="get" class="d-flex mb-3">
                        <input type="hidden" name="action" value="searchRouting">
                        <input type="text" name="keyword" class="form-control me-2" placeholder="Tìm tên quy trình..." value="${param.keyword}">
                        <button class="btn btn-outline-primary"><i class="fa-solid fa-magnifying-glass"></i></button>
                    </form>
                    <table class="table table-hover align-middle">
                        <thead class="table-dark"><tr><th>ID</th><th>Tên Quy Trình Tổng</th><th class="text-center">Hành động</th></tr></thead>
                        <tbody>
                            <c:forEach items="${listR}" var="r">
                                <tr>
                                    <td>${r.routingId}</td>
                                    <td class="fw-bold text-success">${r.routingName}</td>
                                    <td class="text-center">
                                        <a href="MainController?action=loadUpdateRouting&id=${r.routingId}" class="btn btn-sm btn-warning"><i class="fa-solid fa-pen"></i></a>
                                        <a href="MainController?action=deleteRouting&id=${r.routingId}" class="btn btn-sm btn-danger" onclick="return confirm('Xóa quy trình này?')"><i class="fa-solid fa-trash"></i></a>
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
</body>
</html>