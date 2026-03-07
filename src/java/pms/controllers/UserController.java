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

        switch (action) {
            case "login":
                DoLogin(request);
                break;
            case "logout":
                DoLogout(request);
                break;
            case "addUser":
                DoLogin(request);
                break;
            case "removeUser":
                DoLogin(request);
                break;
            case "updateUser":
                DoLogin(request);
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
            ArrayList<UserDTO> eList = udao.EmployeeList();
            if (user != null) {
                url = "BangDieuKien.jsp";
                session.setAttribute("user", user);
                request.setAttribute("eList", eList);
            } else {
                url = "login.jsp";
                request.setAttribute("message", "Incorrect User ID or Password");
            }
        } else {
            UserDAO udao = new UserDAO();
            ArrayList<UserDTO> eList = udao.EmployeeList();
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

    private void RemoveUser() {

    }

    private void AddUser() {

    }

    private void UpdateUser() {

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
