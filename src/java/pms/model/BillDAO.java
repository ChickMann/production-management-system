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
        try {
            Connection conn = DBUtils.getConnection();
            String sql = "SELECT * FROM [Bill] WHERE " + column + "= ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, value);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new BillDTO(
                        rs.getInt("bill_id"),
                        rs.getInt("wo_id"),
                        rs.getInt("customer_id"),
                        rs.getDouble("total_amount"),
                        rs.getDate("bill_date")
                );
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());

        }
        return null;
    }

    public ArrayList<BillDTO> getAllBill() {
        ArrayList<BillDTO> list = new ArrayList<>();
        try {
            Connection conn = DBUtils.getConnection();
            String sql = "SELECT * FROM Bill";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new BillDTO(
                        rs.getInt("bill_id"),
                        rs.getInt("wo_id"),
                        rs.getInt("customer_id"),
                        rs.getDouble("total_amount"),
                        rs.getDate("bill_date")
                ));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public boolean InsertBill(BillDTO bill) {
        int result = 0;
        try {
            Connection conn = DBUtils.getConnection();
            String sql = "INSERT INTO BILL (wo_id, customer_id, total_amount, bill_date) VALUES(?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, bill.getWo_id());
            ps.setInt(2, bill.getCustomer_id());
            ps.setDouble(3, bill.getTotal_amount());
            ps.setDate(4, bill.getBill_date());

            result = ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return result > 0;
    }

    public boolean UpdateBill(BillDTO bill) {
        int result = 0;

        try {
            Connection conn = DBUtils.getConnection();
            String sql = "UPDATE BILL SET wo_id = ?, customer_id = ?, total_amount = ?, bill_date = ? WHERE bill_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, bill.getWo_id());
            ps.setInt(2, bill.getCustomer_id());
            ps.setDouble(3, bill.getTotal_amount());
            ps.setDate(4, bill.getBill_date());
            ps.setInt(5, bill.getBill_id());

            result = ps.executeUpdate();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return result > 0;
    }

    public boolean deleteBill(int id) {
        int result = 0;
        try {
            Connection conn = DBUtils.getConnection();
            String sql = "DELETE FROM Bill WHERE bill_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            result = ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return result > 0;
    }
    
    public ArrayList<BillDTO> searchBill(String keyword) {

    ArrayList<BillDTO> list = new ArrayList<>();

    try {
        Connection conn = DBUtils.getConnection();

        String sql = "SELECT * FROM Bill WHERE bill_id LIKE ?";

        PreparedStatement ps = conn.prepareStatement(sql);

        ps.setString(1, "%" + keyword + "%");

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            list.add(new BillDTO(
                    rs.getInt("bill_id"),
                    rs.getInt("wo_id"),
                    rs.getInt("customer_id"),
                    rs.getDouble("total_amount"),
                    rs.getDate("bill_date")
            ));
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

}
