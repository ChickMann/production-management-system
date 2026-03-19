package pms.model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import pms.utils.DBUtils;

public class RoutingDAO {
    public List<RoutingDTO> getAllRouting() {
        List<RoutingDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM Routing";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new RoutingDTO(rs.getInt("routing_id"), rs.getString("routing_name")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean insertRouting(RoutingDTO r) {
        String sql = "INSERT INTO Routing (routing_name) VALUES(?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, r.getRoutingName());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateRouting(RoutingDTO r) {
        String sql = "UPDATE Routing SET routing_name = ? WHERE routing_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, r.getRoutingName());
            ps.setInt(2, r.getRoutingId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteRouting(int id) {
        String sql = "DELETE FROM Routing WHERE routing_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public RoutingDTO getRoutingById(int id) {
        String sql = "SELECT * FROM Routing WHERE routing_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return new RoutingDTO(rs.getInt("routing_id"), rs.getString("routing_name"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
}