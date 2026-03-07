<%-- 
    Document   : Banned
    Created on : Mar 7, 2026, 10:05:40 AM
    Author     : BAO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
    <c:if test="${not empty user}">
        <h1>Hello ${user.fullName}</h1><br/>
        <h2>Your Account is banned!</h2>
          <a href="MainController?action=logout">Logout</a>
    </c:if>

</body>
</html>
