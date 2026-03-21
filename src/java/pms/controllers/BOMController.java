package pms.controllers;

import java.io.IOException;
import java.util.ArrayList;
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
        loadBomListData(request);
        url = "bom-list.jsp";
    }

    private void searchBOMs(HttpServletRequest request) {
        BOMDAO dao = new BOMDAO();
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        List<BOMDTO> boms = dao.getAllBOMS();

        if (keyword != null && !keyword.trim().isEmpty()) {
            boms.removeIf(b -> b.getProductName() == null || !b.getProductName().toLowerCase().contains(keyword.toLowerCase()));
        }
        if (status != null && !status.isEmpty() && !status.equals("all")) {
            boms.removeIf(b -> !b.getStatus().equals(status));
        }

        loadBomReferenceData(request);
        request.setAttribute("boms", boms);
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
        loadBomListData(request);
        request.setAttribute("selectedBom", bom);
        request.setAttribute("mode", "view");
        url = "bom-list.jsp";
    }

    private void showAddForm(HttpServletRequest request) {
        loadBomListData(request);
        request.setAttribute("mode", "add");
        url = "bom-list.jsp";
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
        BOMDTO bom = dao.getBOMById(id);

        loadBomListData(request);
        request.setAttribute("selectedBom", bom);
        request.setAttribute("mode", "update");
        url = "bom-list.jsp";
    }

    private void addBOM(HttpServletRequest request) {
        String msg = "";
        String error = "";
        BOMDTO bom = new BOMDTO();

        try {
            int productItemId = Integer.parseInt(request.getParameter("productItemId"));
            String notes = request.getParameter("notes");
            List<BOMDetailDTO> details = extractDetails(request);

            bom.setProductItemId(productItemId);
            bom.setBomVersion(generateDefaultVersion(productItemId));
            bom.setStatus("active");
            bom.setNotes(notes);
            bom.setDetails(details);

            if (details.isEmpty()) {
                throw new IllegalArgumentException("Vui lòng thêm ít nhất một nguyên liệu cho BOM");
            }

            BOMDAO dao = new BOMDAO();
            if (dao.insertBOM(bom)) {
                for (BOMDetailDTO detail : details) {
                    detail.setBomId(bom.getBomId());
                    if (!dao.addBOMDetail(detail)) {
                        throw new IllegalStateException("Không thể lưu nguyên liệu cho BOM");
                    }
                }
                url = "redirect:BOMController?action=list";
                return;
            } else {
                error = "Không thể tạo BOM mới";
            }
        } catch (Exception e) {
            error = "Lỗi: " + e.getMessage();
            try {
                bom.setProductItemId(Integer.parseInt(request.getParameter("productItemId")));
            } catch (Exception ignore) {
            }
            bom.setNotes(request.getParameter("notes"));
            bom.setDetails(extractDetails(request));
        }

        loadBomListData(request);
        request.setAttribute("selectedBom", bom);
        request.setAttribute("msg", msg);
        request.setAttribute("error", error);
        request.setAttribute("mode", "add");
        url = "bom-list.jsp";
    }

    private List<BOMDetailDTO> extractDetails(HttpServletRequest request) {
        String[] materialIds = request.getParameterValues("materialItemId[]");
        String[] quantities = request.getParameterValues("quantityRequired[]");
        String[] units = request.getParameterValues("unit[]");
        String[] wastePercents = request.getParameterValues("wastePercent[]");
        String[] notes = request.getParameterValues("detailNotes[]");

        List<BOMDetailDTO> details = new ArrayList<>();
        if (materialIds == null || quantities == null) {
            return details;
        }

        for (int i = 0; i < materialIds.length; i++) {
            String materialIdValue = materialIds[i] != null ? materialIds[i].trim() : "";
            String quantityValue = i < quantities.length && quantities[i] != null ? quantities[i].trim() : "";

            if (materialIdValue.isEmpty() && quantityValue.isEmpty()) {
                continue;
            }

            BOMDetailDTO detail = new BOMDetailDTO();
            detail.setMaterialItemId(Integer.parseInt(materialIdValue));
            detail.setQuantityRequired(Double.parseDouble(quantityValue));
            detail.setUnit(getArrayValue(units, i));
            detail.setWastePercent(parseDoubleOrDefault(wastePercents, i, 0));
            detail.setNotes(getArrayValue(notes, i));
            details.add(detail);
        }

        return details;
    }

    private String getArrayValue(String[] values, int index) {
        if (values == null || index >= values.length || values[index] == null) {
            return "";
        }
        return values[index].trim();
    }

    private double parseDoubleOrDefault(String[] values, int index, double defaultValue) {
        if (values == null || index >= values.length || values[index] == null || values[index].trim().isEmpty()) {
            return defaultValue;
        }
        return Double.parseDouble(values[index].trim());
    }

    private String generateDefaultVersion(int productItemId) {
        BOMDAO dao = new BOMDAO();
        int nextVersion = 1;
        for (BOMDTO existing : dao.getBOMSByProduct(productItemId)) {
            String version = existing.getBomVersion();
            if (version == null || !version.startsWith("v")) {
                continue;
            }
            try {
                String normalized = version.substring(1);
                int current = Integer.parseInt(normalized.split("\\.")[0]);
                if (current >= nextVersion) {
                    nextVersion = current + 1;
                }
            } catch (Exception ignore) {
            }
        }
        return "v" + nextVersion + ".0";
    }

    private void updateBOM(HttpServletRequest request) {
        String msg = "";
        String error = "";

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int productItemId = Integer.parseInt(request.getParameter("productItemId"));
            String notes = request.getParameter("notes");
            List<BOMDetailDTO> details = extractDetails(request);

            if (details.isEmpty()) {
                throw new IllegalArgumentException("Vui lòng thêm ít nhất một nguyên liệu cho BOM");
            }

            BOMDAO dao = new BOMDAO();
            BOMDTO existingBom = dao.getBOMById(id);
            String version = request.getParameter("version");
            String status = request.getParameter("status");

            if ((version == null || version.trim().isEmpty()) && existingBom != null) {
                version = existingBom.getBomVersion();
            }
            if ((status == null || status.trim().isEmpty()) && existingBom != null) {
                status = existingBom.getStatus();
            }

            BOMDTO bom = new BOMDTO();
            bom.setBomId(id);
            bom.setProductItemId(productItemId);
            bom.setBomVersion(version);
            bom.setStatus(status);
            bom.setNotes(notes);

            if (dao.updateBOM(bom)) {
                if (!dao.deleteBOMDetailsByBomId(id)) {
                    throw new IllegalStateException("Không thể làm mới danh sách nguyên liệu của BOM");
                }
                for (BOMDetailDTO detail : details) {
                    detail.setBomId(id);
                    if (!dao.addBOMDetail(detail)) {
                        throw new IllegalStateException("Không thể cập nhật nguyên liệu cho BOM");
                    }
                }
                msg = "Cập nhật BOM thành công!";
            } else {
                error = "Không thể cập nhật BOM";
            }
        } catch (Exception e) {
            error = "Lỗi: " + e.getMessage();
        }

        if (error != null && !error.trim().isEmpty()) {
            BOMDAO dao = new BOMDAO();
            BOMDTO bom = dao.getBOMById(Integer.parseInt(request.getParameter("id")));
            if (bom != null) {
                bom.setProductItemId(Integer.parseInt(request.getParameter("productItemId")));
                bom.setNotes(request.getParameter("notes"));
                bom.setDetails(extractDetails(request));
            }
            loadBomListData(request);
            request.setAttribute("selectedBom", bom);
            request.setAttribute("msg", msg);
            request.setAttribute("error", error);
            request.setAttribute("mode", "update");
            url = "bom-list.jsp";
            return;
        }

        url = "redirect:BOMController?action=list";
    }

    private void loadBomListData(HttpServletRequest request) {
        BOMDAO dao = new BOMDAO();
        request.setAttribute("boms", dao.getAllBOMS());
        loadBomReferenceData(request);
    }

    private void loadBomReferenceData(HttpServletRequest request) {
        ItemDAO itemDao = new ItemDAO();
        request.setAttribute("products", itemDao.getProducts());
        request.setAttribute("materials", itemDao.getMaterials());
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
            String swp = request.getParameter("wastePercent");
            if (swp != null && !swp.isEmpty()) {
                try { wastePercent = Double.parseDouble(swp); } catch (Exception e) {}
            }
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
            double wastePercent = 0;
            String swp = request.getParameter("wastePercent");
            if (swp != null && !swp.isEmpty()) {
                try { wastePercent = Double.parseDouble(swp); } catch (Exception e) {}
            }
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
