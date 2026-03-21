package pms.controllers;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.BOMDAO;
import pms.model.BOMDTO;
import pms.model.BOMDetailDTO;
import pms.model.ItemDAO;
import pms.model.ItemDTO;

public class BOMController extends HttpServlet {

    String url = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "list":
            case "listBOM":
                listBOMs(request);
                break;
            case "search":
                searchBOMs(request);
                break;
            case "addBOM":
                showAddForm(request);
                break;
            case "saveAddBOM":
                addBOM(request);
                break;
            case "editBOM":
                showEditForm(request);
                break;
            case "saveUpdateBOM":
                updateBOM(request);
                break;
            case "viewBOM":
                viewBOM(request);
                break;
            case "cloneBOM":
                cloneBOM(request);
                break;
            case "deleteBOM":
                deleteBOM(request);
                break;
            case "activateBOM":
                activateBOM(request);
                break;
            case "deactivateBOM":
                deactivateBOM(request);
                break;
            case "addDetail":
                addDetail(request);
                break;
            case "updateDetail":
                updateDetail(request);
                break;
            case "deleteDetail":
                deleteDetail(request);
                break;
            default:
                url = "redirect:BOMController?action=list";
                break;
        }

        if (url != null && url.startsWith("redirect:")) {
            response.sendRedirect(url.substring(9));
        } else {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private void listBOMs(HttpServletRequest request) {
        BOMDAO dao = new BOMDAO();
        ItemDAO itemDao = new ItemDAO();
        List<BOMDTO> boms = dao.getAllBOMS();
        List<ItemDTO> products = itemDao.getProducts();
        request.setAttribute("boms", boms);
        request.setAttribute("products", products);
        url = "bom-list.jsp";
    }

    private void searchBOMs(HttpServletRequest request) {
        BOMDAO dao = new BOMDAO();
        ItemDAO itemDao = new ItemDAO();
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        List<BOMDTO> boms = dao.getAllBOMS();
        List<ItemDTO> products = itemDao.getProducts();

        if (keyword != null && !keyword.trim().isEmpty()) {
            boms.removeIf(b -> b.getProductName() == null || !b.getProductName().toLowerCase().contains(keyword.toLowerCase()));
        }
        if (status != null && !status.isEmpty() && !status.equals("all")) {
            boms.removeIf(b -> !b.getStatus().equals(status));
        }

        request.setAttribute("boms", boms);
        request.setAttribute("products", products);
        url = "bom-list.jsp";
    }

    private void viewBOM(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        int id = 0;
        try {
            id = Integer.parseInt(s_id);
        } catch (Exception e) {
            request.setAttribute("error", "Invalid BOM ID");
            url = "redirect:BOMController?action=list";
            return;
        }

        BOMDAO dao = new BOMDAO();
        BOMDTO bom = dao.getBOMById(id);
        request.setAttribute("bom", bom);
        url = "bom-detail.jsp";
    }

    private void showAddForm(HttpServletRequest request) {
        ItemDAO itemDao = new ItemDAO();
        List<ItemDTO> products = itemDao.getProducts();
        request.setAttribute("products", products);
        request.setAttribute("mode", "add");
        url = "bom-form.jsp";
    }

    private void showEditForm(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        int id = 0;
        try {
            id = Integer.parseInt(s_id);
        } catch (Exception e) {
            request.setAttribute("error", "Invalid BOM ID");
            url = "redirect:BOMController?action=list";
            return;
        }

        BOMDAO dao = new BOMDAO();
        ItemDAO itemDao = new ItemDAO();
        
        BOMDTO bom = dao.getBOMById(id);
        List<ItemDTO> products = itemDao.getProducts();
        
        request.setAttribute("bom", bom);
        request.setAttribute("products", products);
        request.setAttribute("mode", "update");
        url = "bom-form.jsp";
    }

    private void addBOM(HttpServletRequest request) {
        String msg = "";
        String error = "";

        try {
            int productItemId = Integer.parseInt(request.getParameter("productItemId"));
            String version = request.getParameter("version");
            if (version == null || version.trim().isEmpty()) { version = "v1.0"; }
            String status = request.getParameter("status");
            if (status == null || status.trim().isEmpty()) { status = "active"; }
            String notes = request.getParameter("notes");

            BOMDTO bom = new BOMDTO();
            bom.setProductItemId(productItemId);
            bom.setBomVersion(version);
            bom.setStatus(status);
            bom.setNotes(notes);

            BOMDAO dao = new BOMDAO();
            if (dao.insertBOM(bom)) {
                url = "redirect:BOMController?action=list&msg=T%E1%BA%A1o%20BOM%20m%E1%BB%9Bi%20th%C3%A0nh%20c%C3%B4ng";
                return;
            } else {
                error = "Không thể tạo BOM mới";
            }
        } catch (Exception e) {
            error = "Lỗi: " + e.getMessage();
        }

        request.setAttribute("msg", msg);
        request.setAttribute("error", error);
        request.setAttribute("products", new ItemDAO().getProducts());
        request.setAttribute("mode", "add");
        url = "bom-list.jsp";
    }

    private void updateBOM(HttpServletRequest request) {
        String msg = "";
        String error = "";

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int productItemId = Integer.parseInt(request.getParameter("productItemId"));
            String version = request.getParameter("version");
            if (version == null || version.trim().isEmpty()) { version = "v1.0"; }
            String status = request.getParameter("status");
            if (status == null || status.trim().isEmpty()) { status = "active"; }
            String notes = request.getParameter("notes");

            BOMDTO bom = new BOMDTO();
            bom.setBomId(id);
            bom.setProductItemId(productItemId);
            bom.setBomVersion(version);
            bom.setStatus(status);
            bom.setNotes(notes);

            BOMDAO dao = new BOMDAO();
            if (dao.updateBOM(bom)) {
                msg = "BOM updated successfully!";
            } else {
                error = "Failed to update BOM";
            }
        } catch (Exception e) {
            error = "Error: " + e.getMessage();
        }

        request.setAttribute("msg", msg);
        request.setAttribute("error", error);
        request.setAttribute("mode", "update");
        url = "redirect:BOMController?action=viewBOM&id=" + request.getParameter("id");
    }

    private void cloneBOM(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        String newVersion = request.getParameter("newVersion");

        try {
            int id = Integer.parseInt(s_id);
            BOMDAO dao = new BOMDAO();
            
            if (newVersion == null || newVersion.trim().isEmpty()) {
                BOMDTO existing = dao.getBOMById(id);
                String currentVersion = existing.getBomVersion();
                if (currentVersion != null && currentVersion.startsWith("v")) {
                    try {
                        int verNum = Integer.parseInt(currentVersion.substring(1).split("\\.")[0]);
                        newVersion = "v" + (verNum + 1) + ".0";
                    } catch (Exception ex) {
                        newVersion = "v2.0";
                    }
                } else {
                    newVersion = "v2.0";
                }
            }
            
            boolean success = dao.cloneBOM(id, newVersion);
            if (success) {
                request.setAttribute("msg", "BOM cloned successfully as version " + newVersion);
            } else {
                request.setAttribute("error", "Failed to clone BOM");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        url = "redirect:BOMController?action=list";
    }

    private void deleteBOM(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        try {
            int id = Integer.parseInt(s_id);
            BOMDAO dao = new BOMDAO();
            boolean success = dao.deleteBOM(id);
            if (success) {
                request.setAttribute("msg", "BOM deleted successfully!");
            } else {
                request.setAttribute("error", "Failed to delete BOM");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        url = "redirect:BOMController?action=list";
    }

    private void activateBOM(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        try {
            int id = Integer.parseInt(s_id);
            BOMDAO dao = new BOMDAO();
            boolean success = dao.activateBOM(id);
            if (success) {
                request.setAttribute("msg", "BOM activated successfully!");
            } else {
                request.setAttribute("error", "Failed to activate BOM");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        url = "redirect:BOMController?action=list";
    }

    private void deactivateBOM(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        try {
            int id = Integer.parseInt(s_id);
            BOMDAO dao = new BOMDAO();
            boolean success = dao.deactivateBOM(id);
            if (success) {
                request.setAttribute("msg", "BOM deactivated successfully!");
            } else {
                request.setAttribute("error", "Failed to deactivate BOM");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        url = "redirect:BOMController?action=list";
    }

    private void addDetail(HttpServletRequest request) {
        String s_bomId = request.getParameter("bomId");
        try {
            int bomId = Integer.parseInt(s_bomId);
            int materialItemId = Integer.parseInt(request.getParameter("materialItemId"));
            double quantity = Double.parseDouble(request.getParameter("quantity"));
            String unit = request.getParameter("unit");
            double wastePercent = 0;
            try {
                wastePercent = Double.parseDouble(request.getParameter("wastePercent"));
            } catch (Exception e) {}
            String notes = request.getParameter("notes");

            BOMDetailDTO detail = new BOMDetailDTO();
            detail.setBomId(bomId);
            detail.setMaterialItemId(materialItemId);
            detail.setQuantityRequired(quantity);
            detail.setUnit(unit);
            detail.setWastePercent(wastePercent);
            detail.setNotes(notes);

            BOMDAO dao = new BOMDAO();
            boolean success = dao.addBOMDetail(detail);
            if (success) {
                request.setAttribute("msg", "Material added successfully!");
            } else {
                request.setAttribute("error", "Failed to add material");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        url = "redirect:BOMController?action=viewBOM&id=" + s_bomId;
    }

    private void updateDetail(HttpServletRequest request) {
        String s_bomId = request.getParameter("bomId");
        try {
            int detailId = Integer.parseInt(request.getParameter("detailId"));
            int materialItemId = Integer.parseInt(request.getParameter("materialItemId"));
            double quantity = Double.parseDouble(request.getParameter("quantity"));
            String unit = request.getParameter("unit");
            double wastePercent = Double.parseDouble(request.getParameter("wastePercent"));
            String notes = request.getParameter("notes");

            BOMDetailDTO detail = new BOMDetailDTO();
            detail.setBomDetailId(detailId);
            detail.setMaterialItemId(materialItemId);
            detail.setQuantityRequired(quantity);
            detail.setUnit(unit);
            detail.setWastePercent(wastePercent);
            detail.setNotes(notes);

            BOMDAO dao = new BOMDAO();
            boolean success = dao.updateBOMDetail(detail);
            if (success) {
                request.setAttribute("msg", "Material updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update material");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        url = "redirect:BOMController?action=viewBOM&id=" + s_bomId;
    }

    private void deleteDetail(HttpServletRequest request) {
        String s_bomId = request.getParameter("bomId");
        String s_id = request.getParameter("id");
        try {
            int detailId = Integer.parseInt(s_id);
            BOMDAO dao = new BOMDAO();
            boolean success = dao.deleteBOMDetail(detailId);
            if (success) {
                request.setAttribute("msg", "Material deleted successfully!");
            } else {
                request.setAttribute("error", "Failed to delete material");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        url = "redirect:BOMController?action=viewBOM&id=" + s_bomId;
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
        return "BOM Controller";
    }
}
