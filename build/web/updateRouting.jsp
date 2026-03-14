<%-- 
    Document   : updateRouting
    Created on : Mar 14, 2026, 9:32:30 PM
    Author     : se193234_TranGiaBao
--%>

<%@page import="model.RoutingDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head><title>Sửa Quy trình</title></head>
    <body>
        <h2>Cập nhật Quy trình Sản xuất</h2>
        
        <% RoutingDTO r = (RoutingDTO) request.getAttribute("routingEdit"); if (r != null) { %>
        <form action="RoutingServlet" method="POST">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="routingId" value="<%= r.getRoutingId() %>">
            
            Tên quy trình: <input type="text" name="routingName" value="<%= r.getRoutingName() %>" required>
            <button type="submit">Lưu Cập Nhật</button>
            <a href="RoutingServlet?action=list">Hủy</a>
        </form>
        <% } else { out.print("<h3 style='color:red;'>Không tìm thấy Quy trình này!</h3>"); } %>
    </body>
</html>