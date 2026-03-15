-- Khởi tạo và sử dụng Database mới
USE master;
GO

-- Xóa database nếu đã tồn tại
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'FACTORYERD')
    DROP DATABASE FactoryERD;
GO

CREATE DATABASE FactoryERD;
GO

USE FactoryERD;
GO

-- ==========================================
-- PHẦN 1: CÁC BẢNG DANH MỤC ĐỘC LẬP (Không chứa khóa ngoại)
-- ==========================================

-- 1. Bảng Phân quyền đăng nhập
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) CHECK (role IN ('Sep', 'CongNhan'))
);

-- 2. Bảng Quản lý Vật phẩm (Sản phẩm & Vật tư)
CREATE TABLE Item (
    item_id INT PRIMARY KEY IDENTITY(1,1),
    item_name NVARCHAR(100) NOT NULL,
    item_type VARCHAR(20) CHECK (item_type IN ('SanPham', 'VatTu')),
    stock_quantity INT DEFAULT 0
);

-- 12. Bảng Nhà cung cấp
CREATE TABLE Supplier (
    supplier_id INT PRIMARY KEY IDENTITY(1,1),
    supplier_name NVARCHAR(100) NOT NULL,
    contact_phone VARCHAR(15)
);

-- 7. Bảng Khách hàng
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    customer_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(50)
);

-- 11. Bảng Danh sách lỗi
CREATE TABLE Defect_Reason (
    defect_id INT PRIMARY KEY IDENTITY(1,1),
    reason_name NVARCHAR(255) NOT NULL
);

-- 4. Bảng Quy trình tổng
CREATE TABLE Routing (
    routing_id INT PRIMARY KEY IDENTITY(1,1),
    routing_name NVARCHAR(100) NOT NULL
);

-- ==========================================
-- PHẦN 2: CÁC BẢNG CÓ PHỤ THUỘC (Chứa khóa ngoại)
-- ==========================================

-- 5. Bảng Công đoạn chi tiết (Phụ thuộc Routing)
CREATE TABLE Routing_Step (
    step_id INT PRIMARY KEY IDENTITY(1,1),
    routing_id INT,
    step_name NVARCHAR(100) NOT NULL,
    estimated_time INT, -- tính theo phút
    is_inspected BIT DEFAULT 0, -- 0: Chưa kiểm tra, 1: Đã kiểm tra (Tick OK)
    FOREIGN KEY (routing_id) REFERENCES Routing(routing_id)
);

-- 9. Bảng Đề nghị mua vật tư (Phụ thuộc Item, Supplier)
CREATE TABLE Purchase_Order (
    po_id INT PRIMARY KEY IDENTITY(1,1),
    item_id INT,
    supplier_id INT,
    required_quantity INT,
    alert_date DATE DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (item_id) REFERENCES Item(item_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
);

-- 3. Bảng Công thức sản phẩm - BOM (Phụ thuộc Item)
CREATE TABLE BOM (
    bom_id INT PRIMARY KEY IDENTITY(1,1),
    product_item_id INT, -- ID của Bàn, Ghế
    material_item_id INT, -- ID của Gỗ, Ốc vít
    quantity_required INT, -- Số lượng vật tư cần dùng
    FOREIGN KEY (product_item_id) REFERENCES Item(item_id),
    FOREIGN KEY (material_item_id) REFERENCES Item(item_id)
);

-- 8. Lệnh sản xuất (Phụ thuộc Item, Routing)
CREATE TABLE Work_Order (
    wo_id INT PRIMARY KEY IDENTITY(1,1),
    product_item_id INT,
    routing_id INT,
    order_quantity INT,
    status VARCHAR(20) DEFAULT 'New', -- New, InProgress, Done
    FOREIGN KEY (product_item_id) REFERENCES Item(item_id),
    FOREIGN KEY (routing_id) REFERENCES Routing(routing_id)
);

-- 6. Nhật ký xưởng (Phụ thuộc Work_Order, Routing_Step, Users, Defect_Reason)
CREATE TABLE Production_Log (
    log_id INT PRIMARY KEY IDENTITY(1,1),
    wo_id INT,
    step_id INT,
    worker_user_id INT,
    produced_quantity INT,
    defect_id INT NULL, -- Có thể NULL nếu không có lỗi
    log_date DATE DEFAULT GETDATE(),
    FOREIGN KEY (wo_id) REFERENCES Work_Order(wo_id),
    FOREIGN KEY (step_id) REFERENCES Routing_Step(step_id),
    FOREIGN KEY (worker_user_id) REFERENCES Users(user_id),
    FOREIGN KEY (defect_id) REFERENCES Defect_Reason(defect_id)
);

-- 10. Bảng Hóa đơn chốt đơn (Phụ thuộc Work_Order, Customer)
CREATE TABLE Bill (
    bill_id INT PRIMARY KEY IDENTITY(1,1),
    wo_id INT,
    customer_id INT,
    total_amount DECIMAL(18,2),
    bill_date DATE DEFAULT GETDATE(),
    FOREIGN KEY (wo_id) REFERENCES Work_Order(wo_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);