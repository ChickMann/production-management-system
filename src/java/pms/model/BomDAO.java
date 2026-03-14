/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pms.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import pms.utils.DBUtils;

/**
 *
 * @author BAO
 */
public class BomDAO {

    private BomDTO SearchByColumn(String column, String value) {
        try {
            Connection con = DBUtils.getConnection();
            String sql = "SELECT * FROM BOM WHERE " + column + " = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, value);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new BomDTO(rs.getInt("bom_id"),
                        rs.getInt("parent_item_id"),
                        rs.getInt("child_item_id"),
                        rs.getFloat("quantity")
                );
            }
        } catch (Exception e) {
        }
        return null;
    }


    public BomDTO SearchByID(String id) {
        return SearchByColumn("bom_id", id);
    }

    public Boolean SoftDelete(String id) {
        int result = 0;
        try {
            Connection conn = DBUtils.getConnection();
            String sql = "UPDATE BOM SET status=0 WHERE item_id =?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, id);
            result = ps.executeUpdate();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return result > 0;
    }

    public boolean Add(BomDTO b) {
        int result = 0;
        try {
            Connection con = DBUtils.getConnection();
            String sql = "INSERT into BOM values(?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, b.getBomID());
            ps.setInt(2, b.getParentItemID());
            ps.setInt(3, b.getChildItemID());
            ps.setFloat(4, b.getQuantity());
            result = ps.executeUpdate();
        } catch (Exception e) {
        }
        return result > 0;
    }

    public boolean Update(BomDTO b) {
        int result = 0;
        try {
            Connection con = DBUtils.getConnection();
            String sql = "Update BOM SET"
                    + " parent_item_id = ?"
                    + " child_item_id = ?"
                    + " quantity = ?"
                    + " Where bom_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, b.getParentItemID());
            ps.setInt(2, b.getChildItemID());
            ps.setFloat(3, b.getQuantity());
            ps.setInt(4, b.getBomID());

            result = ps.executeUpdate();
        } catch (Exception e) {
        }
        return result > 0;
    }
}
