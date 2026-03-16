<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Item Form</title>
    </head>
    <body>
        <h2>${mode == 'update' ? 'Update Item' : 'Add New Item'}</h2>
        <form action="MainController" method="post">
            <input type="hidden" name="action" value="${mode == 'update' ? 'saveUpdateItem' : 'saveAddItem'}"/> <br/>
            Item ID: <input type="text" name="id" value="${mode == 'update' ? item.itemID : index}" readonly /><br/>
            Name: <input type="text" name="name" value="${item.itemName}" required/><br/>
            Type: <input type="text" name="type" value="${item.itemType}" required/><br/>
            Stock quantity: <input type="number" step="0.01" min="0" name="stockQuantity" value="${item.stockQuantity}" required/><br/>
            <input type="submit" value="${mode == 'update' ? 'Update' : 'Add'}"/><br/>
        </form>
        <p style="color: green">${msg}</p><br/>
        <p style="color: red">${error}</p>
        <a href="MainController?action=loginUser">Back to Dashboard</a>
        
    </body>
</html>
