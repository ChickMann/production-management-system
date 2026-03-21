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
 * @author HP
 */
public class BillDAO {

    private BillDTO SearchByColumn(String column, String value) {
        String sql = "SELECT * FROM [Bill] WHERE " + column + " = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, value);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BillDTO bill = new BillDTO(
                            rs.getInt("bill_id"),
                            rs.getInt("wo_id"),
                            rs.getInt("customer_id"),
                            rs.getDouble("total_amount"),
                            rs.getDate("bill_date"),
                            rs.getString("status")
                    );
                    try {
                        bill.setCustomerName(rs.getString("customer_name"));
                        bill.setProductName(rs.getString("item_name"));
                    } catch (Exception e) {}
                    return bill;
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public ArrayList<BillDTO> getAllBill() {
        ArrayList<BillDTO> list = new ArrayList<>();
        String sql = "SELECT b.*, c.customer_name, i.item_name FROM Bill b "
                   + "LEFT JOIN Customer c ON b.customer_id = c.customer_id "
                   + "LEFT JOIN Work_Order wo ON b.wo_id = wo.wo_id "
                   + "LEFT JOIN Item i ON wo.product_item_id = i.item_id";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                BillDTO b = new BillDTO(
                        rs.getInt("bill_id"),
                        rs.getInt("wo_id"),
                        rs.getInt("customer_id"),
                        rs.getDouble("total_amount"),
                        rs.getDate("bill_date"),
                        rs.getString("status")
                );
                try {
                    b.setCustomerName(rs.getString("customer_name"));
                    b.setProductName(rs.getString("item_name"));
                } catch (Exception e) {}
                list.add(b);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public boolean InsertBill(BillDTO bill) {
        String sql = "INSERT INTO BILL (wo_id, customer_id, total_amount, bill_date) VALUES(?,?,?,?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bill.getWo_id());
            ps.setInt(2, bill.getCustomer_id());
            ps.setDouble(3, bill.getTotal_amount());
            ps.setDate(4, bill.getBill_date());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean UpdateBill(BillDTO bill) {
        String sql = "UPDATE BILL SET wo_id = ?, customer_id = ?, total_amount = ?, bill_date = ?, status = ? WHERE bill_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bill.getWo_id());
            ps.setInt(2, bill.getCustomer_id());
            ps.setDouble(3, bill.getTotal_amount());
            ps.setDate(4, bill.getBill_date());
            ps.setString(5, bill.getStatus());
            ps.setInt(6, bill.getBill_id());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean UpdateBillStatus(int billId, String status) {
        String sql = "UPDATE BILL SET status = ? WHERE bill_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, billId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean deleteBill(int id) {
        String sql = "DELETE FROM Bill WHERE bill_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public ArrayList<BillDTO> searchBill(String keyword) {
        ArrayList<BillDTO> list = new ArrayList<>();
        String sql = "SELECT b.*, c.customer_name, i.item_name FROM Bill b "
                   + "LEFT JOIN Customer c ON b.customer_id = c.customer_id "
                   + "LEFT JOIN Work_Order wo ON b.wo_id = wo.wo_id "
                   + "LEFT JOIN Item i ON wo.product_item_id = i.item_id "
                   + "WHERE b.bill_id LIKE ? OR c.customer_name LIKE ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BillDTO b = new BillDTO(
                            rs.getInt("bill_id"),
                            rs.getInt("wo_id"),
                            rs.getInt("customer_id"),
                            rs.getDouble("total_amount"),
                            rs.getDate("bill_date"),
                            rs.getString("status")
                    );
                    try {
                        b.setCustomerName(rs.getString("customer_name"));
                        b.setProductName(rs.getString("item_name"));
                    } catch (Exception e) {}
                    list.add(b);
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public BillDTO SearchByBillID(String id) {
        return SearchByColumn("bill_id", id);
    }

    public BillDTO SearchByCustomerID(String id){
        return SearchByColumn("customer_id", id);
    }

    public java.util.ArrayList<Double> getMonthlyRevenue() {
        java.util.ArrayList<Double> revenueList = new java.util.ArrayList<>();
        for (int i = 0; i < 12; i++) {
            revenueList.add(0.0);
        }

        String sql = "SELECT MONTH(bill_date) as Month, SUM(total_amount) as Total "
                   + "FROM Bill "
                   + "WHERE YEAR(bill_date) = YEAR(GETDATE()) "
                   + "GROUP BY MONTH(bill_date)";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int month = rs.getInt("Month");
                double total = rs.getDouble("Total");
                revenueList.set(month - 1, total);
            }
        } catch (Exception e) {
            System.out.println("Loi load bieu do: " + e.getMessage());
        }
        return revenueList;
    }
}
