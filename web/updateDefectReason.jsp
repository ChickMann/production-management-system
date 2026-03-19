<%-- 
    Document   : updateDefectReason
    
--%>

<%@page import="pms.model.DefectDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head><title>Sửa Lỗi</title></head>
    <body>
        <h2>Cập nhật Danh mục Lỗi</h2>
        <% DefectDTO d = (DefectDTO) request.getAttribute("defectEdit"); if (d != null) { %>
        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="saveUpdateDefectReason">
            <input type="hidden" name="defectId" value="<%= d.getDefectId() %>">
            
            Tên nguyên nhân lỗi: <input type="text" name="reasonName" value="<%= d.getReasonName() %>" required>
            <button type="submit">Lưu Cập Nhật</button>
            <a href="MainController?action=listDefectReason">Hủy</a>
        </form>
        <% } else { out.print("Lỗi không tồn tại!"); } %>
    </body>
</html>
