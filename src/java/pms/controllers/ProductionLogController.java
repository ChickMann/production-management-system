/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package pms.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.ProductionLogDAO;
import pms.model.ProductionLogDTO;

/**
 *
 * @author HP
 */
public class ProductionLogController extends HttpServlet {

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
        ProductionLogDAO dao = new ProductionLogDAO();
        try {
            if (action == null || action.equals("list")) {
                List<ProductionLogDTO> list = dao.getAllLogs();
                request.setAttribute("logs", list);
                request.getRequestDispatcher("productionlog.jsp").forward(request, response);
            }
            if (action.equals("insert")) {
                int woId = Integer.parseInt(request.getParameter("woId"));
                int stepId = Integer.parseInt(request.getParameter("stepId"));
                int workerUserId = Integer.parseInt(request.getParameter("workerUserId"));
                int quantity = Integer.parseInt(request.getParameter("producedQuantity"));
                String defectStr = request.getParameter("defectId");
                Integer defectId = null;
                if (defectStr != null && !defectStr.isEmpty()) {
                    defectId = Integer.parseInt(defectStr);
                }
                ProductionLogDTO log = new ProductionLogDTO();
                log.setWoId(woId);
                log.setStepId(stepId);
                log.setWorkerUserId(workerUserId);
                log.setProducedQuantity(quantity);
                log.setDefectId(defectId);
                dao.insertLog(log);
                response.sendRedirect("ProductionLogController");
            }
            if (action.equals("update")) {
                int logId = Integer.parseInt(request.getParameter("logId"));
                int quantity = Integer.parseInt(request.getParameter("producedQuantity"));
                String defectStr = request.getParameter("defectId");
                Integer defectId = null;
                if (defectStr != null && !defectStr.isEmpty()) {
                    defectId = Integer.parseInt(defectStr);
                }
                ProductionLogDTO log = new ProductionLogDTO();
                log.setLogId(logId);
                log.setProducedQuantity(quantity);
                log.setDefectId(defectId);
                dao.updateLog(log);
                response.sendRedirect("ProductionLogController");
            }
            if (action.equals("delete")) {
                int logId = Integer.parseInt(request.getParameter("logId"));
                dao.deleteLog(logId);
                response.sendRedirect("ProductionLogController");
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
