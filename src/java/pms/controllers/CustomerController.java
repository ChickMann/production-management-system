package pms.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.CustomerDAO;
import pms.model.CustomerDTO;

public class CustomerController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String url = "";
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "listCustomer";
        }

        switch (action) {
            case "addCustomer":
            case "saveAddCustomer":
                url = addCustomer(request);
                break;
            case "removeCustomer":
                url = removeCustomer(request);
                break;
            case "updateCustomer":
            case "saveUpdateCustomer":
                url = updateCustomer(request, response);
                break;
            case "searchCustomer":
            case "listCustomer":
                url = searchCustomer(request);
                break;
            default:
                url = "redirect:CustomerController?action=listCustomer";
                break;
        }

        if (url != null && url.startsWith("redirect:")) {
            response.sendRedirect(url.substring(9));
        } else if (url != null && !url.isEmpty()) {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private String removeCustomer(HttpServletRequest request) {
        String id = request.getParameter("id");
        CustomerDAO cdao = new CustomerDAO();
        if (id != null && !id.isEmpty()) {
            try {
                boolean check = cdao.deleteCustomer(Integer.parseInt(id));
                if (check) {
                    request.setAttribute("msg", "Xóa khách hàng thành công!");
                } else {
                    request.setAttribute("error", "Không thể xóa khách hàng " + id + " vì có dữ liệu liên quan.");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi: " + e.getMessage());
            }
        }
        request.setAttribute("customerList", cdao.getAllCustomers());
        return "customer.jsp";
    }

    private String addCustomer(HttpServletRequest request) {
        CustomerDAO cdao = new CustomerDAO();
        String action = request.getParameter("action");
        request.setAttribute("mode", "add");
        
        if ("saveAddCustomer".equals(action)) {
            String name = request.getParameter("customer_name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            CustomerDTO c = new CustomerDTO(0, name, phone, email);
            if (cdao.insertCustomer(c)) {
                return "redirect:CustomerController?action=listCustomer";
            } else {
                request.setAttribute("error", "Không thể thêm khách hàng");
                request.setAttribute("customer", c);
            }
        }
        request.setAttribute("customerList", cdao.getAllCustomers());
        return "customer.jsp";
    }

    private String updateCustomer(HttpServletRequest request, HttpServletResponse response) {
        CustomerDAO cdao = new CustomerDAO();
        String action = request.getParameter("action");
        String s_id = request.getParameter("id");
        CustomerDTO c = cdao.SearchByCustomerID(s_id);
        request.setAttribute("mode", "update");
        
        if ("saveUpdateCustomer".equals(action)) {
            String name = request.getParameter("customer_name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            try {
                int id = Integer.parseInt(s_id);
                c = new CustomerDTO(id, name, phone, email);
                if (cdao.updateCustomer(c)) {
                    return "redirect:CustomerController?action=listCustomer";
                } else {
                    request.setAttribute("error", "Cập nhật thất bại");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi: " + e.getMessage());
            }
        }
        request.setAttribute("customer", c);
        request.setAttribute("customerList", cdao.getAllCustomers()); // Ensure list is populated for background
        return "customer.jsp";
    }

    private String searchCustomer(HttpServletRequest request) {
        String keyword = request.getParameter("keyword");
        CustomerDAO cdao = new CustomerDAO();
        List<CustomerDTO> customerList;
        if (keyword != null && !keyword.trim().isEmpty()) {
            customerList = cdao.searchCustomers(keyword.trim());
        } else {
            customerList = cdao.getAllCustomers();
        }
        request.setAttribute("customerList", customerList);
        request.setAttribute("keyword", keyword);
        return "customer.jsp";
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
