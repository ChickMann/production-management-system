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
public class WorkOrderDAO {

    public ArrayList<WorkOrderDTO> filterByColumn(String column, String value) {

        ArrayList<WorkOrderDTO> result = new ArrayList<>();
        try {
            Connection conn = DBUtils.getConnection();
            String sql = "SELECT * FROM Work_Order WHERE " + column + " LIKE ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + value + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int wo_id = rs.getInt("wo_id");
                int product_item_id = rs.getInt("product_item_id");
                int routing = rs.getInt("routing_id");
                int order_quantity = rs.getInt("order_quantity");
                String status = rs.getString("status");
                
                WorkOrderDTO wo = new WorkOrderDTO(wo_id, product_item_id, routing, order_quantity, status);
                result.add(wo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public boolean insertWorkOrder(WorkOrderDTO wo){
        try {
            String sql = "INSERT INTO Work_Order(product_item_id, routing_id, order_quantity, status) VALUES(?, ?, ?, ?)";
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps =conn.prepareStatement(sql);
            
            ps.setInt(1, wo.getProduct_item_id());
            ps.setInt(2, wo.getRouting_id());
            ps.setInt(3, wo.getOrder_quantity());
            ps.setString(4, wo.getStatus());
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateWorkOrder(WorkOrderDTO wo){
        try {
            String sql = "Update Work_Order SET product_item_id = ?, routing_id = ?, order_quantity = ?, status = ? WHERE wo_id = ?";
            Connection conn =DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            
            ps.setInt(1, wo.getProduct_item_id());
            ps.setInt(2, wo.getRouting_id());
            ps.setInt(3, wo.getOrder_quantity());
            ps.setString(4, wo.getStatus());
            ps.setInt(5, wo.getWo_id());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteWorkOrder(int id){
        try {
            String sql = "DELETE FROM Work_Order WHERE wo_id = ?";
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public WorkOrderDTO searchById(int id){
        try {
            String sql = "SELECT * FROM Work_Order WHERE wo_id = ?";
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()){
                return new WorkOrderDTO(
                        rs.getInt("wo_id"),
                        rs.getInt("product_item_id"),
                        rs.getInt("routing_id"),
                        rs.getInt("order_quantity"),
                        rs.getString("status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
