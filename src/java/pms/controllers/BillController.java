/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package pms.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.BillDAO;
import pms.model.BillDTO;

/**
 *
 * @author HP
 */
public class BillController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    String url = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null) {
            action = "listBill";

        }
        switch (action) {
            case "listBill":
                ListBill(request);
                break;

            case "addBill":
                AddBill(request);
                break;

            case "deleteBill":
                DeleteBill(request);
                break;

            case "updateBill":
                UpdateBill(request);
                break;

            case "searchBill":
                SearchBill(request);
                break;
        }
        request.getRequestDispatcher(url).forward(request, response);
    }

    private void ListBill(HttpServletRequest request) {
        BillDAO dao = new BillDAO();
        ArrayList<BillDTO> list = dao.getAllBill();
        request.setAttribute("billList", list);
        url = "bill.jsp";
    }

    private void AddBill(HttpServletRequest request) {

        int wo_id = Integer.parseInt(request.getParameter("wo_id"));
        int customer_id = Integer.parseInt(request.getParameter("customer_id"));
        double total_amount = Double.parseDouble(request.getParameter("total_amount"));
        BillDAO dao = new BillDAO();
        BillDTO bill = new BillDTO(0, wo_id, customer_id, total_amount, null);
        boolean result = dao.InsertBill(bill);
        if (result) {
            request.setAttribute("msg", "Add Bill Success");
        } else {
            request.setAttribute("msg", "Add Bill Failed");
        }

        ListBill(request);
    }

    private void DeleteBill(HttpServletRequest request) {
        int bill_id = Integer.parseInt(request.getParameter("bill_id"));
        BillDAO dao = new BillDAO();
        boolean result = dao.deleteBill(bill_id);
        if (result) {
            request.setAttribute("msg", "Delete Bill Success");
        } else {
            request.setAttribute("msg", "Delete Bill Failed");
        }
        ListBill(request);
    }

    private void UpdateBill(HttpServletRequest request) {

        int bill_id = Integer.parseInt(request.getParameter("bill_id"));
        int wo_id = Integer.parseInt(request.getParameter("wo_id"));
        int customer_id = Integer.parseInt(request.getParameter("customer_id"));
        double total_amount = Double.parseDouble(request.getParameter("total_amount"));
        BillDAO dao = new BillDAO();
        BillDTO bill = new BillDTO(bill_id, wo_id, customer_id, total_amount, null);
        boolean result = dao.UpdateBill(bill);
        if (result) {
            request.setAttribute("msg", "Update Bill Success");
        } else {
            request.setAttribute("msg", "Update Bill Failed");
        }

        ListBill(request);
    }

    private void SearchBill(HttpServletRequest request) {
        String keyword = request.getParameter("keyword");
        BillDAO dao = new BillDAO();
        ArrayList<BillDTO> list = dao.searchBill(keyword);
        request.setAttribute("billList", list);
        url = "bill.jsp";
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
        return "";
    }// </editor-fold>

}
