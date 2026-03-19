<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hệ Thống Quản Lý Sản Xuất (PMS)</title>
        <style>
            body { font-family: Arial, sans-serif; background-color: #f4f7f6; text-align: center; padding-top: 50px; }
            h1 { color: #333; margin-bottom: 40px; }
            .menu-container { display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; max-width: 800px; margin: 0 auto; }
            .menu-btn {
                display: block; width: 300px; padding: 20px; background-color: #ffffff; color: #333;
                text-decoration: none; font-size: 18px; font-weight: bold; border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1); transition: transform 0.2s, background-color 0.2s;
            }
            .btn-bom { border-left: 6px solid #2196F3; }
            .btn-defect { border-left: 6px solid #f44336; }
            .btn-routing { border-left: 6px solid #ff9800; }
            .btn-step { border-left: 6px solid #9c27b0; }
            .menu-btn:hover { transform: translateY(-5px); background-color: #f0f0f0; }
            .menu-btn span { display: block; font-size: 14px; color: #666; font-weight: normal; margin-top: 5px; }
        </style>
    </head>
    <body>
        <h1>🛠️ BẢNG ĐIỀU KHIỂN - MODULE SẢN XUẤT</h1>
        <div class="menu-container">
            <a href="MainController?action=listBOM" class="menu-btn btn-bom">📦 Quản lý BOM<span>(Công thức sản phẩm)</span></a>
            <a href="MainController?action=listDefectReason" class="menu-btn btn-defect">⚠️ Danh mục Lỗi<span>(Các loại lỗi hư hỏng)</span></a>
            <a href="MainController?action=listRouting" class="menu-btn btn-routing">📋 Quy trình tổng<span>(Tên các quy trình lớn)</span></a>
            <a href="MainController?action=listRoutingStep" class="menu-btn btn-step">⚙️ Chi tiết Công đoạn<span>(Các bước trong quy trình)</span></a>
        </div>
    </body>
</html>