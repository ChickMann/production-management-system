<%-- 
    Document   : customer
    Created on : Mar 15, 2026, 5:15:09 PM
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="pms.model.CustomerDTO"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Customer Management</title>
    </head>
    <body>
        <h2>Customer Management</h2>
        <!-- SEARCH -->
        <form action="CustomerController" method="get">
            <input type="hidden" name="action" value="searchCustomer">
            Search ID:
            <input type="text" name="keyword"
                   value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : ""%>">
            <input type="submit" value="Search">
        </form

        <br>
        <!-- ADD / UPDATE FORM -->
        <h3>Add / Update Customer</h3>
        <form action="CustomerController" method="post">
            <%
                CustomerDTO customer = (CustomerDTO) request.getAttribute("customer");
                String mode = (String) request.getAttribute("mode");

                if (mode == null) {
                    mode = "add";
                }
            %>
            <input type="hidden" name="action"
                   value="<%= mode.equals("update") ? "saveUpdateCustomer" : "saveAddCustomer"%>">
            ID:
            <input type="text" name="id"
                   value="<%= customer != null ? customer.getCustomer_id() : ""%>"
                   <%= mode.equals("add") ? "readonly" : "readonly"%> >
            <br><br>
            Name:
            <input type="text" name="customer_name"
                   value="<%= customer != null ? customer.getCustomer_name() : ""%>">
            <br><br>
            Phone:
            <input type="text" name="phone"
                   value="<%= customer != null ? customer.getPhone() : ""%>">
            <br><br>
            Email:
            <input type="text" name="email"
                   value="<%= customer != null ? customer.getEmail() : ""%>">
            <br><br>

            <input type="submit" value="<%= mode.equals("update") ? "Update" : "Add"%>">
        </form>
        <br>
        <!-- MESSAGE -->
        <%
            String msg = (String) request.getAttribute("msg");
            String error = (String) request.getAttribute("error");

            if (msg != null) {
        %>
        <p style="color:green;"><b><%=msg%></b></p>
                <%
                    }

                    if (error != null) {
                %>
        <p style="color:red;"><b><%=error%></b></p>
                <%
                    }
                %>
        <hr>
        <!-- CUSTOMER LIST -->
        <h3>Customer List</h3>
        <table border="1" cellpadding="5">
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Phone</th>
                <th>Email</th>
                <th>Action</th>
            </tr>
            <%
                List<CustomerDTO> customerList
                        = (List<CustomerDTO>) request.getAttribute("customerList");

                if (customerList != null) {
                    for (CustomerDTO c : customerList) {
            %>
            <tr>
                <td><%= c.getCustomer_id()%></td>
                <td><%= c.getCustomer_name()%></td>
                <td><%= c.getPhone()%></td>
                <td><%= c.getEmail()%></td>
                <td>
                    <a href="CustomerController?action=updateCustomer&id=<%=c.getCustomer_id()%>">
                        Edit
                    </a>
                    |
                    <a href="CustomerController?action=removeCustomer&id=<%=c.getCustomer_id()%>"
                       onclick="return confirm('Delete this customer?')">
                        Delete
                    </a>
                </td>
            </tr>
            <%
                    }
                }
            %>
        </table>
    </body>
</html>