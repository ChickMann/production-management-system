package pms.controllers;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.SupplierDAO;
import pms.model.SupplierDTO;

public class SupplierController extends HttpServlet {

    String url = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        System.err.println("adad");

        switch (action) {
            case "addSupplier":
            case "saveAddSupplier":
                AddSupplier(request);
                break;
            case "removeSupplier":
                RemoveSupplier(request);
                break;
            case "updateSupplier":
            case "saveUpdateSupplier":
                UpdateSupplier(request);
                break;
            case "searchSupplier":
                SearchSupplier(request);

                break;
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    private void RemoveSupplier(HttpServletRequest request) {
        String idStr = request.getParameter("id");
        SupplierDAO sdao = new SupplierDAO();

        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            boolean check = sdao.Delete(id);
            if (check) {
                request.setAttribute("msg", "Deleted!");
            } else {
                request.setAttribute("msg", "Error, can not delete: " + id);
            }
        }
        ArrayList<SupplierDTO> supplierList = sdao.SupplierList();
        request.setAttribute("supplierList", supplierList);
        url = "SearchSupplier.jsp";
    }

    private void AddSupplier(HttpServletRequest request) {
        String msg = "";
        String error = "";

        SupplierDAO sdao = new SupplierDAO();
        String action = request.getParameter("action");
        request.setAttribute("mode", "add");

        if (action.equals("saveAddSupplier")) {
            String supplierName = request.getParameter("supplierName");
            String contactPhone = request.getParameter("contactPhone");

            SupplierDTO s = new SupplierDTO(0, supplierName, contactPhone);
            if (error.isEmpty()) {
                if (sdao.Add(s)) {
                    msg = "Thêm thành công";
                } else {
                    error = "Thêm thất bại";
                }
            }
            request.setAttribute("supplier", s);
            request.setAttribute("msg", msg);
            request.setAttribute("error", error);
        }

        url = "supplier-form.jsp";
    }

    private void UpdateSupplier(HttpServletRequest request) {
        String msg = "";
        String error = "";

        SupplierDAO sdao = new SupplierDAO();
        String action = request.getParameter("action");
        String s_id = request.getParameter("id");

        int id = Integer.parseInt(s_id);
        SupplierDTO s = sdao.SearchByID(id);
        request.setAttribute("mode", "update");

        if (action.equals("saveUpdateSupplier")) {
            String supplierName = request.getParameter("supplierName");
            String contactPhone = request.getParameter("contactPhone");

            s = new SupplierDTO(id, supplierName, contactPhone);
            if (error.isEmpty()) {
                if (sdao.Update(s)) {
                    msg = "Cập nhật thành công";
                } else {
                    error = "Cập nhật thất bại";
                }
            }
            request.setAttribute("msg", msg);
            request.setAttribute("error", error);
        }

        request.setAttribute("supplier", s);
        url = "supplier-form.jsp";
    }

    private void SearchSupplier(HttpServletRequest request) {
        SupplierDAO sdao = new SupplierDAO();
        ArrayList<SupplierDTO> supplierList = sdao.SupplierList();

        request.setAttribute("supplierList", supplierList);
        url = "SearchSupplier.jsp";
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
