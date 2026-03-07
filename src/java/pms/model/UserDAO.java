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

    private UserDTO FilterByName(String username) {
        try {
            Connection con = DBUtils.getConnection();
            String sql = "SELECT * FROM [User] WHERE username = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new UserDTO(rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("full_name"),
                        rs.getString("role")
                );
            }
        } catch (Exception e) {
        }
        return null;
    }
    
    public UserDTO Login(String username, String password){
        UserDTO user = FilterByName(username);
        if(user!=null && user.getPassword().equalsIgnoreCase(password)){
            return user;
        }
        return null;
    }
    
    public ArrayList<UserDTO> EmployeeList(){
        ArrayList<UserDTO> eList = new ArrayList<>();
         try {
            Connection con = DBUtils.getConnection();
            String sql = "SELECT * FROM [User] WHERE role = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "employee");
            ResultSet rs = ps.executeQuery();
             while (rs.next()) {                 
                 eList.add(new UserDTO(rs.getInt("user_id")-1,
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("full_name"),
                        rs.getString("role"))
                );
                 
             }
            return eList;
        } catch (Exception e) {
        }
        return null;
    }
}
