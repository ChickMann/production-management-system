<%@page import="pms.model.DefectReasonDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Danh mục Lỗi</title>
        <style>
            table { width: 50%; border-collapse: collapse; margin-top: 15px; }
            table, th, td { border: 1px solid black; } th, td { padding: 10px; text-align: center; } th { background-color: #ffebee; }
            .btn-back { display: inline-block; padding: 8px 15px; background-color: #607d8b; color: white; text-decoration: none; border-radius: 5px; margin-bottom: 15px; }
        </style>
    </head>
    <body>
        <h2>Danh mục Nguyên nhân Lỗi</h2>
        <a href="MainController?action=loginUser" class="btn-back">⬅️ Quay lại Menu</a>
        
        <form action="MainController" method="POST" style="margin-bottom: 20px;">
            <input type="hidden" name="action" value="addDefectReason">
            Tên nguyên nhân lỗi: <input type="text" name="reasonName" required>
            <button type="submit">+ Thêm Lỗi</button>
        </form>

        <table>
            <tr><th>ID Lỗi</th><th>Tên Lỗi</th><th>Hành động</th></tr>
            <%
                List<DefectReasonDTO> list = (List<DefectReasonDTO>) request.getAttribute("listDefect");
                if (list != null && !list.isEmpty()) {
                    for (DefectReasonDTO d : list) {
            %>
            <tr>
                <td><%= d.getDefectId() %></td><td><%= d.getReasonName() %></td>
                <td>
                    <a href="MainController?action=loadUpdateDefectReason&defectId=<%= d.getDefectId() %>">Sửa</a> | 
                    <a href="MainController?action=deleteDefectReason&defectId=<%= d.getDefectId() %>" onclick="return confirm('Xóa lỗi này?');" style="color:red;">Xóa</a>
                </td>
            </tr>
            <% } } else { out.print("<tr><td colspan='3'>Chưa có dữ liệu</td></tr>"); } %>
        </table>
    </body>
</html>
