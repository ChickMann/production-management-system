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
public class ItemDAO {
    private ItemDTO SearchByColumn(String column, String value) {
        try {
            Connection con = DBUtils.getConnection();
            String sql = "SELECT * FROM item WHERE " + column + " = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, value);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new ItemDTO(rs.getInt("item_id"),
                        rs.getString("item_code"),
                        rs.getString("name"),
                        rs.getString("type"),
                        rs.getDouble("standard_cost")
                );
            }
        } catch (Exception e) {
        }
        return null;
    }

    public ItemDTO SearchByCode(String code) {
        return SearchByColumn("item_code", code);
    }

    public ItemDTO SearchByID(String id) {
        return SearchByColumn("item_id", id);
    }

  


    public Boolean SoftDelete(String id) {
        int result = 0;
        try {
            Connection conn = DBUtils.getConnection();
            String sql = "UPDATE Item SET status=0 WHERE item_id =?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, id);
            result = ps.executeUpdate();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return result > 0;
    }

    public boolean Add(ItemDTO i) {
        int result = 0;
        try {
            Connection con = DBUtils.getConnection();
            String sql = "INSERT into Item values(?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, i.getItemCode());
            ps.setString(2, i.getName());
            ps.setString(3, i.getType());
            ps.setDouble(4, i.getStandardCost());
            result = ps.executeUpdate();
        } catch (Exception e) {
        }
        return result > 0;
    }

    public boolean Update(ItemDTO i) {
        int result = 0;
        try {
            Connection con = DBUtils.getConnection();
            String sql = "Update Item SET"
                    + " item_code = ?,"
                    + " name = ?,"
                    + " type = ?,"
                    + " standard_cost = ?"
                    + " Where item_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, i.getItemCode());
            ps.setString(2, i.getName());
            ps.setString(3, i.getType());
            ps.setDouble(4, i.getStandardCost());
            ps.setInt(5, i.getItemID());
            result = ps.executeUpdate();
        } catch (Exception e) {
        }
        return result > 0;
    }
    public int GetCurrentID() {
        try {
            Connection con = DBUtils.getConnection();
            String sql = "SELECT MAX(item_id) as max_id FROM item";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("max_id") + 1;
            }
        } catch (Exception e) {
        }
        return 1;
    }

    public ArrayList<ItemDTO> ItemList() {
        ArrayList<ItemDTO> list = new ArrayList<>();
        try {
            Connection con = DBUtils.getConnection();
            String sql = "SELECT * FROM item WHERE status = 1";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new ItemDTO(rs.getInt("item_id"),
                        rs.getString("item_code"),
                        rs.getString("name"),
                        rs.getString("type"),
                        rs.getDouble("standard_cost")
                ));
            }
        } catch (Exception e) {
        }
        return list;
    }
}
