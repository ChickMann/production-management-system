package pms.controllers;

import java.io.IOException;
import java.net.URLEncoder;
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
                url = updateCustomer(request);
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
            response.sendRedirect(request.getContextPath() + "/" + url.substring(9));
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
                    return "redirect:CustomerController?action=listCustomer&msg="
                            + URLEncoder.encode("Xóa khách hàng thành công!", "UTF-8");
                } else {
                    String daoError = cdao.getLastError();
                    String errorMessage = (daoError != null && !daoError.trim().isEmpty())
                            ? daoError
                            : "Không thể xóa khách hàng " + id + " vì có dữ liệu liên quan.";
                    return "redirect:CustomerController?action=listCustomer&error="
                            + URLEncoder.encode(errorMessage, "UTF-8");
                }
            } catch (Exception e) {
                return "redirect:CustomerController?action=listCustomer&error="
                        + safeEncode("Lỗi: " + e.getMessage());
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
            String name = trimToNull(request.getParameter("customer_name"));
            String phone = trimToNull(request.getParameter("phone"));
            String email = trimToNull(request.getParameter("email"));
            CustomerDTO c = new CustomerDTO(0, name, phone, email);

            if (name == null) {
                request.setAttribute("error", "Tên khách không được để trống");
                request.setAttribute("customer", c);
            } else if (cdao.insertCustomer(c)) {
                return "redirect:CustomerController?action=listCustomer&msg="
                        + safeEncode("Thêm khách hàng thành công!");
            } else {
                String daoError = cdao.getLastError();
                request.setAttribute("error", daoError != null && !daoError.trim().isEmpty()
                        ? daoError
                        : "Không thể thêm khách hàng");
                request.setAttribute("customer", c);
            }
        }
        request.setAttribute("customerList", cdao.getAllCustomers());
        return "customer.jsp";
    }

    private String updateCustomer(HttpServletRequest request) {
        CustomerDAO cdao = new CustomerDAO();
        String action = request.getParameter("action");
        String sId = request.getParameter("id");
        CustomerDTO c = cdao.SearchByCustomerID(sId);
        request.setAttribute("mode", "update");

        if ("saveUpdateCustomer".equals(action)) {
            String name = trimToNull(request.getParameter("customer_name"));
            String phone = trimToNull(request.getParameter("phone"));
            String email = trimToNull(request.getParameter("email"));
            try {
                int id = Integer.parseInt(sId);
                c = new CustomerDTO(id, name, phone, email);
                if (name == null) {
                    request.setAttribute("error", "Tên khách không được để trống");
                } else if (cdao.updateCustomer(c)) {
                    return "redirect:CustomerController?action=listCustomer&msg="
                            + safeEncode("Cập nhật khách hàng thành công!");
                } else {
                    String daoError = cdao.getLastError();
                    request.setAttribute("error", daoError != null && !daoError.trim().isEmpty()
                            ? daoError
                            : "Cập nhật thất bại");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi: " + e.getMessage());
            }
        }

        request.setAttribute("customer", c);
        request.setAttribute("customerList", cdao.getAllCustomers());
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
        if (request.getAttribute("msg") == null && request.getParameter("msg") != null) {
            request.setAttribute("msg", request.getParameter("msg"));
        }
        if (request.getAttribute("error") == null && request.getParameter("error") != null) {
            request.setAttribute("error", request.getParameter("error"));
        }
        return "customer.jsp";
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String safeEncode(String value) {
        try {
            return URLEncoder.encode(value, "UTF-8");
        } catch (Exception ex) {
            return "Loi-he-thong";
        }
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
