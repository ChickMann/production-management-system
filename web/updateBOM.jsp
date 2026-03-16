<%-- 
    Document   : updateBOM
    Created on : Mar 14, 2026, 9:08:05 PM
    Author     : se193234_TranGiaBao
--%>


<%@page import="pms.model.BOMDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sửa BOM</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 50px; }
            .form-group { margin-bottom: 15px; }
            label { display: inline-block; width: 150px; font-weight: bold; }
            input[type="number"] { padding: 5px; width: 200px; }
            button { padding: 8px 15px; background-color: #ff9800; color: white; border: none; cursor: pointer; }
        </style>
    </head>
    <body>
        <h2>Cập nhật Công thức Sản phẩm</h2>
        
        <%
            // Hứng dữ liệu cũ từ Servlet gửi qua
            BOMDTO bom = (BOMDTO) request.getAttribute("bomEdit");
            if (bom != null) {
        %>
        
        <form action="BOMServlet" method="POST">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="bomId" value="<%= bom.getBomId() %>">
            
            <div class="form-group">
                <label>Mã BOM:</label>
                <input type="text" value="<%= bom.getBomId() %>" disabled> (Không được sửa mã)
            </div>
            
            <div class="form-group">
                <label>ID Sản phẩm:</label>
                <input type="number" name="productItemId" value="<%= bom.getProductItemId() %>" required>
            </div>
            
            <div class="form-group">
                <label>ID Vật tư:</label>
                <input type="number" name="materialItemId" value="<%= bom.getMaterialItemId() %>" required>
            </div>
            
            <div class="form-group">
                <label>Số lượng cần:</label>
                <input type="number" name="quantityRequired" value="<%= bom.getQuantityRequired() %>" required>
            </div>
            
            <button type="submit">Cập nhật vào Database</button>
            <a href="MainController?action=listBOM" style="margin-left: 10px; text-decoration: none; color: red;">Hủy</a>
        </form>
        
        <% } else { %>
            <h3 style="color:red;">Không tìm thấy BOM này!</h3>
            <a href="MainController?action=listBOM">Quay lại danh sách</a>
        <% } %>
    </body>
</html>
