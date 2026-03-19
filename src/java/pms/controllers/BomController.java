package pms.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pms.model.BOMDAO;
import pms.model.BOMDTO;
import pms.model.ItemDAO;
import pms.model.ItemDTO;

@WebServlet(name = "BOMController", urlPatterns = {"/BOMController"})
public class BOMController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8"); 
        
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "listBOM";
        }

        BOMDAO dao = new BOMDAO();
        ItemDAO itemDao = new ItemDAO();

        try {
            switch (action) {
                // =============== 1. XỬ LÝ HIỂN THỊ & TÌM KIẾM ===============
                case "listBOM":
                case "searchBom":
                    String keyword = request.getParameter("keyword");
                    List<BOMDTO> listBom = dao.getAllBOMS();
                    
                    // LẤY DANH SÁCH ITEM TRƯỚC ĐỂ DÙNG CHO TÌM KIẾM THEO TÊN
                    List<ItemDTO> itemList = itemDao.ItemList(); 
                    
                    // Logic Lọc Tìm Kiếm (CHỈ TÌM THEO TÊN SẢN PHẨM)
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        String lowerKeyword = keyword.toLowerCase(); // Đưa từ khóa về chữ thường
                        List<BOMDTO> filteredList = new ArrayList<>();
                        
                        for (BOMDTO b : listBom) {
                            boolean isMatch = false;
                            
                            // Chỉ duyệt qua danh sách Item để tìm tên của SẢN PHẨM
                            for (ItemDTO item : itemList) {
                                // Chỉ xét Item nào là Product (Sản Phẩm) của công thức này
                                if (item.getItemID() == b.getProductItemId()) {
                                    // Kiểm tra xem Tên của Sản phẩm đó có chứa từ khóa tìm kiếm không
                                    if (item.getItemName().toLowerCase().contains(lowerKeyword)) {
                                        isMatch = true;
                                        break; 
                                    }
                                }
                            }
                            
                            // Nếu Tên Sản Phẩm khớp thì mới thêm vào danh sách kết quả hiển thị
                            if (isMatch) {
                                filteredList.add(b);
                            }
                        }
                        listBom = filteredList; // Thay thế danh sách gốc bằng danh sách đã lọc
                    }
                    
                    request.setAttribute("danhSachBOM", listBom);
                    request.setAttribute("itemList", itemList);
                    request.getRequestDispatcher("listBOM.jsp").forward(request, response);
                    break;
                    
                // =============== 2. XỬ LÝ THÊM MỚI ===============
                case "addBom":
                    int pId = Integer.parseInt(request.getParameter("productItemId"));
                    int mId = Integer.parseInt(request.getParameter("materialItemId"));
                    int qty = Integer.parseInt(request.getParameter("quantityRequired"));
                    
                    dao.insertBOM(new BOMDTO(0, pId, mId, qty));
                    response.sendRedirect("MainController?action=listBOM");
                    break;
                    
                // =============== 3. XỬ LÝ XÓA ===============
                case "deleteBom":
                case "removeBom":
                    int delId = Integer.parseInt(request.getParameter("bomId"));
                    BOMDTO delBom = new BOMDTO();
                    delBom.setBomId(delId);
                    
                    dao.deleteBOM(delBom);
                    response.sendRedirect("MainController?action=listBOM");
                    break;
                    
                // =============== 4. XỬ LÝ HIỂN THỊ FORM SỬA ===============
                case "loadUpdateBom":
                    String strBomId = request.getParameter("bomId");
                    if(strBomId != null && !strBomId.isEmpty()) {
                        int updId = Integer.parseInt(strBomId);
                        BOMDTO bomEdit = dao.getBOMById(updId);
                        request.setAttribute("bomEdit", bomEdit); // Đẩy dữ liệu cũ sang form
                    }
                    
                    // Phải load lại cả danh sách để bảng bên phải không bị trắng
                    request.setAttribute("danhSachBOM", dao.getAllBOMS());
                    request.setAttribute("itemList", itemDao.ItemList());
                    request.getRequestDispatcher("listBOM.jsp").forward(request, response);
                    break;
                    
                // =============== 5. XỬ LÝ LƯU CẬP NHẬT ===============
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