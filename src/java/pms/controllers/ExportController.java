package pms.controllers;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.WorkOrderDAO;
import pms.model.ProductionLogDAO;
import pms.model.ItemDAO;
import pms.model.BillDAO;
import pms.model.BOMDAO;
import pms.model.DashboardDAO;
import pms.model.DashboardDTO;
import pms.model.WorkOrderDTO;
import pms.model.ProductionLogDTO;
import pms.model.ItemDTO;
import pms.model.BillDTO;
import pms.model.BOMDTO;
import pms.model.BOMDetailDTO;
import pms.utils.ExportService;

public class ExportController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String type = request.getParameter("type");
        if (type == null) type = "workorders";

        try {
            switch (type) {
                case "workorders":
                    exportWorkOrders(request, response);
                    break;
                case "productionlogs":
                    exportProductionLogs(request, response);
                    break;
                case "items":
                    exportItems(request, response);
                    break;
                case "bills":
                    exportBills(request, response);
                    break;
                case "bom":
                    exportBom(request, response);
                    break;
                case "dashboard":
                    exportDashboard(request, response);
                    break;
                default:
                    response.sendRedirect("DashboardController");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Loi xuat file: " + e.getMessage());
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        }
    }

    private void exportWorkOrders(HttpServletRequest request, HttpServletResponse response) throws IOException {
        WorkOrderDAO dao = new WorkOrderDAO();
        List<WorkOrderDTO> list = dao.getAllWorkOrders();
        ExportService.exportWorkOrdersToCsv(list, response);
    }

    private void exportProductionLogs(HttpServletRequest request, HttpServletResponse response) throws IOException {
        ProductionLogDAO dao = new ProductionLogDAO();
        List<ProductionLogDTO> list = dao.getAllLogs();
        ExportService.exportProductionLogsToCsv(list, response);
    }

    private void exportItems(HttpServletRequest request, HttpServletResponse response) throws IOException {
        ItemDAO dao = new ItemDAO();
        List<ItemDTO> list = dao.getAllItems();
        ExportService.exportItemsToCsv(list, response);
    }

    private void exportBills(HttpServletRequest request, HttpServletResponse response) throws IOException {
        BillDAO dao = new BillDAO();
        List<BillDTO> list = dao.getAllBill();
        ExportService.exportBillsToCsv(list, response);
    }

    private void exportBom(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String sBomId = request.getParameter("bomId");
        if (sBomId == null || sBomId.trim().isEmpty()) {
            response.sendRedirect("MainController?action=listBOM");
            return;
        }
        int bomId = Integer.parseInt(sBomId);
        BOMDAO dao = new BOMDAO();
        BOMDTO bom = dao.getBOMById(bomId);
        if (bom == null) {
            response.sendRedirect("MainController?action=listBOM");
            return;
        }
        List<BOMDetailDTO> details = bom.getDetails();
        ExportService.exportBomToCsv(bom, details, response);
    }

    private void exportDashboard(HttpServletRequest request, HttpServletResponse response) throws IOException {
        DashboardDAO dao = new DashboardDAO();
        DashboardDTO data = dao.loadDashboardStats();
        String html = ExportService.generateDashboardHtml(data);
        ExportService.exportDashboardReport(new StringBuilder(html), response);
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
        return "Export Controller";
    }
}
