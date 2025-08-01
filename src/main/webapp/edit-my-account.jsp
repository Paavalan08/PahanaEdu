<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.pahanaedu.util.DBUtil" %>
<%@ page session="true" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int customerId = 0;
    String name = "", address = "", telephone = "", password = "", user = "";

    try (Connection conn = DBUtil.getConnection()) {
        String sql = "SELECT * FROM customer WHERE username = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            customerId = rs.getInt("customer_id");
            name = rs.getString("name");
            address = rs.getString("address");
            telephone = rs.getString("telephone");
            password = rs.getString("password");
            user = rs.getString("username");  // Fetch username (not editable)
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit My Account</title>
    <style>
        .form-container {
            width: 400px;
            margin: 80px auto;
            padding: 20px;
            background: white;
            box-shadow: 0 0 10px gray;
        }
        input { width: 100%; padding: 8px; margin: 8px 0; }
        button { padding: 10px; background: #007bff; color: white; border: none; width: 100%; }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Edit My Account</h2>
    <form action="UpdateMyAccountServlet" method="post">
        <input type="hidden" name="customer_id" value="<%= customerId %>" />

        <!-- Username (Not editable by the customer) -->
        <label>Username:</label>
        <input type="text" name="username" value="<%= user %>" disabled />

        <label>Name:</label>
        <input type="text" name="name" value="<%= name %>" required />

        <label>Address:</label>
        <input type="text" name="address" value="<%= address %>" required />

        <label>Telephone:</label>
        <input type="text" name="telephone" value="<%= telephone %>" required />

        <label>Password:</label>
        <input type="text" name="password" value="<%= password %>" required />

        <button type="submit">Update</button>
    </form>
</div>
</body>
</html>
