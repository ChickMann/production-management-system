<%-- 
    Document   : SearchBom
    Created on : Mar 14, 2026, 8:57:40 PM
    Author     : BAO
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <hr/>
        <h2>BOM Management</h2>
        <form action="MainController" method="post">
            <input type="hidden" name="action" value="searchBom"/> <br/>
            id: <input type="text" name="keyword" value="${param.keyword}"/> <br/>
            <input type="submit" value="Search"/> <br/>
        </form>
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
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${bomList}" var="b">
                            <tr>
                                <td>${b.bomID}</td>
                                <td>${b.parentItemID}</td>
                                <td>${b.childItemID}</td>
                                <td>${b.quantity}</td>
                                <td>
                                    <a href="MainController?action=updateBom&id=${b.bomID}">Update</a> |
                                    <a href="MainController?action=removeBom&id=${b.bomID}" onclick="return confirm('Are you sure?')">Remove</a>
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
        <a href="MainController?action=addBom">Add BOM</a> <br/><br/>
        <a href="MainController?action=loginUser">Back to Dashboard</a>


    </body>
</html>
