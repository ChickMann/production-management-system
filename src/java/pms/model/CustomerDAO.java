/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pms.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import pms.utils.DBUtils;

/**
 *
 * @author HP
 */
public class CustomerDAO {

    public List<CustomerDTO> getAllCustomers() {
        List<CustomerDTO> list = new ArrayList<>();
        try {
            Connection conn = DBUtils.getConnection();
            String sql = "SELECT * FROM Customer";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CustomerDTO c = new CustomerDTO(
                        rs.getInt("customer_id"),
                        rs.getString("customer_name"),
                        rs.getString("phone"),
                        rs.getString("email")
                );
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm khách hàng
    public boolean insertCustomer(CustomerDTO c) {
        try {
            Connection conn = DBUtils.getConnection();
            String sql = "INSERT INTO Customer(customer_name, phone, email) VALUES(?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, c.getCustomer_name());
            ps.setString(2, c.getPhone());
            ps.setString(3, c.getEmail());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Cập nhật khách hàng
    public boolean updateCustomer(CustomerDTO c) {
        try {
            Connection conn = DBUtils.getConnection();
            String sql = "UPDATE Customer SET customer_name=?, phone=?, email=? WHERE customer_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, c.getCustomer_name());
            ps.setString(2, c.getPhone());
            ps.setString(3, c.getEmail());
            ps.setInt(4, c.getCustomer_id());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa khách hàng
    public boolean deleteCustomer(int id) {
        try {
            Connection conn = DBUtils.getConnection();
            String sql = "DELETE FROM Customer WHERE customer_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private CustomerDTO SearchByColumn(String column, String value) {
    try {
        Connection conn = DBUtils.getConnection();
        String sql = "SELECT * FROM Customer WHERE " + column + " = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, value);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return new CustomerDTO(
                    rs.getInt("customer_id"),
                    rs.getString("customer_name"),
                    rs.getString("phone"),
                    rs.getString("email")
            );
        }

    } catch (Exception e) {
        System.out.println(e.getMessage());
    }

    return null;
}

    public CustomerDTO SearchByCustomerID(String id) {
        return SearchByColumn("customer_id", id);
    }
    
    public CustomerDTO SearchByCustomerName(String id) {
        return SearchByColumn("customer_name", id);
    }
}
