<%-- 
    Document   : bill
    Created on : Mar 15, 2026, 12:31:27 PM
    Author     : HP
--%>

<%@page import="pms.model.BillDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Bill Management</title>
    </head>
    <body>
        <h2>Bill Management</h2>

<!-- ===== MESSAGE ===== -->

<%
String msg = (String)request.getAttribute("msg");
if(msg != null){
%>
    <p style="color:green;"><%=msg%></p>
<%
}
%>

<!-- ===== SEARCH BILL ===== -->

<h3>Search Bill</h3>

<form action="BillController" method="get">

    <input type="hidden" name="action" value="searchBill">

    Bill ID:
    <input type="text" name="keyword">

    <input type="submit" value="Search">

</form>

<a href="BillController?action=listBill">Show All Bills</a>

<hr>

<!-- ===== ADD BILL ===== -->

<h3>Add Bill</h3>

<form action="BillController" method="post">
    <input type="hidden" name="action" value="addBill">
    Work Order ID:
    <input type="text" name="wo_id" required>
    <br><br>
    Customer ID:
    <input type="text" name="customer_id" required>
    <br><br>
    Total Amount:
    <input type="text" name="total_amount" required>
    <br><br>
    <input type="submit" value="Add Bill">
</form>
<hr>

<!-- ===== BILL LIST ===== -->

<h3>Bill List</h3>
<table border="1" cellpadding="5">
<tr>
    <th>Bill ID</th>
    <th>Work Order</th>
    <th>Customer</th>
    <th>Total Amount</th>
    <th>Bill Date</th>
    <th>Update</th>
    <th>Delete</th>
</tr>

<%

ArrayList<BillDTO> list = (ArrayList<BillDTO>)request.getAttribute("billList");

if(list != null){
    for(BillDTO b : list){

%>

<tr>

<form action="BillController" method="post">

<td>
<%=b.getBill_id()%>
<input type="hidden" name="bill_id" value="<%=b.getBill_id()%>">
</td>

<td>
<input type="text" name="wo_id" value="<%=b.getWo_id()%>">
</td>

<td>
<input type="text" name="customer_id" value="<%=b.getCustomer_id()%>">
</td>

<td>
<input type="text" name="total_amount" value="<%=b.getTotal_amount()%>">
</td>

<td>
<%=b.getBill_date()%>
</td>

<td>

<input type="hidden" name="action" value="updateBill">
<input type="submit" value="Update">

</td>

</form>

<td>

<a href="BillController?action=deleteBill&bill_id=<%=b.getBill_id()%>"
   onclick="return confirm('Delete this bill?')">

Delete

</a>

</td>

</tr>

<%
    }
}
%>

</table>

<br>

<!-- ===== BACK TO DASHBOARD ===== -->

<a href="BangDieuKien.jsp">Back to Dashboard</a>

    </body>
</html>
