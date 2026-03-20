package pms.controllers;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.ItemDAO;
import pms.model.ItemDTO;

public class ItemController extends HttpServlet {

    String url = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listItems(request);
                break;
            case "search":
                searchItems(request);
                break;
            case "addItem":
                showAddForm(request);
                break;
            case "saveAddItem":
                addItem(request);
                break;
            case "editItem":
                showEditForm(request);
                break;
            case "saveUpdateItem":
                updateItem(request);
                break;
            case "deleteItem":
                deleteItem(request);
                break;
            case "lowStock":
                listLowStock(request);
                break;
        }

        if (url != null && url.startsWith("redirect:")) {
            response.sendRedirect(url.substring(9));
        } else {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private void listItems(HttpServletRequest request) {
        ItemDAO dao = new ItemDAO();
        ArrayList<ItemDTO> items = dao.getAllItems();
        request.setAttribute("items", items);
        url = "item-list.jsp";
    }

    private void searchItems(HttpServletRequest request) {
        ItemDAO dao = new ItemDAO();
        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");

        ArrayList<ItemDTO> items = dao.getAllItems();

        if (keyword != null && !keyword.trim().isEmpty()) {
            items.removeIf(i -> i.getItemName() == null || !i.getItemName().toLowerCase().contains(keyword.toLowerCase()));
        }
        if (type != null && !type.isEmpty() && !type.equals("all")) {
            items.removeIf(i -> !i.getItemType().equals(type));
        }

        request.setAttribute("items", items);
        url = "item-list.jsp";
    }

    private void listLowStock(HttpServletRequest request) {
        ItemDAO dao = new ItemDAO();
        ArrayList<ItemDTO> items = dao.getLowStockItems();
        request.setAttribute("items", items);
        request.setAttribute("lowStockOnly", true);
        url = "item-list.jsp";
    }

    private void showAddForm(HttpServletRequest request) {
        request.setAttribute("mode", "add");
        url = "item-form.jsp";
    }

    private void showEditForm(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        int id = 0;
        try {
            id = Integer.parseInt(s_id);
        } catch (Exception e) {
            request.setAttribute("error", "Invalid item ID");
            url = "redirect:ItemController?action=list";
            return;
        }

        ItemDAO dao = new ItemDAO();
        ItemDTO item = dao.SearchByID(id);
        request.setAttribute("item", item);
        request.setAttribute("mode", "update");
        url = "item-form.jsp";
    }

    private void addItem(HttpServletRequest request) {
        String error = "";

        try {
            String itemName = request.getParameter("itemName");
            String itemType = request.getParameter("itemType");
            int stockQuantity = 0;
            try {
                stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            } catch (Exception e) {
            }
            String unit = request.getParameter("unit");
            String description = request.getParameter("description");
            int minStockLevel = 0;
            try {
                minStockLevel = Integer.parseInt(request.getParameter("minStockLevel"));
            } catch (Exception e) {
            }

            ItemDTO item = new ItemDTO();
            item.setItemName(itemName);
            item.setItemType(itemType);
            item.setStockQuantity(stockQuantity);
            item.setUnit(unit);
            item.setDescription(description);
            item.setMinStockLevel(minStockLevel);

            ItemDAO dao = new ItemDAO();
            if (dao.Add(item)) {
                url = "redirect:ItemController?action=list&msg="
                        + java.net.URLEncoder.encode("Thêm vật tư thành công", "UTF-8");
                return;
            } else {
                error = "Không thể thêm vật tư";
                dao.ReseedSQL();
            }
        } catch (Exception e) {
            error = "Lỗi: " + e.getMessage();
        }

        request.setAttribute("error", error);
        request.setAttribute("mode", "add");
        url = "item-form.jsp";
    }

    private void updateItem(HttpServletRequest request) {
        String msg = "";
        String error = "";

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String itemName = request.getParameter("itemName");
            String itemType = request.getParameter("itemType");
            int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            String unit = request.getParameter("unit");
            String description = request.getParameter("description");
            int minStockLevel = Integer.parseInt(request.getParameter("minStockLevel"));

            ItemDTO item = new ItemDTO();
            item.setItemID(id);
            item.setItemName(itemName);
            item.setItemType(itemType);
            item.setStockQuantity(stockQuantity);
            item.setUnit(unit);
            item.setDescription(description);
            item.setMinStockLevel(minStockLevel);

            ItemDAO dao = new ItemDAO();
            if (dao.Update(item)) {
                msg = "Item updated successfully!";
            } else {
                error = "Failed to update item";
            }
        } catch (Exception e) {
            error = "Error: " + e.getMessage();
        }

        request.setAttribute("msg", msg);
        request.setAttribute("error", error);
        url = "redirect:ItemController?action=list";
    }

    private void deleteItem(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        try {
            int id = Integer.parseInt(s_id);
            ItemDAO dao = new ItemDAO();
            boolean success = dao.Delete(id);
            if (success) {
                request.setAttribute("msg", "Item deleted successfully!");
            } else {
                request.setAttribute("error", "Failed to delete item");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        url = "redirect:ItemController?action=list";
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
        return "Item Controller";
    }
}
