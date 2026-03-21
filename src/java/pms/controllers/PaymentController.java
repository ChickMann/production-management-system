package pms.controllers;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.PaymentDTO;
import pms.utils.PaymentService;

public class PaymentController extends HttpServlet {

    String url = "";
    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        this.paymentService = new PaymentService();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listPayments(request);
                break;
            case "createQr":
                createQrPayment(request);
                break;
            case "refreshQr":
                refreshQrPayment(request);
                break;
            case "checkStatus":
                checkPaymentStatus(request, response);
                return;
            case "confirmPayment":
                confirmPayment(request);
                break;
            case "cancelPayment":
                cancelPayment(request);
                break;
            case "search":
                searchPayments(request);
                break;
            case "pending":
                listPendingPayments(request);
                break;
            case "paid":
                listPaidPayments(request);
                break;
        }

        if (url != null && url.startsWith("redirect:")) {
            response.sendRedirect(url.substring(9));
        } else {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private void listPayments(HttpServletRequest request) {
        ArrayList<PaymentDTO> list = paymentService.getAllPayments();
        request.setAttribute("paymentList", list);
        url = "payment-list.jsp";
    }

    private void listPendingPayments(HttpServletRequest request) {
        ArrayList<PaymentDTO> list = paymentService.getPendingPayments();
        request.setAttribute("paymentList", list);
        url = "payment-list.jsp";
    }

    private void listPaidPayments(HttpServletRequest request) {
        ArrayList<PaymentDTO> list = paymentService.getPaidPayments();
        request.setAttribute("paymentList", list);
        url = "payment-list.jsp";
    }

    private void createQrPayment(HttpServletRequest request) {
        try {
            int billId = Integer.parseInt(request.getParameter("bill_id"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            int expireMinutes = 15;
            String expireStr = request.getParameter("expire_minutes");
            if (expireStr != null && !expireStr.isEmpty()) {
                expireMinutes = Integer.parseInt(expireStr);
            }
            String customerName = request.getParameter("customer_name");
            String customerEmail = request.getParameter("customer_email");

            if (customerName == null) customerName = "Khach hang";
            if (customerEmail == null) customerEmail = "";

            PaymentDTO payment = paymentService.createQrPayment(billId, amount, expireMinutes, customerName, customerEmail);

            if (payment != null) {
                request.setAttribute("msg", "QR code da duoc tao thanh cong!");
                request.setAttribute("payment", payment);
            } else {
                request.setAttribute("error", "Khong the tao QR thanh toan!");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Loi: " + e.getMessage());
            e.printStackTrace();
        }
        listPayments(request);
    }

    private void refreshQrPayment(HttpServletRequest request) {
        try {
            int paymentId = Integer.parseInt(request.getParameter("payment_id"));
            int expireMinutes = 15;
            String expireStr = request.getParameter("expire_minutes");
            if (expireStr != null && !expireStr.isEmpty()) {
                expireMinutes = Integer.parseInt(expireStr);
            }

            boolean success = paymentService.refreshQrCode(paymentId, expireMinutes);
            if (success) {
                request.setAttribute("msg", "QR code da duoc lam moi! Thoi gian dem nguoc da duoc reset.");
                PaymentDTO updated = paymentService.getPaymentInfo(paymentId);
                request.setAttribute("payment", updated);
            } else {
                request.setAttribute("error", "Khong the lam moi QR! Hoa don da duoc thanh toan hoac khong ton tai.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Loi: " + e.getMessage());
            e.printStackTrace();
        }
        listPayments(request);
    }

    private void checkPaymentStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        try {
            int paymentId = Integer.parseInt(request.getParameter("payment_id"));
            java.util.Map<String, Object> status = paymentService.getPaymentStatus(paymentId);

            StringBuilder json = new StringBuilder("{");
            json.append("\"exists\":").append(status.get("exists"));
            if (Boolean.TRUE.equals(status.get("exists"))) {
                json.append(",\"paymentId\":").append(status.get("paymentId"));
                json.append(",\"billId\":").append(status.get("billId"));
                json.append(",\"amount\":").append(status.get("amount"));
                json.append(",\"status\":\"").append(status.get("status")).append("\"");
                json.append(",\"paymentMethod\":\"").append(status.get("paymentMethod")).append("\"");
                json.append(",\"remainingSeconds\":").append(status.get("remainingSeconds"));
                if (status.get("transactionId") != null) {
                    json.append(",\"transactionId\":\"").append(status.get("transactionId")).append("\"");
                }
                if (status.get("paidAt") != null) {
                    json.append(",\"paidAt\":\"").append(status.get("paidAt")).append("\"");
                }
            }
            json.append("}");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private void confirmPayment(HttpServletRequest request) {
        try {
            int paymentId = Integer.parseInt(request.getParameter("payment_id"));
            String transactionId = request.getParameter("transaction_id");
            if (transactionId == null) transactionId = "";

            boolean success = paymentService.confirmPayment(paymentId, transactionId);
            if (success) {
                request.setAttribute("msg", "Xac nhan thanh toan thanh cong!");
            } else {
                request.setAttribute("error", "Xac nhan thanh toan that bai! QR co the da het han.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Loi: " + e.getMessage());
            e.printStackTrace();
        }
        listPayments(request);
    }

    private void cancelPayment(HttpServletRequest request) {
        try {
            int paymentId = Integer.parseInt(request.getParameter("payment_id"));
            pms.model.PaymentDAO dao = new pms.model.PaymentDAO();
            boolean success = dao.cancelPayment(paymentId);
            if (success) {
                request.setAttribute("msg", "Huy thanh toan thanh cong!");
            } else {
                request.setAttribute("error", "Huy thanh toan that bai!");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Loi: " + e.getMessage());
            e.printStackTrace();
        }
        listPayments(request);
    }

    private void searchPayments(HttpServletRequest request) {
        String keyword = request.getParameter("keyword");
        ArrayList<PaymentDTO> list = paymentService.searchPayments(keyword);
        request.setAttribute("paymentList", list);
        request.setAttribute("keyword", keyword);
        url = "payment-list.jsp";
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
        return "Payment Controller";
    }
}
