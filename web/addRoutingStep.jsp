<%-- 
    Document   : SearchItem
    
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head><title>Thêm Công đoạn</title></head>
    <body>
        <h2>Thêm Công đoạn mới</h2>
        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="addRoutingStep">
            
            <p>ID Quy trình tổng (Routing ID): <br>
               <input type="number" name="routingId" required></p>
               
            <p>Tên công đoạn: <br>
               <input type="text" name="stepName" required></p>
               
            <p>Thời gian ước tính (phút): <br>
               <input type="number" name="estimatedTime" required></p>
               
            <p><label>
                <input type="checkbox" name="isInspected" value="true"> Cần kiểm tra chất lượng (QC)?
            </label></p>
            
            <button type="submit">Lưu Công đoạn</button>
            <a href="MainController?action=listRoutingStep">Hủy</a>
        </form>
    </body>
</html>
