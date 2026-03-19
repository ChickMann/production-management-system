package pms.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import pms.utils.DBUtils;

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

    // ==========================================
    // HÀM MỚI: Lấy doanh thu theo từng tháng để vẽ biểu đồ
    // ==========================================
    public ArrayList<Double> getMonthlyRevenue() {
        ArrayList<Double> revenueList = new ArrayList<>();
        // Khởi tạo 12 tháng với giá trị 0
        for(int i=0; i<12; i++) {
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
                // Index mảng bắt đầu từ 0 (Tháng 1 = index 0)
                revenueList.set(month - 1, total);
            }
        } catch (Exception e) {
            System.out.println("Lỗi load biểu đồ: " + e.getMessage());
        }
        return revenueList;
    }
}