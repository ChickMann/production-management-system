package pms.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MainController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String url = "login.jsp"; // Mặc định nếu không khớp thì về login
        String action = request.getParameter("action");

        // Ghi log ra màn hình console của NetBeans để bác kiểm tra xem action gửi lên là gì
        System.out.println("Action hien tai la: " + action);

        try {
            if (action == null || action.isEmpty()) {
                url = "login.jsp";
            } else {
                String a = action.toLowerCase();
                
                // Kiểm tra các đầu mục
                // Kiểm tra các đầu mục
                if (a.contains("user")) url = "UserController";
                else if (a.contains("item")) url = "ItemController";
                else if (a.contains("bom")) url = "BOMController";
                else if (a.contains("routingstep")) url = "RoutingStepController";
                else if (a.contains("routing")) url = "RoutingController";
                else if (a.contains("workorder")) url = "WorkOrderController";
                else if (a.contains("customer")) url = "CustomerController";
                
                // ĐẢM BẢO 3 DÒNG NÀY ĐÃ CÓ TRONG MAIN CONTROLLER
                else if (a.contains("bill")) url = "BillController";
                else if (a.contains("defect")) url = "DefectController";
                else if (a.contains("supplier")) url = "SupplierController"; 
                
                else if (a.contains("purchaseorder") || a.contains("po")) url = "PurchaseOrderController";
                else if (a.contains("log") || a.contains("production")) url = "ProductionLogController";
                }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Forward tới controller tương ứng
            request.getRequestDispatcher(url).forward(request, response);
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
        return "Main Controller";
    }

}
