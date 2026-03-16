<%-- 
    Document   : updateRoutingStep
    Created on : Mar 14, 2026, 9:36:11 PM
    Author     : se193234_TranGiaBao
--%>


<%@page import="pms.model.RoutingStepDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head><title>Sửa Công đoạn</title></head>
    <body>
        <h2>Cập nhật Công đoạn</h2>
        <% 
            RoutingStepDTO s = (RoutingStepDTO) request.getAttribute("stepEdit"); 
            if (s != null) { 
        %>
        <form action="RoutingStepServlet" method="POST">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="stepId" value="<%= s.getStepId() %>">
            
            <p>ID Quy trình tổng: <br>
               <input type="number" name="routingId" value="<%= s.getRoutingId() %>" required></p>
               
            <p>Tên công đoạn: <br>
               <input type="text" name="stepName" value="<%= s.getStepName() %>" required></p>
               
            <p>Thời gian (phút): <br>
               <input type="number" name="estimatedTime" value="<%= s.getEstimatedTime() %>" required></p>
               
            <p><label>
                <input type="checkbox" name="isInspected" value="true" <%= s.isIsInspected() ? "checked" : "" %>> Cần kiểm tra chất lượng (QC)?
            </label></p>
            
            <button type="submit">Lưu Cập Nhật</button>
            <a href="MainController?action=listRoutingStep">Hủy</a>
        </form>
        <% } else { out.print("Lỗi dữ liệu!"); } %>
    </body>
</html>
