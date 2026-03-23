<%@page import="pms.model.RoutingDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    RoutingDTO r = (RoutingDTO) request.getAttribute("routingEdit");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Routing</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
        <%@include file="/WEB-INF/jspf/admin-module-style.jspf" %>
    </head>
    <body>
        <div class="module-shell">
            <div class="module-container">
                <section class="module-hero">
                    <div>
                        <h1 class="module-title">Update Routing</h1>
                        <p class="module-subtitle">Review and update the routing information below.</p>
                    </div>
                    <div class="module-actions">
                        <a class="app-btn app-btn-secondary" href="MainController?action=listRouting">← Back to routing list</a>
                    </div>
                </section>

                <div class="module-grid single-layout">
                    <section class="module-grid-main module-panel module-card form-surface">
                        <div class="toolbar-row">
                            <div>
                                <h2 class="panel-title">Edit routing</h2>
                                <p class="panel-note">Update the routing name and save your changes.</p>
                            </div>
                        </div>

                        <% if (r != null) { %>
                        <form action="MainController" method="POST">
                            <input type="hidden" name="action" value="saveUpdateRouting">
                            <input type="hidden" name="routingId" value="<%= r.getRoutingId() %>">

                            <div class="app-form-grid">
                                <div class="app-field-half">
                                    <label class="app-label" for="routingIdDisplay">Routing ID</label>
                                    <input class="app-input" id="routingIdDisplay" type="text" value="<%= r.getRoutingId() %>" readonly>
                                </div>

                                <div class="app-field-half">
                                    <label class="app-label" for="routingName">Routing Name</label>
                                    <input class="app-input" id="routingName" type="text" name="routingName" value="<%= r.getRoutingName() %>" required>
                                </div>
                            </div>

                            <div class="toolbar-stack" style="margin-top: 24px;">
                                <button class="app-btn app-btn-primary" type="submit">Save update</button>
                                <a class="app-btn app-btn-danger" href="MainController?action=listRouting">Cancel</a>
                            </div>
                        </form>
                        <% } else { %>
                        <div class="message-error">Không tìm thấy routing cần cập nhật.</div>
                        <a class="app-btn app-btn-secondary" href="MainController?action=listRouting">Return to routing list</a>
                        <% } %>
                    </section>

                </div>
            </div>
        </div>
    </body>
</html>
