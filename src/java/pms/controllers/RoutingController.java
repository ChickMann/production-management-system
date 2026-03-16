package pms.controllers;



import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.RoutingDAO;
import pms.model.RoutingDTO;

public class RoutingController extends HttpServlet {


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "list";

        RoutingDAO dao = new RoutingDAO();

        try {
            switch (action) {
                case "list":
                    List<RoutingDTO> list = dao.getAllRouting();
                    request.setAttribute("listRouting", list);
                    request.getRequestDispatcher("listRouting.jsp").forward(request, response);
                    break;
                case "add":
                    String addName = request.getParameter("routingName");
                    dao.insertRouting(new RoutingDTO(0, addName));
                    response.sendRedirect("MainController?action=listRouting");
                    break;
                case "delete":
                    int delId = Integer.parseInt(request.getParameter("routingId"));
                    dao.deleteRouting(new RoutingDTO(delId, "")); // Truyền vỏ rỗng
                    response.sendRedirect("MainController?action=listRouting");
                    break;
                case "load_update":
                    int updId = Integer.parseInt(request.getParameter("routingId"));
                    request.setAttribute("routingEdit", dao.getRoutingById(updId));
                    request.getRequestDispatcher("updateRouting.jsp").forward(request, response);
                    break;
                case "update":
                    int uId = Integer.parseInt(request.getParameter("routingId"));
                    String uName = request.getParameter("routingName");
                    dao.updateRouting(new RoutingDTO(uId, uName));
                    response.sendRedirect("MainController?action=listRouting");
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
        return "Routing Controller";
    }

}
