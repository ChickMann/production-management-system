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
        String sql = "SELECT * FROM [User] WHERE " + column + " = ?";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, value);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new UserDTO(rs.getInt("user_id"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getString("full_name"),
                            rs.getString("role"),
                            rs.getBoolean("status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public UserDTO SearchByName(String username) {
        return SearchByColumn("username", username);
    }

    public UserDTO SearchByID(int id) {
        String s_id = id + "";
        return SearchByColumn("user_id", s_id);
    }

    public UserDTO Login(String username, String password) {
        UserDTO user = SearchByName(username);
        if (user != null && user.getPassword().equalsIgnoreCase(password)) {
            return user;
        }
        return null;
    }

    public ArrayList<UserDTO> EmployeeList(String role) {
        ArrayList<UserDTO> eList = new ArrayList<>();
        String sql = "SELECT * FROM [User] WHERE status = 1 AND role = ?";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    eList.add(new UserDTO(rs.getInt("user_id") - 1,
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getString("full_name"),
                            rs.getString("role"),
                            rs.getBoolean("status"))
                    );
                }
            }
            return eList;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Boolean SoftDelete(String id) {
        int result = 0;
        String sql = "UPDATE [User] SET status=0 WHERE user_id =?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            result = ps.executeUpdate();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return result > 0;
    }

    public boolean Add(UserDTO u) {
        int result = 0;
        String sql = "INSERT INTO [User] VALUES(?,?,?,?,?)";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getFullName());
            ps.setString(4, u.getRole());
            ps.setBoolean(5, true);
            result = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result > 0;
    }

    public boolean Update(UserDTO u) {
        String sql = "UPDATE [User] SET "
                + " username = ?, "
                + " password = ?, "
                + " full_name = ?, "
                + " role = ?, "
                + " status = ? "
                + " WHERE user_id = ?";

        try ( Connection con = DBUtils.getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getFullName());
            ps.setString(4, u.getRole());
            ps.setBoolean(5, true);
            ps.setInt(6, u.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int GetCurrentID() {
        String sql = "SELECT TOP 1 user_id FROM [User] ORDER BY user_id DESC";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return Integer.parseInt(rs.getString("user_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void ReseedSQL() {
        try ( Connection con = DBUtils.getConnection();  PreparedStatement ps = con.prepareStatement("DBCC CHECKIDENT ('[User]', RESEED, "
                + GetCurrentID() + ")")) {

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
