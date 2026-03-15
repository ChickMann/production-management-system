<%-- 
    Document   : addBOM
    Created on : Mar 14, 2026, 9:02:29 PM
    Author     : se193234_TranGiaBao
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm mới BOM</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 50px; }
            .form-group { margin-bottom: 15px; }
            label { display: inline-block; width: 150px; font-weight: bold; }
            input[type="number"] { padding: 5px; width: 200px; }
            button { padding: 8px 15px; background-color: #008CBA; color: white; border: none; cursor: pointer; }
        </style>
    </head>
    <body>
        <h2>Thêm Công thức Sản phẩm mới</h2>
        
        <form action="BOMServlet" method="POST">
            <input type="hidden" name="action" value="add">
            
            <div class="form-group">
                <label>ID Sản phẩm:</label>
                <input type="number" name="productItemId" required>
            </div>
            
            <div class="form-group">
                <label>ID Vật tư:</label>
                <input type="number" name="materialItemId" required>
            </div>
            
            <div class="form-group">
                <label>Số lượng cần:</label>
                <input type="number" name="quantityRequired" required>
            </div>
            
            <button type="submit">Lưu vào Database</button>
            <a href="BOMServlet?action=list" style="margin-left: 10px; text-decoration: none; color: red;">Hủy</a>
        </form>
    </body>
</html>
