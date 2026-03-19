package pms.controllers;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import pms.model.*;

@WebServlet(name = "ProductionLogController", urlPatterns = {"/ProductionLogController"})
public class ProductionLogController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "listLog";

        ProductionLogDAO logDao = new ProductionLogDAO();
        WorkOrderDAO woDao = new WorkOrderDAO();
        RoutingStepDAO stepDao = new RoutingStepDAO();
        DefectDAO defectDao = new DefectDAO();

        try {
            if (action.contains("Log") && !action.equals("addLog")) {
                // BƯỚC QUAN TRỌNG: Đổ dữ liệu vào các List để hiện lên Dropdown
                request.setAttribute("listLogs", logDao.getAllLogs());
                request.setAttribute("listWO", woDao.getAllWorkOrders()); // <-- HIỆN LỆNH SẢN XUẤT
                request.setAttribute("listSteps", stepDao.getAllRoutingStep());
                request.setAttribute("listDefects", defectDao.getAllDefects());
                
                request.getRequestDispatcher("production-log.jsp").forward(request, response);
                
            } else if (action.equals("addLog")) {
                int woId = Integer.parseInt(request.getParameter("workOrderId"));
                int sId = Integer.parseInt(request.getParameter("stepId"));
                int qDone = Integer.parseInt(request.getParameter("quantityDone"));
                int qDef = Integer.parseInt(request.getParameter("quantityDefective"));
                int dId = Integer.parseInt(request.getParameter("defectId"));
                String date = LocalDate.now().toString();

                logDao.insertLog(new ProductionLogDTO(0, woId, sId, qDone, qDef, dId, date));
                response.sendRedirect("MainController?action=listLog");
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { processRequest(req, resp); }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { processRequest(req, resp); }
}