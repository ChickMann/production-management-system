package pms.controllers;

import java.io.IOException;
import java.util.Properties;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import pms.model.UserDTO;
import pms.utils.EmailService;

@WebServlet(name = "AdminController", urlPatterns = {"/AdminController"})
public class AdminController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        ServletContext app = getServletContext();
        Properties smtpConfig = (Properties) app.getAttribute("smtpConfig");
        if (smtpConfig == null) {
            smtpConfig = loadSmtpConfig(app);
            app.setAttribute("smtpConfig", smtpConfig);
        }

        switch (action) {
            case "saveSmtpConfig":
                saveSmtpConfig(request, app, smtpConfig);
                request.setAttribute("msg", "Cau hinh email da duoc luu thanh cong!");
                break;

            case "sendTestEmail":
                sendTestEmail(request, response);
                return;

            default:
                break;
        }

        request.getRequestDispatcher("email-settings.jsp").forward(request, response);
    }

    private Properties loadSmtpConfig(ServletContext app) {
        Properties props = new Properties();
        props.setProperty("smtp.host", app.getInitParameter("smtp.host") != null ? app.getInitParameter("smtp.host") : "");
        props.setProperty("smtp.port", app.getInitParameter("smtp.port") != null ? app.getInitParameter("smtp.port") : "587");
        props.setProperty("smtp.user", app.getInitParameter("smtp.user") != null ? app.getInitParameter("smtp.user") : "");
        props.setProperty("smtp.password", app.getInitParameter("smtp.password") != null ? app.getInitParameter("smtp.password") : "");
        props.setProperty("admin.email", app.getInitParameter("admin.email") != null ? app.getInitParameter("admin.email") : "");
        return props;
    }

    private void saveSmtpConfig(HttpServletRequest request, ServletContext app, Properties smtpConfig) {
        String smtpHost = request.getParameter("smtp_host");
        String smtpPort = request.getParameter("smtp_port");
        String smtpUser = request.getParameter("smtp_user");
        String smtpPassword = request.getParameter("smtp_password");
        String adminEmail = request.getParameter("admin_email");

        if (smtpHost != null) smtpConfig.setProperty("smtp.host", smtpHost.trim());
        if (smtpPort != null) smtpConfig.setProperty("smtp.port", smtpPort.trim());
        if (smtpUser != null) smtpConfig.setProperty("smtp.user", smtpUser.trim());
        if (smtpPassword != null && !smtpPassword.isEmpty()) {
            smtpConfig.setProperty("smtp.password", smtpPassword);
        }
        if (adminEmail != null) smtpConfig.setProperty("admin.email", adminEmail.trim());

        app.setAttribute("smtpConfig", smtpConfig);
        System.out.println("SMTP Config saved: host=" + smtpConfig.getProperty("smtp.host") + ", user=" + smtpConfig.getProperty("smtp.user"));
    }

    private void sendTestEmail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        String testEmail = request.getParameter("test_email");
        ServletContext app = getServletContext();
        Properties smtpConfig = (Properties) app.getAttribute("smtpConfig");

        if (smtpConfig == null) {
            smtpConfig = loadSmtpConfig(app);
            app.setAttribute("smtpConfig", smtpConfig);
        }

        if (testEmail == null || testEmail.trim().isEmpty() || !testEmail.contains("@")) {
            response.getWriter().write("Email khong hop le!");
            return;
        }

        EmailService emailService = new EmailService(
                smtpConfig.getProperty("smtp.host"),
                smtpConfig.getProperty("smtp.port"),
                smtpConfig.getProperty("smtp.user"),
                smtpConfig.getProperty("smtp.password")
        );

        if (!emailService.isConfigured()) {
            response.getWriter().write("SMTP chua duoc cau hinh! Vui long cau hinh truoc.");
            return;
        }

        String subject = "[PMS] Email Test - He Thong San Xuat";
        String body = buildTestEmailBody();
        boolean success = emailService.sendEmail(testEmail.trim(), subject, body);

        if (success) {
            response.getWriter().write("Email test da duoc gui thanh cong!");
        } else {
            response.getWriter().write("Loi gui email. Vui long kiem tra cau hinh SMTP.");
        }
    }

    private String buildTestEmailBody() {
        StringBuilder sb = new StringBuilder();
        sb.append("<!DOCTYPE html><html><head><meta charset=\"UTF-8\"></head>");
        sb.append("<body style=\"margin:0;padding:0;font-family:Arial,sans-serif;\">");
        sb.append("<div style=\"background:#14b8a6;padding:32px;text-align:center;\">");
        sb.append("<h1 style=\"color:white;margin:0;font-size:1.8rem;\">PMS - Email Test</h1>");
        sb.append("</div>");
        sb.append("<div style=\"padding:32px;max-width:600px;margin:0 auto;background:#fff;\">");
        sb.append("<p>Xin chao,</p>");
        sb.append("<p>Day la email test tu <strong>Production Management System</strong>.</p>");
        sb.append("<p>Neu ban nhan duoc email nay, cau hinh SMTP da hoat dong binh thuong!</p>");
        sb.append("<div style=\"background:#f0fdf4;border-radius:12px;padding:20px;margin:24px 0;text-align:center;\">");
        sb.append("<p style=\"margin:0;font-size:2rem;\">&#9989;</p>");
        sb.append("<p style=\"margin:8px 0 0;color:#059669;font-weight:bold;\">Email Config OK!</p>");
        sb.append("</div>");
        sb.append("<hr style=\"border:none;border-top:1px solid #e5e7eb;margin:24px 0;\">");
        sb.append("<p style=\"color:#6b7280;font-size:12px;text-align:center;\">He thong tu dong - Production Management System</p>");
        sb.append("</div></body></html>");
        return sb.toString();
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
        return "Admin Controller";
    }
}
