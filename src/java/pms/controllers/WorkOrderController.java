/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package pms.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.ItemDAO;
import pms.model.ItemDTO;
import pms.model.RoutingDAO;
import pms.model.RoutingDTO;
import pms.model.WorkOrderDAO;
import pms.model.WorkOrderDTO;

/**
 *
 * @author HP
 */
public class WorkOrderController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "listWorkOrder";
        }

        WorkOrderDAO dao = new WorkOrderDAO();

        try {
            if ("insert".equals(action)) {
                int product = Integer.parseInt(request.getParameter("product_item_id"));
                int routing = Integer.parseInt(request.getParameter("routing_id"));
                int quantity = Integer.parseInt(request.getParameter("order_quantity"));
                String status = request.getParameter("status");

                WorkOrderDTO wo = new WorkOrderDTO();
                wo.setProduct_item_id(product);
                wo.setRouting_id(routing);
                wo.setOrder_quantity(quantity);
                wo.setStatus(status);
                dao.insertWorkOrder(wo);
                response.sendRedirect("MainController?action=listWorkOrder");
                return;

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("wo_id"));
                int product = Integer.parseInt(request.getParameter("product_item_id"));
                int routing = Integer.parseInt(request.getParameter("routing_id"));
                int quantity = Integer.parseInt(request.getParameter("order_quantity"));
                String status = request.getParameter("status");

                WorkOrderDTO wo = new WorkOrderDTO();
                wo.setWo_id(id);
                wo.setProduct_item_id(product);
                wo.setRouting_id(routing);
                wo.setOrder_quantity(quantity);
                wo.setStatus(status);
                dao.updateWorkOrder(wo);
                response.sendRedirect("MainController?action=listWorkOrder");
                return;

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("wo_id"));
                dao.deleteWorkOrder(id);
                response.sendRedirect("MainController?action=listWorkOrder");
                return;

            } else if ("search".equals(action)) {
                int id = Integer.parseInt(request.getParameter("wo_id"));
                WorkOrderDTO wo = dao.searchById(id);
                request.setAttribute("WORKORDER", wo);
                loadWorkOrderPageData(request, dao);
                request.getRequestDispatcher("workorder.jsp").forward(request, response);
                return;

            } else if ("listWorkOrder".equals(action) || "list".equals(action) || "loadUpdate".equals(action)) {
                String searchKeyword = request.getParameter("keyword");
                String filterStatus = request.getParameter("status");
                String searchId = request.getParameter("search");
                String woIdParam = request.getParameter("wo_id");

                if (searchId != null && !searchId.trim().isEmpty()) {
                    try {
                        request.setAttribute("WORKORDER", dao.searchById(Integer.parseInt(searchId.trim())));
                    } catch (NumberFormatException e) {
                        request.setAttribute("error", "Mã lệnh sản xuất không hợp lệ");
                    }
                } else if (woIdParam != null && !woIdParam.trim().isEmpty()) {
                    try {
                        request.setAttribute("WORKORDER", dao.searchById(Integer.parseInt(woIdParam.trim())));
                    } catch (NumberFormatException e) {
                        request.setAttribute("error", "Mã lệnh sản xuất không hợp lệ");
                    }
                }

                loadWorkOrderPageData(request, dao);

                if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                    request.setAttribute("workOrders", filterWorkOrders((List<WorkOrderDTO>) request.getAttribute("workOrders"), searchKeyword, filterStatus));
                } else if (filterStatus != null && !filterStatus.trim().isEmpty()) {
                    request.setAttribute("workOrders", filterWorkOrders((List<WorkOrderDTO>) request.getAttribute("workOrders"), null, filterStatus));
                }

                request.getRequestDispatcher("workorder.jsp").forward(request, response);
                return;
            }

            loadWorkOrderPageData(request, dao);
            request.getRequestDispatcher("workorder.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            loadWorkOrderPageData(request, dao);
            request.getRequestDispatcher("workorder.jsp").forward(request, response);
        }
    }

    private void loadWorkOrderPageData(HttpServletRequest request, WorkOrderDAO dao) {
        ItemDAO itemDao = new ItemDAO();
        RoutingDAO routingDao = new RoutingDAO();

        List<WorkOrderDTO> workOrders = dao.getAllWorkOrders();
        List<ItemDTO> items = itemDao.getAllItems();
        List<RoutingDTO> routings = routingDao.getAllRouting();

        request.setAttribute("workOrders", workOrders != null ? workOrders : new ArrayList<WorkOrderDTO>());
        request.setAttribute("items", items != null ? items : new ArrayList<ItemDTO>());
        request.setAttribute("routings", routings != null ? routings : new ArrayList<RoutingDTO>());
    }

    private List<WorkOrderDTO> filterWorkOrders(List<WorkOrderDTO> source, String keyword, String status) {
        List<WorkOrderDTO> filtered = new ArrayList<>();
        String normalizedKeyword = keyword != null ? keyword.trim().toLowerCase() : null;
        String normalizedStatus = status != null ? status.trim() : null;

        for (WorkOrderDTO wo : source) {
            boolean matchesKeyword = true;
            boolean matchesStatus = true;

            if (normalizedKeyword != null && !normalizedKeyword.isEmpty()) {
                String idText = String.valueOf(wo.getWo_id()).toLowerCase();
                String productName = wo.getProductName() != null ? wo.getProductName().toLowerCase() : "";
                String routingName = wo.getRoutingName() != null ? wo.getRoutingName().toLowerCase() : "";
                matchesKeyword = idText.contains(normalizedKeyword)
                        || productName.contains(normalizedKeyword)
                        || routingName.contains(normalizedKeyword);
            }

            if (normalizedStatus != null && !normalizedStatus.isEmpty()) {
                String woStatus = wo.getStatus() != null ? wo.getStatus() : "";
                matchesStatus = woStatus.equalsIgnoreCase(normalizedStatus);
            }

            if (matchesKeyword && matchesStatus) {
                filtered.add(wo);
            }
        }

        return filtered;
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
        return "Short description";
    }
}
