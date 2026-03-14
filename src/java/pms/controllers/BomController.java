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
import pms.model.BomDAO;
import pms.model.BomDTO;
import pms.model.ItemDAO;
import pms.model.ItemDTO;

/**
 *
 * @author BAO
 */
public class BomController extends HttpServlet {

    String url = "";

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

        switch (action) {
            case "addBom":
                AddBom(request);
                break;
            case "deleteBom":
                RemoveBom(request);
                break;
            case "updateBom":
                UpdateBom(request);
                break;
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    private void RemoveBom(HttpServletRequest request) {

        String id = request.getParameter("id");
        BomDAO bdao = new BomDAO();

        if (!id.isEmpty()) {
            boolean check = bdao.SoftDelete(id);
            if (check) {
                request.setAttribute("msg", "Deleted!");
            } else {
                request.setAttribute("msg", "Error, can not delete: " + id);
            }
        }

        url = "BangDieuKien.jsp";

    }

    private void AddBom(HttpServletRequest request) {
        String msg = "";
        String error = "";

        BomDAO bdao = new BomDAO();

        String s_id = request.getParameter("id");
        String s_parentItemId = request.getParameter("parentItemId");
        String s_childItemId = request.getParameter("childItemId");
        String s_quantity = request.getParameter("quantity");
        float quantity = 0;
        try {
            quantity = Float.parseFloat(s_quantity);
        } catch (Exception e) {
            error += "cost phai la so thap phan";
        }
        int id = 0;
        try {
            id = Integer.parseInt(s_id);
        } catch (Exception e) {
            error += "id phai la so nguyen duong";
        }

        int parentItemId = 0;
        try {
            parentItemId = Integer.parseInt(s_parentItemId);
        } catch (Exception e) {
            error += "parentItemId phai la so nguyen duong";
        }
        int childItemId = 0;
        try {
            childItemId = Integer.parseInt(s_childItemId);
        } catch (Exception e) {
            error += "childItemId phai la so nguyen duong";
        }

        BomDTO b = new BomDTO(id, parentItemId, childItemId, quantity);
        if (!error.isEmpty()) {
            if (bdao.Add(b)) {
                msg = "Add thanh cong";
            } else {
                error = "Add that bai";
            }
        }

        request.setAttribute("bom", b);
        request.setAttribute("msg", msg);
        request.setAttribute("error", error);

        url = "bom-form.jsp";
    }

    private void UpdateBom(HttpServletRequest request) {
        String msg = "";
        String error = "";

        BomDAO bdao = new BomDAO();

        String action = request.getParameter("action");
        String s_id = request.getParameter("id");

        BomDTO b = bdao.SearchByID(s_id);
        

        if (action.equals("saveUpdateBom")) {
            String s_parentItemId = request.getParameter("parentItemId");
            String s_childItemId = request.getParameter("childItemId");
            String s_quantity = request.getParameter("quantity");
             float quantity = 0;
        try {
            quantity = Float.parseFloat(s_quantity);
        } catch (Exception e) {
            error += "cost phai la so thap phan";
        }
        int id = 0;
        try {
            id = Integer.parseInt(s_id);
        } catch (Exception e) {
            error += "id phai la so nguyen duong";
        }

        int parentItemId = 0;
        try {
            parentItemId = Integer.parseInt(s_parentItemId);
        } catch (Exception e) {
            error += "parentItemId phai la so nguyen duong";
        }
        int childItemId = 0;
        try {
            childItemId = Integer.parseInt(s_childItemId);
        } catch (Exception e) {
            error += "childItemId phai la so nguyen duong";
        }

         b = new BomDTO(id, parentItemId, childItemId, quantity);
            if (!error.isEmpty()) {
                if (bdao.Update(b)) {
                    msg = "Add thanh cong";
                } else {
                    error = "Add that bai";
                }
            }

            request.setAttribute("msg", msg);
            request.setAttribute("error", error);
        }

        request.setAttribute("bom", b);

        url = "bom-form.jsp";
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
