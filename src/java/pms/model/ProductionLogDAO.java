package pms.model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import pms.utils.DBUtils;

public class ProductionLogDAO {
    
    public List<ProductionLogDTO> getAllLogs() {
        List<ProductionLogDTO> list = new ArrayList<>();
        String sql = "SELECT l.*, s.step_name, d.reason_name FROM Production_Log l " +
                     "LEFT JOIN Routing_Step s ON l.step_id = s.step_id " +
                     "LEFT JOIN Defect_Reason d ON l.defect_id = d.defect_id ORDER BY l.log_id DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ProductionLogDTO log = new ProductionLogDTO(
                    rs.getInt("log_id"), rs.getInt("work_order_id"), rs.getInt("step_id"),
                    rs.getInt("quantity_done"), rs.getInt("quantity_defective"),
                    rs.getInt("defect_id"), rs.getString("log_date")
                );
                log.setStepName(rs.getString("step_name"));
                log.setDefectName(rs.getString("reason_name") != null ? rs.getString("reason_name") : "OK");
                list.add(log);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean insertLog(ProductionLogDTO log) {
        String sql = "INSERT INTO Production_Log (work_order_id, step_id, quantity_done, quantity_defective, defect_id, log_date) VALUES(?,?,?,?,?,?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, log.getWorkOrderId());
            ps.setInt(2, log.getStepId());
            ps.setInt(3, log.getQuantityDone());
            ps.setInt(4, log.getQuantityDefective());
            if (log.getDefectId() > 0) ps.setInt(5, log.getDefectId()); 
            else ps.setNull(5, Types.INTEGER); // Lưu NULL nếu không có lỗi
            ps.setString(6, log.getLogDate());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}