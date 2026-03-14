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
            
            <%-- Admin: Manage Users --%>
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
                <br/>
                <a href="MainController?action=addUser">Add employee</a> <br/><br/>
            </c:if>

            <%-- Employee (and Admin): Manage Items and BOMs --%>
            <c:if test="${user.role eq 'employee' or user.role eq 'admin'}">
                <hr/>
                <h2>Item Management</h2>
                <c:choose>
                    <c:when test="${empty itemList}">
                        <p>Empty Item List</p>
                    </c:when>
                    <c:otherwise>
                        <table border="1">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Type</th>
                                    <th>Cost</th>
                                    <c:if test="${user.role eq 'employee'}"><th>Actions</th></c:if>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${itemList}" var="i">
                                    <tr>
                                        <td>${i.itemID}</td>
                                        <td>${i.itemCode}</td>
                                        <td>${i.name}</td>
                                        <td>${i.type}</td>
                                        <td>${i.standardCost}</td>
                                        <c:if test="${user.role eq 'employee'}">
                                            <td>
                                                <a href="MainController?action=updateItem&id=${i.itemID}">Update</a> |
                                                <a href="MainController?action=removeItem&id=${i.itemID}" onclick="return confirm('Are you sure?')">Remove</a>
                                            </td>
                                        </c:if>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
                <c:if test="${user.role eq 'employee'}">
                    <br/>
                    <a href="MainController?action=addItem">Add Item</a> <br/><br/>
                </c:if>

                <hr/>
                <h2>BOM Management</h2>
                <c:choose>
                    <c:when test="${empty bomList}">
                        <p>Empty BOM List</p>
                    </c:when>
                    <c:otherwise>
                        <table border="1">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Parent Item ID</th>
                                    <th>Child Item ID</th>
                                    <th>Quantity</th>
                                    <c:if test="${user.role eq 'employee'}"><th>Actions</th></c:if>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${bomList}" var="b">
                                    <tr>
                                        <td>${b.bomID}</td>
                                        <td>${b.parentItemID}</td>
                                        <td>${b.childItemID}</td>
                                        <td>${b.quantity}</td>
                                        <c:if test="${user.role eq 'employee'}">
                                            <td>
                                                <a href="MainController?action=updateBom&id=${b.bomID}">Update</a> |
                                                <a href="MainController?action=removeBom&id=${b.bomID}" onclick="return confirm('Are you sure?')">Remove</a>
                                            </td>
                                        </c:if>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
                <c:if test="${user.role eq 'employee'}">
                    <br/>
                    <a href="MainController?action=addBom">Add BOM</a> <br/><br/>
                </c:if>
            </c:if>

            <c:if test="${not empty msg}">
                <p style="color: blue;"><b>${msg}</b></p>
            </c:if>

            <br/>
            <a href="MainController?action=logoutUser">Logout</a>
        </c:if>
            
    </body>
</html>