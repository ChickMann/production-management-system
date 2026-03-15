<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Purchase Order Form</title>
    </head>
    <body>
        <h2>${mode == 'update' ? 'Update Purchase Order' : 'Add New Purchase Order'}</h2>
        <form action="MainController" method="post">
            <input type="hidden" name="action" value="${mode == 'update' ? 'saveUpdatePurchaseOrder' : 'saveAddPurchaseOrder'}"/> <br/>
            
            <c:if test="${mode == 'update'}">
                PO ID: <input type="text" name="id" value="${po.poId}" readonly /><br/>
            </c:if>
            
            Item ID: <input type="number" name="itemId" value="${po.itemId}" required/><br/>
            Supplier ID: <input type="number" name="supplierId" value="${po.supplierId}" required/><br/>
            Required Quantity: <input type="number" name="requiredQuantity" value="${po.requiredQuantity}" required/><br/>
            
            <!-- Use a modern date input format, standard format is yyyy-mm-dd -->
            Alert Date: <input type="date" name="alertDate" value="${po.alertDate}" required/><br/>
            
            Status: 
            <select name="status">
                <option value="Pending" ${po.status == 'Pending' ? 'selected' : ''}>Pending</option>
                <option value="Ordered" ${po.status == 'Ordered' ? 'selected' : ''}>Ordered</option>
                <option value="Completed" ${po.status == 'Completed' ? 'selected' : ''}>Completed</option>
            </select><br/>
            
            <input type="submit" value="${mode == 'update' ? 'Update' : 'Add'}"/><br/>
        </form>
        <p style="color: green">${msg}</p><br/>
        <p style="color: red">${error}</p>
        <a href="MainController?action=loginUser">Back to Dashboard</a>
        
    </body>
</html>
