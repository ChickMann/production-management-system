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
        DashboardDAO dao = new DashboardDAO();
        DashboardDTO data = dao.loadDashboardStats();
        request.setAttribute("dashboardData", data);
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
