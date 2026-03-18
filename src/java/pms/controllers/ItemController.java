package pms.controllers;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Base64;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import pms.model.ItemDAO;
import pms.model.ItemDTO;

@MultipartConfig(maxFileSize = 10485760)
public class ItemController extends HttpServlet {

    String url = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        switch (action) {
            case "addItem":
            case "saveAddItem":
                AddItem(request);
                break;
            case "removeItem":
                RemoveItem(request);
                break;
            case "updateItem":
            case "saveUpdateItem":
                UpdateItem(request);
                break;
            case "searchItem":
                SearchItem(request);
                break;
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    private void RemoveItem(HttpServletRequest request) {
        String id = request.getParameter("id");
        ItemDAO idao = new ItemDAO();

        if (id != null && !id.isEmpty()) {
            boolean check = idao.SoftDelete(id);
            if (check) {
                request.setAttribute("msg", "Deleted!");
            } else {
                request.setAttribute("msg", "Error, can not delete: " + id);
            }
        }
        ArrayList<ItemDTO> itemList = idao.ItemList();
        request.setAttribute("itemList", itemList);
        url = "SearchItem.jsp";
    }

    private void AddItem(HttpServletRequest request) throws Exception {
        String msg = "";
        String error = "";

        ItemDAO idao = new ItemDAO();
        String action = request.getParameter("action");
        request.setAttribute("mode", "add");

        if (action.equals("saveAddItem")) {
            String name = request.getParameter("name");
            String type = request.getParameter("type");
            String s_stockQuantity = request.getParameter("stockQuantity");
            int stockQuantity = 0;
            try {
                stockQuantity = Integer.parseInt(s_stockQuantity);
            } catch (Exception e) {
                error += "stock quantity phải là số ";
            }

            String base64Image = null;
            Part filePart = request.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String contentType = filePart.getContentType();
                InputStream is = filePart.getInputStream();
                ByteArrayOutputStream bos = new ByteArrayOutputStream();
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = is.read(buffer)) != -1) {
                    bos.write(buffer, 0, bytesRead);
                }
                byte[] imageBytes = bos.toByteArray();
                base64Image = "data:" + contentType + ";base64," + Base64.getEncoder().encodeToString(imageBytes);
            }

            ItemDTO i = new ItemDTO(0, name, type, stockQuantity, base64Image);
            if (error.isEmpty()) {
                if (idao.Add(i)) {
                    msg = "Thêm thành công";
                } else {
                    error = "Thêm thất bại";
                    idao.ReseedSQL();
                }
            }
            request.setAttribute("item", i);
            request.setAttribute("msg", msg);
            request.setAttribute("error", error);
        }

        int index = idao.GetCurrentID();
        request.setAttribute("index", index);
        url = "item-form.jsp";
    }

    private void UpdateItem(HttpServletRequest request) throws Exception {
        String msg = "";
        String error = "";

        ItemDAO idao = new ItemDAO();
        String action = request.getParameter("action");
        String s_id = request.getParameter("id");

        ItemDTO i = idao.SearchByID(s_id);
        request.setAttribute("mode", "update");

        if (action.equals("saveUpdateItem")) {
            String name = request.getParameter("name");
            String type = request.getParameter("type");
            String s_stockQuantity = request.getParameter("stockQuantity");
            int stockQuantity = 0;
            try {
                stockQuantity = Integer.parseInt(s_stockQuantity);
            } catch (Exception e) {
                error += "standard cost phải là số; ";
            }
            int id = Integer.parseInt(s_id);
            String base64Image = null;
            Part filePart = request.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String contentType = filePart.getContentType();
                InputStream is = filePart.getInputStream();
                ByteArrayOutputStream bos = new ByteArrayOutputStream();
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = is.read(buffer)) != -1) {
                    bos.write(buffer, 0, bytesRead);
                }
                byte[] imageBytes = bos.toByteArray();
                base64Image = "data:" + contentType + ";base64," + Base64.getEncoder().encodeToString(imageBytes);
            } else if (i != null) {
                base64Image = i.getImageBase64();
            }

            i = new ItemDTO(id, name, type, stockQuantity, base64Image);
            if (error.isEmpty()) {
                if (idao.Update(i)) {
                    msg = "Cập nhật thành công";
                } else {
                    error = "Cập nhật thất bại";
                    idao.ReseedSQL();
                }
            }
            request.setAttribute("msg", msg);
            request.setAttribute("error", error);
        }

        request.setAttribute("item", i);
        url = "item-form.jsp";
    }

    private void SearchItem(HttpServletRequest request) {
        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }
        ItemDAO idao = new ItemDAO();

        ArrayList<ItemDTO> itemList = new ArrayList<>();
        if (keyword.trim().length() > 0) {
            itemList = idao.FilterByName(keyword);
        } else {
            itemList = idao.ItemList();
        }

        request.setAttribute("itemList", itemList);
        request.setAttribute("keyword", keyword);
        url = "SearchItem.jsp";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(ItemController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(ItemController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getServletInfo() {
        return "Item Controller";
    }

}
