<%-- 
    Document   : workorder
    Created on : Mar 16, 2026, 4:34:33 PM
    Author     : HP
--%>

<%@page import="pms.model.WorkOrderDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Work Order Management</title>
    </head>
    <body>

        <h2>WORK ORDER MANAGEMENT</h2>

        <!-- SEARCH -->
        <h3>Search Work Order</h3>
        <form action="WorkOrderController" method="get">
            <input type="hidden" name="action" value="search">
            Work Order ID:
            <input type="text" name="wo_id" required>
            <button type="submit">Search</button>
        </form>
        <hr>
        
        <!-- INSERT -->
        <h3>Add Work Order</h3>
        <form action="WorkOrderController" method="post">
            <input type="hidden" name="action" value="insert">
            Product Item ID:
            <input type="text" name="product_item_id" required>
            <br><br>
            Routing ID:
            <input type="text" name="routing_id" required>
            <br><br>
            Quantity:
            <input type="text" name="order_quantity" required>
            <br><br>
            Status:
            <input type="text" name="status" required>
            <br><br>
            <button type="submit">Insert</button>
        </form>
        <hr>

        <!-- UPDATE -->
        <h3>Update Work Order</h3>
        <form action="WorkOrderController" method="post">
            <input type="hidden" name="action" value="update">
            Work Order ID:
            <input type="text" name="wo_id" required>
            <br><br>
            Product Item ID:
            <input type="text" name="product_item_id" required>
            <br><br>
            Routing ID:
            <input type="text" name="routing_id" required>
            <br><br>
            Quantity:
            <input type="text" name="order_quantity" required>
            <br><br>
            Status:
            <input type="text" name="status" required>
            <br><br>
            <button type="submit">Update</button>
        </form>
        <hr>

        <!-- DELETE -->
        <h3>Delete Work Order</h3>
        <form action="WorkOrderController" method="get">
            <input type="hidden" name="action" value="delete">
            Work Order ID:
            <input type="text" name="wo_id" required>
            <button type="submit">Delete</button>
        </form>
        <hr>

        <!-- SEARCH RESULT -->
        <%
            WorkOrderDTO wo = (WorkOrderDTO) request.getAttribute("WORKORDER");

            if (wo != null) {
        %>
        <h3>Search Result</h3>
        <table border="1">
            <tr>
                <th>ID</th>
                <th>Product Item</th>
                <th>Routing</th>
                <th>Quantity</th>
                <th>Status</th>
            </tr>
            <tr>
                <td><%= wo.getWo_id()%></td>
                <td><%= wo.getProduct_item_id()%></td>
                <td><%= wo.getRouting_id()%></td>
                <td><%= wo.getOrder_quantity()%></td>
                <td><%= wo.getStatus()%></td>
            </tr>
        </table>
        <%
            }
        %>
    </body>
</html>
