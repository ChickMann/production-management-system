package pms.controllers;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import pms.model.BOMDAO;
import pms.model.InventoryLogDAO;
import pms.model.InventoryLogDTO;
import pms.model.ItemDAO;
import pms.model.ItemDTO;
import pms.model.UserDTO;
import pms.utils.NotificationService;

public class InventoryController extends HttpServlet {

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
                listLogs(request);
                url = "inventory-log.jsp";
                break;
            case "byItem":
                logsByItem(request);
                url = "inventory-log.jsp";
                break;
            case "adjust":
                adjustStock(request);
                url = "redirect:InventoryController?action=list";
                return;
            case "replenish":
                replenishStock(request);
                url = "redirect:InventoryController?action=list";
                return;
            case "checkLowStock":
                listLogs(request);
                url = "inventory-log.jsp";
                break;
            default:
                listLogs(request);
                url = "inventory-log.jsp";
                break;
        }

        if (url.startsWith("redirect:")) {
            response.sendRedirect(url.substring(9));
        } else {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private void listLogs(HttpServletRequest request) {
        InventoryLogDAO dao = new InventoryLogDAO();
        List<InventoryLogDTO> logs = dao.getRecentLogs(200);
        request.setAttribute("logs", logs);
        request.setAttribute("mode", "all");
    }

    private void logsByItem(HttpServletRequest request) {
        String sItemId = request.getParameter("itemId");
        if (sItemId == null || sItemId.trim().isEmpty()) {
            listLogs(request);
            return;
        }
        try {
            int itemId = Integer.parseInt(sItemId);
            InventoryLogDAO dao = new InventoryLogDAO();
            List<InventoryLogDTO> logs = dao.getLogsByItem(itemId);
            request.setAttribute("logs", logs);
            request.setAttribute("itemId", itemId);
            request.setAttribute("mode", "byItem");

            ItemDAO itemDao = new ItemDAO();
            ItemDTO item = itemDao.SearchByID(itemId);
            request.setAttribute("item", item);
        } catch (Exception e) {
            request.setAttribute("error", "Invalid item ID");
            listLogs(request);
        }
    }

    private void adjustStock(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return;
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null) return;

        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            int change = Integer.parseInt(request.getParameter("quantityChange"));
            String reason = request.getParameter("reason");
            String refType = request.getParameter("referenceType");

            ItemDAO itemDao = new ItemDAO();
            ItemDTO item = itemDao.SearchByID(itemId);
            if (item == null) return;

            int before = item.getStockQuantity();
            int after = before + change;
            if (after < 0) after = 0;

            itemDao.updateStock(itemId, after);

            InventoryLogDTO log = new InventoryLogDTO();
            log.setItemId(itemId);
            log.setChangeType(change >= 0 ? "ADJUST" : "ADJUST");
            log.setQuantityBefore(before);
            log.setQuantityChange(change);
            log.setQuantityAfter(after);
            log.setReferenceType(refType != null ? refType : "MANUAL");
            log.setReferenceId(0);
            log.setReason(reason != null ? reason : "Dieu chinh thu cong");
            log.setPerformedBy(user.getId());

            InventoryLogDAO invDao = new InventoryLogDAO();
            invDao.logChange(log);

            if (after <= item.getMinStockLevel()) {
                NotificationService.notifyLowStock(item.getItemName(), after);
            }

            request.setAttribute("msg", "Da dieu chinh ton kho thanh cong!");
        } catch (Exception e) {
            request.setAttribute("error", "Loi dieu chinh: " + e.getMessage());
        }
    }

    private void replenishStock(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return;
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null) return;

        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String refType = request.getParameter("referenceType");
            int refId = 0;
            try { refId = Integer.parseInt(request.getParameter("referenceId")); } catch (Exception e) {}

            ItemDAO itemDao = new ItemDAO();
            ItemDTO item = itemDao.SearchByID(itemId);
            if (item == null) return;

            int before = item.getStockQuantity();
            int after = before + quantity;

            itemDao.updateStock(itemId, after);

            InventoryLogDTO log = new InventoryLogDTO();
            log.setItemId(itemId);
            log.setChangeType("IN");
            log.setQuantityBefore(before);
            log.setQuantityChange(quantity);
            log.setQuantityAfter(after);
            log.setReferenceType(refType != null ? refType : "MANUAL");
            log.setReferenceId(refId);
            log.setReason("Nhap kho thu cong");
            log.setPerformedBy(user.getId());

            InventoryLogDAO invDao = new InventoryLogDAO();
            invDao.logChange(log);

            request.setAttribute("msg", "Da nhap kho " + quantity + " " + (item.getUnit() != null ? item.getUnit() : "") + " thanh cong!");
        } catch (Exception e) {
            request.setAttribute("error", "Loi nhap kho: " + e.getMessage());
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
