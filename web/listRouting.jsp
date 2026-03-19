<%@page import="pms.model.RoutingDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Demo data - will be replaced by real data from DB
    List<RoutingDTO> list = (List<RoutingDTO>) request.getAttribute("listRouting");
    
    // If no data from DB, use demo data
    if (list == null || list.isEmpty()) {
        list = new java.util.ArrayList<>();
        list.add(new RoutingDTO(1, "Laptop Assembly Line"));
        list.add(new RoutingDTO(2, "Phone Production Line"));
        list.add(new RoutingDTO(3, "Tablet Manufacturing"));
        list.add(new RoutingDTO(4, "Quality Control"));
    }
    
    int totalRecords = list.size();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Routing Management</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
        <%@include file="/WEB-INF/jspf/admin-module-style.jspf" %>
    </head>
    <body>
        <div class="module-shell">
            <div class="module-container">
                <section class="module-hero">
                    <div>
                        <h1 class="module-title">Routing Management</h1>
                        <p class="module-subtitle">Create, view, edit, and delete routing records in one clear screen.</p>
                    </div>
                    <div class="module-actions">
                        <a class="app-btn app-btn-secondary" href="index.jsp">← Dashboard</a>
                    </div>
                </section>

                <section class="module-panel module-card">
                    <div class="toolbar-row">
                        <div>
                            <h2 class="panel-title">Add New Routing</h2>
                            <p class="panel-note">Create a routing by entering its name below.</p>
                        </div>
                        <span class="badge-soft"><%= totalRecords %> records</span>
                    </div>

                    <form action="MainController" method="POST">
                        <input type="hidden" name="action" value="addRouting">
                        <div class="app-form-grid">
                            <div class="app-field">
                                <label class="app-label" for="routingName">Routing Name</label>
                                <input class="app-input" id="routingName" type="text" name="routingName" required>
                            </div>
                        </div>
                        <div class="toolbar-stack" style="margin-top: 20px;">
                            <button class="app-btn app-btn-primary" type="submit">Add Routing</button>
                            <a class="app-btn app-btn-secondary" href="MainController?action=listRouting">Refresh</a>
                        </div>
                    </form>
                </section>

                <section class="module-panel module-card">
                    <div class="toolbar-row">
                        <div>
                            <h2 class="panel-title">Routing List</h2>
                            <p class="panel-note">All existing routes are shown here.</p>
                        </div>
                    </div>

                    <div class="app-table-shell">
                        <table class="app-table">
                            <thead>
                                <tr>
                                    <th>Routing ID</th>
                                    <th>Routing Name</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (list != null && !list.isEmpty()) {
                                        for (RoutingDTO r : list) {
                                %>
                                <tr>
                                    <td>#<%= r.getRoutingId() %></td>
                                    <td><%= r.getRoutingName() %></td>
                                    <td>
                                        <div class="table-actions">
                                            <a class="app-btn app-btn-secondary" href="MainController?action=loadUpdateRouting&routingId=<%= r.getRoutingId() %>">Edit</a>
                                            <a class="app-btn app-btn-danger" href="MainController?action=deleteRouting&routingId=<%= r.getRoutingId() %>" onclick="return confirm('Delete this routing?');">Delete</a>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="3" class="app-empty">No routing records found.</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </section>
            </div>
        </div>
    </body>
</html>
