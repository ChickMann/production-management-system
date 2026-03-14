<%-- 
    Document   : user-form
    Created on : Mar 14, 2026, 10:00:11 AM
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
        <form action="MainController" method="post">
            <input type="hidden" name="action" value="${mode == 'update'?'saveUpdateUser':'saveAddUser'}"/> <br/>
            User id: <input type="text" name="id" value="${mode == 'update'? u.id : index}" readonly /><br/>
            username: <input type="text" name="username" value="${u.username}" required/><br/>
            password: <input type="text" name="password" value="${u.password}" required/><br/>
            full name: <input type="text" name="fullName" value="${u.fullName}" required/><br/>
            role: <input type="text" name="role" value="${u.role}" required/><br/>
            <input type="submit" value="${mode == 'update'?'Update':'Add'}"/><br/>
        </form>
            <p style="color: green">${msg}</p><br/>
            <p style="color: red">${error}</p>
    </body>
</html>
