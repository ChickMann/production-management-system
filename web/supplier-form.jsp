<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String mode = (String) request.getAttribute("mode");
    pms.model.SupplierDTO supplier = (pms.model.SupplierDTO) request.getAttribute("supplier");
    Integer index = (Integer) request.getAttribute("index");
    String msg = (String) request.getAttribute("msg");
    String error = (String) request.getAttribute("error");

    boolean isUpdate = "update".equals(mode);
    String pageTitle = isUpdate ? "Update Supplier" : "Add Supplier";
    String submitAction = isUpdate ? "saveUpdateSupplier" : "saveAddSupplier";
    String supplierIdValue = "";
    String supplierNameValue = "";
    String contactPhoneValue = "";

    if (supplier != null) {
        supplierIdValue = String.valueOf(supplier.getSupplierId());
        supplierNameValue = supplier.getSupplierName() != null ? supplier.getSupplierName() : "";
        contactPhoneValue = supplier.getContactPhone() != null ? supplier.getContactPhone() : "";
    } else if (!isUpdate && index != null) {
        supplierIdValue = String.valueOf(index);
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= pageTitle %></title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
        <%@include file="/WEB-INF/jspf/admin-module-style.jspf" %>
    </head>
    <body>
        <div class="module-shell">
            <div class="module-container">
                <section class="module-hero">
                    <div>
                        <h1 class="module-title"><%= pageTitle %></h1>
                        <p class="module-subtitle"><%= isUpdate ? "Review and update the supplier information below." : "Enter the information below to add a new supplier." %></p>
                    </div>
                    <div class="module-actions">
                        <a class="app-btn app-btn-secondary" href="MainController?action=searchSupplier">← Back to supplier list</a>
                    </div>
                </section>

                <div class="module-grid single-layout">
                    <section class="module-grid-main module-panel module-card form-surface">
                        <div class="toolbar-row">
                            <div>
                                <h2 class="panel-title">Supplier information</h2>
                                <p class="panel-note">Complete the supplier details and save when you are ready.</p>
                            </div>
                        </div>

                        <% if (msg != null && !msg.trim().isEmpty()) { %>
                            <div class="message-success"><%= msg %></div>
                        <% } %>
                        <% if (error != null && !error.trim().isEmpty()) { %>
                            <div class="message-error"><%= error %></div>
                        <% } %>

                        <form action="MainController" method="post">
                            <input type="hidden" name="action" value="<%= submitAction %>">

                            <div class="app-form-grid">
                                <div class="app-field-half">
                                    <label class="app-label" for="id">Supplier ID</label>
                                    <input class="app-input" id="id" type="text" name="id" value="<%= supplierIdValue %>" readonly>
                                </div>

                                <div class="app-field-half">
                                    <label class="app-label" for="supplierName">Supplier Name</label>
                                    <input class="app-input" id="supplierName" type="text" name="supplierName" value="<%= supplierNameValue %>" required>
                                </div>

                                <div class="app-field-half">
                                    <label class="app-label" for="contactPhone">Contact Phone</label>
                                    <input class="app-input" id="contactPhone" type="text" name="contactPhone" value="<%= contactPhoneValue %>" required>
                                </div>
                            </div>

                            <div class="toolbar-stack" style="margin-top: 24px;">
                                <button class="app-btn app-btn-primary" type="submit"><%= isUpdate ? "Save update" : "Create supplier" %></button>
                                <a class="app-btn app-btn-danger" href="MainController?action=searchSupplier">Cancel</a>
                            </div>
                        </form>
                    </section>

                </div>
            </div>
        </div>
    </body>
</html>
