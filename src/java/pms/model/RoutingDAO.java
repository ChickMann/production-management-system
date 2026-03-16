/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pms.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import pms.utils.DBUtils;

/**
 *
 * @author se193234_TranGiaBao
 */
public class RoutingDAO {

    // ==========================================
    // 1. R - READ: Lấy danh sách toàn bộ BOM
    // ==========================================
    public List<RoutingDTO> getAllRouting() {
        List<RoutingDTO> list = new ArrayList<>();
        String sql = "SELECT *"
                + "  FROM [dbo].[Routing]";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int routingId = rs.getInt("routing_id");
                String routingName = rs.getString("routing_name");
                RoutingDTO r = new RoutingDTO(routingId, routingName);
                list.add(r);
            }
        } catch (Exception e) {
            System.out.println("Error in getAllRouting: " + e.getMessage());
        }
        return list;
    }

    // ==========================================
    // 2. C - CREATE: Thêm mới 1 công thức BOM
    // ==========================================
    public boolean insertRouting(RoutingDTO routing) {
        String sql = "INSERT INTO [dbo].[Routing]\n"
                + "           ([routing_name])\n"
                + "     VALUES(?)";
        boolean isSuccess = false;

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setString(1, routing.getRoutingName());
            int change = ps.executeUpdate();
            if (change > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            System.err.println("Error in insertRouting: " + e.getMessage());
        }
        return isSuccess;
    }

    // ==========================================
    // 3. U - UPDATE: Cập nhật công thức BOM
    // ==========================================  
    public boolean updateRouting(RoutingDTO routing) {
        String sql = "UPDATE [dbo].[Routing]\n"
                + "   SET [routing_name] = ?\n"
                + " WHERE routing_id = ?";
        boolean isSuccess = false;

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setString(1, routing.getRoutingName());
            ps.setInt(2, routing.getRoutingId());

            int change = ps.executeUpdate();
            if (change > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            System.err.println("Error in updateRouting: " + e.getMessage());
        }
        return isSuccess;
    }

    // ==========================================
    // 4. D - DELETE: Xóa 1 công thức BOM theo ID
    // ==========================================
    public boolean deleteRouting(RoutingDTO routing) {
        String sql = "DELETE FROM [dbo].[Routing]\n"
                + "      WHERE routing_id = ?";
        boolean isSuccess = false;

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, routing.getRoutingId());

            int change = ps.executeUpdate();
            if (change > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            System.err.println("Error in deleteRouting: " + e.getMessage());
        }
        return isSuccess;
    }
    
    // ==========================================
    // 5. Lấy 1 Quy trình theo ID (Dùng cho form Sửa)
    // ==========================================
    public RoutingDTO getRoutingById(int routingId) {
        String sql = "SELECT * FROM [dbo].[Routing] WHERE routing_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, routingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new RoutingDTO(rs.getInt("routing_id"), rs.getString("routing_name"));
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getRoutingById: " + e.getMessage());
        }
        return null;
    }
}
