package pms.controllers;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.ItemDAO;
import pms.model.ItemDTO;
import pms.model.PurchaseOrderDAO;
import pms.model.PurchaseOrderDTO;
import pms.model.UserDTO;
import pms.utils.NotificationService;

@WebServlet(name = "PurchaseOrderController", urlPatterns = {"/PurchaseOrderController"})
public class PurchaseOrderController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
 
        String action = request.getParameter("action");
        if (action == null) action = "listPurchaseOrder";
 
        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        ItemDAO itemDao = new ItemDAO();
        UserDTO user = (UserDTO) request.getSession().getAttribute("user");
        String role = user != null ? user.getRole() : "user";
        boolean isAdmin = "admin".equalsIgnoreCase(role);
        boolean isWorker = "employee".equalsIgnoreCase(role)
                || "worker".equalsIgnoreCase(role)
                || "user".equalsIgnoreCase(role);
 
        try {
            switch (action) {
                case "listPurchaseOrder":
                case "searchPurchaseOrder":
                    request.setAttribute("listPO", dao.getAllPurchaseOrders());
                    request.setAttribute("listItems", itemDao.ItemList());
                    request.setAttribute("isAdmin", isAdmin);
                    request.setAttribute("isWorker", isWorker);
                    request.getRequestDispatcher("SearchPurchaseOrder.jsp").forward(request, response);
                    return;
 
                case "addPurchaseOrder":
                    if (!isAdmin && !isWorker) {
                        response.sendRedirect("MainController?action=listPurchaseOrder");
                        return;
                    }
                    int itemId = Integer.parseInt(request.getParameter("itemId"));
                    int qty = Integer.parseInt(request.getParameter("quantity"));
                    String date = LocalDate.now().toString();
                    boolean inserted = dao.insertPurchaseOrder(new PurchaseOrderDTO(0, itemId, qty, "Pending", date));
                    if (inserted) {
                        List<PurchaseOrderDTO> latestOrders = dao.getAllPurchaseOrders();
                        PurchaseOrderDTO createdPo = latestOrders != null && !latestOrders.isEmpty() ? latestOrders.get(0) : null;
                        ItemDTO item = itemDao.SearchByID(itemId);
                        String itemName = item != null && item.getItemName() != null ? item.getItemName() : "Vật tư";
                        String requesterName = resolveRequesterName(user);
                        int poId = createdPo != null ? createdPo.getPoId() : 0;
                        NotificationService.notifyPurchaseOrderRequested(poId, itemName, qty, requesterName);
                        response.sendRedirect("MainController?action=listPurchaseOrder&msg="
                                + java.net.URLEncoder.encode("Đã tạo đề nghị mua vật tư.", "UTF-8"));
                    } else {
                        response.sendRedirect("MainController?action=listPurchaseOrder&error="
                                + java.net.URLEncoder.encode("Không thể tạo đề nghị mua vật tư.", "UTF-8"));
                    }
                    return;
 
                case "updateStatusPurchaseOrder":
                    if (!isAdmin) {
                        response.sendRedirect("MainController?action=listPurchaseOrder&error="
                                + java.net.URLEncoder.encode("Chỉ quản lý mới được cập nhật trạng thái đề nghị mua.", "UTF-8"));
                        return;
                    }
                    int poId = Integer.parseInt(request.getParameter("poId"));
                    String newStatus = request.getParameter("status");
                    dao.updateStatus(poId, newStatus);
                    response.sendRedirect("MainController?action=listPurchaseOrder&msg="
                            + java.net.URLEncoder.encode("Đã cập nhật trạng thái đề nghị mua.", "UTF-8"));
                    return;
 
                case "deletePurchaseOrder":
                    if (!isAdmin) {
                        response.sendRedirect("MainController?action=listPurchaseOrder&error="
                                + java.net.URLEncoder.encode("Chỉ quản lý mới được xóa đề nghị mua.", "UTF-8"));
                        return;
                    }
                    int idDel = Integer.parseInt(request.getParameter("poId"));
                    dao.deletePurchaseOrder(idDel);
                    response.sendRedirect("MainController?action=listPurchaseOrder&msg="
                            + java.net.URLEncoder.encode("Đã xóa đề nghị mua vật tư.", "UTF-8"));
                    return;
 
                default:
                    response.sendRedirect("MainController?action=listPurchaseOrder");
                    return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("MainController?action=listPurchaseOrder&error="
                    + java.net.URLEncoder.encode("Có lỗi xảy ra khi xử lý đề nghị mua vật tư.", "UTF-8"));
        }
    }

    private String resolveRequesterName(UserDTO user) {
        if (user == null) {
            return "Người dùng hệ thống";
        }
        if (user.getFullName() != null && !user.getFullName().trim().isEmpty()) {
            return user.getFullName().trim();
        }
        if (user.getUsername() != null && !user.getUsername().trim().isEmpty()) {
            return user.getUsername().trim();
        }
        return "Người dùng hệ thống";
    }
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
