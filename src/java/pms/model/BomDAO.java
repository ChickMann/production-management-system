package pms.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import pms.utils.DBUtils;

public class BOMDAO {

    public List<BOMDTO> getAllBOMS() {
        List<BOMDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM [dbo].[BOM]";
        try(Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new BOMDTO(rs.getInt("bom_id"), rs.getInt("product_item_id"), rs.getInt("material_item_id"), rs.getInt("quantity_required")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertBOM(BOMDTO bom) {
        String sql = "INSERT INTO [dbo].[BOM] ([product_item_id], [material_item_id], [quantity_required]) VALUES (?, ?, ?)";
        try(Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bom.getProductItemId());
            ps.setInt(2, bom.getMaterialItemId());
            ps.setInt(3, bom.getQuantityRequired());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateBOM(BOMDTO bom) {
        String sql = "UPDATE [dbo].[BOM] SET [product_item_id] = ?, [material_item_id] = ?, [quantity_required] = ? WHERE bom_id = ?";
        try(Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bom.getProductItemId());
            ps.setInt(2, bom.getMaterialItemId());
            ps.setInt(3, bom.getQuantityRequired());
            ps.setInt(4, bom.getBomId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteBOM(BOMDTO bom) {
        String sql = "DELETE FROM [dbo].[BOM] WHERE bom_id = ?";
        try(Connection conn = DBUtils.getConnection();  
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bom.getBomId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public BOMDTO getBOMById(int bomId) {
        String sql = "SELECT * FROM [dbo].[BOM] WHERE bom_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new BOMDTO(rs.getInt("bom_id"), rs.getInt("product_item_id"), rs.getInt("material_item_id"), rs.getInt("quantity_required"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
