package pms.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.ItemDAO;
import pms.model.CustomerDAO;
import pms.model.SupplierDAO;
import pms.model.WorkOrderDAO;
import pms.model.BOMDAO;
import pms.model.ItemDTO;
import pms.model.CustomerDTO;
import pms.model.SupplierDTO;
import pms.model.WorkOrderDTO;
import pms.model.BOMDTO;

public class AutoCompleteSearchServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        String query = request.getParameter("q");
        String type = request.getParameter("type");

        if (query == null || query.trim().isEmpty()) {
            writeResponse(response, "[]");
            return;
        }

        query = query.trim();
        StringBuilder json = new StringBuilder();
        json.append("[");

        try {
            boolean first = true;

            if (type == null || type.isEmpty() || "item".equals(type)) {
                for (ItemDTO item : searchItems(query)) {
                    if (!first) json.append(",");
                    json.append("{\"type\":\"item\",\"id\":").append(item.getItemID())
                        .append(",\"label\":\"").append(esc(item.getItemName())).append("\"")
                        .append(",\"sublabel\":\"").append(esc(item.getItemType())).append(" | ").append(item.getStockQuantity()).append(" ").append(esc(item.getUnit())).append("\"")
                        .append(",\"url\":\"MainController?action=updateItem&id=").append(item.getItemID())
                        .append("\"}");

                    first = false;
                }
            }

            if (type == null || type.isEmpty() || "customer".equals(type)) {
                for (CustomerDTO c : searchCustomers(query)) {
                    if (!first) json.append(",");
                    String phone = c.getPhone() != null ? c.getPhone() : "";
                    String email = c.getEmail() != null ? c.getEmail() : "";
                    json.append("{\"type\":\"customer\",\"id\":").append(c.getCustomer_id())
                        .append(",\"label\":\"").append(esc(c.getCustomer_name())).append("\"")
                        .append(",\"sublabel\":\"").append(esc(phone)).append(email.isEmpty() ? "" : " | " + esc(email)).append("\"")
                        .append(",\"url\":\"MainController?action=updateCustomer&id=").append(c.getCustomer_id()).append("\"}")
                        .append("}");
                    first = false;
                }
            }

            if (type == null || type.isEmpty() || "supplier".equals(type)) {
                for (SupplierDTO s : searchSuppliers(query)) {
                    if (!first) json.append(",");
                    String city = s.getCity() != null ? s.getCity() : (s.getEmail() != null ? s.getEmail() : "");
                    json.append("{\"type\":\"supplier\",\"id\":").append(s.getSupplierId())
                        .append(",\"label\":\"").append(esc(s.getSupplierName())).append("\"")
                        .append(",\"sublabel\":\"").append(esc(city)).append("\"")
                        .append(",\"url\":\"MainController?action=updateSupplier&id=").append(s.getSupplierId()).append("\"}")
                        .append("}");
                    first = false;
                }
            }

            if (type == null || type.isEmpty() || "workorder".equals(type)) {
                for (WorkOrderDTO wo : searchWorkOrders(query)) {
                    if (!first) json.append(",");
                    String label = "#" + wo.getWo_id() + (wo.getProductName() != null ? " - " + wo.getProductName() : "");
                    json.append("{\"type\":\"workorder\",\"id\":").append(wo.getWo_id())
                        .append(",\"label\":\"").append(esc(label)).append("\"")
                        .append(",\"sublabel\":\"SL: ").append(wo.getOrder_quantity()).append(" | Status: ").append(wo.getStatus() != null ? wo.getStatus() : "N/A").append("\"")
                        .append(",\"url\":\"MainController?action=updateWorkOrder&id=").append(wo.getWo_id()).append("\"}")
                        .append("}");
                    first = false;
                }
            }

            if (type == null || type.isEmpty() || "bom".equals(type)) {
                for (BOMDTO bom : searchBoms(query)) {
                    if (!first) json.append(",");
                    String name = (bom.getProductName() != null ? bom.getProductName() : "") + " (" + (bom.getBomVersion() != null ? bom.getBomVersion() : "") + ")";
                    json.append("{\"type\":\"bom\",\"id\":").append(bom.getBomId())
                        .append(",\"label\":\"").append(esc(name)).append("\"")
                        .append(",\"sublabel\":\"Status: ").append(bom.getStatus() != null ? bom.getStatus() : "N/A").append("\"")
                        .append(",\"url\":\"MainController?action=viewBOM&id=").append(bom.getBomId()).append("\"}")
                        .append("}");
                    first = false;
                }
            }

        } catch (Exception e) {
            json.append("{\"error\":\"").append(esc(e.getMessage())).append("\"}]");
            writeResponse(response, json.toString());
            return;
        }

        json.append("]");
        writeResponse(response, json.toString());
    }

    private List<ItemDTO> searchItems(String query) {
        List<ItemDTO> result = new ArrayList<>();
        ItemDAO dao = new ItemDAO();
        ArrayList<ItemDTO> items = dao.FilterByName(query);
        if (items != null) {
            for (ItemDTO item : items) {
                if (matches(item.getItemName(), query)) {
                    result.add(item);
                }
            }
        }
        return result;
    }

    private List<CustomerDTO> searchCustomers(String query) {
        List<CustomerDTO> result = new ArrayList<>();
        try {
            CustomerDAO dao = new CustomerDAO();
            List<CustomerDTO> list = dao.getAllCustomers();
            if (list != null) {
                for (CustomerDTO c : list) {
                    String name = c.getCustomer_name() != null ? c.getCustomer_name() : "";
                    String phone = c.getPhone() != null ? c.getPhone() : "";
                    if (matches(name, query) || phone.contains(query)) {
                        result.add(c);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private List<SupplierDTO> searchSuppliers(String query) {
        List<SupplierDTO> result = new ArrayList<>();
        try {
            SupplierDAO dao = new SupplierDAO();
            ArrayList<SupplierDTO> list = dao.getAllSupplier();
            if (list != null) {
                for (SupplierDTO s : list) {
                    String name = s.getSupplierName() != null ? s.getSupplierName() : "";
                    String phone = s.getContactPhone() != null ? s.getContactPhone() : "";
                    if (matches(name, query) || phone.contains(query)) {
                        result.add(s);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private List<WorkOrderDTO> searchWorkOrders(String query) {
        List<WorkOrderDTO> result = new ArrayList<>();
        try {
            WorkOrderDAO dao = new WorkOrderDAO();
            List<WorkOrderDTO> list = dao.getAllWorkOrders();
            if (list != null) {
                for (WorkOrderDTO wo : list) {
                    String label = "#" + wo.getWo_id() + (wo.getProductName() != null ? " " + wo.getProductName() : "");
                    if (matches(label, query) || String.valueOf(wo.getWo_id()).contains(query)) {
                        result.add(wo);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private List<BOMDTO> searchBoms(String query) {
        List<BOMDTO> result = new ArrayList<>();
        try {
            BOMDAO dao = new BOMDAO();
            List<BOMDTO> list = dao.getAllBOMS();
            if (list != null) {
                for (BOMDTO bom : list) {
                    String name = bom.getProductName() != null ? bom.getProductName() : "";
                    String ver = bom.getBomVersion() != null ? bom.getBomVersion() : "";
                    if (matches(name, query) || matches(ver, query)) {
                        result.add(bom);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private boolean matches(String field, String query) {
        return field != null && field.toLowerCase().contains(query.toLowerCase());
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                 .replace("\"", "\\\"")
                 .replace("\n", "\\n")
                 .replace("\r", "\\r")
                 .replace("\t", "\\t");
    }

    private void writeResponse(HttpServletResponse response, String json) throws IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.getWriter().write(json);
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
