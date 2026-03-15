package pms.model;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import pms.utils.DBUtils;

public class PurchaseOrderDAO {

    public PurchaseOrderDTO SearchByID(int id) {
        String sql = "SELECT * FROM Purchase_Order WHERE po_id = ?";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new PurchaseOrderDTO(
                            rs.getInt("po_id"),
                            rs.getInt("item_id"),
                            rs.getInt("supplier_id"),
                            rs.getInt("required_quantity"),
                            rs.getDate("alert_date"),
                            rs.getString("status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public ArrayList<PurchaseOrderDTO> PurchaseOrderList() {
        ArrayList<PurchaseOrderDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM Purchase_Order";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new PurchaseOrderDTO(
                        rs.getInt("po_id"),
                        rs.getInt("item_id"),
                        rs.getInt("supplier_id"),
                        rs.getInt("required_quantity"),
                        rs.getDate("alert_date"),
                        rs.getString("status")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean Add(PurchaseOrderDTO po) {
        int result = 0;
        String sql = "INSERT INTO Purchase_Order (item_id, supplier_id, required_quantity, alert_date, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, po.getItemId());
            ps.setInt(2, po.getSupplierId());
            ps.setInt(3, po.getRequiredQuantity());
            ps.setDate(4, new Date(po.getAlertDate().getTime()));
            ps.setString(5, po.getStatus());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result > 0;
    }

    public boolean Update(PurchaseOrderDTO po) {
        int result = 0;
        String sql = "UPDATE Purchase_Order SET item_id = ?, supplier_id = ?, required_quantity = ?, alert_date = ?, status = ? WHERE po_id = ?";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, po.getItemId());
            ps.setInt(2, po.getSupplierId());
            ps.setInt(3, po.getRequiredQuantity());
            ps.setDate(4, new Date(po.getAlertDate().getTime()));
            ps.setString(5, po.getStatus());
            ps.setInt(6, po.getPoId());
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result > 0;
    }

    public boolean Delete(int id) {
        String sql = "DELETE FROM Purchase_Order WHERE po_id = ?";
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
        String sql = "SELECT TOP 1 po_id FROM Purchase_Order ORDER BY po_id DESC";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("po_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void ReseedSQL() {
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement("DBCC CHECKIDENT ('Purchase_Order', RESEED, " + GetCurrentID() + ")")) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
