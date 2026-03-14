<%-- 
    Document   : bom-form
    Created on : Mar 14, 2026
    Author     : Antigravity
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>BOM Form</title>
    </head>
    <body>
        <h2>${mode == 'update' ? 'Update BOM' : 'Add New BOM'}</h2>
        <form action="MainController" method="post">
            <input type="hidden" name="action" value="${mode == 'update' ? 'saveUpdateBom' : 'saveAddBom'}"/> <br/>
            BOM ID: <input type="text" name="id" value="${mode == 'update' ? bom.bomID : index}" readonly /><br/>
            Parent Item ID: <input type="number" step="1" min="0" name="parentItemId" value="${bom.parentItemID}" required/><br/>
            Child Item ID: <input type="number" step="1" min="0" name="childItemId" value="${bom.childItemID}" required/><br/>
            Quantity: <input type="number" step="0.01" min="0"name="quantity" value="${bom.quantity}" required/><br/>
            <input type="submit" value="${mode == 'update' ? 'Update' : 'Add'}"/><br/>
        </form>
        <p style="color: green">${msg}</p><br/>
        <p style="color: red">${error}</p>
        <a href="MainController?action=loginUser">Back to Dashboard</a>
        
    </body>
</html>
