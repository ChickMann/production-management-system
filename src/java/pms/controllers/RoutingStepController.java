package pms.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.RoutingDAO;
import pms.model.RoutingDTO;
import pms.model.RoutingStepDAO;
import pms.model.RoutingStepDTO;

public class RoutingStepController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "listRoutingStep";
        }

        RoutingStepDAO dao = new RoutingStepDAO();
        RoutingDAO rDao = new RoutingDAO();

        try {
            switch (action) {
                case "listRoutingStep":
                case "searchRoutingStep": {
                    String keyword = request.getParameter("keyword");
                    String searchRoutingId = request.getParameter("searchRoutingId");

                    List<RoutingStepDTO> listStep = dao.getAllRoutingStep();
                    List<RoutingDTO> listRouting = rDao.getAllRouting();

                    if ((keyword != null && !keyword.trim().isEmpty()) || (searchRoutingId != null && !searchRoutingId.isEmpty())) {
                        String lowerKeyword = keyword != null ? keyword.toLowerCase() : "";
                        List<RoutingStepDTO> filtered = new ArrayList<>();

                        for (RoutingStepDTO s : listStep) {
                            String stepName = s.getStepName();
                            boolean matchKeyword = stepName == null || stepName.isEmpty()
                                    || stepName.toLowerCase().contains(lowerKeyword);
                            boolean matchRouting = (searchRoutingId == null || searchRoutingId.isEmpty())
                                    || String.valueOf(s.getRoutingId()).equals(searchRoutingId);

                            if (matchKeyword && matchRouting) {
                                filtered.add(s);
                            }
                        }
                        listStep = filtered;
                    }

                    request.setAttribute("listStep", listStep);
                    request.setAttribute("listRouting", listRouting);
                    request.getRequestDispatcher("listRoutingStep.jsp").forward(request, response);
                    break;
                }

                case "addRoutingStep": {
                    int rId = Integer.parseInt(request.getParameter("routingId"));
                    String sName = request.getParameter("stepName");
                    int time = Integer.parseInt(request.getParameter("estimatedTime"));
                    boolean isInsp = request.getParameter("isInspected") != null;

                    dao.insertRoutingStep(new RoutingStepDTO(0, rId, sName, time, isInsp));
                    response.sendRedirect("MainController?action=listRoutingStep");
                    break;
                }

                case "deleteRoutingStep": {
                    int delId = Integer.parseInt(request.getParameter("stepId"));
                    dao.deleteRoutingStep(delId);
                    response.sendRedirect("MainController?action=listRoutingStep");
                    break;
                }

                case "loadUpdateRoutingStep": {
                    int updId = Integer.parseInt(request.getParameter("stepId"));
                    request.setAttribute("stepEdit", dao.getRoutingStepById(updId));
                    request.setAttribute("listStep", dao.getAllRoutingStep());
                    request.setAttribute("listRouting", rDao.getAllRouting());
                    request.getRequestDispatcher("listRoutingStep.jsp").forward(request, response);
                    break;
                }

                case "saveUpdateRoutingStep": {
                    int uId = Integer.parseInt(request.getParameter("stepId"));
                    int uRId = Integer.parseInt(request.getParameter("routingId"));
                    String uName = request.getParameter("stepName");
                    int uTime = Integer.parseInt(request.getParameter("estimatedTime"));
                    boolean uInsp = request.getParameter("isInspected") != null;

                    dao.updateRoutingStep(new RoutingStepDTO(uId, uRId, uName, uTime, uInsp));
                    response.sendRedirect("MainController?action=listRoutingStep");
                    break;
                }
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
}
