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
public class DefectReasonDAO {

    // ==========================================
    // 1. R - READ: Lấy danh sách toàn bộ BOM
    // ==========================================
    public List<DefectReasonDTO> getAllDefectReasons() {
        List<DefectReasonDTO> list = new ArrayList<>();
        String sql = "SELECT *"
                + "  FROM [dbo].[Defect_Reason]";

        try(Connection conn = DbUtils.getConnection();  
                PreparedStatement ps = conn.prepareStatement(sql);  
                ResultSet rs = ps.executeQuery();) {
            
            while (rs.next()) {
                int defectId = rs.getInt("defect_id");
                String reasonName = rs.getString("reason_name");
                DefectReasonDTO dr = new DefectReasonDTO(defectId, reasonName);
                list.add(dr);
            }
        } catch (Exception e) {
            System.err.println("Error list DefectReasons: " + e.getMessage());
        }
        return list;

    }

    // ==========================================
    // 2. C - CREATE: Thêm mới 1 công thức BOM
    // ==========================================
    public boolean insertDefectReasons(DefectReasonDTO defect) {
        String sql = "INSERT INTO [dbo].[Defect_Reason]\n"
                + "           ([reason_name])\n"
                + "     VALUES(?)";

        Boolean isSuccess = false;

        try( Connection conn = DbUtils.getConnection();  
             PreparedStatement ps = conn.prepareStatement(sql);) {
           

            ps.setString(1, defect.getReasonName());
            int change = ps.executeUpdate();

            if (change > 0) {
                isSuccess = true;
            }

        } catch (Exception e) {
            System.err.println("Error create DefectReasons: " + e.getMessage());
        }
        return isSuccess;
    }

    // ==========================================
    // 3. U - UPDATE: Cập nhật công thức BOM
    // ==========================================  
    public boolean updateDefectReasons(DefectReasonDTO defect) {
        String sql = "UPDATE [dbo].[Defect_Reason]\n"
                + "   SET [reason_name] = ?"
                + " WHERE defect_id = ?";

        Boolean isSuccess = false;

        try( Connection conn = DbUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);) {
           

            ps.setString(1, defect.getReasonName());
            ps.setInt(2, defect.getDefectId());

            int change = ps.executeUpdate();

            if (change > 0) {
                isSuccess = true;
            }

        } catch (Exception e) {
            System.err.println("Error update DefectReasons: " + e.getMessage());
        }
        return isSuccess;
    }

    // ==========================================
    // 4. D - DELETE: Xóa 1 công thức BOM theo ID
    // ==========================================
    public boolean deleteDefectReasons(DefectReasonDTO defect) {
        String sql = "DELETE FROM [dbo].[Defect_Reason]\n"
                + "      WHERE defect_id = ?";

        Boolean isSuccess = false;

        try(Connection conn = DbUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);) {
            

            ps.setInt(1, defect.getDefectId());

            int change = ps.executeUpdate();

            if (change > 0) {
                isSuccess = true;
            }

        } catch (Exception e) {
            System.err.println("Error delete DefectReasons: " + e.getMessage());
        }
        return isSuccess;
    }
}
