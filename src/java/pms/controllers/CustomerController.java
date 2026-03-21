/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package pms.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.CustomerDAO;
import pms.model.CustomerDTO;

/**
 *
 * @author HP
 */
public class CustomerController extends HttpServlet {
    String url = "";
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "searchCustomer";
        }
        switch (action) {
            case "addCustomer":
            case "saveAddCustomer":
                AddCustomer(request);
                break;
            case "removeCustomer":
                RemoveCustomer(request);
                break;
            case "updateCustomer":
            case "saveUpdateCustomer":
                UpdateCustomer(request);
                break;
            case "searchCustomer":
            case "listCustomer":
                SearchCustomer(request);
                break;
        }
        request.getRequestDispatcher(url).forward(request, response);
    }

    private void RemoveCustomer(HttpServletRequest request) {
    String id = request.getParameter("id");
    CustomerDAO cdao = new CustomerDAO();
    if (id != null && !id.isEmpty()) {
        boolean check = cdao.deleteCustomer(Integer.parseInt(id));
        if (check) {
            request.setAttribute("msg", "Xóa khách hàng thành công!");
        } else {
            request.setAttribute("error", "Không thể xóa khách hàng " + id + " vì đang có Liên kết dữ liệu (ví dụ: Hóa đơn, Lệnh). Vui lòng kiểm tra lại dữ liệu liên quan.");
        }
    }
    List<CustomerDTO> customerList = cdao.getAllCustomers();
    request.setAttribute("customerList", customerList);
    url = "customer.jsp";
}

    private void AddCustomer(HttpServletRequest request) {
        String msg = "";
        String error = "";
        CustomerDAO cdao = new CustomerDAO();
        String action = request.getParameter("action");
        request.setAttribute("mode", "add");
        if (action.equals("saveAddCustomer")) {
            String name = request.getParameter("customer_name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            CustomerDTO c = new CustomerDTO(0, name, phone, email);
            if (cdao.insertCustomer(c)) {
                msg = "Thêm khách hàng thành công";
            } else {
                error = "Không thể thêm khách hàng";
                request.setAttribute("customer", c);
            }
            request.setAttribute("msg", msg);
            request.setAttribute("error", error);
        }
        request.setAttribute("customerList", cdao.getAllCustomers());
        url = "customer.jsp";
    }

    private void UpdateCustomer(HttpServletRequest request) {
        String msg = "";
        String error = "";
        CustomerDAO cdao = new CustomerDAO();
        String action = request.getParameter("action");
        String s_id = request.getParameter("id");
        CustomerDTO c = cdao.SearchByCustomerID(s_id);
        request.setAttribute("mode", "update");
        if (action.equals("saveUpdateCustomer")) {
            String name = request.getParameter("customer_name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            int id = Integer.parseInt(s_id);
            c = new CustomerDTO(id, name, phone, email);
            if (cdao.updateCustomer(c)) {
                // Redirect to list after successful update
                response.sendRedirect("CustomerController?action=listCustomer");
                return;
            } else {
                error = "Cập nhật thất bại";
            }
            request.setAttribute("error", error);
        }
        request.setAttribute("customer", c);
        url = "customer.jsp";
    }

    private void SearchCustomer(HttpServletRequest request) {
        String keyword = request.getParameter("keyword");
        CustomerDAO cdao = new CustomerDAO();
        List<CustomerDTO> customerList = new ArrayList<>();
        if (keyword != null && keyword.trim().length() > 0) {
            customerList = cdao.searchCustomers(keyword.trim());
        } else {
            customerList = cdao.getAllCustomers();
        }
        request.setAttribute("customerList", customerList);
        request.setAttribute("keyword", keyword);

        url = "customer.jsp";
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
