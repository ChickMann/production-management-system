package pms.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@MultipartConfig
public class MainController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String url = "login.jsp";
        String action = request.getParameter("action");
        if(action.contains("User")){
            url = "UserController";
        }else if(action.contains("Item")){
            url = "ItemController";
        } else if(action.contains("Bom") || action.contains("BOM"))
        {
            url = "BomController";
        } else if(action.contains("Supplier"))
        {
            url = "SupplierController";
        } else if(action.contains("PurchaseOrder"))
        {
            url = "PurchaseOrderController";
        } else if (action.contains("RoutingStep")) 
        {
            url = "RoutingStepController";
        } else if (action.contains("Routing")) 
        {
            url = "RoutingController";
        } else if (action.contains("DefectReason")) 
        {
            url = "DefectReasonController";
        } else if (action.contains("Bill")) 
        {
            url = "BillController";
        } else if (action.contains("Customer")) 
        {
            url = "CustomerController";
        } else if (action.contains("Production")) 
        {
            url = "ProductionLogController";
        } else if (action.contains("WorkOrder")) 
        {
            url = "WorkOrderController";
        }
        
        request.getRequestDispatcher(url).forward(request, response);
        
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
