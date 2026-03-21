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

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "listSupplier";
        SupplierDAO sdao = new SupplierDAO();

        try {
            switch (action) {
                case "listSupplier":
                case "searchSupplier":
                    String keyword = request.getParameter("keyword");
                    ArrayList<SupplierDTO> list = sdao.SupplierList();

                    if (keyword != null && !keyword.trim().isEmpty()) {
                        ArrayList<SupplierDTO> filtered = new ArrayList<>();
                        for (SupplierDTO s : list) {
                            String name = s.getSupplierName();
                            String phone = s.getContactPhone();
                            if ((name != null && name.toLowerCase().contains(keyword.toLowerCase()))
                                    || (phone != null && phone.contains(keyword))) {
                                filtered.add(s);
                            }
                        }
                        list = filtered;
                    }

                    request.setAttribute("supplierList", list);
                    request.getRequestDispatcher("SearchSupplier.jsp").forward(request, response);
                    break;

                case "addSupplier":
                    sdao.Add(new SupplierDTO(0, request.getParameter("supplierName"), request.getParameter("contactPhone")));
                    response.sendRedirect("MainController?action=listSupplier");
                    break;

                case "deleteSupplier":
                    sdao.Delete(Integer.parseInt(request.getParameter("id")));
                    response.sendRedirect("MainController?action=listSupplier");
                    break;

                case "loadUpdateSupplier":
                    request.setAttribute("supplierEdit", sdao.SearchByID(Integer.parseInt(request.getParameter("id"))));
                    request.setAttribute("supplierList", sdao.SupplierList());
                    request.getRequestDispatcher("SearchSupplier.jsp").forward(request, response);
                    break;

                case "saveUpdateSupplier":
                    sdao.Update(new SupplierDTO(Integer.parseInt(request.getParameter("id")), request.getParameter("supplierName"), request.getParameter("contactPhone")));
                    response.sendRedirect("MainController?action=listSupplier");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }
}
