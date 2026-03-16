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
import pms.model.DefectReasonDAO;

import pms.model.DefectReasonDTO;


/**
 *
 * @author se193234_TranGiaBao
 */
public class DefectReasonController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "list";

        DefectReasonDAO dao = new DefectReasonDAO();

        try {
            switch (action) {
                case "list":
                    List<DefectReasonDTO> list = dao.getAllDefectReasons();
                    request.setAttribute("listDefect", list);
                    request.getRequestDispatcher("listDefectReason.jsp").forward(request, response);
                    break;
                case "add":
                    String addName = request.getParameter("reasonName");
                    dao.insertDefectReasons(new DefectReasonDTO(0, addName));
                    response.sendRedirect("MainController?action=listDefectReason");
                    break;
                case "delete":
                    int delId = Integer.parseInt(request.getParameter("defectId"));
                    dao.deleteDefectReasons(new DefectReasonDTO(delId, "")); // Truyền DTO giả chỉ chứa ID
                    response.sendRedirect("MainController?action=listDefectReason");
                    break;
                case "load_update":
                    int updId = Integer.parseInt(request.getParameter("defectId"));
                    request.setAttribute("defectEdit", dao.getDefectReasonById(updId));
                    request.getRequestDispatcher("updateDefectReason.jsp").forward(request, response);
                    break;
                case "update":
                    int uId = Integer.parseInt(request.getParameter("defectId"));
                    String uName = request.getParameter("reasonName");
                    dao.updateDefectReasons(new DefectReasonDTO(uId, uName));
                    response.sendRedirect("MainController?action=listDefectReason");
                    break;
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { processRequest(request, response); }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { processRequest(request, response); }
}
