<%@page import="pms.model.BOMDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    BOMDTO bom = (BOMDTO) request.getAttribute("bomEdit");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update BOM</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
        <%@include file="/WEB-INF/jspf/admin-module-style.jspf" %>
    </head>
    <body>
        <div class="module-shell">
            <div class="module-container">
                <section class="module-hero">
                    <div>
                        <h1 class="module-title">Update BOM</h1>
                        <p class="module-subtitle">Review and update the BOM information below.</p>
                    </div>
                    <div class="module-actions">
                        <a class="app-btn app-btn-secondary" href="MainController?action=listBOM">← Back to BOM list</a>
                    </div>
                </section>

                <div class="module-grid single-layout">
                    <section class="module-grid-main module-panel module-card form-surface">
                        <div class="toolbar-row">
                            <div>
                                <h2 class="panel-title">Edit BOM information</h2>
                                <p class="panel-note">Update the product, material, or quantity, then save your changes.</p>
                            </div>
                        </div>

                        <% if (bom != null) { %>
                        <form action="MainController" method="POST">
                            <input type="hidden" name="action" value="saveUpdateBom">
                            <input type="hidden" name="bomId" value="<%= bom.getBomId() %>">

                            <div class="app-form-grid">
                                <div class="app-field-half">
                                    <label class="app-label" for="bomIdDisplay">BOM ID</label>
                                    <input class="app-input" id="bomIdDisplay" type="text" value="<%= bom.getBomId() %>" readonly>
                                </div>

                                <div class="app-field-half">
                                    <label class="app-label" for="productItemId">Product Item ID</label>
                                    <input class="app-input" id="productItemId" type="number" name="productItemId" value="<%= bom.getProductItemId() %>" required>
                                </div>

                                <div class="app-field-half">
                                    <label class="app-label" for="materialItemId">Material Item ID</label>
                                    <input class="app-input" id="materialItemId" type="number" name="materialItemId" value="<%= bom.getMaterialItemId() %>" required>
                                </div>

                                <div class="app-field-half">
                                    <label class="app-label" for="quantityRequired">Quantity Required</label>
                                    <input class="app-input" id="quantityRequired" type="number" name="quantityRequired" value="<%= bom.getQuantityRequired() %>" required>
                                </div>
                            </div>

                            <div class="toolbar-stack" style="margin-top: 24px;">
                                <button class="app-btn app-btn-primary" type="submit">Save update</button>
                                <a class="app-btn app-btn-danger" href="MainController?action=listBOM">Cancel</a>
                            </div>
                        </form>
                        <% } else { %>
                        <div class="message-error">Không tìm thấy BOM cần cập nhật.</div>
                        <a class="app-btn app-btn-secondary" href="MainController?action=listBOM">Return to BOM list</a>
                        <% } %>
                    </section>

                </div>
            </div>
        </div>
    </body>
</html>
