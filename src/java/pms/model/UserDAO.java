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
public class UserDAO {

    private UserDTO SearchByColumn(String column, String value) {
        try {
            Connection con = DBUtils.getConnection();
            String sql = "SELECT * FROM [User] WHERE " + column + " = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, value);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new UserDTO(rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("full_name"),
                        rs.getString("role"),
                        rs.getBoolean("status")
                );
            }
        } catch (Exception e) {
        }
        return null;
    }

    public UserDTO SearchByName(String username) {
        return SearchByColumn("username", username);
    }

    public UserDTO SearchByID(String id) {
        return SearchByColumn("user_id", id);
    }

    public UserDTO Login(String username, String password) {
        UserDTO user = SearchByName(username);
        if (user != null && user.getPassword().equalsIgnoreCase(password)) {
            return user;
        }
        return null;
    }

    public ArrayList<UserDTO> EmployeeList() {
        ArrayList<UserDTO> eList = new ArrayList<>();
        try {
            Connection con = DBUtils.getConnection();
            String sql = "SELECT * FROM [User] WHERE status = 1 AND role = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "employee");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                eList.add(new UserDTO(rs.getInt("user_id") - 1,
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("full_name"),
                        rs.getString("role"),
                        rs.getBoolean("status"))
                );

            }
            return eList;
        } catch (Exception e) {
        }
        return null;
    }

    public Boolean SoftDelete(String id) {
        int result = 0;
        try {
            Connection conn = DBUtils.getConnection();
            String sql = "UPDATE [User] SET status=0 WHERE user_id =?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, id);
            result = ps.executeUpdate();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return result > 0;
    }

    public boolean Add(UserDTO u) {
        int result = 0;
        try {
            Connection con = DBUtils.getConnection();
            String sql = "INSERT into [User] values(?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, u.getId());
            ps.setString(2, u.getUsername());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getFullName());
            ps.setString(5, u.getRole());
            ps.setBoolean(6, true);
            result = ps.executeUpdate();
        } catch (Exception e) {
        }
        return result > 0;
    }

    public boolean Update(UserDTO u) {
        int result = 0;
        try {
            Connection con = DBUtils.getConnection();
            String sql = "Update [User] SET"
                    + " username = ?"
                    + " password = ?"
                    + " full_name = ?"
                    + " role = ?"
                    + " status = ?"
                    + " Where user_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getFullName());
            ps.setString(4, u.getRole());
            ps.setBoolean(5, true);
            ps.setInt(6, u.getId());
            result = ps.executeUpdate();
        } catch (Exception e) {
        }
        return result > 0;
    }
    
    public int GetNextID(){
        try {
            Connection con = DBUtils.getConnection();
            String sql = "SELECT TOP 1 user_id FROM [User] ORDER BY user_id DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
               
                return Integer.parseInt(rs.getString("user_id"))+1;
            }
        } catch (Exception e) {
        }
        return -1;
    }
}
