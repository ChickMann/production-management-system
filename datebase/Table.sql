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
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) CHECK (role IN ('admin', 'employee')),
    full_name NVARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_date DATETIME DEFAULT GETDATE()
);

-- 2. Bảng Quản lý Vật phẩm (Sản phẩm & Vật tư)
CREATE TABLE Item (
    item_id INT PRIMARY KEY IDENTITY(1,1),
    item_name NVARCHAR(100) NOT NULL,
    item_type VARCHAR(20) CHECK (item_type IN ('SanPham', 'VatTu')),
    stock_quantity INT DEFAULT 0,
    unit NVARCHAR(20),
    description NVARCHAR(500),
    min_stock_level INT DEFAULT 0,
    image_base64 VARCHAR(MAX)
);

-- 12. Bảng Nhà cung cấp
CREATE TABLE Supplier (
    supplier_id INT PRIMARY KEY IDENTITY(1,1),
    supplier_name NVARCHAR(100) NOT NULL,
    contact_phone VARCHAR(15),
    email VARCHAR(100),
    address NVARCHAR(200),
    city NVARCHAR(50),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive'))
);

-- 7. Bảng Khách hàng
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    customer_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(50),
    address NVARCHAR(200),
    city NVARCHAR(50),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive'))
);

-- 11. Bảng Danh sách lỗi
CREATE TABLE Defect_Reason (
    defect_id INT PRIMARY KEY IDENTITY(1,1),
    reason_name NVARCHAR(255) NOT NULL
);

-- 4. Bảng Quy trình tổng
CREATE TABLE Routing (
    routing_id INT PRIMARY KEY IDENTITY(1,1),
    routing_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_date DATETIME DEFAULT GETDATE()
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
    notes NVARCHAR(500),
    FOREIGN KEY (item_id) REFERENCES Item(item_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
);

-- 3. Bảng Công thức sản phẩm - BOM (Phụ thuộc Item)
CREATE TABLE BOM (
    bom_id INT PRIMARY KEY IDENTITY(1,1),
    product_item_id INT,
    bom_version VARCHAR(20),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'pending')),
    created_date DATETIME DEFAULT GETDATE(),
    notes NVARCHAR(500),
    FOREIGN KEY (product_item_id) REFERENCES Item(item_id)
);

-- Bảng Chi tiết BOM (Nguyên liệu cần cho mỗi BOM)
CREATE TABLE BOM_Detail (
    bom_detail_id INT PRIMARY KEY IDENTITY(1,1),
    bom_id INT,
    material_item_id INT,
    quantity_required DECIMAL(10,2),
    unit NVARCHAR(20),
    waste_percent DECIMAL(5,2) DEFAULT 0,
    notes NVARCHAR(200),
    FOREIGN KEY (bom_id) REFERENCES BOM(bom_id),
    FOREIGN KEY (material_item_id) REFERENCES Item(item_id)
);

-- 8. Lệnh sản xuất (Phụ thuộc Item, Routing)
CREATE TABLE Work_Order (
    wo_id INT PRIMARY KEY IDENTITY(1,1),
    product_item_id INT,
    routing_id INT,
    order_quantity INT,
    status VARCHAR(20) DEFAULT 'New' CHECK (status IN ('New', 'InProgress', 'Done', 'Cancelled')),
    start_date DATE,
    due_date DATE,
    completed_date DATE,
    notes NVARCHAR(500),
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

-- 11. Bảng Thanh toán QR/Chuyển khoản (Phụ thuộc Bill)
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    bill_id INT NOT NULL,
    amount DECIMAL(18,2) NOT NULL,
    payment_method VARCHAR(30) NOT NULL DEFAULT 'QR',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'PAID', 'EXPIRED', 'CANCELLED')),
    transaction_id VARCHAR(100) NULL,
    qr_code_data VARCHAR(MAX) NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    expires_at DATETIME NULL,
    paid_at DATETIME NULL,
    bank_bin VARCHAR(20) NULL,
    bank_account VARCHAR(50) NULL,
    bank_account_name NVARCHAR(150) NULL,
    customer_name NVARCHAR(150) NULL,
    customer_email VARCHAR(100) NULL,
    FOREIGN KEY (bill_id) REFERENCES Bill(bill_id)
);

CREATE TABLE EncryptedFile (
    file_id INT PRIMARY KEY IDENTITY(1,1),
    original_name NVARCHAR(255) NOT NULL,
    stored_name VARCHAR(255) NOT NULL,
    file_extension VARCHAR(20) NOT NULL,
    file_size BIGINT NOT NULL,
    password_hash VARCHAR(512) NOT NULL,
    uploader_id INT NULL,
    file_description NVARCHAR(500),
    related_table VARCHAR(50),
    related_id INT DEFAULT 0,
    uploaded_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (uploader_id) REFERENCES Users(user_id)
);
