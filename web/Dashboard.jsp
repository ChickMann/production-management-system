<%@page import="pms.model.BillDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // Lấy dữ liệu doanh thu động từ DB ném sang JavaScript
    BillDAO bDao = new BillDAO();
    ArrayList<Double> revenueList = bDao.getMonthlyRevenue();
    request.setAttribute("rev", revenueList);
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hệ thống Quản lý Sản xuất - PMS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f4f7fa;
            }
            .sidebar {
                height: 100vh;
                width: 250px;
                position: fixed;
                top: 0;
                left: 0;
                background-color: #2c3e50;
                color: white;
                padding-top: 15px;
                overflow-y: auto;
            }
            .sidebar-brand {
                text-align: center;
                font-size: 1.5rem;
                font-weight: bold;
                margin-bottom: 30px;
                border-bottom: 1px solid #34495e;
                padding-bottom: 15px;
            }
            .sidebar-brand i { color: #3498db; }
            .sidebar-menu a {
                display: block;
                color: #b8c7ce;
                padding: 12px 20px;
                text-decoration: none;
                transition: 0.3s;
            }
            .sidebar-menu a:hover, .sidebar-menu a.active {
                background-color: #34495e;
                color: #fff;
                border-left: 4px solid #3498db;
            }
            .sidebar-menu i { width: 25px; }
            .header {
                margin-left: 250px;
                background-color: #fff;
                padding: 15px 30px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .search-bar input {
                border-radius: 20px;
                padding-left: 15px;
                border: 1px solid #ddd;
            }
            .main-content {
                margin-left: 250px;
                padding: 30px;
            }
        </style>
    </head>
    <body>

        <div class="sidebar">
            <div class="sidebar-brand">
                <i class="fa-solid fa-industry"></i> PMS Admin<br>
                <span style="font-size: 12px; font-weight: normal; color: #2ecc71;">Role: ${user.role}</span>
            </div>

            <div class="sidebar-menu">
                <p style="padding-left: 20px; font-size: 12px; color: #7f8c8d; text-transform: uppercase;">Quản lý chung</p>
                <a href="MainController?action=loginUser" class="active"><i class="fa-solid fa-chart-line"></i> Dashboard</a>

                <c:if test="${user.role eq 'Sep' or user.role eq 'admin'}">
                    <p style="padding-left: 20px; font-size: 12px; color: #7f8c8d; text-transform: uppercase; margin-top: 15px;">Module Kho & Lỗi</p>
                    <a href="MainController?action=searchItem"><i class="fa-solid fa-boxes-stacked"></i> Quản lý Item</a>
                    <a href="MainController?action=listDefectReason"><i class="fa-solid fa-triangle-exclamation"></i> Danh mục Lỗi</a>
                    <a href="MainController?action=searchSupplier"><i class="fa-solid fa-truck"></i> Nhà cung cấp</a>

                    <p style="padding-left: 20px; font-size: 12px; color: #7f8c8d; text-transform: uppercase; margin-top: 15px;">Module Sản Xuất</p>
                    <a href="MainController?action=listBOM"><i class="fa-solid fa-clipboard-list"></i> Công thức BOM</a>
                    <a href="MainController?action=listRouting"><i class="fa-solid fa-route"></i> Quy trình (Routing)</a>
                    <a href="MainController?action=listRoutingStep"><i class="fa-solid fa-list-check"></i> Chi tiết Công đoạn</a>
                    <a href="MainController?action=listWorkOrder"><i class="fa-solid fa-file-contract"></i> Lệnh Sản xuất (WO)</a>
                </c:if>

                <a href="MainController?action=listLog" class="nav-link">
                    <i class="fa-solid fa-hard-hat"></i> Nhật ký xưởng
                </a>   

                <c:if test="${user.role eq 'Sep' or user.role eq 'admin'}">
                    <p style="padding-left: 20px; font-size: 12px; color: #7f8c8d; text-transform: uppercase; margin-top: 15px;">Khách Hàng & Đơn Từ</p>
                    <a href="MainController?action=searchCustomer"><i class="fa-solid fa-users"></i> Khách hàng</a>
                    <a href="MainController?action=listBill"><i class="fa-solid fa-file-invoice-dollar"></i> Hóa đơn (Bill)</a>
                    <a href="MainController?action=searchPurchaseOrder"><i class="fa-solid fa-cart-shopping"></i> Đề nghị vật tư (PO)</a>
                </c:if>
            </div>
        </div>

        <div class="header">
            <div class="d-flex align-items-center">
                <i class="fa-solid fa-bars fs-4 me-3" style="cursor: pointer;"></i>
                <div class="search-bar d-flex align-items-center position-relative">
                    <i class="fa-solid fa-search position-absolute ms-3 text-muted"></i>
                    <input type="text" class="form-control ps-5" placeholder="Search...">
                </div>
            </div>
            <div class="header-icons d-flex align-items-center gap-4 text-muted">
                <i class="fa-solid fa-expand fs-5"></i>
                <i class="fa-solid fa-bell fs-5 position-relative">
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.5rem;">5</span>
                </i>
                <div class="d-flex align-items-center gap-2">
                    <img src="https://ui-avatars.com/api/?name=${user.username}&background=random" class="rounded-circle" width="35" height="35" alt="User">
                    <span class="fw-bold">${user.username}</span>
                    <a href="MainController?action=logoutUser" class="text-danger ms-2" title="Đăng xuất"><i class="fa-solid fa-right-from-bracket"></i></a>
                </div>
            </div>
        </div>

        <div class="main-content">
            <h2>Chào mừng trở lại, ${user.username}!</h2>
            <p class="text-muted">
                <c:choose>
                    <c:when test="${user.role eq 'CongNhan'}">Chúc bạn một ngày làm việc an toàn và hiệu quả.</c:when>
                    <c:otherwise>Hệ thống quản lý sản xuất đang hoạt động tốt.</c:otherwise>
                </c:choose>
            </p>

            <c:if test="${user.role eq 'Sep' or user.role eq 'admin'}">
                <div class="row mt-4">
                    <div class="col-md-3">
                        <div class="card bg-primary text-white p-3 shadow-sm rounded">
                            <h5>Đơn hàng mới</h5>
                            <h2>1,847</h2>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-success text-white p-3 shadow-sm rounded">
                            <h5>Lệnh SX đang chạy</h5>
                            <h2>24</h2>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-warning text-dark p-3 shadow-sm rounded">
                            <h5>Vật tư cần nhập (PO)</h5>
                            <h2>5</h2>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-danger text-white p-3 shadow-sm rounded">
                            <h5>Sản phẩm lỗi</h5>
                            <h2>12</h2>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card shadow-sm rounded border-0">
                            <div class="card-header bg-white fw-bold border-bottom">
                                <i class="fa-solid fa-chart-bar text-primary me-2"></i> BIỂU ĐỒ DOANH THU THEO THÁNG NĂM NAY (VNĐ)
                            </div>
                            <div class="card-body">
                                <canvas id="revenueChart" height="80"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <c:if test="${user.role eq 'CongNhan'}">
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm rounded text-center p-5 bg-white">
                            <i class="fa-solid fa-clipboard-user fa-4x text-primary mb-3"></i>
                            <h4 class="fw-bold">Giao Diện Công Nhân</h4>
                            <p class="text-muted mb-4">Tại đây bạn có thể xem các Lệnh sản xuất đang chạy, báo cáo sản lượng Đạt/Lỗi và ghi nhận tiến độ công việc hàng ngày.</p>
                            <a href="MainController?action=listLog" class="btn btn-primary btn-lg fw-bold rounded-pill shadow-sm">
                                <i class="fa-solid fa-arrow-right-to-bracket me-2"></i> ĐI TỚI NHẬT KÝ XƯỞNG
                            </a>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm rounded p-4 bg-light">
                            <h5 class="text-danger fw-bold"><i class="fa-solid fa-triangle-exclamation me-2"></i> Lưu ý An Toàn</h5>
                            <ul class="text-muted mt-3">
                                <li class="mb-2">Luôn mang đồ bảo hộ khi vào xưởng.</li>
                                <li class="mb-2">Ghi nhận chính xác số lượng hàng NG (Lỗi) để kiểm soát chất lượng.</li>
                                <li>Báo ngay cho Quản đốc nếu phát hiện thiếu vật tư.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>

        <c:if test="${user.role eq 'Sep' or user.role eq 'admin'}">
            <script>
                const ctx = document.getElementById('revenueChart').getContext('2d');
                
                // Mảng dữ liệu từ Server ném xuống
                const revenueData = [
                    ${rev[0]}, ${rev[1]}, ${rev[2]}, ${rev[3]}, 
                    ${rev[4]}, ${rev[5]}, ${rev[6]}, ${rev[7]}, 
                    ${rev[8]}, ${rev[9]}, ${rev[10]}, ${rev[11]}
                ];

                const config = {
                    type: 'line',
                    data: {
                        labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 
                                 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'],
                        datasets: [{
                            label: 'Doanh thu (VNĐ)',
                            data: revenueData,
                            backgroundColor: 'rgba(52, 152, 219, 0.2)',
                            borderColor: 'rgba(41, 128, 185, 1)',
                            borderWidth: 2,
                            pointBackgroundColor: '#e74c3c',
                            tension: 0.4,
                            fill: true
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: { beginAtZero: true }
                        }
                    }
                };

                new Chart(ctx, config);
            </script>
        </c:if>

    </body>
</html>