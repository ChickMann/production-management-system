-- ==============================================================================
-- PHẦN 0: KHỞI TẠO DATABASE
-- ==============================================================================
-- 1. Tạo Database mới (Nếu máy chưa có thì nó tự tạo)
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'FactoryERP')
BEGIN
    CREATE DATABASE FactoryERP;
END
GO

-- 2. Lệnh cực kỳ quan trọng: Bắt hệ thống phải chui vào đúng cái Database vừa tạo để làm việc
USE FactoryERP;
GO


DROP TABLE IF EXISTS Production_Log;
DROP TABLE IF EXISTS Purchase_Order;
DROP TABLE IF EXISTS Work_Order;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Routing_Step;
DROP TABLE IF EXISTS Routing;
DROP TABLE IF EXISTS BOM;
DROP TABLE IF EXISTS Item;


-- ==============================================================================
-- PHẦN 2: TẠO 8 BẢNG CỐT LÕI (CHUẨN SQL SERVER - ĐÃ BỎ CỘT VERSION)
-- ==============================================================================

-- 1. Bảng Item (Danh mục vật tư & thành phẩm)
CREATE TABLE [User] (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    full_name NVARCHAR(100),
    role VARCHAR(20) 
);

CREATE TABLE Item (
    item_id INT IDENTITY(1,1) PRIMARY KEY, 
    item_code VARCHAR(50) UNIQUE NOT NULL,  
    name NVARCHAR(255) NOT NULL,             
    type VARCHAR(20) NOT NULL,              -- MATERIAL, SUB, FINISHED
    standard_cost DECIMAL(15, 2) DEFAULT 0  
);

-- 2. Bảng BOM (Công thức cấu tạo)
CREATE TABLE BOM (
    bom_id INT IDENTITY(1,1) PRIMARY KEY,
    parent_item_id INT NOT NULL,            
    child_item_id INT NOT NULL,             
    quantity FLOAT NOT NULL,                
    FOREIGN KEY (parent_item_id) REFERENCES Item(item_id),
    FOREIGN KEY (child_item_id) REFERENCES Item(item_id)
);

