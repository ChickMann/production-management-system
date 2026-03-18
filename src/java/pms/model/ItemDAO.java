package pms.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import pms.utils.DBUtils;

public class ItemDAO {

    private ItemDTO SearchByColumn(String column, String value) {
        String sql = "SELECT * FROM Item WHERE " + column + " = ?";
        try (Connection con = DBUtils.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, value);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new ItemDTO(rs.getInt("item_id"),
                            rs.getString("item_name"),
                            rs.getString("item_type"),
                            rs.getInt("stock_quantity"),
                            rs.getString("image_base64"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private ArrayList<ItemDTO> FilterByColumn(String column, String value) {
        ArrayList<ItemDTO> iList = new ArrayList<>();
        String sql = "SELECT * FROM Item WHERE " + column + " LIKE ?";
        try (Connection con = DBUtils.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + value + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    iList.add(new ItemDTO(rs.getInt("item_id"),
                            rs.getString("item_name"),
                            rs.getString("item_type"),
                            rs.getInt("stock_quantity"),
                            rs.getString("image_base64")));
                }
            }
            return iList;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public ItemDTO SearchByCode(String code) {
        return SearchByColumn("item_code", code);
    }

    public ItemDTO SearchByID(String id) {
        return SearchByColumn("item_id", id);
    }

    public ArrayList<ItemDTO> FilterByName(String name) {
        return FilterByColumn("item_name", name);
    }

    public Boolean SoftDelete(String id) {
        String sql = "DELETE FROM Item WHERE item_id =?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean Add(ItemDTO i) {
        String sql = "INSERT into Item (item_name, item_type, stock_quantity, image_base64) values(?,?,?,?)";
        try (Connection con = DBUtils.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, i.getItemName());
            ps.setString(2, i.getItemType());
            ps.setInt(3, i.getStockQuantity());
            ps.setString(4, i.getImageBase64());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean Update(ItemDTO i) {
        String sql = "Update Item SET item_name = ?, item_type = ?, stock_quantity = ?, image_base64 = ? Where item_id = ?";

        try (Connection con = DBUtils.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, i.getItemName());
            ps.setString(2, i.getItemType());
            ps.setInt(3, i.getStockQuantity());
            ps.setString(4, i.getImageBase64());
            ps.setInt(5, i.getItemID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int GetCurrentID() {
        String sql = "SELECT MAX(item_id) as max_id FROM item";
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

    public ArrayList<ItemDTO> ItemList() {
        ArrayList<ItemDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM Item";
        try (Connection con = DBUtils.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ItemDTO(rs.getInt("item_id"),
                        rs.getString("item_name"),
                        rs.getString("item_type"),
                        rs.getInt("stock_quantity"),
                        rs.getString("image_base64")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void ReseedSQL() {
        try (Connection con = DBUtils.getConnection();
                PreparedStatement ps = con
                        .prepareStatement("DBCC CHECKIDENT ('item', RESEED, " + GetCurrentID() + ")")) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
