package pms.controllers;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import pms.model.TenantDAO;
import pms.model.TenantDTO;
import pms.model.UserDTO;
import pms.utils.TenantContext;
import pms.utils.MultiTenantDBUtils;

public class TenantController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session != null) {
            UserDTO user = (UserDTO) session.getAttribute("user");
            if (user != null && "admin".equalsIgnoreCase(user.getRole())) {
                TenantContext.setTenantId(user.getUsername());
            }
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        String url = "";

        switch (action) {
            case "list":
                listTenants(request);
                url = "tenant-list.jsp";
                break;
            case "add":
                showAddForm(request);
                url = "tenant-form.jsp";
                break;
            case "saveAdd":
                saveTenant(request);
                url = "redirect:TenantController?action=list";
                return;
            case "activate":
                activateTenant(request);
                url = "redirect:TenantController?action=list";
                return;
            case "deactivate":
                deactivateTenant(request);
                url = "redirect:TenantController?action=list";
                return;
            case "switch":
                switchTenant(request);
                url = "redirect:DashboardController";
                return;
            default:
                listTenants(request);
                url = "tenant-list.jsp";
                break;
        }

        if (url.startsWith("redirect:")) {
            response.sendRedirect(url.substring(9));
        } else {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    private void listTenants(HttpServletRequest request) {
        TenantDAO dao = new TenantDAO();
        List<TenantDTO> list = dao.getAllTenants();
        request.setAttribute("tenants", list);
    }

    private void showAddForm(HttpServletRequest request) {
        request.setAttribute("mode", "add");
    }

    private void saveTenant(HttpServletRequest request) {
        try {
            TenantDTO tenant = new TenantDTO();
            tenant.setTenantCode(request.getParameter("tenantCode"));
            tenant.setTenantName(request.getParameter("tenantName"));
            tenant.setDbHost(request.getParameter("dbHost"));
            tenant.setDbName(request.getParameter("dbName"));
            tenant.setDbUser(request.getParameter("dbUser"));
            tenant.setDbPassword(request.getParameter("dbPassword"));
            tenant.setSmtpHost(request.getParameter("smtpHost"));
            tenant.setSmtpUser(request.getParameter("smtpUser"));
            tenant.setContactEmail(request.getParameter("contactEmail"));
            tenant.setContactPhone(request.getParameter("contactPhone"));
            tenant.setAddress(request.getParameter("address"));
            tenant.setSubscriptionPlan(request.getParameter("subscriptionPlan"));
            tenant.setNotes(request.getParameter("notes"));
            tenant.setActive(true);

            TenantDAO dao = new TenantDAO();
            boolean success = dao.insertTenant(tenant);

            if (success) {
                MultiTenantDBUtils.getInstance().registerTenant(
                    tenant.getTenantCode(),
                    tenant.getDbHost(),
                    tenant.getDbName(),
                    tenant.getDbUser(),
                    tenant.getDbPassword()
                );
                request.setAttribute("msg", "Tenant '" + tenant.getTenantName() + "' da duoc tao thanh cong!");
            } else {
                request.setAttribute("error", "Loi khi tao tenant.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Loi: " + e.getMessage());
        }
    }

    private void activateTenant(HttpServletRequest request) {
        String code = request.getParameter("code");
        if (code == null) return;
        TenantDAO dao = new TenantDAO();
        TenantDTO tenant = dao.getTenantByCode(code);
        if (tenant != null) {
            dao.activateTenant(code);
            MultiTenantDBUtils.getInstance().registerTenant(
                tenant.getTenantCode(),
                tenant.getDbHost(),
                tenant.getDbName(),
                tenant.getDbUser(),
                tenant.getDbPassword()
            );
            request.setAttribute("msg", "Tenant da duoc kich hoat.");
        }
    }

    private void deactivateTenant(HttpServletRequest request) {
        String code = request.getParameter("code");
        if (code == null) return;
        TenantDAO dao = new TenantDAO();
        dao.deactivateTenant(code);
        MultiTenantDBUtils.getInstance().unregisterTenant(code);
        TenantContext.clear();
        request.setAttribute("msg", "Tenant da bi vo hieu hoa.");
    }

    private void switchTenant(HttpServletRequest request) {
        String code = request.getParameter("code");
        if (code == null) return;
        TenantDAO dao = new TenantDAO();
        TenantDTO tenant = dao.getTenantByCode(code);
        if (tenant != null && tenant.isActive() && !tenant.isExpired()) {
            TenantContext.setTenantId(code);
            HttpSession sess = request.getSession(true);
            sess.setAttribute("currentTenant", code);
            request.setAttribute("msg", "Da chuyen sang tenant: " + tenant.getTenantName());
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
