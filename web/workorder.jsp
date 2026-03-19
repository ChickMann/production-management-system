<%@page import="pms.model.WorkOrderDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    WorkOrderDTO wo = (WorkOrderDTO) request.getAttribute("WORKORDER");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Work Order Management</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
        <%@include file="/WEB-INF/jspf/admin-module-style.jspf" %>
    </head>
    <body>
        <div class="module-shell">
            <div class="module-container">
                <section class="module-hero">
                    <div>
                        <h1 class="module-title">Work Order Management</h1>
                        <p class="module-subtitle">Search, create, update, and delete work orders in one clear screen.</p>
                    </div>
                    <div class="module-actions">
                        <a class="app-btn app-btn-secondary" href="index.jsp">← Dashboard</a>
                    </div>
                </section>

                <section class="module-panel module-card">
                    <div class="toolbar-row">
                        <div>
                            <h2 class="panel-title">Search Work Order</h2>
                            <p class="panel-note">Enter a work order ID to view its details.</p>
                        </div>
                    </div>

                    <form action="WorkOrderController" method="get">
                        <input type="hidden" name="action" value="search">
                        <div class="app-form-grid">
                            <div class="app-field-half">
                                <label class="app-label" for="searchWoId">Work Order ID</label>
                                <input class="app-input" id="searchWoId" type="text" name="wo_id" required>
                            </div>
                        </div>
                        <div class="toolbar-stack" style="margin-top: 20px;">
                            <button class="app-btn app-btn-primary" type="submit">Search</button>
                        </div>
                    </form>
                </section>

                <section class="module-panel module-card">
                    <div class="toolbar-row">
                        <div>
                            <h2 class="panel-title">Add Work Order</h2>
                            <p class="panel-note">Fill in the fields below to create a new work order.</p>
                        </div>
                    </div>

                    <form action="WorkOrderController" method="post">
                        <input type="hidden" name="action" value="insert">
                        <div class="app-form-grid">
                            <div class="app-field-half">
                                <label class="app-label" for="insertProductItemId">Product Item ID</label>
                                <input class="app-input" id="insertProductItemId" type="text" name="product_item_id" required>
                            </div>
                            <div class="app-field-half">
                                <label class="app-label" for="insertRoutingId">Routing ID</label>
                                <input class="app-input" id="insertRoutingId" type="text" name="routing_id" required>
                            </div>
                            <div class="app-field-half">
                                <label class="app-label" for="insertOrderQuantity">Quantity</label>
                                <input class="app-input" id="insertOrderQuantity" type="text" name="order_quantity" required>
                            </div>
                            <div class="app-field-half">
                                <label class="app-label" for="insertStatus">Status</label>
                                <input class="app-input" id="insertStatus" type="text" name="status" required>
                            </div>
                        </div>
                        <div class="toolbar-stack" style="margin-top: 20px;">
                            <button class="app-btn app-btn-primary" type="submit">Add Work Order</button>
                        </div>
                    </form>
                </section>

                <section class="module-panel module-card">
                    <div class="toolbar-row">
                        <div>
                            <h2 class="panel-title">Update Work Order</h2>
                            <p class="panel-note">Edit an existing work order by entering its full information.</p>
                        </div>
                    </div>

                    <form action="WorkOrderController" method="post">
                        <input type="hidden" name="action" value="update">
                        <div class="app-form-grid">
                            <div class="app-field-half">
                                <label class="app-label" for="updateWoId">Work Order ID</label>
                                <input class="app-input" id="updateWoId" type="text" name="wo_id" required>
                            </div>
                            <div class="app-field-half">
                                <label class="app-label" for="updateProductItemId">Product Item ID</label>
                                <input class="app-input" id="updateProductItemId" type="text" name="product_item_id" required>
                            </div>
                            <div class="app-field-half">
                                <label class="app-label" for="updateRoutingId">Routing ID</label>
                                <input class="app-input" id="updateRoutingId" type="text" name="routing_id" required>
                            </div>
                            <div class="app-field-half">
                                <label class="app-label" for="updateOrderQuantity">Quantity</label>
                                <input class="app-input" id="updateOrderQuantity" type="text" name="order_quantity" required>
                            </div>
                            <div class="app-field-half">
                                <label class="app-label" for="updateStatus">Status</label>
                                <input class="app-input" id="updateStatus" type="text" name="status" required>
                            </div>
                        </div>
                        <div class="toolbar-stack" style="margin-top: 20px;">
                            <button class="app-btn app-btn-primary" type="submit">Update Work Order</button>
                        </div>
                    </form>
                </section>

                <section class="module-panel module-card">
                    <div class="toolbar-row">
                        <div>
                            <h2 class="panel-title">Delete Work Order</h2>
                            <p class="panel-note">Enter the ID of the work order you want to remove.</p>
                        </div>
                    </div>

                    <form action="WorkOrderController" method="get">
                        <input type="hidden" name="action" value="delete">
                        <div class="app-form-grid">
                            <div class="app-field-half">
                                <label class="app-label" for="deleteWoId">Work Order ID</label>
                                <input class="app-input" id="deleteWoId" type="text" name="wo_id" required>
                            </div>
                        </div>
                        <div class="toolbar-stack" style="margin-top: 20px;">
                            <button class="app-btn app-btn-danger" type="submit">Delete Work Order</button>
                        </div>
                    </form>
                </section>

                <section class="module-panel module-card">
                    <div class="toolbar-row">
                        <div>
                            <h2 class="panel-title">Search Result</h2>
                            <p class="panel-note">The searched work order information is displayed here.</p>
                        </div>
                    </div>

                    <% if (wo != null) { %>
                    <div class="app-table-shell">
                        <table class="app-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Product Item</th>
                                    <th>Routing</th>
                                    <th>Quantity</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>#<%= wo.getWo_id()%></td>
                                    <td><%= wo.getProduct_item_id()%></td>
                                    <td><%= wo.getRouting_id()%></td>
                                    <td><%= wo.getOrder_quantity()%></td>
                                    <td><%= wo.getStatus()%></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="message-info">No work order has been searched yet.</div>
                    <% } %>
                </section>
            </div>
        </div>
    </body>
</html>
