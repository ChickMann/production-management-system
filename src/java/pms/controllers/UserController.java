package pms.controllers;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import pms.model.UserDAO;
import pms.model.UserDTO;

public class UserController extends HttpServlet {

    String url = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "loginUser":
                DoLogin(request);
                break;
            case "logoutUser":
            case "logout":
                DoLogout(request);
                break;
            case "list":
                listUsers(request);
                break;
            case "search":
                searchUsers(request);
                break;
            case "add":
                request.setAttribute("mode", "add");
                url = "user-form.jsp";
                break;
            case "addUser":
            case "saveAddUser":
                AddUser(request);
                break;
            case "removeUser":
                RemoveUser(request);
                break;
            case "edit":
            case "updateUser":
            case "saveUpdateUser":
                UpdateUser(request);
                break;
            case "view":
            case "viewUser":
                viewUser(request);
                break;
            case "lockUser":
                lockUser(request);
                break;
            case "unlockUser":
                unlockUser(request);
                break;
            case "resetPassword":
                resetPassword(request);
                break;
            case "changePassword":
                changePassword(request);
                break;
            case "changeOwnPassword":
                changeOwnPassword(request);
                break;
            case "updateProfile":
                updateProfile(request);
                break;
            case "viewProfile":
                viewProfile(request);
                break;
            case "changePasswordForm":
                doChangePassword(request, response);
                return;
        }

        if (url != null && url.startsWith("redirect:")) {
            response.sendRedirect(url.substring(9));
        } else {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private void DoLogin(HttpServletRequest request) {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        UserDAO udao = new UserDAO();

        if (user == null) {
            String username = request.getParameter("txtUsername");
            String password = request.getParameter("txtPassword");
            user = udao.Login(username, password);
            if (user != null) {
                session.setAttribute("user", user);
            } else {
                session.setAttribute("loginMessage", "Incorrect User ID or Password");
                session.setAttribute("loginUsername", username);
            }
        }

        if (user != null) {
            if (!user.isActive()) {
                url = "Banned.jsp";
            } else {
                url = "DashboardController";
                if (user.getRole().equals("admin")) {
                    ArrayList<UserDTO> eList = udao.getUsersByRole("employee");
                    session.setAttribute("eList", eList);
                }
            }
        } else {
            url = "redirect:login.jsp";
        }
    }

    private void DoLogout(HttpServletRequest request) {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") != null) {
            session.invalidate();
        }
        url = "redirect:login.jsp";
    }

    private void listUsers(HttpServletRequest request) {
        UserDAO udao = new UserDAO();
        String roleFilter = request.getParameter("role");
        
        ArrayList<UserDTO> users;
        if (roleFilter != null && !roleFilter.isEmpty() && !"all".equals(roleFilter)) {
            users = udao.getUsersByRole(roleFilter);
            request.setAttribute("role", roleFilter);
        } else {
            users = udao.getAllUsers();
        }
        
        request.setAttribute("users", users);
        url = "user-list.jsp";
    }

    private void searchUsers(HttpServletRequest request) {
        UserDAO udao = new UserDAO();
        String keyword = request.getParameter("keyword");
        String role = request.getParameter("role");

        ArrayList<UserDTO> users;
        if (role != null && !role.isEmpty() && !role.equals("all")) {
            users = udao.getUsersByRole(role);
        } else {
            users = udao.getAllUsers();
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            final String kw = keyword.toLowerCase();
            users.removeIf(u -> {
                boolean matchUsername = u.getUsername() != null && u.getUsername().toLowerCase().contains(kw);
                boolean matchFullName = u.getFullName() != null && u.getFullName().toLowerCase().contains(kw);
                boolean matchEmail = u.getEmail() != null && u.getEmail().toLowerCase().contains(kw);
                boolean matchPhone = u.getPhone() != null && u.getPhone().toLowerCase().contains(kw);
                return !matchUsername && !matchFullName && !matchEmail && !matchPhone;
            });
        }

        request.setAttribute("users", users);
        request.setAttribute("keyword", keyword);
        request.setAttribute("role", role);
        url = "user-list.jsp";
    }

    private void viewUser(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        int id = 0;
        try {
            id = Integer.parseInt(s_id);
        } catch (Exception e) {
            request.setAttribute("error", "Invalid user ID");
            url = "redirect:UserController?action=list";
            return;
        }

        UserDAO udao = new UserDAO();
        UserDTO user = udao.SearchByID(id);
        request.setAttribute("user", user);
        url = "user-detail.jsp";
    }

    private void RemoveUser(HttpServletRequest request) {
        String id = request.getParameter("id");
        UserDAO udao = new UserDAO();

        if (id != null && !id.isEmpty()) {
            boolean check = udao.Delete(Integer.parseInt(id));
            if (check) {
                request.setAttribute("msg", "Deleted!");
            } else {
                request.setAttribute("error", "Cannot delete user: " + id);
            }
        }
        url = "redirect:UserController?action=list";
    }

    private void lockUser(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        UserDAO udao = new UserDAO();

        try {
            int id = Integer.parseInt(s_id);
            boolean success = udao.lockUser(id);
            if (success) {
                request.setAttribute("msg", "User locked successfully!");
            } else {
                request.setAttribute("error", "Failed to lock user");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid user ID");
        }
        url = "redirect:UserController?action=list";
    }

    private void unlockUser(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        UserDAO udao = new UserDAO();

        try {
            int id = Integer.parseInt(s_id);
            boolean success = udao.unlockUser(id);
            if (success) {
                request.setAttribute("msg", "User unlocked successfully!");
            } else {
                request.setAttribute("error", "Failed to unlock user");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid user ID");
        }
        url = "redirect:UserController?action=list";
    }

    private void resetPassword(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        UserDAO udao = new UserDAO();
        String defaultPassword = "123456";

        try {
            int id = Integer.parseInt(s_id);
            boolean success = udao.resetPassword(id, defaultPassword);
            if (success) {
                request.setAttribute("msg", "Password reset to: " + defaultPassword);
            } else {
                request.setAttribute("error", "Failed to reset password");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid user ID");
        }
        url = "redirect:UserController?action=list";
    }

    private void changePassword(HttpServletRequest request) {
        HttpSession session = request.getSession();
        UserDTO currentUser = (UserDTO) session.getAttribute("user");

        if (currentUser == null || !currentUser.getRole().equals("admin")) {
            request.setAttribute("error", "Unauthorized");
            url = "redirect:login.jsp";
            return;
        }

        String s_id = request.getParameter("id");
        String newPassword = request.getParameter("newPassword");

        UserDAO udao = new UserDAO();

        try {
            int id = Integer.parseInt(s_id);
            boolean success = udao.resetPassword(id, newPassword);
            if (success) {
                request.setAttribute("msg", "Password changed successfully!");
            } else {
                request.setAttribute("error", "Failed to change password");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid user ID");
        }
        url = "redirect:UserController?action=list";
    }

    private void changeOwnPassword(HttpServletRequest request) {
        HttpSession session = request.getSession();
        UserDTO currentUser = (UserDTO) session.getAttribute("user");

        if (currentUser == null) {
            url = "redirect:login.jsp";
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New passwords do not match");
            url = "change-password.jsp";
            return;
        }

        UserDAO udao = new UserDAO();
        boolean success = udao.changePassword(currentUser.getId(), oldPassword, newPassword);

        if (success) {
            request.setAttribute("msg", "Password changed successfully!");
        } else {
            request.setAttribute("error", "Old password is incorrect");
        }
        url = "change-password.jsp";
    }

    private void AddUser(HttpServletRequest request) {
        String msg = "";
        String error = "";

        UserDAO udao = new UserDAO();
        String action = request.getParameter("action");

        if (action.equals("saveAddUser")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String status = request.getParameter("status") != null ? request.getParameter("status") : "active";

            if (udao.isUsernameExists(username, null)) {
                error = "Username already exists";
                // Reload user list and show modal with error
                request.setAttribute("users", udao.getAllUsers());
                request.setAttribute("showModal", true);
                request.setAttribute("error", error);
                url = "user-list.jsp";
                return;
            } else {
                UserDTO u = new UserDTO();
                u.setUsername(username);
                u.setPassword(password);
                u.setRole(role);
                u.setFullName(fullName);
                u.setEmail(email);
                u.setPhone(phone);
                u.setStatus(status);

                if (udao.Add(u)) {
                    msg = "Thêm người dùng thành công!";
                    url = "redirect:UserController?action=list";
                    return;
                } else {
                    error = "Failed to add user";
                    udao.ReseedSQL();
                    request.setAttribute("users", udao.getAllUsers());
                    request.setAttribute("showModal", true);
                    request.setAttribute("error", error);
                    url = "user-list.jsp";
                    return;
                }
            }
        }

        url = "user-form.jsp";
    }

    private void UpdateUser(HttpServletRequest request) {
        String msg = "";
        String error = "";

        UserDAO udao = new UserDAO();
        String action = request.getParameter("action");
        String s_id = request.getParameter("id");
        int id = 0;
        try {
            if (s_id != null && !s_id.isEmpty()) {
                id = Integer.parseInt(s_id);
            }
        } catch (Exception e) {
            error += "ID must be a number";
        }

        UserDTO existingUser = udao.SearchByID(id);

        if (action.equals("saveUpdateUser")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");

            if (udao.isUsernameExists(username, id)) {
                error = "Username already exists";
                // Reload user list and show edit modal with error
                request.setAttribute("users", udao.getAllUsers());
                request.setAttribute("showEditModal", true);
                request.setAttribute("editUser", existingUser);
                request.setAttribute("error", error);
                url = "user-list.jsp";
                return;
            } else {
                UserDTO u = new UserDTO();
                u.setId(id);
                u.setUsername(username);
                u.setPassword(password != null && !password.isEmpty() ? password : existingUser.getPassword());
                u.setRole(role);
                u.setFullName(fullName);
                u.setEmail(email);
                u.setPhone(phone);
                u.setStatus(status);

                if (udao.Update(u)) {
                    msg = "Cập nhật người dùng thành công!";
                    url = "redirect:UserController?action=list";
                    return;
                } else {
                    error = "Failed to update user";
                    request.setAttribute("users", udao.getAllUsers());
                    request.setAttribute("showEditModal", true);
                    request.setAttribute("editUser", existingUser);
                    request.setAttribute("error", error);
                    url = "user-list.jsp";
                    return;
                }
            }
        }

        request.setAttribute("editUser", existingUser);
        url = "user-form.jsp";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "User Controller";
    }

    // ========== PROFILE METHODS ==========
    
    private void viewProfile(HttpServletRequest request) {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null) {
            url = "redirect:login.jsp";
            return;
        }
        // Refresh user data from DB
        UserDAO udao = new UserDAO();
        UserDTO freshUser = udao.SearchByID(user.getId());
        if (freshUser != null) {
            session.setAttribute("user", freshUser);
        }
        url = "profile.jsp";
    }
    
    private void updateProfile(HttpServletRequest request) {
        HttpSession session = request.getSession();
        UserDTO currentUser = (UserDTO) session.getAttribute("user");
        if (currentUser == null) {
            url = "redirect:login.jsp";
            return;
        }
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        UserDAO udao = new UserDAO();
        UserDTO u = new UserDTO();
        u.setId(currentUser.getId());
        u.setUsername(currentUser.getUsername());
        u.setPassword(currentUser.getPassword()); // Keep existing password
        u.setRole(currentUser.getRole());
        u.setStatus(currentUser.getStatus());
        u.setFullName(fullName);
        u.setEmail(email);
        u.setPhone(phone);
        
        boolean success = udao.Update(u);
        
        if (success) {
            // Refresh session with updated user
            UserDTO updatedUser = udao.SearchByID(currentUser.getId());
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
            }
            request.setAttribute("success", "Cap nhat thong tin thanh cong!");
        } else {
            request.setAttribute("error", "Loi khi cap nhat thong tin!");
        }
        
        url = "profile.jsp";
    }
    
    private void doChangePassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO currentUser = (UserDTO) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate
        if (currentPassword == null || newPassword == null || confirmPassword == null ||
            currentPassword.isEmpty() || newPassword.isEmpty()) {
            request.setAttribute("error", "Vui long nhap day du thong tin!");
            url = "profile.jsp";
            request.getRequestDispatcher(url).forward(request, response);
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mat khau moi khong khop!");
            url = "profile.jsp";
            request.getRequestDispatcher(url).forward(request, response);
            return;
        }
        
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mat khau moi phai it nhat 6 ky tu!");
            url = "profile.jsp";
            request.getRequestDispatcher(url).forward(request, response);
            return;
        }
        
        // Verify current password
        UserDAO udao = new UserDAO();
        if (!udao.verifyPassword(currentUser.getId(), currentPassword)) {
            request.setAttribute("error", "Mat khau hien tai khong dung!");
            url = "profile.jsp";
            request.getRequestDispatcher(url).forward(request, response);
            return;
        }
        
        // Change password
        boolean success = udao.resetPassword(currentUser.getId(), newPassword);
        
        if (success) {
            request.setAttribute("success", "Doi mat khau thanh cong!");
        } else {
            request.setAttribute("error", "Loi khi doi mat khau!");
        }
        
        url = "profile.jsp";
        request.getRequestDispatcher(url).forward(request, response);
    }
}
