<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Redirect any legacy or manual hits to supplier.jsp directly to the proper controller
    response.sendRedirect("MainController?action=listSupplier");
%>
