package pms.controllers;

import java.io.IOException;
import java.time.LocalDate;
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
                case "listPurchaseOrder":
                case "searchPurchaseOrder":
                    request.setAttribute("listPO", dao.getAllPurchaseOrders());
                    request.setAttribute("listItems", itemDao.ItemList());
                    request.getRequestDispatcher("SearchPurchaseOrder.jsp").forward(request, response);
                    break;

                case "addPurchaseOrder":
                    int itemId = Integer.parseInt(request.getParameter("itemId"));
                    int qty = Integer.parseInt(request.getParameter("quantity"));
                    String date = LocalDate.now().toString();
                    dao.insertPurchaseOrder(new PurchaseOrderDTO(0, itemId, qty, "Pending", date));
                    response.sendRedirect("MainController?action=listPurchaseOrder");
                    break;

                case "updateStatusPurchaseOrder":
                    int poId = Integer.parseInt(request.getParameter("poId"));
                    String newStatus = request.getParameter("status");
                    
                    if ("Received".equals(newStatus)) {
                        PurchaseOrderDTO po = dao.getPurchaseOrderById(poId);
                        if (po != null && !"Received".equals(po.getStatus())) {
                            itemDao.increaseStock(po.getItemId(), po.getQuantityRequested());
                        }
                    }
                    
                    dao.updateStatus(poId, newStatus);
                    response.sendRedirect("MainController?action=listPurchaseOrder");
                    break;

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
