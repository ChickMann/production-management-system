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
import javax.xml.transform.Result;
import pms.utils.DBUtils;

/**
 *
 * @author se193234_TranGiaBao
 */
public class BOMDAO {

    // ==========================================
    // 1. R - READ: Lấy danh sách toàn bộ BOM
    // ==========================================
    public List<BOMDTO> getAllBOMS() {

        List<BOMDTO> list = new ArrayList<>();
        String sql = "SELECT *"
                + "  FROM [dbo].[BOM]";

        try(Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();) {
            

            while (rs.next()) {
                int bomId = rs.getInt("bom_id");
                int productItemId = rs.getInt("product_item_id");
                int materialItemId = rs.getInt("material_item_id");
                int quantityRequired = rs.getInt("quantity_required");

                BOMDTO bom = new BOMDTO(bomId, productItemId, materialItemId, quantityRequired);
                list.add(bom);
            }

        } catch (Exception e) {
            System.err.println("Error in getAllBOMS(): " + e.getMessage());
        }
        return list;
    }

    // ==========================================
    // 2. C - CREATE: Thêm mới 1 công thức BOM
    // ==========================================
    public boolean insertBOM(BOMDTO bom) {
        String sql = "INSERT INTO [dbo].[BOM]"
                + "           ([product_item_id]\n"
                + "           ,[material_item_id]\n"
                + "           ,[quantity_required])\n"
                + "     VALUES (?, ?, ?)";

        boolean isSuccess = false;

        try(Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);) {
            

            ps.setInt(1, bom.getProductItemId());
            ps.setInt(2, bom.getMaterialItemId());
            ps.setInt(3, bom.getQuantityRequired());

            int change = ps.executeUpdate();

            if (change > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            System.err.println("Error in insertBOM: " + e.getMessage());
        }
        return isSuccess;
    }

    // ==========================================
    // 3. U - UPDATE: Cập nhật công thức BOM
    // ==========================================
    public boolean updateBOM(BOMDTO bom) {
        String sql = "UPDATE [dbo].[BOM]\n"
                + "   SET [product_item_id] = ?\n"
                + "      ,[material_item_id] = ?\n"
                + "      ,[quantity_required] = ?\n"
                + " WHERE bom_id = ?";

        boolean isSuccess = false;

        try(Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);) {
            

            ps.setInt(1, bom.getProductItemId());
            ps.setInt(2, bom.getMaterialItemId());
            ps.setInt(3, bom.getQuantityRequired());
            ps.setInt(4, bom.getBomId());

            int change = ps.executeUpdate();

            if (change > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            System.err.println("Error in updateBOM: " + e.getMessage());
        }
        return isSuccess;
    }

    // ==========================================
    // 4. D - DELETE: Xóa 1 công thức BOM theo ID
    // ==========================================
    public boolean deleteBOM(BOMDTO bom) {
        String sql = "DELETE FROM [dbo].[BOM]\n"
                + "      WHERE bom_id = ?";

        boolean isSuccess = false;

        try(Connection conn = DBUtils.getConnection();  
                PreparedStatement ps = conn.prepareStatement(sql);) {
            

            ps.setInt(1, bom.getBomId());

            int change = ps.executeUpdate();

            if (change > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            System.err.println("Error in deleteBOM: " + e.getMessage());
        }
        return isSuccess;
    }
// ==========================================
    // 5. Lấy 1 công thức BOM theo ID (Dùng cho form Sửa)
    // ==========================================
    public BOMDTO getBOMById(int bomId) {
        String sql = "SELECT * FROM [dbo].[BOM] WHERE bom_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new BOMDTO(
                        rs.getInt("bom_id"),
                        rs.getInt("product_item_id"),
                        rs.getInt("material_item_id"),
                        rs.getInt("quantity_required")
                    );
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getBOMById: " + e.getMessage());
        }
        return null;
    }
    
    
}