-- 3. Bảng Routing (Hồ sơ quy trình sản xuất)
CREATE TABLE Routing (
    routing_id INT IDENTITY(1,1) PRIMARY KEY,
    item_id INT NOT NULL,                   
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

-- 4. Bảng Routing_Step (Các công đoạn chi tiết)
CREATE TABLE Routing_Step (
    routing_step_id INT IDENTITY(1,1) PRIMARY KEY,
    routing_id INT NOT NULL,                
    step_order INT NOT NULL,                
    operation_name NVARCHAR(100) NOT NULL,   
    machine_id VARCHAR(50),                 
    estimated_time_minutes INT DEFAULT 0,   
    FOREIGN KEY (routing_id) REFERENCES Routing(routing_id)
);

-- 5. Bảng Inventory (Quản lý tồn kho)
CREATE TABLE Inventory (
    inventory_id INT IDENTITY(1,1) PRIMARY KEY,
    item_id INT NOT NULL UNIQUE,            
    quantity_on_hand FLOAT DEFAULT 0,       
    quantity_reserved FLOAT DEFAULT 0,      
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

-- 6. Bảng Work_Order (Lệnh sản xuất)
CREATE TABLE Work_Order (
    work_order_id INT IDENTITY(1,1) PRIMARY KEY,
    wo_code VARCHAR(50) UNIQUE NOT NULL,    
    item_id INT NOT NULL,                   
    target_quantity INT NOT NULL,           
    status VARCHAR(20) DEFAULT 'NEW',       -- NEW, RUNNING, COMPLETED
    start_date DATETIME,                    
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

-- 7. Bảng Production_Log (Nhật ký báo cáo tiến độ)
CREATE TABLE Production_Log (
    production_log_id INT IDENTITY(1,1) PRIMARY KEY,
    work_order_id INT NOT NULL,             
    routing_step_id INT NOT NULL,           
    pass_qty INT DEFAULT 0,                 
    fail_qty INT DEFAULT 0,                 
    fail_reason NVARCHAR(MAX),              -- Lý do hỏng (hỗ trợ tiếng Việt) 
    log_date DATETIME DEFAULT GETDATE(),    
    FOREIGN KEY (work_order_id) REFERENCES Work_Order(work_order_id),
    FOREIGN KEY (routing_step_id) REFERENCES Routing_Step(routing_step_id)
);

-- 8. Bảng Purchase_Order (Đơn cảnh báo mua vật tư)
CREATE TABLE Purchase_Order (
    purchase_order_id INT IDENTITY(1,1) PRIMARY KEY,
    item_id INT NOT NULL,                   
    missing_quantity FLOAT NOT NULL,        
    status VARCHAR(20) DEFAULT 'PENDING',   -- PENDING, ORDERED
    created_at DATETIME DEFAULT GETDATE(),  
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

-- ==============================================================================
-- PHẦN 3: BƠM DỮ LIỆU GIẢ (MOCK DATA) ĐỂ CẢ TEAM TEST CODE
-- ==============================================================================

-- 1. Nạp 5 món hàng vào Item (Dùng N'' để lưu tiếng Việt có dấu)
INSERT INTO Item (item_code, name, type, standard_cost) VALUES
('SP-BAN-01', N'Bàn Gỗ Cao Cấp', 'FINISHED', 500000),     -- ID = 1
('SUB-MAT-01', N'Mặt bàn cắt sẵn', 'SUB', 200000),        -- ID = 2
('SUB-CHAN-01', N'Chân bàn vát góc', 'SUB', 50000),       -- ID = 3
('MAT-GO-01', N'Khối gỗ thô (m3)', 'MATERIAL', 100000),   -- ID = 4
('MAT-OC-01', N'Ốc vít chịu lực (hộp)', 'MATERIAL', 20000); -- ID = 5

-- 2. Nạp Công thức ráp Cái Bàn (BOM)
INSERT INTO BOM (parent_item_id, child_item_id, quantity) VALUES
(1, 2, 1),   -- 1 Bàn cần 1 Mặt bàn
(1, 3, 4),   -- 1 Bàn cần 4 Chân bàn
(3, 4, 0.5), -- 1 Chân bàn cần 0.5 khối gỗ
(3, 5, 0.1); -- 1 Chân bàn cần 0.1 hộp ốc vít

-- 3. Nạp Quy trình làm Cái Bàn (Routing)
INSERT INTO Routing (item_id) VALUES (1); -- Khai báo quy trình cho Bàn (ID = 1)

-- 4. Nạp 2 công đoạn (Cắt ráp & Sơn) vào Routing_Step
INSERT INTO Routing_Step (routing_id, step_order, operation_name, machine_id, estimated_time_minutes) VALUES
(1, 1, N'Lắp ráp phần mộc', 'TO-MOC', 30),
(1, 2, N'Phun sơn bóng', 'P-SON', 45);

-- 5. Nạp Tồn kho ban đầu (Inventory)
INSERT INTO Inventory (item_id, quantity_on_hand, quantity_reserved) VALUES
(4, 100, 0), -- Gỗ thô: Đang có sẵn 100 khối
(5, 50, 0);  -- Ốc vít: Đang có sẵn 50 hộp

INSERT INTO [User] (username, password, full_name, role)
VALUES 
    -- 1 Tài khoản Admin
    ('admin', 'Admin@123', N'Quản Trị Viên Hệ Thống', 'admin'),
    
    -- 9 Tài khoản Employee
    ('tuanna', 'Emp@123', N'Nguyễn Anh Tuấn', 'employee'),
    ('lantt', 'Emp@123', N'Trần Thị Lan', 'employee'),
    ('hunglq', 'Emp@123', N'Lê Quốc Hùng', 'employee'),
    ('maipn', 'Emp@123', N'Phạm Ngọc Mai', 'employee'),
    ('vieth', 'Emp@123', N'Hoàng Việt', 'employee'),
    ('dungdt', 'Emp@123', N'Đỗ Thùy Dung', 'employee'),
    ('kienvt', 'Emp@123', N'Võ Trung Kiên', 'employee'),
    ('thaonp', 'Emp@123', N'Ngô Phương Thảo', 'employee'),
    ('longbd', 'Emp@123', N'Bùi Đức Long', 'employee');