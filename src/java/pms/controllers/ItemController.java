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
import javax.servlet.http.HttpSession;
import pms.model.ItemDAO;
import pms.model.ItemDTO;
import pms.model.UserDAO;
import pms.model.UserDTO;

/**
 *
 * @author BAO
 */
public class ItemController extends HttpServlet {

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
            case "addItem":
                AddItem(request);
                break;
            case "deleteItem":
                RemoveItem(request);
                break;
            case "updateItem":
                UpdateItem(request);
                break;
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    private void RemoveItem(HttpServletRequest request) {

        String id = request.getParameter("id");
        ItemDAO idao = new ItemDAO();

        if (!id.isEmpty()) {
            boolean check = idao.SoftDelete(id);
            if (check) {
                request.setAttribute("msg", "Deleted!");
            } else {
                request.setAttribute("msg", "Error, can not delete: " + id);
            }
        }

        url = "BangDieuKien.jsp";

    }

    private void AddItem(HttpServletRequest request) {
        String msg = "";
        String error = "";

        ItemDAO idao = new ItemDAO();

        String s_id = request.getParameter("itemID");
        String itemCode = request.getParameter("itemCode");
        String name = request.getParameter("name");
        String type = request.getParameter("type");
        String s_standartCost = request.getParameter("standardCost");
        double standartCost = 0;
        try {
            standartCost = Double.parseDouble(s_standartCost);
        } catch (Exception e) {
            error += "cost phai la so thap phan";
        }
        int id = 0;
        try {
            id = Integer.parseInt(s_id);
        } catch (Exception e) {
            error += "id phai la so nguyen duong";
        }

        ItemDTO i = new ItemDTO(id, itemCode, name, type, standartCost);
        if (!error.isEmpty()) {
            if (idao.Add(i)) {
                msg = "Add thanh cong";
            } else {
                error = "Add that bai";
            }
        }

        request.setAttribute("item", i);
        request.setAttribute("msg", msg);
        request.setAttribute("error", error);

        url = "item-form.jsp";
    }

    private void UpdateItem(HttpServletRequest request) {
        String msg = "";
        String error = "";

        ItemDAO idao = new ItemDAO();

        String action = request.getParameter("action");
        String s_id = request.getParameter("id");

        ItemDTO i = idao.SearchByID(s_id);

        if (action.equals("saveUpdateItem")) {
            String itemCode = request.getParameter("itemCode");
            String name = request.getParameter("name");
            String type = request.getParameter("type");
            String s_standartCost = request.getParameter("standardCost");
            double standartCost = 0;
            try {
                standartCost = Double.parseDouble(s_standartCost);
            } catch (Exception e) {
                error += "cost phai la so thap phan";
            }
            int id = 0;
            try {
                id = Integer.parseInt(s_id);
            } catch (Exception e) {
                error += "id phai la so nguyen duong";
            }

            i = new ItemDTO(id, itemCode, name, type, standartCost);
            if (!error.isEmpty()) {
                if (idao.Update(i)) {
                    msg = "Add thanh cong";
                } else {
                    error = "Add that bai";
                }
            }

            request.setAttribute("msg", msg);
            request.setAttribute("error", error);
        }

        request.setAttribute("item", i);

        url = "item-form.jsp";
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
