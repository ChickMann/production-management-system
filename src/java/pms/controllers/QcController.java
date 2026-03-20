package pms.controllers;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import pms.model.DefectDAO;
import pms.model.QcInspectionDAO;
import pms.model.QcInspectionDTO;
import pms.model.RoutingStepDAO;
import pms.model.UserDTO;
import pms.model.WorkOrderDAO;
import pms.utils.NotificationService;

public class QcController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "list";

        String url = "";

        switch (action) {
            case "list":
                listInspections(request);
                url = "qc-list.jsp";
                break;
            case "add":
                showAddForm(request);
                url = "qc-form.jsp";
                break;
            case "saveAdd":
                addInspection(request);
                url = "redirect:QcController?action=list";
                return;
            case "byWo":
                inspectionsByWo(request);
                url = "qc-list.jsp";
                break;
            case "failed":
                failedInspections(request);
                url = "qc-list.jsp";
                break;
            case "delete":
                deleteInspection(request);
                url = "redirect:QcController?action=list";
                return;
            default:
                listInspections(request);
                url = "qc-list.jsp";
                break;
        }

        if (url.startsWith("redirect:")) {
            response.sendRedirect(url.substring(9));
        } else {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private void listInspections(HttpServletRequest request) {
        QcInspectionDAO dao = new QcInspectionDAO();
        List<QcInspectionDTO> list = dao.getAllInspections();
        int totalInspected = dao.getTotalInspected();
        int totalFailed = dao.getTotalFailed();
        double passRate = dao.getOverallPassRate();

        request.setAttribute("inspections", list);
        request.setAttribute("totalInspected", totalInspected);
        request.setAttribute("totalFailed", totalFailed);
        request.setAttribute("passRate", passRate);
        request.setAttribute("mode", "all");
        loadFormOptions(request);
    }

    private void loadFormOptions(HttpServletRequest request) {
        request.setAttribute("workOrders", new WorkOrderDAO().getAllWorkOrders());
        request.setAttribute("steps", new RoutingStepDAO().getAllRoutingStep());
        request.setAttribute("defects", new DefectDAO().getAllDefects());
    }

    private void inspectionsByWo(HttpServletRequest request) {
        String sWoId = request.getParameter("woId");
        if (sWoId == null || sWoId.trim().isEmpty()) {
            listInspections(request);
            return;
        }
        try {
            int woId = Integer.parseInt(sWoId);
            QcInspectionDAO dao = new QcInspectionDAO();
            List<QcInspectionDTO> list = dao.getInspectionsByWo(woId);
            request.setAttribute("inspections", list);
            request.setAttribute("woId", woId);
            request.setAttribute("mode", "byWo");
            loadFormOptions(request);
        } catch (Exception e) {
            listInspections(request);
        }
    }

    private void failedInspections(HttpServletRequest request) {
        QcInspectionDAO dao = new QcInspectionDAO();
        List<QcInspectionDTO> list = dao.getInspectionsByResult("FAIL");
        request.setAttribute("inspections", list);
        request.setAttribute("mode", "failed");
        loadFormOptions(request);
    }

    private void showAddForm(HttpServletRequest request) {
        request.setAttribute("mode", "add");
    }

    private void addInspection(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return;
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null) return;

        try {
            int woId = Integer.parseInt(request.getParameter("woId"));
            int stepId = Integer.parseInt(request.getParameter("stepId"));
            String result = request.getParameter("inspectionResult");
            int inspected = Integer.parseInt(request.getParameter("quantityInspected"));
            int passed = Integer.parseInt(request.getParameter("quantityPassed"));
            int failed = inspected - passed;
            String notes = request.getParameter("notes");

            QcInspectionDTO qc = new QcInspectionDTO();
            qc.setWoId(woId);
            qc.setStepId(stepId);
            qc.setInspectorUserId(user.getId());
            qc.setInspectionResult(result);
            qc.setQuantityInspected(inspected);
            qc.setQuantityPassed(passed);
            qc.setQuantityFailed(failed);
            qc.setNotes(notes);

            QcInspectionDAO dao = new QcInspectionDAO();
            boolean success = dao.insertInspection(qc);

            if (success) {
                if ("FAIL".equals(result)) {
                    NotificationService.notifyDefectDetected(String.valueOf(woId),
                        "QC khong dat - " + failed + " san pham loi");
                }
                request.setAttribute("msg", "Kiem tra chat luong da duoc ghi nhan!");
            } else {
                request.setAttribute("error", "Loi khi luu ket qua QC.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Loi: " + e.getMessage());
        }
    }

    private void deleteInspection(HttpServletRequest request) {
        String sId = request.getParameter("id");
        if (sId == null || sId.trim().isEmpty()) return;
        try {
            int id = Integer.parseInt(sId);
            QcInspectionDAO dao = new QcInspectionDAO();
            dao.deleteInspection(id);
            request.setAttribute("msg", "Da xoa ket qua QC.");
        } catch (Exception e) {
            request.setAttribute("error", "Loi xoa: " + e.getMessage());
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
}
