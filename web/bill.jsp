<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chốt Đơn - Hóa Đơn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light p-4">
    <c:set var="mode" value="${not empty billEdit ? 'update' : 'add'}" />
    
    <div class="container-fluid">
        <div class="mb-3">
            <a href="MainController?action=loginUser" class="btn btn-secondary shadow-sm">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Dashboard
            </a>
        </div>
        
        <div class="row">
            <div class="col-md-4">
                <div class="card shadow border-0 sticky-top">
                    <div class="card-header ${mode == 'update' ? 'bg-warning text-dark' : 'bg-primary text-white'} fw-bold">
                        <i class="fa-solid fa-file-invoice-dollar me-2"></i> ${mode == 'update' ? 'Sửa Hóa Đơn' : 'Chốt Đơn Mới'}
                    </div>
                    <div class="card-body">
                        <form action="MainController" method="post">
                            <input type="hidden" name="action" value="${mode == 'update' ? 'saveUpdateBill' : 'addBill'}">
                            <c:if test="${mode == 'update'}">
                                <input type="hidden" name="bill_id" value="${billEdit.bill_id}">
                            </c:if>
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold">Chọn Lệnh SX Đã Xong</label>
                                <select name="wo_id" class="form-select border-primary" required>
                                    <option value="">-- Chọn mã lệnh --</option>
                                    <c:forEach items="${listWO}" var="wo">
                                        <option value="${wo.workOrderID}" ${billEdit.wo_id == wo.workOrderID ? 'selected' : ''}>
                                            WO-#${wo.workOrderID} (Khách ID: ${wo.customerID})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold">Chọn Khách Hàng</label>
                                <select name="customer_id" class="form-select border-primary" required>
                                    <option value="">-- Chọn khách hàng --</option>
                                    <c:forEach items="${listC}" var="c">
                                        <option value="${c.customer_id}" ${billEdit.customer_id == c.customer_id ? 'selected' : ''}>
                                            ${c.customer_name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold text-success">Tổng Tiền Cần Thu (VNĐ)</label>
                                <input type="number" name="total_amount" class="form-control border-success fw-bold" value="${billEdit.total_amount}" min="0" required>
                            </div>
                            
                            <button type="submit" class="btn ${mode == 'update' ? 'btn-warning text-dark' : 'btn-primary'} w-100 fw-bold shadow-sm">
                                <i class="fa-solid fa-floppy-disk me-1"></i> LƯU HÓA ĐƠN
                            </button>
                            
                            <c:if test="${mode == 'update'}">
                                <a href="MainController?action=listBill" class="btn btn-outline-secondary w-100 mt-2">Hủy Bỏ</a>
                            </c:if>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-8">
                <div class="card shadow border-0">
                    <div class="card-header bg-dark text-white fw-bold">Danh Sách Hóa Đơn & Doanh Thu</div>
                    <div class="card-body">
                        
                        <form action="MainController" method="get" class="mb-3 d-flex">
                            <input type="hidden" name="action" value="searchBill">
                            <input type="text" name="keyword" class="form-control me-2" placeholder="Nhập ID hóa đơn..." value="${param.keyword}">
                            <button type="submit" class="btn btn-outline-primary text-nowrap"><i class="fa-solid fa-magnifying-glass me-1"></i> Tìm</button>
                        </form>
                        
                        <div class="table-responsive">
                            <table class="table align-middle table-hover border text-center">
                                <thead class="table-light">
                                    <tr>
                                        <th>Mã Bill</th>
                                        <th>Tên Khách Hàng</th>
                                        <th>Chi Tiết Sản Phẩm</th>
                                        <th>Số Tiền (VNĐ)</th>
                                        <th>Hành Động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${billList}" var="b">
                                        <tr>
                                            <td class="fw-bold text-primary">#BILL-${b.bill_id}</td>
                                            
                                            <td class="text-start fw-bold">
                                                <i class="fa-solid fa-user text-muted me-1"></i>
                                                <c:forEach items="${listC}" var="c">
                                                    <c:if test="${c.customer_id == b.customer_id}">${c.customer_name}</c:if>
                                                </c:forEach>
                                            </td>

                                            <td class="text-start">
                                                <c:forEach items="${listWO}" var="wo">
                                                    <c:if test="${wo.workOrderID == b.wo_id}">
                                                        <c:forEach items="${listI}" var="i">
                                                            <c:if test="${i.itemID == wo.productItemID}">
                                                                <span class="badge bg-secondary">WO-${wo.workOrderID}</span> 
                                                                ${i.itemName} 
                                                                <b class="text-danger">(SL: ${wo.quantity})</b>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>
                                                </c:forEach>
                                            </td>

                                            <td><b class="text-success fs-5">${b.total_amount}</b></td>
                                            
                                            <td class="text-nowrap">
                                                <button type="button" class="btn btn-sm btn-info shadow-sm text-white" onclick="showQR(${b.bill_id}, ${b.total_amount})" title="Quét QR Thanh Toán">
                                                    <i class="fa-solid fa-qrcode"></i>
                                                </button>
                                                
                                                <a href="MainController?action=loadUpdateBill&id=${b.bill_id}" class="btn btn-sm btn-warning shadow-sm" title="Sửa"><i class="fa-solid fa-pen"></i></a>
                                                <a href="MainController?action=deleteBill&id=${b.bill_id}" class="btn btn-sm btn-danger shadow-sm" onclick="return confirm('Xóa hóa đơn này?')" title="Xóa"><i class="fa-solid fa-trash"></i></a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="qrModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
          <div class="modal-header bg-primary text-white">
            <h5 class="modal-title fw-bold"><i class="fa-solid fa-qrcode me-2"></i> QUÉT MÃ ĐỂ THANH TOÁN</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body text-center p-4">
            
            <h3 class="fw-bold text-success mb-1" id="qrAmount">0 VNĐ</h3>
            <p class="text-muted mb-3">Nội dung chuyển khoản: <b id="qrContent" class="text-dark"></b></p>
            
            <div class="d-inline-block p-2 bg-white rounded shadow-sm border mb-3">
                <img id="qrImage" src="" alt="Mã QR Chuyển Khoản" class="img-fluid" style="width: 250px; height: 250px; object-fit: contain;">
            </div>

            <div class="text-start bg-light p-3 rounded border">
                <div class="d-flex justify-content-between mb-1">
                    <span class="text-muted">Ngân hàng:</span>
                    <b id="bankNameDisplay" class="text-dark"></b>
                </div>
                <div class="d-flex justify-content-between mb-1">
                    <span class="text-muted">Chủ tài khoản:</span>
                    <b id="accountNameDisplay" class="text-dark"></b>
                </div>
                <div class="d-flex justify-content-between">
                    <span class="text-muted">Số tài khoản:</span>
                    <b id="accountNoDisplay" class="text-primary fs-5"></b>
                </div>
            </div>

          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function showQR(billId, amount) {
            // 1. CẤU HÌNH THÔNG TIN TÀI KHOẢN NGÂN HÀNG CỦA BẠN 
            // Bạn có thể đổi lại thành NH và STK thật của mình để test
            const bankId = "MB"; // Tên viết tắt ngân hàng (MB, VCB, ACB, TPB, BIDV...)
            const accountNo = "0123456789"; // Số tài khoản của bạn
            const accountName = "LE MINH HOANG"; // Tên in trên thẻ (Viết hoa không dấu)
            
            // 2. Nội dung chuyển khoản tự động sinh ra
            const content = "Thanh toan hoa don BILL " + billId;

            // 3. Gọi API tự động tạo ảnh QR từ VietQR.io
            const qrUrl = `https://img.vietqr.io/image/${bankId}-${accountNo}-compact.png?amount=${amount}&addInfo=${content}&accountName=${accountName}`;

            // 4. Định dạng tiền tệ VNĐ
            const formattedAmount = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);

            // 5. Đẩy dữ liệu vào Modal
            document.getElementById("qrAmount").innerText = formattedAmount;
            document.getElementById("qrContent").innerText = content;
            document.getElementById("qrImage").src = qrUrl;
            
            document.getElementById("bankNameDisplay").innerText = bankId + " Bank";
            document.getElementById("accountNameDisplay").innerText = accountName;
            document.getElementById("accountNoDisplay").innerText = accountNo;

            // 6. Kích hoạt Popup
            var myModal = new bootstrap.Modal(document.getElementById('qrModal'));
            myModal.show();
        }
    </script>
</body>
</html>