/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

/**
 *
 * @author se193234_TranGiaBao
 */
public class RoutingStepDAO {
    // ==========================================
    // 1. R - READ: Lấy danh sách RoutingStep
    // ==========================================

    public List<RoutingStepDTO> getAllRoutingStep() {
        List<RoutingStepDTO> list = new ArrayList<>();
        String sql = "SELECT *"
                + "  FROM [dbo].[Routing_Step]";

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new RoutingStepDTO(rs.getInt("step_id"),
                        rs.getInt("routing_id"),
                        rs.getString("step_name"),
                        rs.getInt("estimated_time"),
                        rs.getBoolean("is_inspected")));
            }

        } catch (Exception e) {
            System.err.println("Error list getAllRoutingStep: " + e.getMessage());
        }
        return list;
    }

    // ==========================================
    // 2. C - CREATE: Thêm mới 1 RoutingStep
    // ==========================================
    public boolean insertRoutingStep(RoutingStepDTO step) {
        String sql = "INSERT INTO [dbo].[Routing_Step]\n"
                + "           ([routing_id]\n"
                + "           ,[step_name]\n"
                + "           ,[estimated_time]\n"
                + "           ,[is_inspected])\n"
                + "     VALUES(?, ?, ?, ?)";
        boolean isSuccess = false;

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, step.getRoutingId());
            ps.setString(2, step.getStepName());
            ps.setInt(3, step.getEstimatedTime());
            ps.setBoolean(4, step.isIsInspected());

            int change = ps.executeUpdate();

            if (change > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            System.err.println("Error insertRoutingStep: " + e.getMessage());
        }
        return isSuccess;
    }

    // ==========================================
    // 3. U - UPDATE: Cập nhật công thức BOM
    // ==========================================  
    public boolean updateRoutingStep(RoutingStepDTO step) {
        String sql = "UPDATE [dbo].[Routing_Step]\n"
                + "   SET [routing_id] = ?"
                + "      ,[step_name] = ?\n"
                + "      ,[estimated_time] = ?"
                + "      ,[is_inspected] = ?"
                + " WHERE step_id = ?";
        boolean isSuccess = false;

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, step.getRoutingId());
            ps.setString(2, step.getStepName());
            ps.setInt(3, step.getEstimatedTime());
            ps.setBoolean(4, step.isIsInspected());
            ps.setInt(5, step.getStepId());

            int change = ps.executeUpdate();

            if (change > 0) {
                isSuccess = true;
            }

        } catch (Exception e) {
            System.err.println("Error update RoutingStep: " + e.getMessage());
        }
        return isSuccess;
    }

    // ==========================================
    // 4. D - DELETE: Xóa 1 công thức BOM theo ID
    // ==========================================
    public boolean deleteRoutingStep(int stepId) {
        String sql = "DELETE FROM [dbo].[Routing_Step]\n"
                + "      WHERE WHERE step_id = ?";
        boolean isSuccess = false;

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, stepId);
            int change = ps.executeUpdate();

            if (change > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            System.err.println("Error delete RoutingStep: " + e.getMessage());
        }
        return isSuccess;
    }
}
