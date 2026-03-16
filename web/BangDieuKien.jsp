<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý nhân viên</title>
    </head>
    <body>

        <c:if test="${not empty user}">
            <h1>Hello ${user.fullName} (${user.role})</h1><br/>

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
                                    <th>Full name</th>
                                    <th>Actions</th> 
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${eList}" var="e">
                                    <tr>
                                        <td>${e.id}</td>
                                        <td>${e.username}</td>
                                        <td>${e.password}</td>
                                        <td>${e.fullName}</td>
                                        <td>
                                            <a href="MainController?action=updateUser&id=${e.id}">Update</a> |
                                            <a href="MainController?action=removeUser&id=${e.id + 1}" onclick="return confirm('Are you sure?')">Remove</a>
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
            </c:if>
            <hr/>
            <h2>Item Management</h2>
            <a href="MainController?action=searchItem">Show List Item</a>

            <hr/>
            <h2>BOM Management</h2>
            <a href="MainController?action=listBOM">Show List BOM</a>

            <hr/>
            <h2>Routing Management</h2>
            <a href="MainController?action=listRouting">Show List Routing</a>

            <hr/>
            <h2>Routing Step Management</h2>
            <a href="MainController?action=listRoutingStep">Show List Routing Step</a>

            <hr/>
            <h2>Defect Reason Management</h2>
            <a href="MainController?action=listDefectReason">Show List Defect Reason</a>

            <hr/>
            <h2>Supplier Management</h2>
            <a href="MainController?action=searchSupplier">Show List Supplier</a>

            <hr/>
            <h2>Purchase Order Management</h2>
            <a href="MainController?action=searchPurchaseOrder">Show List Purchase Order</a>
            <br/>
            <a href="MainController?action=logoutUser">Logout</a>
        </c:if>

    </body>
</html>
