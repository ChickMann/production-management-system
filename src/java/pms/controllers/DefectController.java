package pms.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.DefectReasonDAO;
import pms.model.DefectReasonDTO;

@WebServlet(name = "DefectController", urlPatterns = {"/DefectController"})
public class DefectController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "listDefectReason";

        DefectReasonDAO dao = new DefectReasonDAO();

        try {
            switch (action) {
                case "listDefectReason":
                case "listDefect":
                    request.setAttribute("listD", dao.getAllDefectReasons());
                    request.getRequestDispatcher("listDefectReason.jsp").forward(request, response);
                    break;
                case "addDefectReason":
                    dao.insertDefectReasons(new DefectReasonDTO(0, request.getParameter("reasonName")));
                    response.sendRedirect("MainController?action=listDefectReason");
                    break;
                case "deleteDefectReason":
                    int delId = Integer.parseInt(request.getParameter("defectId"));
                    dao.deleteDefectReasons(new DefectReasonDTO(delId, null));
                    response.sendRedirect("MainController?action=listDefectReason");
                    break;
                case "loadUpdateDefectReason":
                    request.setAttribute("defectEdit", dao.getDefectReasonById(Integer.parseInt(request.getParameter("defectId"))));
                    request.setAttribute("listD", dao.getAllDefectReasons());
                    request.getRequestDispatcher("listDefectReason.jsp").forward(request, response);
                    break;
                case "saveUpdateDefectReason":
                    int uId = Integer.parseInt(request.getParameter("defectId"));
                    dao.updateDefectReasons(new DefectReasonDTO(uId, request.getParameter("reasonName")));
                    response.sendRedirect("MainController?action=listDefectReason");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }
}
