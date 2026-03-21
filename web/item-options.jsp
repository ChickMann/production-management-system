<%@page import="pms.model.ItemDTO"%>
<%@page import="pms.model.ItemDAO"%>
<%@page import="java.util.ArrayList"%>
<%
    String type = request.getParameter("type");
    ItemDAO dao = new ItemDAO();
    ArrayList<ItemDTO> items;
    if ("SanPham".equals(type)) {
        items = dao.getProducts();
    } else if ("VatTu".equals(type)) {
        items = dao.getMaterials();
    } else {
        items = dao.getAllItems();
    }
    if (items != null) {
        for (ItemDTO item : items) {
%>
    <option value="<%= item.getItemID() %>"><%= item.getItemName() %></option>
<%
        }
    }
%>
