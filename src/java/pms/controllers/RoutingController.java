package pms.controllers;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.RoutingDAO;
import pms.model.RoutingDTO;
import pms.model.RoutingStepDAO;
import pms.model.RoutingStepDTO;

public class RoutingController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "listRouting";
        }
        action = action.trim();

        RoutingDAO dao = new RoutingDAO();
        RoutingStepDAO stepDao = new RoutingStepDAO();

        try {
            switch (action) {
                case "listRouting":
                case "list":
                case "searchRouting": {
                    String keyword = normalize(request.getParameter("keyword"));
                    List<RoutingDTO> list = getFilteredRoutingList(dao, keyword);
                    request.setAttribute("keyword", keyword);
                    request.setAttribute("msg", consumeFlash(request, "routingMsg"));
                    request.setAttribute("error", consumeFlash(request, "routingError"));
                    request.setAttribute("listRouting", list);
                    request.getRequestDispatcher("listRouting.jsp").forward(request, response);
                    break;
                }
                case "addRouting": {
                    String addName = normalize(request.getParameter("routingName"));
                    if (addName.isEmpty()) {
                        setFlash(request, "routingError", "Tên quy trình không được để trống.");
                    } else if (dao.insertRouting(new RoutingDTO(0, addName))) {
                        setFlash(request, "routingMsg", "Đã thêm quy trình thành công.");
                    } else {
                        setFlash(request, "routingError", "Không thể thêm quy trình.");
                    }
                    response.sendRedirect("RoutingController?action=listRouting");
                    break;
                }
                case "deleteRouting": {
                    int delId = Integer.parseInt(request.getParameter("routingId"));
                    if (dao.deleteRouting(new RoutingDTO(delId, ""))) {
                        setFlash(request, "routingMsg", "Đã xóa quy trình thành công.");
                    } else {
                        setFlash(request, "routingError", "Không thể xóa quy trình này. Dữ liệu có thể đang được sử dụng ở công đoạn khác.");
                    }
                    response.sendRedirect("RoutingController?action=listRouting");
                    break;
                }
                case "loadUpdateRouting": {
                    int updId = Integer.parseInt(request.getParameter("routingId"));
                    String keyword = normalize(request.getParameter("keyword"));
                    RoutingDTO routingEdit = dao.getRoutingById(updId);
                    if (routingEdit == null) {
                        setFlash(request, "routingError", "Không tìm thấy quy trình cần cập nhật.");
                        response.sendRedirect("RoutingController?action=listRouting");
                        break;
                    }
                    List<RoutingDTO> list = getFilteredRoutingList(dao, keyword);
                    request.setAttribute("routingEdit", routingEdit);
                    request.setAttribute("keyword", keyword);
                    request.setAttribute("msg", consumeFlash(request, "routingMsg"));
                    request.setAttribute("error", consumeFlash(request, "routingError"));
                    request.setAttribute("listRouting", list);
                    request.getRequestDispatcher("listRouting.jsp").forward(request, response);
                    break;
                }
                case "viewRoutingDetail": {
                    int routingId = Integer.parseInt(request.getParameter("routingId"));
                    String keyword = normalize(request.getParameter("keyword"));
                    RoutingDTO routingDetail = dao.getRoutingById(routingId);
                    if (routingDetail == null) {
                        setFlash(request, "routingError", "Không tìm thấy quy trình cần xem chi tiết.");
                        response.sendRedirect("RoutingController?action=listRouting");
                        break;
                    }
                    List<RoutingDTO> list = getFilteredRoutingList(dao, keyword);
                    List<RoutingStepDTO> routingSteps = stepDao.getRoutingStepsByRoutingId(routingId);
                    request.setAttribute("routingDetail", routingDetail);
                    request.setAttribute("routingSteps", routingSteps);
                    request.setAttribute("keyword", keyword);
                    request.setAttribute("msg", consumeFlash(request, "routingMsg"));
                    request.setAttribute("error", consumeFlash(request, "routingError"));
                    request.setAttribute("listRouting", list);
                    request.getRequestDispatcher("listRouting.jsp").forward(request, response);
                    break;
                }
                case "saveUpdateRouting": {
                    int uId = Integer.parseInt(request.getParameter("routingId"));
                    String uName = normalize(request.getParameter("routingName"));
                    if (uName.isEmpty()) {
                        setFlash(request, "routingError", "Tên quy trình không được để trống.");
                    } else if (dao.updateRouting(new RoutingDTO(uId, uName))) {
                        setFlash(request, "routingMsg", "Đã cập nhật quy trình thành công.");
                    } else {
                        setFlash(request, "routingError", "Không thể cập nhật quy trình.");
                    }
                    response.sendRedirect("RoutingController?action=listRouting");
                    break;
                }
                default:
                    response.sendRedirect("RoutingController?action=listRouting");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            setFlash(request, "routingError", "Đã xảy ra lỗi khi xử lý quy trình sản xuất.");
            response.sendRedirect("RoutingController?action=listRouting");
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

    private String normalize(String value) {
        return value != null ? value.trim() : "";
    }

    private List<RoutingDTO> getFilteredRoutingList(RoutingDAO dao, String keyword) {
        List<RoutingDTO> list = dao.getAllRouting();
        if (!keyword.isEmpty()) {
            String normalizedKeyword = keyword.toLowerCase();
            list.removeIf(r -> r == null
                    || r.getRoutingName() == null
                    || !r.getRoutingName().toLowerCase().contains(normalizedKeyword));
        }
        return list;
    }

    private void setFlash(HttpServletRequest request, String key, String value) {
        request.getSession().setAttribute(key, value);
    }

    private String consumeFlash(HttpServletRequest request, String key) {
        Object value = request.getSession().getAttribute(key);
        if (value != null) {
            request.getSession().removeAttribute(key);
            return value.toString();
        }
        return null;
    }
}
