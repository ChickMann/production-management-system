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
import pms.model.PurchaseOrderDAO;
import pms.model.PurchaseOrderDTO;

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

        try {
            switch (action) {
                // 1. HIỂN THỊ DANH SÁCH ĐỀ NGHỊ MUA
                case "listPurchaseOrder":
                case "searchPurchaseOrder":
                    List<PurchaseOrderDTO> list = dao.getAllPurchaseOrders();
                    request.setAttribute("listPO", list);
                    request.setAttribute("listItems", itemDao.ItemList()); 
                    request.getRequestDispatcher("purchase-order.jsp").forward(request, response);
                    break;

                // 2. THÊM ĐỀ NGHỊ MUA MỚI (Hoặc hệ thống tự gọi khi thiếu kho)
                case "addPurchaseOrder":
                    int itemId = Integer.parseInt(request.getParameter("itemId"));
                    int qty = Integer.parseInt(request.getParameter("quantity"));
                    String date = LocalDate.now().toString();
                    
                    // Mặc định đơn mới sẽ là "Pending" (Đang chờ Sếp duyệt)
                    dao.insertPurchaseOrder(new PurchaseOrderDTO(0, itemId, qty, "Pending", date));
                    response.sendRedirect("MainController?action=listPurchaseOrder");
                    break;

                // 3. CẬP NHẬT TRẠNG THÁI (Sếp duyệt -> Ordered -> Received)
                case "updateStatusPurchaseOrder":
                    int poId = Integer.parseInt(request.getParameter("poId"));
                    String newStatus = request.getParameter("status");
                    dao.updateStatus(poId, newStatus);
                    response.sendRedirect("MainController?action=listPurchaseOrder");
                    break;

                // 4. XÓA ĐỀ NGHỊ
                case "deletePurchaseOrder":
                    int idDel = Integer.parseInt(request.getParameter("poId"));
                    dao.deletePurchaseOrder(idDel);
                    response.sendRedirect("MainController?action=listPurchaseOrder");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { processRequest(request, response); }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { processRequest(request, response); }
}