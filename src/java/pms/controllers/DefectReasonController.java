package pms.controllers;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.DefectReasonDAO;
import pms.model.DefectReasonDTO;

public class DefectReasonController extends HttpServlet {

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
                    List<DefectReasonDTO> list = dao.getAllDefectReasons();
                    request.setAttribute("listDefect", list);
                    request.getRequestDispatcher("listDefectReason.jsp").forward(request, response);
                    break;
                case "addDefectReason":
                    String addName = request.getParameter("reasonName");
                    dao.insertDefectReasons(new DefectReasonDTO(0, addName));
                    response.sendRedirect("MainController?action=listDefectReason");
                    break;
                case "deleteDefectReason":
                    int delId = Integer.parseInt(request.getParameter("defectId"));
                    dao.deleteDefectReasons(new DefectReasonDTO(delId, ""));
                    response.sendRedirect("MainController?action=listDefectReason");
                    break;
                case "loadUpdateDefectReason":
                    int updId = Integer.parseInt(request.getParameter("defectId"));
                    request.setAttribute("defectEdit", dao.getDefectReasonById(updId));
                    request.getRequestDispatcher("updateDefectReason.jsp").forward(request, response);
                    break;
                case "saveUpdateDefectReason":
                    int uId = Integer.parseInt(request.getParameter("defectId"));
                    String uName = request.getParameter("reasonName");
                    dao.updateDefectReasons(new DefectReasonDTO(uId, uName));
                    response.sendRedirect("MainController?action=listDefectReason");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
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
        return "Defect Reason Controller";
    }

}
