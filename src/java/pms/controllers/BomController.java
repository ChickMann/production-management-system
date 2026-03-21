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
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String url = "";
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "list":
            case "listBOM":
                url = listBOMs(request);
                break;
            case "search":
                url = searchBOMs(request);
                break;
            case "addBOM":
                url = showAddForm(request);
                break;
            case "saveAddBOM":
                url = addBOM(request);
                break;
            case "editBOM":
                url = showEditForm(request);
                break;
            case "saveUpdateBOM":
                url = updateBOM(request);
                break;
            case "viewBOM":
                url = viewBOM(request);
                break;
            case "cloneBOM":
                url = cloneBOM(request);
                break;
            case "deleteBOM":
                url = deleteBOM(request);
                break;
            case "activateBOM":
                url = activateBOM(request);
                break;
            case "deactivateBOM":
                url = deactivateBOM(request);
                break;
            case "addDetail":
                url = addDetail(request);
                break;
            case "updateDetail":
                url = updateDetail(request);
                break;
            case "deleteDetail":
                url = deleteDetail(request);
                break;
            default:
                url = "redirect:BOMController?action=list";
                break;
        }

        if (url != null && url.startsWith("redirect:")) {
            response.sendRedirect(url.substring(9));
        } else if (url != null && !url.isEmpty()) {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private String listBOMs(HttpServletRequest request) {
        BOMDAO dao = new BOMDAO();
        ItemDAO itemDao = new ItemDAO();
        List<BOMDTO> boms = dao.getAllBOMS();
        List<ItemDTO> products = itemDao.getProducts();
        request.setAttribute("boms", boms);
        request.setAttribute("products", products);
        return "bom-list.jsp";
    }

    private String searchBOMs(HttpServletRequest request) {
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
        return "bom-list.jsp";
    }

    private String viewBOM(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        int id = 0;
        try {
            id = Integer.parseInt(s_id);
        } catch (Exception e) {
            request.setAttribute("error", "Invalid BOM ID");
            return "redirect:BOMController?action=list";
        }

        BOMDAO dao = new BOMDAO();
        BOMDTO bom = dao.getBOMById(id);
        if (bom == null) {
            request.setAttribute("error", "BOM not found");
            return "redirect:BOMController?action=list";
        }
        request.setAttribute("bom", bom);
        return "bom-detail.jsp";
    }

    private String showAddForm(HttpServletRequest request) {
        ItemDAO itemDao = new ItemDAO();
        List<ItemDTO> products = itemDao.getProducts();
        request.setAttribute("products", products);
        request.setAttribute("mode", "add");
        return "bom-form.jsp";
    }

    private String showEditForm(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        int id = 0;
        try {
            id = Integer.parseInt(s_id);
        } catch (Exception e) {
            request.setAttribute("error", "Invalid BOM ID");
            return "redirect:BOMController?action=list";
        }

        BOMDAO dao = new BOMDAO();
        ItemDAO itemDao = new ItemDAO();
        
        BOMDTO bom = dao.getBOMById(id);
        if (bom == null) {
            request.setAttribute("error", "BOM not found");
            return "redirect:BOMController?action=list";
        }
        List<ItemDTO> products = itemDao.getProducts();
        
        request.setAttribute("bom", bom);
        request.setAttribute("products", products);
        request.setAttribute("mode", "update");
        return "bom-form.jsp";
    }

    private String addBOM(HttpServletRequest request) {
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
                return "redirect:BOMController?action=list&msg=Success";
            } else {
                error = "Failed to create BOM";
            }
        } catch (Exception e) {
            error = "Error: " + e.getMessage();
        }

        request.setAttribute("msg", msg);
        request.setAttribute("error", error);
        request.setAttribute("products", new ItemDAO().getProducts());
        request.setAttribute("mode", "add");
        return "bom-list.jsp";
    }

    private String updateBOM(HttpServletRequest request) {
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
                return "redirect:BOMController?action=viewBOM&id=" + id;
            } else {
                error = "Failed to update BOM";
            }
        } catch (Exception e) {
            error = "Error: " + e.getMessage();
        }

        request.setAttribute("error", error);
        request.setAttribute("mode", "update");
        return "bom-form.jsp";
    }

    private String cloneBOM(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        String newVersion = request.getParameter("newVersion");
        try {
            int id = Integer.parseInt(s_id);
            BOMDAO dao = new BOMDAO();
            boolean success = dao.cloneBOM(id, newVersion != null ? newVersion : "v2.0");
            if (success) {
                request.setAttribute("msg", "BOM cloned successfully!");
            } else {
                request.setAttribute("error", "Failed to clone BOM");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        return "redirect:BOMController?action=list";
    }

    private String deleteBOM(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        try {
            int id = Integer.parseInt(s_id);
            BOMDAO dao = new BOMDAO();
            if (dao.deleteBOM(id)) {
                request.setAttribute("msg", "BOM deleted successfully!");
            } else {
                request.setAttribute("error", "Failed to delete BOM");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        return "redirect:BOMController?action=list";
    }

    private String activateBOM(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        try {
            int id = Integer.parseInt(s_id);
            BOMDAO dao = new BOMDAO();
            if (dao.activateBOM(id)) {
                request.setAttribute("msg", "BOM activated!");
            } else {
                request.setAttribute("error", "Failed to activate BOM");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        return "redirect:BOMController?action=list";
    }

    private String deactivateBOM(HttpServletRequest request) {
        String s_id = request.getParameter("id");
        try {
            int id = Integer.parseInt(s_id);
            BOMDAO dao = new BOMDAO();
            if (dao.deactivateBOM(id)) {
                request.setAttribute("msg", "BOM deactivated!");
            } else {
                request.setAttribute("error", "Failed to deactivate BOM");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        return "redirect:BOMController?action=list";
    }

    private String addDetail(HttpServletRequest request) {
        String s_bomId = request.getParameter("bomId");
        try {
            int bomId = Integer.parseInt(s_bomId);
            int materialItemId = Integer.parseInt(request.getParameter("materialItemId"));
            double quantity = Double.parseDouble(request.getParameter("quantity"));
            String unit = request.getParameter("unit");
            double wastePercent = 0;
            String swp = request.getParameter("wastePercent");
            if (swp != null && !swp.isEmpty()) {
                try { wastePercent = Double.parseDouble(swp); } catch (Exception e) {}
            }
            String notes = request.getParameter("notes");

            BOMDetailDTO detail = new BOMDetailDTO(0, bomId, materialItemId, "", quantity, unit, wastePercent, notes);
            if (new BOMDAO().addBOMDetail(detail)) {
                request.setAttribute("msg", "Material added!");
            } else {
                request.setAttribute("error", "Failed to add material");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        return "redirect:BOMController?action=viewBOM&id=" + s_bomId;
    }

    private String updateDetail(HttpServletRequest request) {
        String s_bomId = request.getParameter("bomId");
        try {
            int detailId = Integer.parseInt(request.getParameter("detailId"));
            int materialItemId = Integer.parseInt(request.getParameter("materialItemId"));
            double quantity = Double.parseDouble(request.getParameter("quantity"));
            String unit = request.getParameter("unit");
            double wastePercent = 0;
            String swp = request.getParameter("wastePercent");
            if (swp != null && !swp.isEmpty()) {
                try { wastePercent = Double.parseDouble(swp); } catch (Exception e) {}
            }
            String notes = request.getParameter("notes");

            BOMDetailDTO detail = new BOMDetailDTO(detailId, 0, materialItemId, "", quantity, unit, wastePercent, notes);
            if (new BOMDAO().updateBOMDetail(detail)) {
                request.setAttribute("msg", "Material updated!");
            } else {
                request.setAttribute("error", "Failed to update material");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        return "redirect:BOMController?action=viewBOM&id=" + s_bomId;
    }

    private String deleteDetail(HttpServletRequest request) {
        String s_bomId = request.getParameter("bomId");
        try {
            int detailId = Integer.parseInt(request.getParameter("id"));
            if (new BOMDAO().deleteBOMDetail(detailId)) {
                request.setAttribute("msg", "Material deleted!");
            } else {
                request.setAttribute("error", "Failed to delete material");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        return "redirect:BOMController?action=viewBOM&id=" + s_bomId;
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
