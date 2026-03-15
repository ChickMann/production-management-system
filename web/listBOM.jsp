<%-- 
    Document   : listBOM
    Created on : Mar 14, 2026, 9:00:26 PM
    Author     : se193234_TranGiaBao
--%>
<%@page import="java.util.List"%>
<%@page import="model.BOMDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý BOM</title>
        <style>
            table { width: 80%; border-collapse: collapse; margin-top: 20px; }
            table, th, td { border: 1px solid black; }
            th, td { padding: 10px; text-align: center; } th { background-color: #e3f2fd; }
            .btn { display: inline-block; padding: 8px 15px; text-decoration: none; color: white; border-radius: 5px; margin-bottom: 15px; }
            .btn-back { background-color: #607d8b; margin-right: 10px; }
            .btn-add { background-color: #4CAF50; }
        </style>
    </head>
    <body>
        <h2>Danh sách Công thức Sản phẩm (BOM)</h2>
        <a href="index.jsp" class="btn btn-back">⬅️ Quay lại Menu</a>
        <a href="addBOM.jsp" class="btn btn-add">+ Thêm BOM mới</a>
        
        <table>
            <tr><th>Mã BOM</th><th>ID Sản phẩm</th><th>ID Vật tư</th><th>Số lượng</th><th>Hành động</th></tr>
            <%
                List<BOMDTO> list = (List<BOMDTO>) request.getAttribute("danhSachBOM");
                if (list != null && !list.isEmpty()) {
                    for (BOMDTO bom : list) {
            %>
            <tr>
                <td><%= bom.getBomId() %></td><td><%= bom.getProductItemId() %></td>
                <td><%= bom.getMaterialItemId() %></td><td><%= bom.getQuantityRequired() %></td>
                <td>
                    <a href="BOMServlet?action=load_update&bomId=<%= bom.getBomId() %>">Sửa</a> | 
                    <a href="BOMServlet?action=delete&bomId=<%= bom.getBomId() %>" onclick="return confirm('Xóa BOM này?');" style="color:red;">Xóa</a>
                </td>
            </tr>
            <% } } else { out.print("<tr><td colspan='5'>Chưa có dữ liệu</td></tr>"); } %>
        </table>
    </body>
</html>