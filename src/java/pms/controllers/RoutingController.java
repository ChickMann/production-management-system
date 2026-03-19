package pms.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import pms.model.RoutingDAO;
import pms.model.RoutingDTO;

public class RoutingController extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "listRouting";
        RoutingDAO dao = new RoutingDAO();

        try {
            switch (action) {
                case "listRouting":
                case "searchRouting":
                    String keyword = request.getParameter("keyword");
                    List<RoutingDTO> list = dao.getAllRouting();
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        List<RoutingDTO> filtered = new ArrayList<>();
                        for (RoutingDTO r : list) {
                            if (r.getRoutingName().toLowerCase().contains(keyword.toLowerCase())) filtered.add(r);
                        }
                        list = filtered;
                    }
                    request.setAttribute("listR", list);
                    request.getRequestDispatcher("listRouting.jsp").forward(request, response);
                    break;

                case "addRouting":
                    dao.insertRouting(new RoutingDTO(0, request.getParameter("routingName")));
                    response.sendRedirect("MainController?action=listRouting");
                    break;

                case "loadUpdateRouting":
                    int id = Integer.parseInt(request.getParameter("id"));
                    request.setAttribute("routingEdit", dao.getRoutingById(id));
                    request.setAttribute("listR", dao.getAllRouting());
                    request.getRequestDispatcher("listRouting.jsp").forward(request, response);
                    break;

                case "saveUpdateRouting":
                    dao.updateRouting(new RoutingDTO(Integer.parseInt(request.getParameter("routingId")), request.getParameter("routingName")));
                    response.sendRedirect("MainController?action=listRouting");
                    break;

                case "deleteRouting":
                    dao.deleteRouting(Integer.parseInt(request.getParameter("id")));
                    response.sendRedirect("MainController?action=listRouting");
                    break;
            }
        } catch (Exception e) { e.printStackTrace(); }
    }
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { processRequest(req, resp); }
    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { processRequest(req, resp); }
}