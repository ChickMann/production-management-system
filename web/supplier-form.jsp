<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Supplier Form</title>
    </head>
    <body>
        <h2>${mode == 'update' ? 'Update Supplier' : 'Add New Supplier'}</h2>
        <form action="MainController" method="post">
            <input type="hidden" name="action" value="${mode == 'update' ? 'saveUpdateSupplier' : 'saveAddSupplier'}"/> <br/>
            
            <c:if test="${mode == 'update' or mode == 'add'}">
                Supplier ID: <input type="text" name="id" value="${mode == 'update' ? supplier.supplierId : index}" readonly /><br/>
            </c:if>
            
            Supplier Name: <input type="text" name="supplierName" value="${supplier.supplierName}" required/><br/>
            Contact Phone: <input type="text" name="contactPhone" value="${supplier.contactPhone}" required/><br/>
            
            <input type="submit" value="${mode == 'update' ? 'Update' : 'Add'}"/><br/>
        </form>
        <p style="color: green">${msg}</p><br/>
        <p style="color: red">${error}</p>
        <a href="MainController?action=loginUser">Back to Dashboard</a>
        
    </body>
</html>
