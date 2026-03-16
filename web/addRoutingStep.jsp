<%-- 
    Document   : addRoutingStep
    Created on : Mar 14, 2026, 9:35:58 PM
    Author     : se193234_TranGiaBao
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head><title>Thêm Công đoạn</title></head>
    <body>
        <h2>Thêm Công đoạn mới</h2>
        <form action="RoutingStepServlet" method="POST">
            <input type="hidden" name="action" value="add">
            
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
