<%-- 
    Document   : listRoutingStep
    Created on : Mar 14, 2026, 9:35:43 PM
    Author     : se193234_TranGiaBao
--%>

<%@page import="pms.model.RoutingStepDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Chi tiết Công đoạn</title>
        <style>
            table { width: 80%; border-collapse: collapse; margin-top: 20px; }
            table, th, td { border: 1px solid black; } th, td { padding: 10px; text-align: center; } th { background-color: #f3e5f5; }
            .btn { display: inline-block; padding: 8px 15px; text-decoration: none; color: white; border-radius: 5px; margin-bottom: 15px; }
            .btn-back { background-color: #607d8b; margin-right: 10px; }
            .btn-add { background-color: #4CAF50; }
        </style>
    </head>
    <body>
        <h2>Danh sách Chi tiết Công đoạn (Routing Step)</h2>
        <a href="index.jsp" class="btn btn-back">⬅️ Quay lại Menu</a>
        <a href="addRoutingStep.jsp" class="btn btn-add">+ Thêm Công đoạn mới</a>
        
        <table>
            <tr><th>Mã CĐ</th><th>ID Quy trình</th><th>Tên Công đoạn</th><th>T/g Ước tính</th><th>Kiểm tra QC?</th><th>Hành động</th></tr>
            <%
                List<RoutingStepDTO> list = (List<RoutingStepDTO>) request.getAttribute("listStep");
                if (list != null && !list.isEmpty()) {
                    for (RoutingStepDTO s : list) {
            %>
            <tr>
                <td><%= s.getStepId() %></td><td><%= s.getRoutingId() %></td>
                <td><%= s.getStepName() %></td><td><%= s.getEstimatedTime() %> phút</td>
                <td style="font-weight: bold; color: <%= s.isIsInspected() ? "green" : "gray" %>;">
                    <%= s.isIsInspected() ? "Có" : "Không" %>
                </td>
                <td>
                    <a href="MainController?action=listRoutingStep&action=load_update&stepId=<%= s.getStepId() %>">Sửa</a> | 
                    <a href="MainController?action=listRoutingStep&action=delete&stepId=<%= s.getStepId() %>" onclick="return confirm('Xóa công đoạn này?');" style="color:red;">Xóa</a>
                </td>
            </tr>
            <% } } else { out.print("<tr><td colspan='6'>Chưa có công đoạn nào</td></tr>"); } %>
        </table>
    </body>
</html>
