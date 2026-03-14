<%-- 
    Document   : listRoutingStep
    Created on : Mar 14, 2026, 9:35:43 PM
    Author     : se193234_TranGiaBao
--%>

<%@page import="java.util.List"%>
<%@page import="model.RoutingStepDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Chi tiết Công đoạn</title>
        <style>
            table { width: 80%; border-collapse: collapse; margin-top: 20px; }
            table, th, td { border: 1px solid black; }
            th, td { padding: 10px; text-align: center; }
            th { background-color: #ffe0b2; }
        </style>
    </head>
    <body>
        <h2>Danh sách Chi tiết Công đoạn (Routing Step)</h2>
        <a href="addRoutingStep.jsp" style="padding: 10px; background-color: #4CAF50; color: white; text-decoration: none;">+ Thêm Công đoạn mới</a>
        
        <table>
            <tr>
                <th>Mã Công đoạn</th><th>ID Quy trình tổng</th><th>Tên Công đoạn</th>
                <th>T/g Ước tính (Phút)</th><th>Cần kiểm tra QC?</th><th>Hành động</th>
            </tr>
            <%
                List<RoutingStepDTO> list = (List<RoutingStepDTO>) request.getAttribute("listStep");
                if (list != null && !list.isEmpty()) {
                    for (RoutingStepDTO s : list) {
            %>
            <tr>
                <td><%= s.getStepId() %></td>
                <td><%= s.getRoutingId() %></td>
                <td><%= s.getStepName() %></td>
                <td><%= s.getEstimatedTime() %></td>
                <td style="font-weight: bold; color: <%= s.isIsInspected() ? "green" : "gray" %>;">
                    <%= s.isIsInspected() ? "Có" : "Không" %>
                </td>
                <td>
                    <a href="RoutingStepServlet?action=load_update&stepId=<%= s.getStepId() %>">Sửa</a> | 
                    <a href="RoutingStepServlet?action=delete&stepId=<%= s.getStepId() %>" onclick="return confirm('Xóa công đoạn này?');" style="color:red;">Xóa</a>
                </td>
            </tr>
            <% } } else { %>
            <tr><td colspan="6">Chưa có công đoạn nào</td></tr>
            <% } %>
        </table>
    </body>
</html>