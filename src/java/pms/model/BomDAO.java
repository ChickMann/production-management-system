/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pms.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import pms.utils.DBUtils;

/**
 *
 * @author BAO
 */
public class BomDAO {

    private BomDTO SearchByColumn(String column, String value) {
        String sql = "SELECT * FROM BOM WHERE " + column + " = ?";
        try (Connection con = DBUtils.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, value);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new BomDTO(rs.getInt("bom_id"),
                            rs.getInt("product_item_id"),
                            rs.getInt("material_item_id"),
                            rs.getFloat("quantity_required"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private ArrayList<BomDTO> FilterByColumn(String column, String value) {
        ArrayList<BomDTO> bList = new ArrayList<>();
        String sql = "SELECT * FROM BOM WHERE " + column + " LIKE ?";
        try (Connection con = DBUtils.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + value + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bList.add(new BomDTO(rs.getInt("bom_id"),
                            rs.getInt("product_item_id"),
                            rs.getInt("material_item_id"),
                            rs.getFloat("quantity_required")));
                }
            }
            return bList;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public ArrayList<BomDTO> FilterByID(String id) {
        return FilterByColumn("bom_id", id);
    }

    public BomDTO SearchByID(String id) {
        return SearchByColumn("bom_id", id);
    }

    public Boolean SoftDelete(String id) {
        int result = 0;
        String sql = "DELETE FROM BOM WHERE bom_id =?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            result = ps.executeUpdate();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return result > 0;
    }

    public boolean Add(BomDTO b) {
        int result = 0;
        String sql = "INSERT into BOM (product_item_id, material_item_id, quantity_required) values(?,?,?)";
        try (Connection con = DBUtils.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, b.getParentItemID());
            ps.setInt(2, b.getChildItemID());
            ps.setFloat(3, b.getQuantity());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result > 0;
    }

    public boolean Update(BomDTO b) {
        int result = 0;
        String sql = "Update BOM SET"
                + " product_item_id = ?,"
                + " material_item_id = ?,"
                + " quantity_required = ?"
                + " Where bom_id = ?";
        try (Connection con = DBUtils.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, b.getParentItemID());
            ps.setInt(2, b.getChildItemID());
            ps.setFloat(3, b.getQuantity());
            ps.setInt(4, b.getBomID());

            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result > 0;
    }

    public int GetCurrentID() {
        String sql = "SELECT MAX(bom_id) as max_id FROM BOM";
        try (Connection con = DBUtils.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("max_id") + 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 1;
    }

    public ArrayList<BomDTO> BomList() {
        java.util.ArrayList<BomDTO> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM BOM";
        try (Connection con = DBUtils.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new BomDTO(rs.getInt("bom_id"),
                        rs.getInt("product_item_id"),
                        rs.getInt("material_item_id"),
                        rs.getFloat("quantity_required")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void ReseedSQL() {
        try (Connection con = DBUtils.getConnection();
                PreparedStatement ps = con.prepareStatement("DBCC CHECKIDENT ('BOM', RESEED, "
                        + GetCurrentID() + ")")) {

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
