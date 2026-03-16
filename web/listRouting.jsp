<%-- 
    Document   : listRouting
    Created on : Mar 14, 2026, 9:32:07 PM
    Author     : se193234_TranGiaBao
--%>

<%@page import="pms.model.RoutingDTO"%>
<%@page import="java.util.List"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý Quy trình</title>
        <style>
            table { width: 50%; border-collapse: collapse; margin-top: 15px; }
            table, th, td { border: 1px solid black; } th, td { padding: 10px; text-align: center; } th { background-color: #fff3e0; }
            .btn-back { display: inline-block; padding: 8px 15px; background-color: #607d8b; color: white; text-decoration: none; border-radius: 5px; margin-bottom: 15px; }
        </style>
    </head>
    <body>
        <h2>Danh sách Quy trình Sản xuất (Routing)</h2>
        <a href="index.jsp" class="btn-back">⬅️ Quay lại Menu</a>
        
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
                <td><%= r.getRoutingId() %></td><td><%= r.getRoutingName() %></td>
                <td>
                    <a href="MainController?action=listRouting&action=load_update&routingId=<%= r.getRoutingId() %>">Sửa</a> | 
                    <a href="MainController?action=listRouting&action=delete&routingId=<%= r.getRoutingId() %>" onclick="return confirm('Xóa Quy trình này?');" style="color:red;">Xóa</a>
                </td>
            </tr>
            <% } } else { out.print("<tr><td colspan='3'>Chưa có dữ liệu</td></tr>"); } %>
        </table>
    </body>
</html>
