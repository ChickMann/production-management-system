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
import pms.model.BOMDAO;
import pms.model.BOMDTO;
import pms.model.BOMDetailDTO;
import pms.model.PurchaseOrderDAO;
import pms.model.PurchaseOrderDTO;

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
                
                String startDate = request.getParameter("start_date");
                if (startDate != null && startDate.contains("T")) startDate = startDate.replace("T", " ") + ":00";
                
                String dueDate = request.getParameter("due_date");
                if (dueDate != null && dueDate.contains("T")) dueDate = dueDate.replace("T", " ") + ":00";

                WorkOrderDTO wo = new WorkOrderDTO();
                wo.setProduct_item_id(product);
                wo.setRouting_id(routing);
                wo.setOrder_quantity(quantity);
                wo.setStatus(status);
                wo.setStart_date(startDate);
                wo.setDue_date(dueDate);

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
                
                String startDate = request.getParameter("start_date");
                if (startDate != null && startDate.contains("T")) startDate = startDate.replace("T", " ") + ":00";
                
                String dueDate = request.getParameter("due_date");
                if (dueDate != null && dueDate.contains("T")) dueDate = dueDate.replace("T", " ") + ":00";

                WorkOrderDTO wo = new WorkOrderDTO();
                wo.setWo_id(id);
                wo.setProduct_item_id(product);
                wo.setRouting_id(routing);
                wo.setOrder_quantity(quantity);
                wo.setStatus(status);
                wo.setStart_date(startDate);
                wo.setDue_date(dueDate);

                boolean updated = dao.updateWorkOrder(wo);
                String updateNotice = updated
                        ? java.net.URLEncoder.encode("Cập nhật lệnh sản xuất thành công", "UTF-8")
                        : java.net.URLEncoder.encode("Cập nhật lệnh sản xuất thất bại", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/MainController?action=listWorkOrder"
                        + (updated ? "&msg=" : "&error=") + updateNotice);
                return;

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("wo_id"));
                // Thay vì xóa cứng, ta chuyển trạng thái sang Cancelled
                boolean deleted = dao.updateWorkOrderStatusOnly(id, "Cancelled");
                String deleteNotice = deleted
                        ? java.net.URLEncoder.encode("Đã chuyển lệnh sản xuất vào danh sách ĐÃ HỦY", "UTF-8")
                        : java.net.URLEncoder.encode("Không thể hủy lệnh sản xuất này", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/MainController?action=listWorkOrder"
                        + (deleted ? "&msg=" : "&error=") + deleteNotice);
                return;

            } else if ("checkMaterials".equals(action)) {
                int woId = Integer.parseInt(request.getParameter("wo_id"));
                WorkOrderDTO wo = dao.searchById(woId);

                if (wo != null && ("New".equalsIgnoreCase(wo.getStatus()) || "WaitMaterial".equalsIgnoreCase(wo.getStatus()))) {
                    BOMDAO bomDao = new BOMDAO();
                    ItemDAO itemDao = new ItemDAO();
                    PurchaseOrderDAO poDao = new PurchaseOrderDAO();

                    List<BOMDTO> boms = bomDao.getBOMSByProduct(wo.getProduct_item_id());
                    if (boms == null || boms.isEmpty()) {
                        response.sendRedirect(request.getContextPath() + "/MainController?action=listWorkOrder&error=" 
                            + java.net.URLEncoder.encode("Sản phẩm chưa có công thức BOM, không thể tính toán!", "UTF-8"));
                        return;
                    }
                    
                    BOMDTO activeBom = boms.get(0); 
                    List<BOMDetailDTO> materials = bomDao.getBOMDetails(activeBom.getBomId());
                    boolean isMissingMaterial = false;
                    StringBuilder missingNotes = new StringBuilder("Thiếu: ");
                    
                    boolean isRechecking = "WaitMaterial".equalsIgnoreCase(wo.getStatus());

                    for (BOMDetailDTO mat : materials) {
                        double totalNeeded = mat.getQuantityRequired() * wo.getOrder_quantity();
                        ItemDTO item = itemDao.SearchByID(mat.getMaterialItemId());
                        
                        if (item.getStockQuantity() < totalNeeded) {
                            isMissingMaterial = true;
                            int missingAmount = (int) Math.ceil(totalNeeded - item.getStockQuantity());
                            missingNotes.append(missingAmount).append(" ").append(item.getItemName()).append(", ");

                            if (!isRechecking) {
                                PurchaseOrderDTO po = new PurchaseOrderDTO();
                                po.setItemId(item.getItemID());
                                po.setQuantityRequested(missingAmount); 
                                po.setStatus("Pending");
                                po.setOrderDate(new java.sql.Timestamp(System.currentTimeMillis()).toString());
                                poDao.insertPurchaseOrder(po);
                            }
                        }
                    }

                    if (isMissingMaterial) {
                        String notesToSave = missingNotes.substring(0, missingNotes.length() - 2);
                        dao.updateStatusAndNotes(woId, "WaitMaterial", notesToSave);
                        String msg = isRechecking ? "Vẫn còn thiếu vật tư, chưa thể sản xuất!" : "Thiếu vật tư! Đã tạo phiếu Nhập vật tư.";
                        response.sendRedirect(request.getContextPath() + "/MainController?action=listWorkOrder&msg=" 
                            + java.net.URLEncoder.encode(msg, "UTF-8"));
                    } else {
                        dao.updateStatusAndNotes(woId, "Ready", ""); 
                        response.sendRedirect(request.getContextPath() + "/MainController?action=listWorkOrder&msg=" 
                            + java.net.URLEncoder.encode("Kho đã đủ vật tư! Lệnh đã Sẵn sàng.", "UTF-8"));
                    }
                    return;
                }

            } else if ("startProduction".equals(action)) {
                int woId = Integer.parseInt(request.getParameter("wo_id"));
                WorkOrderDTO wo = dao.searchById(woId);
                
                if (wo != null && "Ready".equalsIgnoreCase(wo.getStatus())) {
                    BOMDAO bomDao = new BOMDAO();
                    ItemDAO itemDao = new ItemDAO();
                    
                    List<BOMDTO> boms = bomDao.getBOMSByProduct(wo.getProduct_item_id());
                    if (boms != null && !boms.isEmpty()) {
                        BOMDTO activeBom = boms.get(0); 
                        List<BOMDetailDTO> materials = bomDao.getBOMDetails(activeBom.getBomId());
                        
                        for (BOMDetailDTO mat : materials) {
                            int totalNeeded = (int) Math.ceil(mat.getQuantityRequired() * wo.getOrder_quantity());
                            itemDao.decreaseStock(mat.getMaterialItemId(), totalNeeded);
                        }
                    }
                    
                    dao.updateStatusAndNotes(woId, "In Progress", "");
                    response.sendRedirect(request.getContextPath() + "/MainController?action=listWorkOrder&msg=" 
                        + java.net.URLEncoder.encode("Đã xuất kho vật tư! Lệnh đang được tiến hành sản xuất.", "UTF-8"));
                    return;
                }

            } else if ("completeOrder".equals(action)) {
                int woId = Integer.parseInt(request.getParameter("wo_id"));
                WorkOrderDTO wo = dao.searchById(woId);

                if (wo != null && ("In Progress".equalsIgnoreCase(wo.getStatus()) || "InProgress".equalsIgnoreCase(wo.getStatus()))) {
                    ItemDAO itemDao = new ItemDAO();
                    itemDao.increaseStock(wo.getProduct_item_id(), wo.getOrder_quantity());
                    dao.updateWorkOrderStatusOnly(woId, "Done");
                    response.sendRedirect(request.getContextPath() + "/MainController?action=listWorkOrder&msg="
                        + java.net.URLEncoder.encode("Hoàn thành lệnh! Đã cộng " + wo.getOrder_quantity() + " " + wo.getProductName() + " vào kho.", "UTF-8"));
                    return;
                }

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
                String filterProduct = request.getParameter("product_id"); 
                String searchId = request.getParameter("search");
                String msg = request.getParameter("msg");
                String error = request.getParameter("error");

                if (searchId != null && !searchId.trim().isEmpty()) {
                    try {
                        request.setAttribute("WORKORDER", dao.searchById(Integer.parseInt(searchId.trim())));
                    } catch (NumberFormatException e) {
                        request.setAttribute("error", "Mã lệnh không hợp lệ");
                    }
                }

                if (msg != null && !msg.trim().isEmpty()) request.setAttribute("msg", msg);
                if (error != null && !error.trim().isEmpty()) request.setAttribute("error", error);

                loadWorkOrderPageData(request, dao);
                List<WorkOrderDTO> allWos = (List<WorkOrderDTO>) request.getAttribute("workOrders");
                request.setAttribute("workOrders", filterWorkOrders(allWos, searchKeyword, filterStatus, filterProduct));

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
        if ("calendar".equals(action)) return "production-calendar.jsp";
        if ("gantt".equals(action)) return "production-gantt.jsp";
        return "workorder.jsp";
    }

    private void loadWorkOrderPageData(HttpServletRequest request, WorkOrderDAO dao) {
        ItemDAO itemDao = new ItemDAO();
        RoutingDAO routingDao = new RoutingDAO();
        request.setAttribute("workOrders", dao.getAllWorkOrders());
        request.setAttribute("items", itemDao.getAllItems());
        request.setAttribute("routings", routingDao.getAllRouting());
    }

    private List<WorkOrderDTO> filterWorkOrders(List<WorkOrderDTO> source, String keyword, String status, String productIdStr) {
        if (source == null) return new ArrayList<>();
        List<WorkOrderDTO> filtered = new ArrayList<>();
        String normalizedKeyword = keyword != null ? keyword.trim().toLowerCase() : null;
        String normalizedStatus = status != null ? status.trim() : null;
        
        Integer filterProductId = null;
        if (productIdStr != null && !productIdStr.isEmpty()) {
            try { filterProductId = Integer.parseInt(productIdStr); } catch (Exception e) {}
        }

        for (WorkOrderDTO wo : source) {
            boolean matches = true;
            if (normalizedKeyword != null && !normalizedKeyword.isEmpty()) {
                String idText = String.valueOf(wo.getWo_id()).toLowerCase();
                String productName = wo.getProductName() != null ? wo.getProductName().toLowerCase() : "";
                String routingName = wo.getRoutingName() != null ? wo.getRoutingName().toLowerCase() : "";
                if (!idText.contains(normalizedKeyword) && !productName.contains(normalizedKeyword) && !routingName.contains(normalizedKeyword)) {
                    matches = false;
                }
            }
            if (matches && normalizedStatus != null && !normalizedStatus.isEmpty()) {
                String woStatus = wo.getStatus() != null ? wo.getStatus() : "";
                if (!woStatus.equalsIgnoreCase(normalizedStatus)) matches = false;
            }
            if (matches && filterProductId != null) {
                if (wo.getProduct_item_id() != filterProductId) matches = false;
            }
            if (matches) filtered.add(wo);
        }
        return filtered;
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
    public String getServletInfo() { return "WorkOrder Controller"; }
}