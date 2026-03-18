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

        switch (action) {
            case "loginUser":
                DoLogin(request);
                break;
            case "logoutUser":
                DoLogout(request);
                break;
            case "addUser":
            case "saveAddUser":
                AddUser(request);
                break;
            case "removeUser":
                RemoveUser(request);
                break;
            case "updateUser":
            case "saveUpdateUser":
                UpdateUser(request);
                break;
        }

        request.getRequestDispatcher(url).forward(request, response);
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
            }
        }

        if (user != null) {
            if (!user.isStatus()) {
                url = "Banned.jsp";
            } else {
                url = "BangDieuKien.jsp";
                if (user.getRole().equals("admin")) {
                    ArrayList<UserDTO> eList = udao.EmployeeList("employee");
                    session.setAttribute("eList", eList);
                }
            }
        } else {
            url = "login.jsp";
            request.setAttribute("message", "Incorrect User ID or Password");
        }
    }

    private void DoLogout(HttpServletRequest request) {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") != null) {
            session.invalidate();
            url = "login.jsp";
        }
    }

    private void RemoveUser(HttpServletRequest request) {
        String id = request.getParameter("id");
        UserDAO udao = new UserDAO();

        if (!id.isEmpty()) {
            boolean check = udao.SoftDelete(id);
            if (check) {
                request.setAttribute("msg", "Deleted!");
            } else {
                request.setAttribute("msg", "Error, can not delete: " + id);
            }
        }
        ArrayList<UserDTO> eList = udao.EmployeeList("employee");
        request.getSession().setAttribute("eList", eList);
        url = "BangDieuKien.jsp";
    }

    private void AddUser(HttpServletRequest request) {
        String msg = "";
        String error = "";

        UserDAO udao = new UserDAO();
        String action = request.getParameter("action");
        request.setAttribute("mode", "add");
        if (action.equals("saveAddUser")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String fullName = request.getParameter("fullName");

            UserDTO u = new UserDTO(0, username, password, role, fullName, true);
            if (error.isEmpty()) {
                if (udao.Add(u)) {
                    msg = "Add thanh cong";
                } else {
                    error = "Add that bai";
                    udao.ReseedSQL();
                }
            }

            request.setAttribute("user", u);
            request.setAttribute("msg", msg);
            request.setAttribute("error", error);
        }
        int index = udao.GetCurrentID()+1;

        if (index > 0) {
            request.setAttribute("index", index);
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
            id = Integer.parseInt(s_id);
        } catch (Exception e) {
            error += "id phai la so nguyen duong";
        }
        UserDTO u = udao.SearchByID(id);
        request.setAttribute("mode", "update");
        if (action.equals("saveUpdateUser")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String fullName = request.getParameter("fullName");
            u = new UserDTO(id, username, password, role, fullName, true);
            if (error.isEmpty()) {
                if (udao.Update(u)) {
                    msg = "update thanh cong";
                } else {
                    error = "update that bai";
                }
            }

            request.setAttribute("msg", msg);
            request.setAttribute("error", error);
        }

        request.setAttribute("u", u);
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

}
