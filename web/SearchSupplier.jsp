<%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.ArrayList,pms.model.SupplierDTO"%>
<%
    // Demo data - will be replaced by real data from DB
    ArrayList<SupplierDTO> supplierList = (ArrayList<SupplierDTO>) request.getAttribute("supplierList");
    
    // If no data from DB, use demo data
    if (supplierList == null || supplierList.isEmpty()) {
        supplierList = new ArrayList<>();
        supplierList.add(new SupplierDTO(1, "TechParts Inc.", "+1 555-0101"));
        supplierList.add(new SupplierDTO(2, "Global Chips Ltd.", "+1 555-0102"));
        supplierList.add(new SupplierDTO(3, "MetalWorks Co.", "+1 555-0103"));
        supplierList.add(new SupplierDTO(4, "PlasticTech", "+1 555-0104"));
        supplierList.add(new SupplierDTO(5, "CircuitPro", "+1 555-0105"));
    }
    
    String msg = (String) request.getAttribute("msg");
    String totalSuppliers = supplierList != null ? String.valueOf(supplierList.size()) : "0";
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Supplier Management</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
        <%@include file="/WEB-INF/jspf/admin-module-style.jspf" %>
    </head>
    <body>
        <div class="module-shell">
            <div class="module-container">
                <section class="module-hero">
                    <div>
                        <h1 class="module-title">Supplier Management</h1>
                        <p class="module-subtitle">View, add, edit, and delete supplier records in one clear screen.</p>
                    </div>
                    <div class="module-actions">
                        <a class="app-btn app-btn-secondary" href="index.jsp">← Dashboard</a>
                        <a class="app-btn app-btn-primary" href="MainController?action=addSupplier">＋ Add Supplier</a>
                    </div>
                </section>

                <section class="module-panel module-card">
                    <div class="toolbar-row">
                        <div>
                            <h2 class="panel-title">Supplier List</h2>
                            <p class="panel-note">All suppliers are shown here.</p>
                        </div>
                        <div class="toolbar-stack">
                            <span class="badge-soft"><%= totalSuppliers %> records</span>
                            <form action="MainController" method="post">
                                <input type="hidden" name="action" value="searchSupplier"/>
                                <button class="app-btn app-btn-secondary" type="submit">Refresh</button>
                            </form>
                        </div>
                    </div>

                    <% if (msg != null && !msg.trim().isEmpty()) { %>
                        <div class="message-info"><%= msg %></div>
                    <% } %>

                    <div class="app-table-shell">
                        <table class="app-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Contact Phone</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (supplierList != null && !supplierList.isEmpty()) {
                                        for (SupplierDTO s : supplierList) {
                                %>
                                <tr>
                                    <td>#<%= s.getSupplierId() %></td>
                                    <td><%= s.getSupplierName() %></td>
                                    <td><%= s.getContactPhone() %></td>
                                    <td>
                                        <div class="table-actions">
                                            <a class="app-btn app-btn-secondary" href="MainController?action=updateSupplier&id=<%= s.getSupplierId() %>">Edit</a>
                                            <a class="app-btn app-btn-danger" href="MainController?action=removeSupplier&id=<%= s.getSupplierId() %>" onclick="return confirm('Delete this supplier?')">Delete</a>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="4" class="app-empty">No suppliers found.</td>
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
