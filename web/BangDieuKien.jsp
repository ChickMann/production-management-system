<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý nhân viên</title>
        <style>
            body { font-family: Arial, sans-serif; background-color: #f4f7f6; text-align: center; padding-top: 50px; }
            h1 { color: #333; margin-bottom: 40px; }
             h2 { color: #333; margin-bottom: 20px; }
            .menu-container { display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; max-width: 800px; margin: 0 auto; }
            .menu-btn {
                display: block; width: 300px; padding: 20px; background-color: #ffffff; color: #333;
                text-decoration: none; font-size: 18px; font-weight: bold; border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1); transition: transform 0.2s, background-color 0.2s;
            }
            .btn-bom { border-left: 6px solid #2196F3; }
            .btn-defect { border-left: 6px solid #f44336; }
            .btn-routing { border-left: 6px solid #ff9800; }
            .btn-step { border-left: 6px solid #9c27b0; }
            .btn-other { border-left: 6px solid #4CAF50;}
            .menu-btn:hover { transform: translateY(-5px); background-color: #f0f0f0; }
            .menu-btn span { display: block; font-size: 14px; color: #666; font-weight: normal; margin-top: 5px; }
            .logout-container{ margin-top: 40px; }
            .admin-tools { margin-bottom: 30px; text-align: left; padding: 20px; background-color: #fff; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); max-width: 800px; margin-left: auto; margin-right: auto;}
            .admin-tools table{ width: 100%; border-collapse: collapse; margin-top: 10px;}
            .admin-tools table th, .admin-tools table td { border: 1px solid #ddd; padding: 8px; text-align: left; }
            .admin-tools table tr:nth-child(even){background-color: #f2f2f2;}
        </style>
    </head>
    <body>

        <c:if test="${not empty user}">
            <h1>Hello ${user.username} (${user.role})</h1><br/>

            <c:if test="${user.role eq 'admin'}">
                <h2>User Management</h2>
                <c:choose>
                    <c:when test="${empty eList}"> 
                        <p>Empty Employee List</p>
                    </c:when>
                    <c:otherwise>
                        <table border="1">
                            <thead>
                                <tr>
                                    <th>Id</th>
                                    <th>Username</th>
                                    <th>Password</th>
                                    <th>Actions</th> 
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${eList}" var="e">
                                    <tr>
                                        <td>${e.id}</td>
                                        <td>${e.username}</td>
                                        <td>${e.password}</td>
                                        <td>
                                            <a href="MainController?action=updateUser&id=${e.id}">Update</a> |
                                            <a href="MainController?action=removeUser&id=${e.id}" onclick="return confirm('Are you sure?')">Remove</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
                <c:if test="${not empty msg}">
                    <p style="color: blue;"><b>${msg}</b></p>
                        </c:if>
                <br/>
                <a href="MainController?action=addUser">Add employee</a> <br/><br/>
                </div>
            </c:if>
            <hr/>
            <div class="menu-container">
                <a href="MainController?action=searchItem" class="menu-btn btn-other">📦 Quản lý Item<span>(Danh sách Item)</span></a>
                <a href="MainController?action=listBOM" class="menu-btn btn-bom">📦 Quản lý BOM<span>(Công thức sản phẩm)</span></a>
                <a href="MainController?action=listRouting" class="menu-btn btn-routing">📋 Quy trình tổng<span>(Tên các quy trình lớn)</span></a>
                <a href="MainController?action=listRoutingStep" class="menu-btn btn-step">⚙️ Chi tiết Công đoạn<span>(Các bước trong quy trình)</span></a>
                <a href="MainController?action=listDefectReason" class="menu-btn btn-defect">⚠️ Danh mục Lỗi<span>(Các loại lỗi hư hỏng)</span></a>
                <a href="MainController?action=searchSupplier" class="menu-btn btn-other">🏢 Tùy chọn Nhà cung cấp<span>(Danh sách Nhà cung cấp)</span></a>
                <a href="MainController?action=searchPurchaseOrder" class="menu-btn btn-other">📄 Tùy chọn Hóa đơn<span>(Quản lý Order mua hàng)</span></a>
                <a href="MainController?action=listBill" class="menu-btn btn-routing">💵 Quản lý Bill<span>(Hóa đơn thanh toán)</span></a>
                <a href="MainController?action=searchCustomer" class="menu-btn btn-step">👥 Quản lý Customer<span>(Khách hàng)</span></a>
                <a href="MainController?action=listProduction" class="menu-btn btn-bom">🏭 Quản lý Production<span>(Nhật ký sản xuất)</span></a>
                <a href="MainController?action=listWorkOrder" class="menu-btn btn-defect">📝 Quản lý WorkOrder<span>(Lệnh sản xuất)</span></a>
            </div>
            
            <div class="logout-container">
                <a href="MainController?action=logoutUser" style="color: red;text-decoration:none;font-weight:bold;font-size: 18px">Logout</a>
            </div>
        </c:if>

    </body>
</html>
