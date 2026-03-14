<%-- 
    Document   : SearchItem
    Created on : Mar 14, 2026, 8:37:20 PM
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

        <form action="MainController" method="post">
            <input type="hidden" name="action" value="searchItem"/> <br/>
            name: <input type="text" name="keyword" value="${param.keyword}"/> <br/>
            <input type="submit" value="Search"/> <br/>
        </form>
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
                                <td>
                                    <a href="MainController?action=updateItem&id=${i.itemID}">Update</a> |
                                    <a href="MainController?action=removeItem&id=${i.itemID}" onclick="return confirm('Are you sure?')">Remove</a>
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
        <a href="MainController?action=addItem">Add Item</a> <br/><br/>
        <a href="MainController?action=loginUser">Back to Dashboard</a>


    </body>
</html>
