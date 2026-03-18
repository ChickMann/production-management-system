<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Item Form</title>
        </head>

        <body>
            <h2>${mode == 'update' ? 'Update Item' : 'Add New Item'}</h2>
            <form action="MainController" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="${mode == 'update' ? 'saveUpdateItem' : 'saveAddItem'}" />
                <br />
                Item ID: <input type="text" name="id" value="${mode == 'update' ? item.itemID : index}"
                    readonly /><br />
                Name: <input type="text" name="name" value="${item.itemName}" required /><br />
                Type: <select name="type" required>
                    <option value="SanPham" ${item.itemType == 'SanPham' ? 'selected' : ''}>Sản phẩm</option>
                    <option value="VatTu" ${item.itemType == 'VatTu' ? 'selected' : ''}>Vật tư</option>
                </select><br />
                Stock quantity: <input type="number" step="1" min="0" name="stockQuantity" value="${item.stockQuantity}"
                    required /><br />
                Chọn ảnh: <input type="file" name="imageFile" accept="image/*" /><br />
                <c:if test="${not empty item.imageBase64}">
                    <p>Ảnh hiện tại:</p>
                    <img src="${item.imageBase64}" style="max-width:150px; max-height:150px; object-fit:contain;"
                        alt="Item Image" /><br />
                    <a href="${item.imageBase64}" download="item_${item.itemID}">📥 Tải ảnh về máy</a><br />
                </c:if>
                <input type="submit" value="${mode == 'update' ? 'Update' : 'Add'}" /><br />
            </form>
            <p style="color: green">${msg}</p><br />
            <p style="color: red">${error}</p>
            <a href="MainController?action=loginUser">Back to Dashboard</a>

        </body>

        </html>