package pms.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import pms.utils.DBUtils;

public class WorkOrderDAO {

    // 1. Hàm lấy toàn bộ danh sách Lệnh sản xuất (getAllWorkOrders)
    public List<WorkOrderDTO> getAllWorkOrders() {
        List<WorkOrderDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM Work_Order ORDER BY work_order_id DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new WorkOrderDTO(
                    rs.getInt("work_order_id"),
                    rs.getInt("customer_id"),
                    rs.getInt("product_item_id"),
                    rs.getInt("routing_id"),
                    rs.getInt("quantity"),
                    rs.getString("status"),
                    rs.getString("order_date")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Hàm thêm mới Lệnh sản xuất (insertWorkOrder)
    public boolean insertWorkOrder(WorkOrderDTO wo) {
        String sql = "INSERT INTO Work_Order (customer_id, product_item_id, routing_id, quantity, status, order_date) VALUES(?,?,?,?,?,?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, wo.getCustomerID());
            ps.setInt(2, wo.getProductItemID());
            ps.setInt(3, wo.getRoutingID());
            ps.setInt(4, wo.getQuantity());
            ps.setString(5, wo.getStatus());
            ps.setString(6, wo.getOrderDate());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // 3. Hàm Xóa Lệnh (deleteWorkOrder)
    public boolean deleteWorkOrder(int id) {
        String sql = "DELETE FROM Work_Order WHERE work_order_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Lấy Lệnh theo ID để Sửa (getWorkOrderById)
    public WorkOrderDTO getWorkOrderById(int id) {
        String sql = "SELECT * FROM Work_Order WHERE work_order_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new WorkOrderDTO(
                        rs.getInt("work_order_id"), rs.getInt("customer_id"),
                        rs.getInt("product_item_id"), rs.getInt("routing_id"),
                        rs.getInt("quantity"), rs.getString("status"), rs.getString("order_date")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 5. Hàm Cập nhật Lệnh (updateWorkOrder)
    public boolean updateWorkOrder(WorkOrderDTO wo) {
        String sql = "UPDATE Work_Order SET customer_id=?, product_item_id=?, routing_id=?, quantity=?, status=? WHERE work_order_id=?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, wo.getCustomerID());
            ps.setInt(2, wo.getProductItemID());
            ps.setInt(3, wo.getRoutingID());
            ps.setInt(4, wo.getQuantity());
            ps.setString(5, wo.getStatus());
            ps.setInt(6, wo.getWorkOrderID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}