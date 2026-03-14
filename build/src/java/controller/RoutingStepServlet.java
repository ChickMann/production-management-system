/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.RoutingStepDAO;
import model.RoutingStepDTO;

/**
 *
 * @author se193234_TranGiaBao
 */
public class RoutingStepServlet extends HttpServlet {

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

        RoutingStepDAO dao = new RoutingStepDAO();

        try {
            switch (action) {
                case "list":
                    List<RoutingStepDTO> list = dao.getAllRoutingStep();
                    request.setAttribute("listStep", list);
                    request.getRequestDispatcher("listRoutingStep.jsp").forward(request, response);
                    break;
                    
                case "add":
                    int rId = Integer.parseInt(request.getParameter("routingId"));
                    String sName = request.getParameter("stepName");
                    int time = Integer.parseInt(request.getParameter("estimatedTime"));
                    // Xử lý Checkbox: Nếu được tích thì nó khác null (true), không tích là null (false)
                    boolean isInsp = request.getParameter("isInspected") != null;
                    
                    dao.insertRoutingStep(new RoutingStepDTO(0, rId, sName, time, isInsp));
                    response.sendRedirect("RoutingStepServlet?action=list");
                    break;
                    
                case "delete":
                    int delId = Integer.parseInt(request.getParameter("stepId"));
                    dao.deleteRoutingStep(delId);
                    response.sendRedirect("RoutingStepServlet?action=list");
                    break;
                    
                case "load_update":
                    int updId = Integer.parseInt(request.getParameter("stepId"));
                    request.setAttribute("stepEdit", dao.getRoutingStepById(updId));
                    request.getRequestDispatcher("updateRoutingStep.jsp").forward(request, response);
                    break;
                    
                case "update":
                    int uId = Integer.parseInt(request.getParameter("stepId"));
                    int uRId = Integer.parseInt(request.getParameter("routingId"));
                    String uName = request.getParameter("stepName");
                    int uTime = Integer.parseInt(request.getParameter("estimatedTime"));
                    boolean uInsp = request.getParameter("isInspected") != null; // Xử lý checkbox
                    
                    dao.updateRoutingStep(new RoutingStepDTO(uId, uRId, uName, uTime, uInsp));
                    response.sendRedirect("RoutingStepServlet?action=list");
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
