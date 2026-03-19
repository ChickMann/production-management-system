<%-- 
    Document   : SearchItem
    
--%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Purchase Order List</title>
    </head>
    <body>

        <form action="MainController" method="post">
            <input type="hidden" name="action" value="searchPurchaseOrder"/> <br/>
            <input type="submit" value="Reload Purchase Orders"/> <br/>
        </form>
        
        <h3>Purchase Order Alerts</h3>
        <ul>
            <c:forEach items="${poList}" var="po">
                <c:if test="${po.status == 'Pending'}">
                    <li style="color:red">Alert: Purchase Order #${po.poId} is pending for Item #${po.itemId} from Supplier #${po.supplierId}. Required Date: ${po.alertDate}</li>
                </c:if>
            </c:forEach>
        </ul>
        <hr/>
        
        <c:choose>
            <c:when test="${empty poList}">
                <p>Empty Purchase Order List</p>
            </c:when>
            <c:otherwise>
                <table border="1">
                    <thead>
                        <tr>
                            <th>PO ID</th>
                            <th>Item ID</th>
                            <th>Supplier ID</th>
                            <th>Required Quantity</th>
                            <th>Alert Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${poList}" var="po">
                            <tr>
                                <td>${po.poId}</td>
                                <td>${po.itemId}</td>
                                <td>${po.supplierId}</td>
                                <td>${po.requiredQuantity}</td>
                                <td>${po.alertDate}</td>
                                <td style="${po.status == 'Pending' ? 'color: red;' : 'color: green;'}">${po.status}</td>
                                <td>
                                    <a href="MainController?action=updatePurchaseOrder&id=${po.poId}">Update</a> |
                                    <a href="MainController?action=removePurchaseOrder&id=${po.poId}" onclick="return confirm('Are you sure?')">Remove</a>
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
        <a href="MainController?action=addPurchaseOrder">Add Purchase Order</a> <br/><br/>
        <a href="MainController?action=loginUser">Back to Dashboard</a>
    </body>
</html>
