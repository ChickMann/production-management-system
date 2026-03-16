/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package pms.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.WorkOrderDAO;
import pms.model.WorkOrderDTO;

/**
 *
 * @author HP
 */
public class WorkOrderController extends HttpServlet {

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
        WorkOrderDAO dao = new WorkOrderDAO();

        try {
            if ("insert".equals(action)) {
                int product = Integer.parseInt(request.getParameter("product_item_id"));
                int routing = Integer.parseInt(request.getParameter("routing_id"));
                int quantity = Integer.parseInt(request.getParameter("order_quantity"));
                String status = request.getParameter("status");

                WorkOrderDTO wo = new WorkOrderDTO(0, product, routing, quantity, status);
                dao.insertWorkOrder(wo);
                response.sendRedirect("workorder.jsp");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("wo_id"));
                int product = Integer.parseInt(request.getParameter("product_item_id"));
                int routing = Integer.parseInt(request.getParameter("routing_id"));
                int quantity = Integer.parseInt(request.getParameter("order_quantity"));
                String status = request.getParameter("status");

                WorkOrderDTO wo = new WorkOrderDTO(id, product, routing, quantity, status);
                dao.updateWorkOrder(wo);
                response.sendRedirect("workorder.jsp");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("wo_id"));
                dao.deleteWorkOrder(id);
                response.sendRedirect("workorder.jsp");

            } else if ("search".equals(action)) {
                int id = Integer.parseInt(request.getParameter("wo_id"));
                WorkOrderDTO wo = dao.searchById(id);
                request.setAttribute("WORKORDER", wo);
                request.getRequestDispatcher("workorder.jsp").forward(request, response);
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
