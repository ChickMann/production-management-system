<%-- 
    Document   : defect
    Created on : Mar 18, 2026, 7:19:54 PM
    Author     : se193234_TranGiaBao
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh Mục Lỗi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light p-4">
    <c:set var="mode" value="${not empty defectEdit ? 'update' : 'add'}" />
    <div class="container">
        <div class="mb-3"><a href="MainController?action=loginUser" class="btn btn-secondary"><i class="fa-solid fa-arrow-left"></i> Dashboard</a></div>
        <div class="row">
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-header ${mode == 'update' ? 'bg-warning text-dark' : 'bg-danger text-white'} fw-bold">
                        ${mode == 'update' ? 'Sửa Loại Lỗi' : 'Thêm Loại Lỗi Mới'}
                    </div>
                    <div class="card-body">
                        <form action="MainController" method="post">
                            <input type="hidden" name="action" value="${mode == 'update' ? 'saveUpdateDefect' : 'addDefect'}">
                            <c:if test="${mode == 'update'}">
                                <input type="hidden" name="id" value="${defectEdit.defectId}">
                            </c:if>
                            <label class="form-label">Tên loại lỗi (VD: Nứt gỗ, Sai màu sơn...)</label>
                            <input type="text" name="defectName" class="form-control mb-3" value="${defectEdit.reasonName}" required>
                            <button type="submit" class="btn ${mode == 'update' ? 'btn-warning' : 'btn-danger'} w-100 fw-bold">LƯU LẠI</button>
                            <c:if test="${mode == 'update'}"><a href="MainController?action=listDefect" class="btn btn-link w-100">Hủy</a></c:if>
                        </form>
                    </div>
                </div>
            </div>
            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-dark text-white fw-bold">Danh Sách Các Lỗi Thường Gặp</div>
                    <div class="card-body">
                        <table class="table table-hover align-middle">
                            <thead class="table-light text-center"><tr><th>ID</th><th>Tên Lỗi</th><th>Hành Động</th></tr></thead>
                            <tbody class="text-center">
                                <c:forEach items="${listD}" var="d">
                                    <tr>
                                        <td>${d.defectId}</td>
                                        <td><span class="badge bg-warning text-dark fs-6">${d.reasonName}</span></td>
                                        <td>
                                            <a href="MainController?action=loadUpdateDefect&id=${d.defectId}" class="btn btn-sm btn-primary"><i class="fa-solid fa-pen"></i></a>
                                            <a href="MainController?action=deleteDefect&id=${d.defectId}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Xóa lỗi này?')"><i class="fa-solid fa-trash"></i></a>
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