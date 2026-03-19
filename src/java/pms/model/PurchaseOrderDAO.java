package pms.model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import pms.utils.DBUtils;

public class PurchaseOrderDAO {

    // 1. Lấy toàn bộ danh sách Đề nghị mua hàng
    public List<PurchaseOrderDTO> getAllPurchaseOrders() {
        List<PurchaseOrderDTO> list = new ArrayList<>();
        // Đã sửa: JOIN với bảng Item, đổi tên cột thành item_name, required_quantity, alert_date
        String sql = "SELECT po.*, i.item_name FROM Purchase_Order po " +
                     "JOIN Item i ON po.item_id = i.item_id " +
                     "ORDER BY po.po_id DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PurchaseOrderDTO po = new PurchaseOrderDTO(
                    rs.getInt("po_id"),
                    rs.getInt("item_id"),
                    rs.getInt("required_quantity"), 
                    rs.getString("status"),
                    rs.getString("alert_date")      
                );
                po.setItemName(rs.getString("item_name"));
                list.add(po);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Thêm mới một Đề nghị mua vật tư
    public boolean insertPurchaseOrder(PurchaseOrderDTO po) {
        // Đã sửa: Tên cột required_quantity, alert_date
        String sql = "INSERT INTO Purchase_Order (item_id, required_quantity, status, alert_date) VALUES(?,?,?,?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, po.getItemId());
            ps.setInt(2, po.getQuantityRequested());
            ps.setString(3, po.getStatus());
            ps.setString(4, po.getOrderDate());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Cập nhật trạng thái
    public boolean updateStatus(int poId, String newStatus) {
        String sql = "UPDATE Purchase_Order SET status = ? WHERE po_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, poId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Xóa đề nghị
    public boolean deletePurchaseOrder(int poId) {
        String sql = "DELETE FROM Purchase_Order WHERE po_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, poId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}