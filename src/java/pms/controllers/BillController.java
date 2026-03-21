/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package pms.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.BillDAO;
import pms.model.BillDTO;
import pms.model.CustomerDAO;
import pms.model.CustomerDTO;
import pms.model.PaymentDAO;
import pms.model.PaymentDTO;
import pms.model.WorkOrderDAO;
import pms.model.WorkOrderDTO;

/**
 *
 * @author HP
 */
public class BillController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    String url = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null) {
            action = "listBill";
        }
        switch (action) {
            case "listBill":
                ListBill(request);
                break;

            case "addBill":
                AddBill(request);
                break;

            case "deleteBill":
                DeleteBill(request);
                break;

            case "updateBill":
                UpdateBill(request);
                break;

            case "searchBill":
                SearchBill(request);
                break;
        }
        request.getRequestDispatcher(url).forward(request, response);
    }

    private void ListBill(HttpServletRequest request) {
        BillDAO dao = new BillDAO();
        ArrayList<BillDTO> list = dao.getAllBill();
        list = getFilteredBills(list, request.getParameter("filter"), request.getParameter("keyword"));
        populateBillPageData(request, list);
    }

    private void AddBill(HttpServletRequest request) {
        try {
            int wo_id = Integer.parseInt(request.getParameter("wo_id"));
            int customer_id = Integer.parseInt(request.getParameter("customer_id"));
            double total_amount = Double.parseDouble(request.getParameter("total_amount"));

            if (wo_id <= 0) {
                request.setAttribute("error", "Vui lòng chọn lệnh sản xuất hợp lệ.");
                ListBill(request);
                return;
            }

            if (total_amount <= 0) {
                request.setAttribute("error", "Tổng tiền phải lớn hơn 0.");
                ListBill(request);
                return;
            }

            BillDAO dao = new BillDAO();
            BillDTO bill = new BillDTO(0, wo_id, customer_id, total_amount, new java.sql.Date(System.currentTimeMillis()));
            boolean result = dao.InsertBill(bill);
            if (result) {
                request.setAttribute("msg", "Tạo hóa đơn thành công.");
            } else {
                request.setAttribute("error", "Tạo hóa đơn thất bại.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Không thể tạo hóa đơn: " + e.getMessage());
        }

        ListBill(request);
    }

    private void DeleteBill(HttpServletRequest request) {
        int bill_id = Integer.parseInt(request.getParameter("bill_id"));
        BillDAO dao = new BillDAO();
        boolean result = dao.deleteBill(bill_id);
        if (result) {
            request.setAttribute("msg", "Delete Bill Success");
        } else {
            request.setAttribute("msg", "Delete Bill Failed");
        }
        ListBill(request);
    }

    private void UpdateBill(HttpServletRequest request) {
        try {
            int bill_id = Integer.parseInt(request.getParameter("bill_id"));
            int wo_id = Integer.parseInt(request.getParameter("wo_id"));
            int customer_id = Integer.parseInt(request.getParameter("customer_id"));
            double total_amount = Double.parseDouble(request.getParameter("total_amount"));
            BillDAO dao = new BillDAO();
            BillDTO currentBill = dao.SearchByBillID(String.valueOf(bill_id));

            if (currentBill == null) {
                request.setAttribute("error", "Không tìm thấy hóa đơn cần cập nhật.");
                ListBill(request);
                return;
            }

            BillDTO bill = new BillDTO(
                    bill_id,
                    wo_id,
                    customer_id,
                    total_amount,
                    currentBill.getBill_date() != null ? currentBill.getBill_date() : new java.sql.Date(System.currentTimeMillis()),
                    currentBill.getStatus()
            );
            boolean result = dao.UpdateBill(bill);
            if (result) {
                request.setAttribute("msg", "Cập nhật hóa đơn thành công.");
            } else {
                request.setAttribute("error", "Cập nhật hóa đơn thất bại.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Không thể cập nhật hóa đơn: " + e.getMessage());
        }

        ListBill(request);
    }

    private void SearchBill(HttpServletRequest request) {
        String keyword = request.getParameter("keyword");
        BillDAO dao = new BillDAO();
        ArrayList<BillDTO> list = dao.searchBill(keyword);
        list = getFilteredBills(list, request.getParameter("filter"), keyword);
        populateBillPageData(request, list);
        request.setAttribute("keyword", keyword);
    }

    private void populateBillPageData(HttpServletRequest request, ArrayList<BillDTO> billList) {
        WorkOrderDAO workOrderDAO = new WorkOrderDAO();
        CustomerDAO customerDAO = new CustomerDAO();
        PaymentDAO paymentDAO = new PaymentDAO();

        List<WorkOrderDTO> workOrders = workOrderDAO.getAllWorkOrders();
        List<CustomerDTO> customers = customerDAO.getAllCustomers();
        Map<Integer, WorkOrderDTO> workOrderMap = new HashMap<>();
        Map<Integer, CustomerDTO> customerMap = new HashMap<>();
        Map<Integer, PaymentDTO> latestPaymentMap = new HashMap<>();

        for (WorkOrderDTO workOrder : workOrders) {
            workOrderMap.put(workOrder.getWo_id(), workOrder);
        }

        for (CustomerDTO customer : customers) {
            customerMap.put(customer.getCustomer_id(), customer);
        }

        for (BillDTO bill : billList) {
            PaymentDTO latestPayment = paymentDAO.getLatestPaymentByBillId(bill.getBill_id());
            if (latestPayment != null
                    && latestPayment.getExpiresAt() != null
                    && !"PAID".equalsIgnoreCase(latestPayment.getStatus())
                    && latestPayment.getExpiresAt().before(new java.util.Date())) {
                paymentDAO.updatePaymentStatus(latestPayment.getPaymentId(), "EXPIRED", null);
                latestPayment.setStatus("EXPIRED");
            }
            latestPaymentMap.put(bill.getBill_id(), latestPayment);
        }

        request.setAttribute("billList", billList);
        request.setAttribute("workOrders", new ArrayList<>(workOrders));
        request.setAttribute("customers", new ArrayList<>(customers));
        request.setAttribute("workOrderMap", workOrderMap);
        request.setAttribute("customerMap", customerMap);
        request.setAttribute("latestPaymentMap", latestPaymentMap);
        url = "bill.jsp";
    }

    private ArrayList<BillDTO> getFilteredBills(ArrayList<BillDTO> source, String filter, String keyword) {
        ArrayList<BillDTO> filtered = new ArrayList<>();
        String normalizedFilter = filter == null ? "all" : filter.trim().toLowerCase();
        String normalizedKeyword = keyword == null ? "" : keyword.trim().toLowerCase();

        for (BillDTO bill : source) {
            boolean matchesFilter = "all".equals(normalizedFilter)
                    || normalizedFilter.equalsIgnoreCase(String.valueOf(bill.getStatus()));

            boolean matchesKeyword = normalizedKeyword.isEmpty()
                    || String.valueOf(bill.getBill_id()).contains(normalizedKeyword)
                    || String.valueOf(bill.getWo_id()).contains(normalizedKeyword)
                    || String.valueOf(bill.getCustomer_id()).contains(normalizedKeyword);

            if (matchesFilter && matchesKeyword) {
                filtered.add(bill);
            }
        }

        return filtered;
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
        return "";
    }// </editor-fold>

}
