<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create BOM</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
        <%@include file="/WEB-INF/jspf/admin-module-style.jspf" %>
    </head>
    <body>
        <div class="module-shell">
            <div class="module-container">
                <section class="module-hero">
                    <div>
                        <h1 class="module-title">Create BOM</h1>
                        <p class="module-subtitle">Enter the information below to create a new BOM record.</p>
                    </div>
                    <div class="module-actions">
                        <a class="app-btn app-btn-secondary" href="MainController?action=listBOM">← Back to BOM list</a>
                    </div>
                </section>

                <div class="module-grid single-layout">
                    <section class="module-grid-main module-panel module-card form-surface">
                        <div class="toolbar-row">
                            <div>
                                <h2 class="panel-title">BOM information</h2>
                                <p class="panel-note">Fill in the product, material, and quantity before saving.</p>
                            </div>
                        </div>

                        <form action="MainController" method="POST">
                            <input type="hidden" name="action" value="addBom">

                            <div class="app-form-grid">
                                <div class="app-field-half">
                                    <label class="app-label" for="productItemId">Product Item ID</label>
                                    <input class="app-input" id="productItemId" type="number" name="productItemId" required>
                                </div>

                                <div class="app-field-half">
                                    <label class="app-label" for="materialItemId">Material Item ID</label>
                                    <input class="app-input" id="materialItemId" type="number" name="materialItemId" required>
                                </div>

                                <div class="app-field-half">
                                    <label class="app-label" for="quantityRequired">Quantity Required</label>
                                    <input class="app-input" id="quantityRequired" type="number" name="quantityRequired" required>
                                </div>
                            </div>

                            <div class="toolbar-stack" style="margin-top: 24px;">
                                <button class="app-btn app-btn-primary" type="submit">Create BOM</button>
                                <a class="app-btn app-btn-danger" href="MainController?action=listBOM">Cancel</a>
                            </div>
                        </form>
                    </section>
                </div>
            </div>
        </div>
    </body>
</html>
