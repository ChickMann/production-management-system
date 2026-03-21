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
                addInspection(request, response);
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
                deleteInspection(request, response);
                return;
            default:
                listInspections(request);
                url = "qc-list.jsp";
                break;
        }

        if (url.startsWith("redirect:")) {
            response.sendRedirect(request.getContextPath() + "/" + url.substring(9));
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
        loadFormOptions(request);
    }

    private void addInspection(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/QcController?action=list&error="
                    + java.net.URLEncoder.encode("Phiên đăng nhập đã hết hạn", "UTF-8"));
            return;
        }
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/QcController?action=list&error="
                    + java.net.URLEncoder.encode("Bạn cần đăng nhập để tạo phiếu QC", "UTF-8"));
            return;
        }

        try {
            int woId = Integer.parseInt(request.getParameter("woId"));
            int stepId = Integer.parseInt(request.getParameter("stepId"));
            String result = request.getParameter("inspectionResult");
            int inspected = Integer.parseInt(request.getParameter("quantityInspected"));
            int passed = Integer.parseInt(request.getParameter("quantityPassed"));
            int failed = Math.max(0, inspected - passed);
            String notes = request.getParameter("notes");
            String defectIdRaw = request.getParameter("defectId");

            if (inspected <= 0) {
                response.sendRedirect(request.getContextPath() + "/QcController?action=list&error="
                        + java.net.URLEncoder.encode("Số lượng kiểm tra phải lớn hơn 0", "UTF-8"));
                return;
            }
            if (passed < 0 || passed > inspected) {
                response.sendRedirect(request.getContextPath() + "/QcController?action=list&error="
                        + java.net.URLEncoder.encode("Số lượng đạt không hợp lệ", "UTF-8"));
                return;
            }
            if (result == null || result.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/QcController?action=list&error="
                        + java.net.URLEncoder.encode("Bạn chưa chọn kết quả kiểm tra", "UTF-8"));
                return;
            }

            if ("FAIL".equalsIgnoreCase(result) && defectIdRaw != null && !defectIdRaw.trim().isEmpty() && !"0".equals(defectIdRaw.trim())) {
                try {
                    int defectId = Integer.parseInt(defectIdRaw.trim());
                    DefectDAO defectDAO = new DefectDAO();
                    pms.model.DefectDTO defect = defectDAO.getDefectById(defectId);
                    if (defect != null && defect.getReasonName() != null && !defect.getReasonName().trim().isEmpty()) {
                        String defectNote = "Lý do lỗi: " + defect.getReasonName().trim();
                        notes = (notes == null || notes.trim().isEmpty()) ? defectNote : defectNote + " | " + notes.trim();
                    }
                } catch (NumberFormatException ignore) {
                }
            }

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
                if ("FAIL".equalsIgnoreCase(result)) {
                    NotificationService.notifyDefectDetected(String.valueOf(woId),
                        "QC không đạt - " + failed + " sản phẩm lỗi");
                }
                response.sendRedirect(request.getContextPath() + "/QcController?action=list&msg="
                        + java.net.URLEncoder.encode("Tạo phiếu kiểm tra chất lượng thành công", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/QcController?action=list&error="
                        + java.net.URLEncoder.encode("Lưu kết quả QC thất bại", "UTF-8"));
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/QcController?action=list&error="
                    + java.net.URLEncoder.encode("Lỗi khi tạo phiếu QC: " + e.getMessage(), "UTF-8"));
        }
    }

    private void deleteInspection(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String sId = request.getParameter("id");
        if (sId == null || sId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/QcController?action=list&error="
                    + java.net.URLEncoder.encode("Thiếu mã phiếu QC cần xóa", "UTF-8"));
            return;
        }
        try {
            int id = Integer.parseInt(sId);
            QcInspectionDAO dao = new QcInspectionDAO();
            boolean deleted = dao.deleteInspection(id);
            response.sendRedirect(request.getContextPath() + "/QcController?action=list&"
                    + (deleted ? "msg=" + java.net.URLEncoder.encode("Đã xóa kết quả QC", "UTF-8")
                               : "error=" + java.net.URLEncoder.encode("Không thể xóa kết quả QC", "UTF-8")));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/QcController?action=list&error="
                    + java.net.URLEncoder.encode("Lỗi xóa QC: " + e.getMessage(), "UTF-8"));
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
