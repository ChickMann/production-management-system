USE FACTORYERD;
GO

-- ==========================================
-- 1. CHÈN DỮ LIỆU CÁC BẢNG DANH MỤC (Không khóa ngoại)
-- ==========================================

-- Thêm Users 👤
INSERT INTO Users (username, password_hash, role, full_name) 
VALUES ('admin', '123456', 'admin', N'Quản trị viên'), 
       ('congnhan1', '123456', 'employee', N'Nguyễn Văn B'),
       ('congnhan2', '123456', 'employee', N'Trần Văn C');

-- Thêm Item (2 Sản phẩm, 2 Vật tư) 📦
INSERT INTO Item (item_name, item_type, stock_quantity) 
VALUES (N'Bàn gỗ', 'SanPham', 10), 
       (N'Ghế gỗ', 'SanPham', 20),
       (N'Gỗ công nghiệp', 'VatTu', 100), 
       (N'Ốc vít', 'VatTu', 500);

-- Thêm Nhà cung cấp 🏭
INSERT INTO Supplier (supplier_name, contact_phone) 
VALUES (N'Gỗ An Cường', '0901234567'), 
       (N'Kim Khí Hòa Phát', '0987654321');

-- Thêm Khách hàng 🤝
INSERT INTO Customer (customer_name, phone, email) 
VALUES (N'Nguyễn Văn A', '0911111111', 'a@gmail.com');

-- Thêm Danh sách lỗi ⚠️
INSERT INTO Defect_Reason (reason_name) 
VALUES (N'Trầy xước bề mặt'), 
       (N'Nứt gỗ'), 
       (N'Thiếu ốc vít');

-- Thêm Quy trình tổng ⚙️
INSERT INTO Routing (routing_name) 
VALUES (N'Quy trình sản xuất Bàn'), 
       (N'Quy trình sản xuất Ghế');

-- ==========================================
-- 2. CHÈN DỮ LIỆU CÁC BẢNG GIAO DỊCH (Có khóa ngoại)
-- ==========================================

-- Thêm Công đoạn chi tiết (Cho Quy trình Bàn: ID 1) ⏱️
INSERT INTO Routing_Step (routing_id, step_name, estimated_time, is_inspected) 
VALUES (1, N'Cắt gỗ', 30, 0), 
       (1, N'Lắp ráp Bàn', 45, 1);

-- Thêm BOM (Công thức làm 1 Bàn gỗ: Cần 2 Gỗ công nghiệp, 20 Ốc vít) 📜
INSERT INTO BOM (product_item_id, material_item_id, quantity_required) 
VALUES (1, 3, 2), -- 1 Bàn cần 2 Gỗ
       (1, 4, 20); -- 1 Bàn cần 20 Ốc vít

-- Thêm Cảnh báo mua hàng (Mua thêm 50 Gỗ từ An Cường) 🛒
INSERT INTO Purchase_Order (item_id, supplier_id, required_quantity, status) 
VALUES (3, 1, 50, 'Pending');

-- Thêm Lệnh sản xuất (Sản xuất 5 Bàn gỗ, đang chạy) 📋
INSERT INTO Work_Order (product_item_id, routing_id, order_quantity, status) 
VALUES (1, 1, 5, 'InProgress');

-- Thêm Nhật ký xưởng (Công nhân 1 làm xong bước Cắt gỗ cho Lệnh SX 1, không lỗi) 📝
INSERT INTO Production_Log (wo_id, step_id, worker_user_id, produced_quantity, defect_id) 
VALUES (1, 1, 2, 5, NULL);

-- Thêm Hóa đơn (Chốt đơn Lệnh SX 1 cho Khách hàng 1) 💳
INSERT INTO Bill (wo_id, customer_id, total_amount) 
VALUES (1, 1, 2500000.00);