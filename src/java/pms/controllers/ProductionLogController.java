/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package pms.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.ProductionLogDAO;
import pms.model.ProductionLogDTO;
import pms.model.WorkOrderDAO;
import pms.model.RoutingStepDAO;
import pms.model.DefectDAO;

/**
 *
 * @author HP
 */
public class ProductionLogController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "listLog";
        }

        // Lấy user từ session để phân quyền
        pms.model.UserDTO currentUser = (pms.model.UserDTO) request.getSession().getAttribute("user");
        String userRole = currentUser != null ? currentUser.getRole() : "";
        int currentUserId = currentUser != null ? currentUser.getId() : 0;
        boolean isAdmin = "admin".equalsIgnoreCase(userRole);
        boolean isWorker = "employee".equalsIgnoreCase(userRole)
                || "worker".equalsIgnoreCase(userRole)
                || "user".equalsIgnoreCase(userRole);

        ProductionLogDAO dao = new ProductionLogDAO();
        WorkOrderDAO woDao = new WorkOrderDAO();
        RoutingStepDAO stepDao = new RoutingStepDAO();
        DefectDAO defectDao = new DefectDAO();

        try {
            if ("listLog".equals(action) || "list".equals(action)) {
                // Boss xem tất cả, công nhân chỉ xem log của mình
                if (isAdmin) {
                    request.setAttribute("listLogs", dao.getAllLogs());
                } else if (isWorker) {
                    // Filter logs theo workerId vì chưa có method getLogsByWorkerId
                    java.util.List<ProductionLogDTO> allLogs = dao.getAllLogs();
                    java.util.List<ProductionLogDTO> workerLogs = new java.util.ArrayList<>();
                    for (ProductionLogDTO log : allLogs) {
                        if (log.getWorkerUserId() == currentUserId) {
                            workerLogs.add(log);
                        }
                    }
                    request.setAttribute("listLogs", workerLogs);
                } else {
                    request.setAttribute("listLogs", new java.util.ArrayList<>());
                }
                request.setAttribute("listWO", woDao.getAllWorkOrders());
                request.setAttribute("listSteps", stepDao.getAllRoutingStep());
                request.setAttribute("listDefects", defectDao.getAllDefects());
                request.setAttribute("isAdmin", isAdmin);
                request.setAttribute("isWorker", isWorker);
                request.getRequestDispatcher("productionlog.jsp").forward(request, response);
                return;
            }

            // Chỉ công nhân được thêm log báo cáo
            if ("addLog".equals(action)) {
                if (!isWorker) {
                    response.sendRedirect("MainController?action=listLog");
                    return;
                }
                int woId = Integer.parseInt(request.getParameter("workOrderId"));
                int stepId = Integer.parseInt(request.getParameter("stepId"));
                int quantityDone = Integer.parseInt(request.getParameter("quantityDone"));
                int quantityDefective = Integer.parseInt(request.getParameter("quantityDefective"));
                int defectId = Integer.parseInt(request.getParameter("defectId"));

                ProductionLogDTO log = new ProductionLogDTO();
                log.setWoId(woId);
                log.setStepId(stepId);
                log.setWorkerUserId(currentUserId); // Lấy từ session thay vì set cứng = 0
                log.setQuantityDone(quantityDone);
                log.setQuantityDefective(quantityDefective);
                if (defectId > 0) {
                    log.setDefectId(defectId);
                } else {
                    log.setDefectId(null);
                }
                log.setLogDate(new java.sql.Date(System.currentTimeMillis()));
                dao.insertLog(log);
                response.sendRedirect("MainController?action=listLog");
                return;
            }

            // BACKWARD COMPAT: Goi truc tiep ProductionLogController (khong qua Main)
            if ("insert".equals(action)) {
                int woId = Integer.parseInt(request.getParameter("woId"));
                int stepId = Integer.parseInt(request.getParameter("stepId"));
                int workerUserId = Integer.parseInt(request.getParameter("workerUserId"));
                int quantity = Integer.parseInt(request.getParameter("producedQuantity"));
                String defectStr = request.getParameter("defectId");
                Integer defectId = null;
                if (defectStr != null && !defectStr.isEmpty()) {
                    defectId = Integer.parseInt(defectStr);
                }
                ProductionLogDTO log = new ProductionLogDTO();
                log.setWoId(woId);
                log.setStepId(stepId);
                log.setWorkerUserId(workerUserId);
                log.setProducedQuantity(quantity);
                log.setDefectId(defectId);
                dao.insertLog(log);
                response.sendRedirect("ProductionLogController?action=listLog");
                return;
            }
            if ("update".equals(action)) {
                int logId = Integer.parseInt(request.getParameter("logId"));
                int quantity = Integer.parseInt(request.getParameter("producedQuantity"));
                String defectStr = request.getParameter("defectId");
                Integer defectId = null;
                if (defectStr != null && !defectStr.isEmpty()) {
                    defectId = Integer.parseInt(defectStr);
                }
                ProductionLogDTO log = new ProductionLogDTO();
                log.setLogId(logId);
                log.setProducedQuantity(quantity);
                log.setDefectId(defectId);
                dao.updateLog(log);
                response.sendRedirect("ProductionLogController?action=listLog");
                return;
            }
            if ("delete".equals(action)) {
                int logId = Integer.parseInt(request.getParameter("logId"));
                dao.deleteLog(logId);
                response.sendRedirect("ProductionLogController?action=listLog");
                return;
            }

            response.sendRedirect("ProductionLogController?action=listLog");
        } catch (Exception e) {
            throw new ServletException("Lỗi xử lý nhật ký sản xuất", e);
        }
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
        return "Short description";
    }// </editor-fold>

}
