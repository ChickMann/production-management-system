<%-- 
    Document   : productionlog
    Created on : Mar 16, 2026, 5:42:49 PM
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <title>Production Log Management</title>
</head>
<body>
<h2>Production Log</h2>

<!-- FORM INSERT -->
<h3>Add Production Log</h3>
<form action="ProductionLogController" method="post">
    <input type="hidden" name="action" value="insert"/>
    Work Order ID:
    <input type="text" name="woId" required/>
    Step ID:
    <input type="text" name="stepId" required/>
    Worker User ID:
    <input type="text" name="workerUserId" required/>
    Produced Quantity:
    <input type="number" name="producedQuantity" required/>
    Defect ID:
    <input type="text" name="defectId"/>
    <button type="submit">Insert</button>
</form>
<br><br>

<!-- TABLE SHOW DATA -->
<table border="1">
    <tr>
        <th>Log ID</th>
        <th>WO ID</th>
        <th>Step ID</th>
        <th>Worker ID</th>
        <th>Quantity</th>
        <th>Defect ID</th>
        <th>Date</th>
        <th>Action</th>
    </tr>
    <c:forEach var="log" items="${logs}">
        <tr>
        <form action="ProductionLogController" method="post">
            <td>
                ${log.logId}
                <input type="hidden" name="logId" value="${log.logId}"/>
            </td>
            <td>${log.woId}</td>
            <td>${log.stepId}</td>
            <td>${log.workerUserId}</td>
            <td>
                <input type="number" name="producedQuantity"
                       value="${log.producedQuantity}"/>
            </td>
            <td>
                <input type="text" name="defectId"
                       value="${log.defectId}"/>
            </td>
            <td>${log.logDate}</td>
            <td>
                <input type="hidden" name="action" value="update"/>
                <button type="submit">Update</button>
        </form>
        <form action="ProductionLogController" method="post" style="display:inline">
                <input type="hidden" name="action" value="delete"/>
                <input type="hidden" name="logId" value="${log.logId}"/>
                <button type="submit">Delete</button>
        </form>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
