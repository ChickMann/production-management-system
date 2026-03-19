package pms.controllers;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.*;

@WebServlet(name = "WorkOrderController", urlPatterns = {"/WorkOrderController"})
public class WorkOrderController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "listWorkOrder";

        WorkOrderDAO woDao = new WorkOrderDAO();
        CustomerDAO cDao = new CustomerDAO();
        ItemDAO iDao = new ItemDAO();
        RoutingDAO rDao = new RoutingDAO();

        try {
            List<WorkOrderDTO> listWO = woDao.getAllWorkOrders();
            List<CustomerDTO> listC = cDao.getAllCustomers();
            
            String keyword = request.getParameter("keyword");
            
            if ("searchWorkOrder".equals(action) && keyword != null && !keyword.trim().isEmpty()) {
                String lowerKeyword = keyword.toLowerCase();
                List<WorkOrderDTO> filtered = new ArrayList<>();
                
                for (WorkOrderDTO wo : listWO) {
                    String customerName = "";
                    for (CustomerDTO c : listC) {
                        if (c.getCustomer_id() == wo.getCustomerID()) {
                            customerName = c.getCustomer_name().toLowerCase();
                            break;
                        }
                    }
                    
                    if (String.valueOf(wo.getWorkOrderID()).contains(lowerKeyword) || 
                        wo.getStatus().toLowerCase().contains(lowerKeyword) ||
                        customerName.contains(lowerKeyword)) {
                        filtered.add(wo);
                    }
                }
                listWO = filtered; 
                action = "listWorkOrder"; 
            }

            switch (action) {
                case "listWorkOrder":
                    request.setAttribute("listWO", listWO);
                    request.setAttribute("listC", listC);
                    request.setAttribute("listI", iDao.ItemList());
                    request.setAttribute("listR", rDao.getAllRouting());
                    request.getRequestDispatcher("work-order.jsp").forward(request, response);
                    break;

                case "addWorkOrder":
                    int cId = Integer.parseInt(request.getParameter("cId"));
                    int pId = Integer.parseInt(request.getParameter("pId"));
                    int rId = Integer.parseInt(request.getParameter("rId"));
                    int qty = Integer.parseInt(request.getParameter("qty"));
                    String date = LocalDate.now().toString();

                    WorkOrderDTO newWO = new WorkOrderDTO(0, cId, pId, rId, qty, "New", date);
                    woDao.insertWorkOrder(newWO);
                    response.sendRedirect("MainController?action=listWorkOrder");
                    break;

                case "deleteWorkOrder":
                    int delId = Integer.parseInt(request.getParameter("id"));
                    woDao.deleteWorkOrder(delId);
                    response.sendRedirect("MainController?action=listWorkOrder");
                    break;

                case "loadUpdateWorkOrder":
                    int editId = Integer.parseInt(request.getParameter("id"));
                    request.setAttribute("woEdit", woDao.getWorkOrderById(editId));
                    request.setAttribute("listWO", listWO);
                    request.setAttribute("listC", listC);
                    request.setAttribute("listI", iDao.ItemList());
                    request.setAttribute("listR", rDao.getAllRouting());
                    request.getRequestDispatcher("work-order.jsp").forward(request, response);
                    break;

                case "saveUpdateWorkOrder":
                    int uId = Integer.parseInt(request.getParameter("id"));
                    int uCId = Integer.parseInt(request.getParameter("cId"));
                    int uPId = Integer.parseInt(request.getParameter("pId"));
                    int uRId = Integer.parseInt(request.getParameter("rId"));
                    int uQty = Integer.parseInt(request.getParameter("qty"));
                    String uStatus = request.getParameter("status"); 
                    
                    WorkOrderDTO updateWO = new WorkOrderDTO(uId, uCId, uPId, uRId, uQty, uStatus, "");
                    woDao.updateWorkOrder(updateWO);
                    response.sendRedirect("MainController?action=listWorkOrder");
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