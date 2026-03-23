package pms.controllers;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.DefectReasonDAO;
import pms.model.DefectReasonDTO;

@WebServlet(name = "DefectController", urlPatterns = {"/DefectController"})
public class DefectController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) action = "listDefectReason";
        action = action.trim();

        DefectReasonDAO dao = new DefectReasonDAO();

        try {
            switch (action) {
                case "listDefectReason":
                case "listDefect":
                case "list": {
                    String keyword = normalize(request.getParameter("keyword"));
                    List<DefectReasonDTO> list = dao.getAllDefectReasons();
                    if (!keyword.isEmpty()) {
                        String normalizedKeyword = keyword.toLowerCase();
                        list.removeIf(d -> d == null
                                || d.getReasonName() == null
                                || !d.getReasonName().toLowerCase().contains(normalizedKeyword));
                    }
                    request.setAttribute("keyword", keyword);
                    request.setAttribute("listD", list);
                    request.setAttribute("msg", consumeFlash(request, "defectReasonMsg"));
                    request.setAttribute("error", consumeFlash(request, "defectReasonError"));
                    request.getRequestDispatcher("listDefectReason.jsp").forward(request, response);
                    break;
                }
                case "searchDefectReason":
                case "search":
                    response.sendRedirect("DefectController?action=listDefectReason&keyword="
                            + java.net.URLEncoder.encode(normalize(request.getParameter("keyword")), "UTF-8"));
                    break;
                case "addDefectReason": {
                    String reasonName = normalize(request.getParameter("reasonName"));
                    if (reasonName.isEmpty()) {
                        setFlash(request, "defectReasonError", "Tên nguyên nhân lỗi không được để trống.");
                    } else if (dao.insertDefectReasons(new DefectReasonDTO(0, reasonName))) {
                        setFlash(request, "defectReasonMsg", "Đã thêm nguyên nhân lỗi thành công.");
                    } else {
                        setFlash(request, "defectReasonError", "Không thể thêm nguyên nhân lỗi.");
                    }
                    response.sendRedirect("DefectController?action=listDefectReason");
                    break;
                }
                case "deleteDefectReason": {
                    int delId = Integer.parseInt(request.getParameter("defectId"));
                    if (dao.deleteDefectReasons(new DefectReasonDTO(delId, null))) {
                        setFlash(request, "defectReasonMsg", "Đã xóa nguyên nhân lỗi thành công.");
                    } else {
                        setFlash(request, "defectReasonError", "Không thể xóa nguyên nhân lỗi này. Dữ liệu có thể đang được sử dụng ở màn hình khác.");
                    }
                    response.sendRedirect("DefectController?action=listDefectReason");
                    break;
                }
                case "loadUpdateDefectReason": {
                    String keyword = normalize(request.getParameter("keyword"));
                    DefectReasonDTO defectEdit = dao.getDefectReasonById(Integer.parseInt(request.getParameter("defectId")));
                    if (defectEdit == null) {
                        setFlash(request, "defectReasonError", "Không tìm thấy nguyên nhân lỗi cần sửa.");
                        response.sendRedirect("DefectController?action=listDefectReason");
                        break;
                    }
                    List<DefectReasonDTO> list = dao.getAllDefectReasons();
                    if (!keyword.isEmpty()) {
                        String normalizedKeyword = keyword.toLowerCase();
                        list.removeIf(d -> d == null
                                || d.getReasonName() == null
                                || !d.getReasonName().toLowerCase().contains(normalizedKeyword));
                    }
                    request.setAttribute("defectEdit", defectEdit);
                    request.setAttribute("listD", list);
                    request.setAttribute("keyword", keyword);
                    request.setAttribute("msg", consumeFlash(request, "defectReasonMsg"));
                    request.setAttribute("error", consumeFlash(request, "defectReasonError"));
                    request.getRequestDispatcher("listDefectReason.jsp").forward(request, response);
                    break;
                }
                case "saveUpdateDefectReason": {
                    int uId = Integer.parseInt(request.getParameter("defectId"));
                    String reasonName = normalize(request.getParameter("reasonName"));
                    if (reasonName.isEmpty()) {
                        setFlash(request, "defectReasonError", "Tên nguyên nhân lỗi không được để trống.");
                    } else if (dao.updateDefectReasons(new DefectReasonDTO(uId, reasonName))) {
                        setFlash(request, "defectReasonMsg", "Đã cập nhật nguyên nhân lỗi thành công.");
                    } else {
                        setFlash(request, "defectReasonError", "Không thể cập nhật nguyên nhân lỗi.");
                    }
                    response.sendRedirect("DefectController?action=listDefectReason");
                    break;
                }
                default:
                    response.sendRedirect("DefectController?action=listDefectReason");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            setFlash(request, "defectReasonError", "Đã xảy ra lỗi khi xử lý nguyên nhân lỗi.");
            response.sendRedirect("DefectController?action=listDefectReason");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }
    private String normalize(String value) {
        return value != null ? value.trim() : "";
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
