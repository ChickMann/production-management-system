package pms.controllers;

import java.io.IOException;
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

        List<WorkOrderDTO> newList = new java.util.ArrayList<>();
        List<WorkOrderDTO> inProgressList = new java.util.ArrayList<>();
        List<WorkOrderDTO> doneList = new java.util.ArrayList<>();
        List<WorkOrderDTO> cancelledList = new java.util.ArrayList<>();

        for (WorkOrderDTO wo : all) {
            String status = wo.getStatus();
            if ("New".equals(status)) newList.add(wo);
            else if ("InProgress".equals(status)) inProgressList.add(wo);
            else if ("Done".equals(status)) doneList.add(wo);
            else if ("Cancelled".equals(status)) cancelledList.add(wo);
        }

        request.setAttribute("newList", newList);
        request.setAttribute("inProgressList", inProgressList);
        request.setAttribute("doneList", doneList);
        request.setAttribute("cancelledList", cancelledList);
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String sId = request.getParameter("id");
        String newStatus = request.getParameter("status");

        if (sId == null || newStatus == null) {
            response.setStatus(400);
            return;
        }

        try {
            int woId = Integer.parseInt(sId);
            WorkOrderDAO woDao = new WorkOrderDAO();
            WorkOrderDTO wo = woDao.searchById(woId);

            boolean updated = woDao.updateWorkOrderStatusOnly(woId, newStatus);

            if (updated && "Done".equals(newStatus) && wo != null) {
                BOMDAO bomDao = new BOMDAO();
                InventoryLogDAO invDao = new InventoryLogDAO();

                invDao.autoDeductForWorkOrder(
                    woId,
                    wo.getProduct_item_id(),
                    wo.getOrder_quantity(),
                    1,
                    bomDao
                );

                NotificationService.notifyWorkOrderCompleted(woId,
                    wo.getProductName() != null ? wo.getProductName() : "WO#" + woId);
            }

            response.setContentType("text/plain");
            response.getWriter().write(updated ? "OK" : "FAIL");

        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write("ERROR: " + e.getMessage());
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
        return "Kanban Controller";
    }
}
