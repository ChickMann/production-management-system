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
 * @author HP
 */
public class ProductionLogDAO {

    public List<ProductionLogDTO> getAllLogs() {

        List<ProductionLogDTO> list = new ArrayList<>();

        try {
            String sql = "SELECT * FROM Production_Log";
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ProductionLogDTO log = new ProductionLogDTO();

                log.setLogId(rs.getInt("log_id"));
                log.setWoId(rs.getInt("wo_id"));
                log.setStepId(rs.getInt("step_id"));
                log.setWorkerUserId(rs.getInt("worker_user_id"));
                log.setProducedQuantity(rs.getInt("produced_quantity"));

                int defect = rs.getInt("defect_id");

                if (rs.wasNull()) {
                    log.setDefectId(null);
                } else {
                    log.setDefectId(defect);
                }

                log.setLogDate(rs.getDate("log_date"));

                list.add(log);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean insertLog(ProductionLogDTO log) {
        try {
            String sql = "INSERT INTO Production_Log(wo_id, step_id, worker_user_id, produced_quantity, defect_id) VALUES (?, ?, ?, ?, ?)";
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, log.getWoId());
            ps.setInt(2, log.getStepId());
            ps.setInt(3, log.getWorkerUserId());
            ps.setInt(4, log.getProducedQuantity());

            if (log.getDefectId() == null) {
                ps.setNull(5, java.sql.Types.INTEGER);
            } else {
                ps.setInt(5, log.getDefectId());
            }

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateLog(ProductionLogDTO log) {
        try {
            String sql = "UPDATE Production_Log SET produced_quantity = ?, defect_id = ? WHERE log_id = ?";
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, log.getProducedQuantity());
            if (log.getDefectId() == null) {
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, log.getDefectId());
            }
            ps.setInt(3, log.getLogId());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteLog(int logId) {
        try {
            String sql = "DELETE FROM Production_Log WHERE log_id = ?";
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, logId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
