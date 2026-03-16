/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pms.model;

/**
 *
 * @author BAO
 */
public class UserDTO {

    int id;
    String username, password, role;
    boolean status;

    public UserDTO() {
    }

    public UserDTO(int id, String username , String fullName, String role, boolean status) {
        this.id = id;
        this.username = username;
        this.password = password;

        this.role = role;
        this.status = status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }



    public int getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

   
    public String getRole() {
        return role;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

   

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isStatus() {
        return status;
    }

}
