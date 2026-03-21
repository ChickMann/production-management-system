USE FactoryERD;
GO

-- ==========================================
-- PHẦN 1: CHÈN DỮ LIỆU CÁC BẢNG DANH MỤC (Không khóa ngoại)
-- ==========================================

-- 1. Thêm Users 👤
INSERT INTO Users (username, password_hash, role, full_name, email, phone) 
VALUES 
('admin', '123456', 'admin', N'Quản trị viên', 'admin@factory.com', '0909000000'), 
('congnhan1', '123456', 'employee', N'Nguyễn Văn B', 'nvb@factory.com', '0909000001'),
('congnhan2', '123456', 'employee', N'Trần Văn C', 'tvc@factory.com', '0909000002');
GO

-- 2. Thêm Item (2 Sản phẩm, 2 Vật tư) 📦
INSERT INTO Item (item_name, item_type, stock_quantity, unit) 
VALUES 
(N'Bàn gỗ', 'SanPham', 10, N'Cái'), 
(N'Ghế gỗ', 'SanPham', 20, N'Cái'),
(N'Gỗ công nghiệp', 'VatTu', 100, N'Tấm'), 
(N'Ốc vít', 'VatTu', 500, N'Hộp'),
(N'Đinh', 'VatTu', 200, N'Kg');
GO

-- 3. Thêm Nhà cung cấp 🏭
INSERT INTO Supplier (supplier_name, contact_phone, address) 
VALUES 
(N'Gỗ An Cường', '0901234567', N'KCN Sóng Thần'), 
(N'Kim Khí Hòa Phát', '0987654321', N'KCN Phố Nối A');
GO

-- 4. Thêm Khách hàng 🤝
INSERT INTO Customer (customer_name, phone, email) 
VALUES 
(N'Nguyễn Văn A', '0911111111', 'a@gmail.com');
GO

-- 5. Thêm Danh sách lỗi ⚠️
INSERT INTO Defect_Reason (reason_name) 
VALUES 
(N'Trầy xước bề mặt'), 
(N'Nứt gỗ'), 
(N'Thiếu ốc vít');
GO

-- 6. Thêm Quy trình tổng ⚙️
INSERT INTO Routing (routing_name) 
VALUES 
(N'Quy trình sản xuất Bàn'), 
(N'Quy trình sản xuất Ghế');
GO


-- ==========================================
-- PHẦN 2: CHÈN DỮ LIỆU CÁC BẢNG GIAO DỊCH (Có khóa ngoại)
-- ==========================================

-- 7. Thêm Công đoạn chi tiết (Cho Quy trình Bàn: ID 1) ⏱️
INSERT INTO Routing_Step (routing_id, step_name, estimated_time, is_inspected) 
VALUES 
(1, N'Cắt gỗ', 30, 0), 
(1, N'Lắp ráp Bàn', 45, 1);
GO

-- 8. Thêm Đề nghị mua vật tư (Mua thêm 50 Gỗ từ An Cường) 🛒
INSERT INTO Purchase_Order (item_id, supplier_id, required_quantity, status) 
VALUES 
(3, 1, 50, 'Pending');
GO

-- 9. Thêm BOM (Tạo Header BOM trước) 📜
INSERT INTO BOM (product_item_id, bom_version, status, notes)
VALUES 
(1, 'v1.0', 'active', N'BOM chuẩn cho Bàn gỗ văn phòng');
GO

-- 10. Thêm BOM_Detail (Chi tiết vật tư cho BOM ID 1: Cần 2 Gỗ, 20 Ốc vít)
INSERT INTO BOM_Detail (bom_id, material_item_id, quantity_required, unit)
VALUES 
(1, 3, 2, N'Tấm'),  -- 1 Bàn cần 2 Tấm Gỗ
(1, 4, 20, N'Cái'); -- 1 Bàn cần 20 Cái Ốc vít
GO

-- 11. Thêm Lệnh sản xuất (Sản xuất 5 Bàn gỗ, đang chạy) 📋
INSERT INTO Work_Order (product_item_id, routing_id, order_quantity, status, start_date) 
VALUES 
(1, 1, 5, 'InProgress', GETDATE());
GO

-- 12. Thêm Nhật ký xưởng (Công nhân 1 làm xong bước Cắt gỗ cho Lệnh SX 1, không lỗi) 📝
INSERT INTO Production_Log (wo_id, step_id, worker_user_id, produced_quantity, defect_id) 
VALUES 
(1, 1, 2, 5, NULL);
GO

-- 13. Thêm Hóa đơn (Chốt đơn Lệnh SX 1 cho Khách hàng 1) 💳
INSERT INTO Bill (wo_id, customer_id, total_amount) 
VALUES 
(1, 1, 2500000.00);
GO