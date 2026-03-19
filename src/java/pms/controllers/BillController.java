package pms.controllers;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.*;

@WebServlet(name = "BillController", urlPatterns = {"/BillController"})
public class BillController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "listBill";

        BillDAO dao = new BillDAO();
        WorkOrderDAO woDao = new WorkOrderDAO();
        CustomerDAO cDao = new CustomerDAO();

        try {
            switch (action) {
                case "listBill":
                case "searchBill":
                    String keyword = request.getParameter("keyword");
                    List<BillDTO> list = (keyword != null && !keyword.trim().isEmpty()) 
                                         ? dao.searchBill(keyword) : dao.getAllBill();
                    
                    request.setAttribute("billList", list);
                    request.setAttribute("listWO", woDao.getAllWorkOrders());
                    request.setAttribute("listC", cDao.getAllCustomers());
                    request.setAttribute("listI", new ItemDAO().ItemList());
                    request.getRequestDispatcher("bill.jsp").forward(request, response);
                    break;

                case "addBill":
                    int woId = Integer.parseInt(request.getParameter("wo_id"));
                    int cId = Integer.parseInt(request.getParameter("customer_id"));
                    double totalAmount = Double.parseDouble(request.getParameter("total_amount"));
                    Date date = Date.valueOf(LocalDate.now());

                    dao.InsertBill(new BillDTO(0, woId, cId, totalAmount, date));
                    response.sendRedirect("MainController?action=listBill");
                    break;

                case "deleteBill":
                    int delId = Integer.parseInt(request.getParameter("id"));
                    dao.deleteBill(delId);
                    response.sendRedirect("MainController?action=listBill");
                    break;

                case "loadUpdateBill":
                    int editId = Integer.parseInt(request.getParameter("id"));
                    request.setAttribute("billEdit", dao.SearchByBillID(String.valueOf(editId)));
                    request.setAttribute("billList", dao.getAllBill());
                    request.setAttribute("listWO", woDao.getAllWorkOrders());
                    request.setAttribute("listC", cDao.getAllCustomers());
                    request.setAttribute("listI", new ItemDAO().ItemList());
                    request.getRequestDispatcher("bill.jsp").forward(request, response);
                    break;

                case "saveUpdateBill":
                    int uId = Integer.parseInt(request.getParameter("bill_id"));
                    int uWoId = Integer.parseInt(request.getParameter("wo_id"));
                    int uCId = Integer.parseInt(request.getParameter("customer_id"));
                    double uTotalAmount = Double.parseDouble(request.getParameter("total_amount"));
                    Date uDate = Date.valueOf(LocalDate.now());

                    dao.UpdateBill(new BillDTO(uId, uWoId, uCId, uTotalAmount, uDate));
                    response.sendRedirect("MainController?action=listBill");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { processRequest(req, resp); }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { processRequest(req, resp); }
}