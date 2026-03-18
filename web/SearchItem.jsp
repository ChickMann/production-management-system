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
                            <th>Name</th>
                            <th>Type</th>
                            <th>Stock quantity</th>
                            <th>Image</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${itemList}" var="i">
                            <tr>
                                <td>${i.itemID}</td>
                                <td>${i.itemName}</td>
                                <td>${i.itemType}</td>
                                <td>${i.stockQuantity}</td>
                                <td>
                                    <c:if test="${not empty i.imageBase64}">
                                        <img src="${i.imageBase64}" style="max-width:80px; max-height:80px; object-fit:contain;" alt="Ảnh" /><br/>
                                        <a href="${i.imageBase64}" download="item_${i.itemID}">📥 Tải ảnh</a>
                                    </c:if>
                                    <c:if test="${empty i.imageBase64}">
                                        Không có ảnh
                                    </c:if>
                                </td>
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
