<%-- 
    Document   : listDefectReason
    Created on : Mar 14, 2026, 9:20:19 PM
    Author     : se193234_TranGiaBao
--%>

<%@page import="java.util.List"%>
<%@page import="model.DefectReasonDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head><title>Quản lý Danh mục Lỗi</title></head>
    <body>
        <h2>Danh mục Nguyên nhân Lỗi</h2>
        
        <form action="DefectReasonServlet" method="POST" style="margin-bottom: 20px;">
            <input type="hidden" name="action" value="add">
            Tên nguyên nhân lỗi: <input type="text" name="reasonName" required>
            <button type="submit">+ Thêm Lỗi</button>
        </form>

        <table border="1" cellpadding="8" cellspacing="0" width="50%">
            <tr style="background-color: #f2f2f2;"><th>ID Lỗi</th><th>Tên Lỗi</th><th>Hành động</th></tr>
            <%
                List<DefectReasonDTO> list = (List<DefectReasonDTO>) request.getAttribute("listDefect");
                if (list != null && !list.isEmpty()) {
                    for (DefectReasonDTO d : list) {
            %>
            <tr>
                <td style="text-align:center;"><%= d.getDefectId() %></td>
                <td><%= d.getReasonName() %></td>
                <td style="text-align:center;">
                    <a href="DefectReasonServlet?action=load_update&defectId=<%= d.getDefectId() %>">Sửa</a> | 
                    <a href="DefectReasonServlet?action=delete&defectId=<%= d.getDefectId() %>" onclick="return confirm('Xóa lỗi này?');" style="color:red;">Xóa</a>
                </td>
            </tr>
            <% } } else { %>
            <tr><td colspan="3">Chưa có dữ liệu</td></tr>
            <% } %>
        </table>
    </body>
</html>
