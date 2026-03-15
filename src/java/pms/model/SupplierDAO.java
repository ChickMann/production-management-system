package pms.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import pms.utils.DBUtils;

public class SupplierDAO {

    public SupplierDTO SearchByID(int id) {
        String sql = "SELECT * FROM Supplier WHERE supplier_id = ?";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new SupplierDTO(rs.getInt("supplier_id"),
                            rs.getString("supplier_name"),
                            rs.getString("contact_phone"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public ArrayList<SupplierDTO> SupplierList() {
        ArrayList<SupplierDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM Supplier";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new SupplierDTO(rs.getInt("supplier_id"),
                        rs.getString("supplier_name"),
                        rs.getString("contact_phone")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean Add(SupplierDTO s) {
        int result = 0;
        String sql = "INSERT INTO Supplier (supplier_name, contact_phone) VALUES (?, ?)";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getSupplierName());
            ps.setString(2, s.getContactPhone());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result > 0;
    }

    public boolean Update(SupplierDTO s) {
        int result = 0;
        String sql = "UPDATE Supplier SET supplier_name = ?, contact_phone = ? WHERE supplier_id = ?";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getSupplierName());
            ps.setString(2, s.getContactPhone());
            ps.setInt(3, s.getSupplierId());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result > 0;
    }

    public boolean Delete(int id) {
        String sql = "DELETE FROM Supplier WHERE supplier_id = ?";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int GetCurrentID() {
        String sql = "SELECT TOP 1 supplier_id FROM Supplier ORDER BY supplier_id DESC";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("supplier_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void ReseedSQL() {
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement("DBCC CHECKIDENT ('Supplier', RESEED, " + GetCurrentID() + ")")) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
