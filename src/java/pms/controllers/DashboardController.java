package pms.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.DashboardDAO;
import pms.model.DashboardDTO;

public class DashboardController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "view";

        switch (action) {
            case "view":
            default:
                viewDashboard(request);
                break;
        }

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

    private void viewDashboard(HttpServletRequest request) {
        pms.model.UserDTO user = (pms.model.UserDTO) request.getSession().getAttribute("user");
        DashboardDAO dao = new DashboardDAO();
        
        if (user != null) {
            String userRole = user.getRole();
            boolean isAdmin = "admin".equalsIgnoreCase(userRole);
            boolean isWorker = "employee".equalsIgnoreCase(userRole)
                    || "worker".equalsIgnoreCase(userRole)
                    || "user".equalsIgnoreCase(userRole);
            
            DashboardDTO data;
            if (isAdmin) {
                // Admin xem tất cả thống kê
                data = dao.loadDashboardStats();
            } else if (isWorker) {
                // Worker chỉ xem thống kê liên quan đến mình
                data = dao.loadWorkerDashboardStats(user.getId());
            } else {
                // Mặc định xem thống kê đầy đủ
                data = dao.loadDashboardStats();
            }
            request.setAttribute("dashboardData", data);
            request.setAttribute("isAdmin", isAdmin);
            request.setAttribute("isWorker", isWorker);
        } else {
            // Không có user, load mặc định
            DashboardDTO data = dao.loadDashboardStats();
            request.setAttribute("dashboardData", data);
            request.setAttribute("isAdmin", false);
            request.setAttribute("isWorker", false);
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

    @Override
    public String getServletInfo() {
        return "Dashboard Controller";
    }
}
