package pms.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.DefectDAO;
import pms.model.DefectDTO;

@WebServlet(name = "DefectController", urlPatterns = {"/DefectController"})
public class DefectController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "listDefectReason"; // FIX LỖI TRẮNG TRANG Ở ĐÂY
        
        DefectDAO dao = new DefectDAO();

        try {
            switch (action) {
                // Thêm case listDefectReason để khớp với Dashboard
                case "listDefectReason":
                case "listDefect":
                    request.setAttribute("listD", dao.getAllDefects());
                    request.getRequestDispatcher("defect.jsp").forward(request, response);
                    break;
                case "addDefect":
                    dao.insertDefect(new DefectDTO(0, request.getParameter("defectName")));
                    response.sendRedirect("MainController?action=listDefectReason");
                    break;
                case "deleteDefect":
                    dao.deleteDefect(Integer.parseInt(request.getParameter("id")));
                    response.sendRedirect("MainController?action=listDefectReason");
                    break;
                case "loadUpdateDefect":
                    request.setAttribute("defectEdit", dao.getDefectById(Integer.parseInt(request.getParameter("id"))));
                    request.setAttribute("listD", dao.getAllDefects());
                    request.getRequestDispatcher("defect.jsp").forward(request, response);
                    break;
                case "saveUpdateDefect":
                    dao.updateDefect(new DefectDTO(Integer.parseInt(request.getParameter("id")), request.getParameter("defectName")));
                    response.sendRedirect("MainController?action=listDefectReason");
                    break;
            }
        } catch (Exception e) { e.printStackTrace(); }
    }
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { processRequest(req, resp); }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { processRequest(req, resp); }
}