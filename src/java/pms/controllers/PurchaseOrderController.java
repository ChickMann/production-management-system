package pms.controllers;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.PurchaseOrderDAO;
import pms.model.PurchaseOrderDTO;

public class PurchaseOrderController extends HttpServlet {

    String url = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        switch (action) {
            case "addPurchaseOrder":
            case "saveAddPurchaseOrder":
                AddPurchaseOrder(request);
                break;
            case "removePurchaseOrder":
                RemovePurchaseOrder(request);
                break;
            case "updatePurchaseOrder":
            case "saveUpdatePurchaseOrder":
                UpdatePurchaseOrder(request);
                break;
            case "searchPurchaseOrder":
                SearchPurchaseOrder(request);
                break;
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    private void RemovePurchaseOrder(HttpServletRequest request) {
        String idStr = request.getParameter("id");
        PurchaseOrderDAO pdao = new PurchaseOrderDAO();

        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            boolean check = pdao.Delete(id);
            if (check) {
                request.setAttribute("msg", "Deleted!");
            } else {
                request.setAttribute("msg", "Error, can not delete: " + id);
            }
        }
        ArrayList<PurchaseOrderDTO> poList = pdao.PurchaseOrderList();
        request.setAttribute("poList", poList);
        url = "SearchPurchaseOrder.jsp";
    }

    private void AddPurchaseOrder(HttpServletRequest request) {
        String msg = "";
        String error = "";

        PurchaseOrderDAO pdao = new PurchaseOrderDAO();
        String action = request.getParameter("action");
        request.setAttribute("mode", "add");

        if (action.equals("saveAddPurchaseOrder")) {
            try {
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                int supplierId = Integer.parseInt(request.getParameter("supplierId"));
                int requiredQuantity = Integer.parseInt(request.getParameter("requiredQuantity"));
                Date alertDate = Date.valueOf(request.getParameter("alertDate"));
                String status = request.getParameter("status");

                PurchaseOrderDTO po = new PurchaseOrderDTO(0, itemId, supplierId, requiredQuantity, alertDate, status);
                if (error.isEmpty()) {
                    if (pdao.Add(po)) {
                        msg = "add thành công";
                    } else {
                        error = "add thất bại";
                        pdao.ReseedSQL();
                    }
                }
                request.setAttribute("po", po);
            } catch (Exception e) {
                error = "Vui lòng nhập đúng định dạng dữ liệu (ID và Số lượng là số, Ngày là yyyy-mm-dd)";
            }
            request.setAttribute("msg", msg);
            request.setAttribute("error", error);
        }

        int index = pdao.GetCurrentID();
        if (index > 0) {
            request.setAttribute("index", index + 1);
        }
        
        url = "po-form.jsp";
    }

    private void UpdatePurchaseOrder(HttpServletRequest request) {
        String msg = "";
        String error = "";

        PurchaseOrderDAO pdao = new PurchaseOrderDAO();
        String action = request.getParameter("action");
        String s_id = request.getParameter("id");

        int poId = Integer.parseInt(s_id);
        PurchaseOrderDTO po = pdao.SearchByID(poId);
        request.setAttribute("mode", "update");

        if (action.equals("saveUpdatePurchaseOrder")) {
            try {
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                int supplierId = Integer.parseInt(request.getParameter("supplierId"));
                int requiredQuantity = Integer.parseInt(request.getParameter("requiredQuantity"));
                Date alertDate = Date.valueOf(request.getParameter("alertDate"));
                String status = request.getParameter("status");

                po = new PurchaseOrderDTO(poId, itemId, supplierId, requiredQuantity, alertDate, status);
                if (pdao.Update(po)) {
                    msg = "Cập nhật thành công";
                } else {
                    error = "Cập nhật thất bại";
                }
            } catch (Exception e) {
                error = "Dữ liệu không hợp lệ";
            }
            
            request.setAttribute("msg", msg);
            request.setAttribute("error", error);
        }

        request.setAttribute("po", po);
        url = "po-form.jsp";
    }

    private void SearchPurchaseOrder(HttpServletRequest request) {
        PurchaseOrderDAO pdao = new PurchaseOrderDAO();
        ArrayList<PurchaseOrderDTO> poList = pdao.PurchaseOrderList();

        request.setAttribute("poList", poList);
        url = "SearchPurchaseOrder.jsp";
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
        return "Purchase Order Controller";
    }
}
