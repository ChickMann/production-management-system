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
        action = action.trim();

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
                boolean inserted = dao.insertWorkOrder(wo);
                String insertNotice = inserted
                        ? java.net.URLEncoder.encode("Tạo lệnh sản xuất thành công", "UTF-8")
                        : java.net.URLEncoder.encode("Tạo lệnh sản xuất thất bại", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/MainController?action=listWorkOrder"
                        + (inserted ? "&msg=" : "&error=") + insertNotice);
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
                boolean updated = dao.updateWorkOrder(wo);
                String updateNotice = updated
                        ? java.net.URLEncoder.encode("Cập nhật lệnh sản xuất thành công", "UTF-8")
                        : java.net.URLEncoder.encode("Cập nhật lệnh sản xuất thất bại", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/MainController?action=listWorkOrder"
                        + (updated ? "&msg=" : "&error=") + updateNotice);
                return;

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("wo_id"));
                boolean deleted = dao.deleteWorkOrder(id);
                String deleteNotice = deleted
                        ? java.net.URLEncoder.encode("Xóa lệnh sản xuất thành công", "UTF-8")
                        : java.net.URLEncoder.encode("Không thể xóa lệnh sản xuất vì đang có dữ liệu liên quan", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/MainController?action=listWorkOrder"
                        + (deleted ? "&msg=" : "&error=") + deleteNotice);
                return;

            } else if ("search".equals(action)) {
                int id = Integer.parseInt(request.getParameter("wo_id"));
                WorkOrderDTO wo = dao.searchById(id);
                request.setAttribute("WORKORDER", wo);
                loadWorkOrderPageData(request, dao);
                request.getRequestDispatcher("workorder.jsp").forward(request, response);
                return;

            } else if ("listWorkOrder".equals(action) || "list".equals(action) || "loadUpdate".equals(action)
                    || "calendar".equals(action) || "gantt".equals(action)) {
                String searchKeyword = request.getParameter("keyword");
                String filterStatus = request.getParameter("status");
                String searchId = request.getParameter("search");
                String woIdParam = request.getParameter("wo_id");
                String msg = request.getParameter("msg");
                String error = request.getParameter("error");

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

                if (msg != null && !msg.trim().isEmpty()) {
                    request.setAttribute("msg", msg);
                }
                if (error != null && !error.trim().isEmpty()) {
                    request.setAttribute("error", error);
                }

                loadWorkOrderPageData(request, dao);

                if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                    request.setAttribute("workOrders", filterWorkOrders((List<WorkOrderDTO>) request.getAttribute("workOrders"), searchKeyword, filterStatus));
                } else if (filterStatus != null && !filterStatus.trim().isEmpty()) {
                    request.setAttribute("workOrders", filterWorkOrders((List<WorkOrderDTO>) request.getAttribute("workOrders"), null, filterStatus));
                }

                request.getRequestDispatcher(resolveView(action)).forward(request, response);
                return;
            }

            loadWorkOrderPageData(request, dao);
            request.getRequestDispatcher(resolveView(action)).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            loadWorkOrderPageData(request, dao);
            request.getRequestDispatcher(resolveView(action)).forward(request, response);
        }
    }

    private String resolveView(String action) {
        if ("calendar".equals(action)) {
            return "production-calendar.jsp";
        }
        if ("gantt".equals(action)) {
            return "production-gantt.jsp";
        }
        return "workorder.jsp";
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
