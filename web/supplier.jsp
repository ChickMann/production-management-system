<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Forward legacy hits to supplier.jsp to the proper controller action
    request.getRequestDispatcher("MainController?action=listSupplier").forward(request, response);
%>
