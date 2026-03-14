/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package pms.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import pms.model.UserDAO;
import pms.model.UserDTO;

/**
 *
 * @author BAO
 */
public class UserController extends HttpServlet {

    String url = "";

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        System.err.println(action);

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
        if (session.getAttribute("user") == null) {
            String username = request.getParameter("txtUsername");
            String password = request.getParameter("txtPassword");

            UserDAO udao = new UserDAO();
            UserDTO user = udao.Login(username, password);
            ArrayList<UserDTO> eList = udao.EmployeeList("employee");

            if (user != null) {
                url = "BangDieuKien.jsp";
                session.setAttribute("user", user);
                request.setAttribute("eList", eList);
                if (!user.isStatus()) {
                    url = "Banned.jsp";
                }
            } else {
                url = "login.jsp";
                request.setAttribute("message", "Incorrect User ID or Password");
            }
        } else {
            UserDAO udao = new UserDAO();
            ArrayList<UserDTO> eList = udao.EmployeeList("employee");
            url = "BangDieuKien.jsp";
            request.setAttribute("eList", eList);
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
        request.setAttribute("eList", eList);
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
            String fullName = request.getParameter("fullName");
            String role = request.getParameter("role");

            UserDTO u = new UserDTO(0, username, password, fullName, role, true);
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
        int index = udao.GetCurrentID();

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
        UserDTO u = udao.SearchByID(id + 1);
        request.setAttribute("mode", "update");
        if (action.equals("saveUpdateUser")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String role = request.getParameter("role");
            System.err.println(id);
            System.err.println(password);
            System.err.println(fullName);
            System.err.println(role);
            u = new UserDTO(id, username, password, fullName, role, true);
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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
