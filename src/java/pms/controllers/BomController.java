package pms.controllers;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.BOMDAO;
import pms.model.BOMDTO;

public class BomController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8"); 
        
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "listBOM";
        }

        BOMDAO dao = new BOMDAO();

        try {
            switch (action) {
                case "listBOM":
                case "searchBom":
                    List<BOMDTO> listBom = dao.getAllBOMS();
                    request.setAttribute("danhSachBOM", listBom);
                    request.getRequestDispatcher("listBOM.jsp").forward(request, response);
                    break;
                    
                case "addBom":
                    int pId = Integer.parseInt(request.getParameter("productItemId"));
                    int mId = Integer.parseInt(request.getParameter("materialItemId"));
                    int qty = Integer.parseInt(request.getParameter("quantityRequired"));
                    
                    dao.insertBOM(new BOMDTO(0, pId, mId, qty));
                    response.sendRedirect("MainController?action=listBOM");
                    break;
                    
                case "deleteBom":
                case "removeBom":
                    int delId = Integer.parseInt(request.getParameter("bomId"));
                    BOMDTO delBom = new BOMDTO();
                    delBom.setBomId(delId);
                    
                    dao.deleteBOM(delBom);
                    response.sendRedirect("MainController?action=listBOM");
                    break;
                    
                case "loadUpdateBom":
                case "updateBom":
                    int updId = Integer.parseInt(request.getParameter("bomId"));
                    if(request.getParameter("id") != null && updId == 0) updId = Integer.parseInt(request.getParameter("id"));
                    BOMDTO bomEdit = dao.getBOMById(updId);
                    
                    request.setAttribute("bomEdit", bomEdit);
                    request.getRequestDispatcher("updateBOM.jsp").forward(request, response);
                    break;
                    
                case "saveUpdateBom":
                    int uBomId = Integer.parseInt(request.getParameter("bomId"));
                    int uPId = Integer.parseInt(request.getParameter("productItemId"));
                    int uMId = Integer.parseInt(request.getParameter("materialItemId"));
                    int uQty = Integer.parseInt(request.getParameter("quantityRequired"));
                    
                    dao.updateBOM(new BOMDTO(uBomId, uPId, uMId, uQty));
                    response.sendRedirect("MainController?action=listBOM");
                    break;
                    
                default:
                    response.sendRedirect("MainController?action=listBOM");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
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
        return "Bom Controller";
    }

}
