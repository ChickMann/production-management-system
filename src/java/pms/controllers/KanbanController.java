package pms.controllers;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.WorkOrderDAO;
import pms.model.WorkOrderDTO;
import pms.model.BOMDAO;
import pms.model.InventoryLogDAO;
import pms.utils.NotificationService;

public class KanbanController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "view";

        if ("updateStatus".equals(action)) {
            updateStatus(request, response);
            return;
        }

        switch (action) {
            case "view":
            default:
                viewKanban(request);
                break;
        }
        request.getRequestDispatcher("kanban.jsp").forward(request, response);
    }

    private void viewKanban(HttpServletRequest request) {
        WorkOrderDAO dao = new WorkOrderDAO();
        List<WorkOrderDTO> all = dao.getAllWorkOrders();

        // Lấy dữ liệu từ bộ lọc
        String keyword = request.getParameter("keyword");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        List<WorkOrderDTO> newList = new ArrayList<>();
        List<WorkOrderDTO> inProgressList = new ArrayList<>();
        List<WorkOrderDTO> doneList = new ArrayList<>();
        List<WorkOrderDTO> cancelledList = new ArrayList<>();

        int overdueCount = 0;
        long now = System.currentTimeMillis();
        SimpleDateFormat sdfDb = new SimpleDateFormat("yyyy-MM-dd");

        for (WorkOrderDTO wo : all) {
            boolean match = true;

            // 1. Lọc từ khóa
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = keyword.toLowerCase();
                String name = wo.getProductName() != null ? wo.getProductName().toLowerCase() : "";
                if (!String.valueOf(wo.getWo_id()).contains(kw) && !name.contains(kw)) {
                    match = false;
                }
            }

            // 2. LỌC NGÀY THÁNG THÔNG MINH
            if (match) {
                boolean hasFromDate = fromDate != null && !fromDate.trim().isEmpty();
                boolean hasToDate = toDate != null && !toDate.trim().isEmpty();

                if (hasFromDate || hasToDate) {
                    // Mặc định lấy Ngày Tạo
                    String dateToCompare = wo.getCreated_date();
                    
                    // Nếu thẻ đã hoàn thành -> Ưu tiên lấy Ngày Hoàn Thành để lọc
                    if ("Done".equalsIgnoreCase(wo.getStatus()) || "Completed".equalsIgnoreCase(wo.getStatus())) {
                        dateToCompare = wo.getCompleted_date();
                        // Backup lỡ data cũ không có ngày hoàn thành thì mới xài ngày tạo
                        if (dateToCompare == null || dateToCompare.trim().isEmpty()) {
                            dateToCompare = wo.getCreated_date();
                        }
                    }

                    if (dateToCompare == null || dateToCompare.trim().isEmpty()) {
                        match = false; 
                    } else {
                        try {
                            String dateStr = dateToCompare.trim();
                            if (dateStr.length() >= 10) {
                                dateStr = dateStr.substring(0, 10);
                            }
                            Date targetDate = sdfDb.parse(dateStr);

                            if (hasFromDate) {
                                Date from = sdfDb.parse(fromDate);
                                if (targetDate.getTime() < from.getTime()) match = false;
                            }
                            if (hasToDate) {
                                Date to = sdfDb.parse(toDate);
                                to.setHours(23); to.setMinutes(59); to.setSeconds(59);
                                if (targetDate.getTime() > to.getTime()) match = false;
                            }
                        } catch (Exception e) {
                            match = false;
                        }
                    }
                }
            }

            if (!match) continue;

            // Đếm số lượng quá hạn (Chỉ đếm các lệnh chưa hoàn thành/chưa hủy)
            if (wo.getDue_date() != null && !wo.getDue_date().isEmpty() &&
                !"Done".equalsIgnoreCase(wo.getStatus()) && !"Cancelled".equalsIgnoreCase(wo.getStatus())) {
                try {
                    SimpleDateFormat sdfFull = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    Date dueFull = sdfFull.parse(wo.getDue_date().endsWith(".0") ? wo.getDue_date().substring(0, 19) : wo.getDue_date().replace("T", " "));
                    if (dueFull.getTime() < now) {
                        overdueCount++;
                    }
                } catch (Exception e) {}
            }

            // Phân loại vào cột
            String status = wo.getStatus();
            if ("New".equalsIgnoreCase(status) || "WaitMaterial".equalsIgnoreCase(status) || "Ready".equalsIgnoreCase(status)) {
                newList.add(wo);
            } else if ("InProgress".equalsIgnoreCase(status) || "In Progress".equalsIgnoreCase(status)) {
                inProgressList.add(wo);
            } else if ("Done".equalsIgnoreCase(status) || "Completed".equalsIgnoreCase(status)) {
                doneList.add(wo);
            } else if ("Cancelled".equalsIgnoreCase(status)) {
                cancelledList.add(wo);
            }
        }

        request.setAttribute("newList", newList);
        request.setAttribute("inProgressList", inProgressList);
        request.setAttribute("doneList", doneList);
        request.setAttribute("cancelledList", cancelledList);
        
        request.setAttribute("overdueCount", overdueCount);
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("fromDate", fromDate != null ? fromDate : "");
        request.setAttribute("toDate", toDate != null ? toDate : "");
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int woId = Integer.parseInt(request.getParameter("id"));
            String newStatus = request.getParameter("status");

            WorkOrderDAO woDao = new WorkOrderDAO();
            WorkOrderDTO wo = woDao.searchById(woId);
            boolean updated = woDao.updateWorkOrderStatusOnly(woId, newStatus);

            if (updated && "Done".equals(newStatus) && wo != null) {
                BOMDAO bomDao = new BOMDAO();
                InventoryLogDAO invDao = new InventoryLogDAO();
                invDao.autoDeductForWorkOrder(woId, wo.getProduct_item_id(), wo.getOrder_quantity(), 1, bomDao);
                NotificationService.notifyWorkOrderCompleted(woId, wo.getProductName() != null ? wo.getProductName() : "WO#" + woId);
            }

            response.setContentType("text/plain");
            response.getWriter().write(updated ? "OK" : "FAIL");
        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write("ERROR: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
    @Override
    public String getServletInfo() { return "Kanban Controller"; }
}