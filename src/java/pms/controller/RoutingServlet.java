package pms.controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.RoutingDAO;
import pms.model.RoutingDTO;


/**
 *
 * @author se193234_TranGiaBao
 */
public class RoutingServlet extends HttpServlet {

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

        String action = request.getParameter("action");
        if (action == null) action = "list";

        RoutingDAO dao = new RoutingDAO();

        try {
            switch (action) {
                case "list":
                    List<RoutingDTO> list = dao.getAllRouting();
                    request.setAttribute("listRouting", list);
                    request.getRequestDispatcher("listRouting.jsp").forward(request, response);
                    break;
                case "add":
                    String addName = request.getParameter("routingName");
                    dao.insertRouting(new RoutingDTO(0, addName));
                    response.sendRedirect("RoutingServlet?action=list");
                    break;
                case "delete":
                    int delId = Integer.parseInt(request.getParameter("routingId"));
                    dao.deleteRouting(new RoutingDTO(delId, "")); // Truyền vỏ rỗng
                    response.sendRedirect("RoutingServlet?action=list");
                    break;
                case "load_update":
                    int updId = Integer.parseInt(request.getParameter("routingId"));
                    request.setAttribute("routingEdit", dao.getRoutingById(updId));
                    request.getRequestDispatcher("updateRouting.jsp").forward(request, response);
                    break;
                case "update":
                    int uId = Integer.parseInt(request.getParameter("routingId"));
                    String uName = request.getParameter("routingName");
                    dao.updateRouting(new RoutingDTO(uId, uName));
                    response.sendRedirect("RoutingServlet?action=list");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
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
