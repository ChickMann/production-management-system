<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý nhân viên</title>
    </head>
    <body>
        
        <c:if test="${not empty user}">
            <h1>Hello ${user.fullName}</h1><br/>
             <a href="MainController?action=addUser">Add</a>
            <c:if test="${user.role eq 'admin'}">
                <c:choose>
                    <c:when test="${empty eList}"> 
                        <p>Empty Employee</p>
                    </c:when>
                    <c:otherwise>
                        <h1>List employee</h1>
                        <table border="1">
                            <thead>
                                <tr>
                                    <th>Id</th>
                                    <th>Username</th>
                                    <th>Password</th>
                                    <th>Full name</th>
                                    <th>Actions</th> 
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${eList}" var="e">

                                    <tr>
                                        <td>${e.id}</td>
                                        <td>${e.username}</td>
                                        <td>${e.password}</td>
                                        <td>${e.fullName}</td>
                                        <td>
                                            <a href="MainController?action=updateUser&id=${e.id}">Update</a> |
                                            <form action="MainController" method="post">
                                                <input type="hidden" name="action" value="removeUser"/>
                                                <input type="hidden" name="id" value="${e.id+1}"/>
                                                <input type="submit" value="Remove"/>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose> <c:if test="${not empty msg}">
                    <p style="color: blue;"><b>${msg}</b></p>
                        </c:if>

                <br/>
                <a href="MainController?action=addUser">Add employee</a> <br/><br/>
            </c:if>

            <a href="MainController?action=logoutUser">Logout</a>
        </c:if>
            
    </body>
</html>