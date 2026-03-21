<%@page import="pms.model.BOMDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Demo data - will be replaced by real data from DB
    List<BOMDTO> list = (List<BOMDTO>) request.getAttribute("danhSachBOM");
    
    // If no data from DB, use demo data
    if (list == null || list.isEmpty()) {
        list = new java.util.ArrayList<>();
        list.add(new BOMDTO(1, 101, 201, 2));
        list.add(new BOMDTO(2, 101, 202, 1));
        list.add(new BOMDTO(3, 102, 203, 4));
        list.add(new BOMDTO(4, 103, 204, 1));
        list.add(new BOMDTO(5, 104, 205, 3));
    }
    
    int totalRecords = list.size();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>BOM Management</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
        <%@include file="/WEB-INF/jspf/admin-module-style.jspf" %>
    </head>
    <body>
        <div class="module-shell">
            <div class="module-container">
                <section class="module-hero">
                    <div>
                        <h1 class="module-title">Quản lý BOM</h1>
                        <p class="module-subtitle">Xem chi tiết, thêm mới, chỉnh sửa và xóa BOM trong một màn hình đồng bộ với dashboard.</p>
                    </div>
                    <div class="module-actions">
                        <a class="app-btn app-btn-secondary" href="DashboardController">← Dashboard</a>
                        <a class="app-btn app-btn-primary" href="BOMController?action=addBOM">＋ Thêm BOM</a>
                    </div>
                </section>

                <section class="module-panel module-card">
                    <div class="toolbar-row">
                        <div>
                            <h2 class="panel-title">Danh sách BOM</h2>
                            <p class="panel-note">Toàn bộ BOM đang có trong hệ thống được hiển thị tại đây.</p>
                        </div>
                        <div class="toolbar-stack">
                            <span class="badge-soft"><%= totalRecords %> BOM</span>
                            <a class="app-btn app-btn-secondary" href="BOMController?action=list">Làm mới</a>
                        </div>
                    </div>

                    <div class="app-table-shell">
                        <table class="app-table">
                            <thead>
                                <tr>
                                    <th>BOM ID</th>
                                    <th>Product Item ID</th>
                                    <th>Material Item ID</th>
                                    <th>Quantity</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (list != null && !list.isEmpty()) {
                                        for (BOMDTO bom : list) {
                                %>
                                <tr>
                                    <td>#<%= bom.getBomId() %></td>
                                    <td><%= bom.getProductItemId() %></td>
                                    <td><%= bom.getMaterialItemId() %></td>
                                    <td><%= bom.getQuantityRequired() %></td>
                                    <td>
                                        <div class="table-actions">
                                            <a class="app-btn app-btn-secondary" href="BOMController?action=viewBOM&id=<%= bom.getBomId() %>">Chi tiết</a>
                                            <a class="app-btn app-btn-secondary" href="BOMController?action=editBOM&id=<%= bom.getBomId() %>">Sửa</a>
                                            <a class="app-btn app-btn-danger" href="BOMController?action=deleteBOM&id=<%= bom.getBomId() %>" onclick="return confirm('Xóa BOM này?');">Xóa</a>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="5" class="app-empty">Chưa có BOM nào trong hệ thống.</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </section>
            </div>
        </div>
    </body>
</html>
