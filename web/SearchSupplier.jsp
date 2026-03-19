<%-- 
    Document   : SearchItem
    
--%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Supplier List</title>
    </head>
    <body>

        <form action="MainController" method="post">
            <input type="hidden" name="action" value="searchSupplier"/> <br/>
            <input type="submit" value="Reload Supplier List"/> <br/>
        </form>
        <c:choose>
            <c:when test="${empty supplierList}">
                <p>Empty Supplier List</p>
            </c:when>
            <c:otherwise>
                <table border="1">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Contact Phone</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${supplierList}" var="s">
                            <tr>
                                <td>${s.supplierId}</td>
                                <td>${s.supplierName}</td>
                                <td>${s.contactPhone}</td>
                                <td>
                                    <a href="MainController?action=updateSupplier&id=${s.supplierId}">Update</a> |
                                    <a href="MainController?action=removeSupplier&id=${s.supplierId}" onclick="return confirm('Are you sure?')">Remove</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
        <br/>
        <c:if test="${not empty msg}">
            <p style="color: blue;"><b>${msg}</b></p>
        </c:if>
        <a href="MainController?action=addSupplier">Add Supplier</a> <br/><br/>
        <a href="MainController?action=loginUser">Back to Dashboard</a>


    </body>
</html>
