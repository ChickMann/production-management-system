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

        url = null;
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        request.setAttribute("__httpResponse", response);
 
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

        if (response.isCommitted()) {
            return;
        }
        if (url != null && url.startsWith("redirect:")) {
            response.sendRedirect(url.substring(9));
        } else if (url != null && !url.isEmpty()) {
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
            String source = request.getParameter("source");
            boolean ajax = "1".equals(request.getParameter("ajax")) || "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));

            if (customerName == null) customerName = "Khach hang";
            if (customerEmail == null) customerEmail = "";

            PaymentDTO payment = paymentService.createQrPayment(billId, amount, expireMinutes, customerName, customerEmail);

            if (payment != null) {
                if ("bill".equalsIgnoreCase(source) && ajax) {
                    responseQrJson(request, payment, payment.getPaymentId() > 0
                            ? "QR code da duoc tao thanh cong!"
                            : "Da tao QR tam thoi. He thong se hien thi QR ngay ca khi CSDL chua co bang Payment.");
                    return;
                }
                if ("bill".equalsIgnoreCase(source)) {
                    if (payment.getPaymentId() > 0) {
                        url = "redirect:payment-qr.jsp?payment_id=" + payment.getPaymentId() + "&from=bill";
                    } else {
                        request.setAttribute("msg", "Da tao QR tam thoi. He thong se hien thi QR ngay ca khi CSDL chua co bang Payment.");
                        request.setAttribute("payment", payment);
                        url = "payment-qr.jsp";
                    }
                    return;
                }
                request.setAttribute("msg", "QR code da duoc tao thanh cong!");
                request.setAttribute("payment", payment);
                url = "payment-qr.jsp";
                return;
            } else {
                if ("bill".equalsIgnoreCase(source) && ajax) {
                    responseQrError(request, "Khong the tao QR thanh toan!");
                    return;
                }
                if ("bill".equalsIgnoreCase(source)) {
                    url = "redirect:MainController?action=listBill&error=" + java.net.URLEncoder.encode("Khong the tao QR thanh toan!", "UTF-8");
                    return;
                }
                request.setAttribute("error", "Khong the tao QR thanh toan!");
            }
        } catch (Exception e) {
            String errorMessage = "Loi: " + e.getMessage();
            boolean ajax = "1".equals(request.getParameter("ajax")) || "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));
            if ("bill".equalsIgnoreCase(request.getParameter("source"))) {
                if (ajax) {
                    responseQrError(request, errorMessage);
                    return;
                }
                try {
                    url = "redirect:MainController?action=listBill&error=" + java.net.URLEncoder.encode(errorMessage, "UTF-8");
                } catch (Exception encodeEx) {
                    url = "redirect:MainController?action=listBill&error=Loi%20tao%20QR";
                }
                return;
            }
            request.setAttribute("error", errorMessage);
            e.printStackTrace();
        }
        listPayments(request);
    }

    private void responseQrJson(HttpServletRequest request, PaymentDTO payment, String message) {
        try {
            javax.servlet.http.HttpServletResponse response = (javax.servlet.http.HttpServletResponse) request.getAttribute("__httpResponse");
            if (response == null) {
                return;
            }
            response.setContentType("application/json;charset=UTF-8");
            String qrData = payment.getQrCodeData() != null ? payment.getQrCodeData() : "";
            String qrImageBase64 = qrData;
            String qrVietQrUrl = "";
            if (qrData.contains("|QR_URL|")) {
                String[] parts = qrData.split("\\|QR_URL\\|", 2);
                qrImageBase64 = parts.length > 0 ? parts[0] : "";
                qrVietQrUrl = parts.length > 1 ? parts[1] : "";
            }
            StringBuilder json = new StringBuilder("{");
            json.append("\"success\":true");
            json.append(",\"message\":\"").append(escapeJson(message)).append("\"");
            json.append(",\"paymentId\":").append(payment.getPaymentId());
            json.append(",\"billId\":").append(payment.getBillId());
            json.append(",\"amount\":").append(payment.getAmount());
            json.append(",\"status\":\"").append(escapeJson(payment.getStatus())).append("\"");
            json.append(",\"customerName\":\"").append(escapeJson(payment.getCustomerName())).append("\"");
            json.append(",\"customerEmail\":\"").append(escapeJson(payment.getCustomerEmail())).append("\"");
            json.append(",\"bankBin\":\"").append(escapeJson(payment.getBankBin())).append("\"");
            json.append(",\"bankAccount\":\"").append(escapeJson(payment.getBankAccount())).append("\"");
            json.append(",\"bankAccountName\":\"").append(escapeJson(payment.getBankAccountName())).append("\"");
            json.append(",\"expiresAt\":\"").append(payment.getExpiresAt() != null ? escapeJson(payment.getExpiresAt().toString()) : "").append("\"");
            json.append(",\"qrImageBase64\":\"").append(escapeJson(qrImageBase64)).append("\"");
            json.append(",\"qrVietQrUrl\":\"").append(escapeJson(qrVietQrUrl)).append("\"");
            json.append("}");
            response.getWriter().write(json.toString());
            response.getWriter().flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void responseQrError(HttpServletRequest request, String message) {
        try {
            javax.servlet.http.HttpServletResponse response = (javax.servlet.http.HttpServletResponse) request.getAttribute("__httpResponse");
            if (response == null) {
                return;
            }
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":false,\"message\":\"" + escapeJson(message) + "\"}");
            response.getWriter().flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "")
                .replace("\n", "\\n");
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
            String source = request.getParameter("source");
            if (success) {
                if ("bill".equalsIgnoreCase(source)) {
                    url = "redirect:MainController?action=listBill&msg=" + java.net.URLEncoder.encode("Xac nhan thanh toan thanh cong!", "UTF-8");
                    return;
                }
                request.setAttribute("msg", "Xac nhan thanh toan thanh cong!");
            } else {
                if ("bill".equalsIgnoreCase(source)) {
                    url = "redirect:MainController?action=listBill&error=" + java.net.URLEncoder.encode("Xac nhan thanh toan that bai! QR co the da het han.", "UTF-8");
                    return;
                }
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
