<%-- 
    Document   : listBOM
    Created on : Mar 14, 2026, 9:00:26 PM
    Author     : se193234_TranGiaBao
--%>

<%@page import="java.util.List"%>
<%@page import="model.BOMDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý Công thức (BOM)</title>
        <style>
            table {
                width: 80%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            table, th, td {
                border: 1px solid black;
            }
            th, td {
                padding: 10px;
                text-align: center;
            }
            th {
                background-color: #f2f2f2;
            }
            .btn {
                padding: 5px 10px;
                text-decoration: none;
                color: white;
                border-radius: 3px;
            }
            .btn-edit {
                background-color: #ff9800;
            }
            .btn-delete {
                background-color: #f44336;
            }
        </style>
    </head>
    <body>
        <h2>Danh sách Công thức Sản phẩm (BOM)</h2>
        <a href="addBOM.jsp" style="display: inline-block; padding: 10px 15px; background-color: #4CAF50; color: white; text-decoration: none; margin-bottom: 15px;">+ Thêm BOM mới</a>

        <table>
            <thead>
                <tr>
                    <th>Mã BOM</th>
                    <th>ID Sản phẩm</th>
                    <th>ID Vật tư</th>
                    <th>Số lượng</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<BOMDTO> list = (List<BOMDTO>) request.getAttribute("danhSachBOM");
                    if (list != null && !list.isEmpty()) {
                        for (BOMDTO bom : list) {
                %>
                <tr>
                    <td><%= bom.getBomId()%></td>
                    <td><%= bom.getProductItemId()%></td>
                    <td><%= bom.getMaterialItemId()%></td>
                    <td><%= bom.getQuantityRequired()%></td>
                    <td>
                        <a href="BOMServlet?action=load_update&bomId=<%= bom.getBomId()%>" class="btn btn-edit">Sửa</a>
                        &nbsp;
                        <a href="BOMServlet?action=delete&bomId=<%= bom.getBomId()%>" class="btn btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa công thức <%= bom.getBomId()%> này không?');">Xóa</a>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="5">Chưa có dữ liệu.</td>
                </tr>
                <% }%>
            </tbody>
        </table>
    </body>
</html>