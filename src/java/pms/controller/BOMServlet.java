/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package pms.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.BOMDAO;
import pms.model.BOMDTO;


/**
 *
 * @author se193234_TranGiaBao
 */
public class BOMServlet extends HttpServlet {

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
        
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }

        BOMDAO dao = new BOMDAO();

        try {
            switch (action) {
                case "list":
                    List<BOMDTO> listBom = dao.getAllBOMS();
                    request.setAttribute("danhSachBOM", listBom);
                    request.getRequestDispatcher("listBOM.jsp").forward(request, response);
                    break;
                    
                case "add":
                    int pId = Integer.parseInt(request.getParameter("productItemId"));
                    int mId = Integer.parseInt(request.getParameter("materialItemId"));
                    int qty = Integer.parseInt(request.getParameter("quantityRequired"));
                    
                    dao.insertBOM(new BOMDTO(0, pId, mId, qty));
                    response.sendRedirect("BOMServlet?action=list");
                    break;
                    
                case "delete":
                    int delId = Integer.parseInt(request.getParameter("bomId"));
                    // Vì DAO của bạn nhận vào 1 Object DTO, mình tạo 1 vỏ rỗng nhét ID vào
                    BOMDTO delBom = new BOMDTO();
                    delBom.setBomId(delId);
                    
                    dao.deleteBOM(delBom);
                    response.sendRedirect("BOMServlet?action=list");
                    break;
                    
                case "load_update":
                    // Lấy dữ liệu cũ hiển thị lên form sửa
                    int updId = Integer.parseInt(request.getParameter("bomId"));
                    BOMDTO bomEdit = dao.getBOMById(updId);
                    
                    request.setAttribute("bomEdit", bomEdit);
                    request.getRequestDispatcher("updateBOM.jsp").forward(request, response);
                    break;
                    
                case "update":
                    // Nhận dữ liệu mới từ form và lưu vào DB
                    int uBomId = Integer.parseInt(request.getParameter("bomId"));
                    int uPId = Integer.parseInt(request.getParameter("productItemId"));
                    int uMId = Integer.parseInt(request.getParameter("materialItemId"));
                    int uQty = Integer.parseInt(request.getParameter("quantityRequired"));
                    
                    dao.updateBOM(new BOMDTO(uBomId, uPId, uMId, uQty));
                    response.sendRedirect("BOMServlet?action=list");
                    break;
                    
                default:
                    response.sendRedirect("BOMServlet?action=list");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi hệ thống: " + e.getMessage());
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
