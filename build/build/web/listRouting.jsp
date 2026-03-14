<%-- 
    Document   : listRouting
    Created on : Mar 14, 2026, 9:32:07 PM
    Author     : se193234_TranGiaBao
--%>

<%@page import="java.util.List"%>
<%@page import="model.RoutingDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý Quy trình</title>
        <style>
            table { width: 50%; border-collapse: collapse; margin-top: 20px; }
            table, th, td { border: 1px solid black; }
            th, td { padding: 10px; text-align: center; }
            th { background-color: #e0f7fa; }
        </style>
    </head>
    <body>
        <h2>Danh sách Quy trình Sản xuất (Routing)</h2>
        
        <form action="RoutingServlet" method="POST" style="margin-bottom: 20px;">
            <input type="hidden" name="action" value="add">
            Tên quy trình mới: <input type="text" name="routingName" required>
            <button type="submit">+ Thêm Quy trình</button>
        </form>

        <table>
            <tr><th>ID Quy trình</th><th>Tên Quy trình</th><th>Hành động</th></tr>
            <%
                List<RoutingDTO> list = (List<RoutingDTO>) request.getAttribute("listRouting");
                if (list != null && !list.isEmpty()) {
                    for (RoutingDTO r : list) {
            %>
            <tr>
                <td><%= r.getRoutingId() %></td>
                <td><%= r.getRoutingName() %></td>
                <td>
                    <a href="RoutingServlet?action=load_update&routingId=<%= r.getRoutingId() %>">Sửa</a> | 
                    <a href="RoutingServlet?action=delete&routingId=<%= r.getRoutingId() %>" onclick="return confirm('Bạn có chắc muốn xóa Quy trình này?');" style="color:red;">Xóa</a>
                </td>
            </tr>
            <% } } else { %>
            <tr><td colspan="3">Chưa có dữ liệu</td></tr>
            <% } %>
        </table>
    </body>
</html>
