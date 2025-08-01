<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%
    Integer customerId = (Integer) session.getAttribute("customerId");
    if (customerId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, String>> bills = new ArrayList<>();
    try (Connection conn = com.pahanaedu.util.DBUtil.getConnection()) {
        PreparedStatement stmt = conn.prepareStatement(
            "SELECT b.bill_id, i.item_name, b.quantity, b.total_amount, b.bill_date FROM bill b JOIN item i ON b.item_id = i.item_id WHERE b.customer_id = ?");
        stmt.setInt(1, customerId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> bill = new HashMap<>();
            bill.put("id", rs.getString("bill_id"));
            bill.put("item", rs.getString("item_name"));
            bill.put("qty", rs.getString("quantity"));
            bill.put("amount", rs.getString("total_amount"));
            bill.put("date", rs.getString("bill_date"));
            bills.add(bill);
        }
    } catch (Exception e) {
        out.println("Error loading bills.");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Bills - Pahana Edu</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f7f6;
            color: #333;
            margin: 0;
            padding: 20px;
        }
        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 2.2em;
        }
        table {
            width: 90%;
            margin: 30px auto;
            border-collapse: separate; /* Changed to separate for rounded corners */
            border-spacing: 0;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-radius: 8px; /* Rounded corners for the table */
            overflow: hidden; /* Ensures content respects border-radius */
            background-color: #fff;
        }
        th, td {
            padding: 15px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }
        th {
            background-color: #007bff;
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9em;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #eef;
            transition: background-color 0.3s ease;
        }
        td {
            color: #555;
            font-size: 0.95em;
        }
        /* Specific styling for the last row's cells to remove bottom border */
        tr:last-child td {
            border-bottom: none;
        }
        /* Rounded corners for the first and last th */
        th:first-child {
            border-top-left-radius: 8px;
        }
        th:last-child {
            border-top-right-radius: 8px;
        }
        /* Responsive adjustments */
        @media (max-width: 768px) {
            table {
                width: 98%;
                font-size: 0.9em;
            }
            th, td {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <h2>My Bills</h2>
    <table>
        <thead>
            <tr>
                <th>Bill ID</th>
                <th>Item</th>
                <th>Quantity</th>
                <th>Total</th>
                <th>Date</th>
            </tr>
        </thead>
        <tbody>
            <% for (Map<String, String> bill : bills) { %>
            <tr>
                <td><%= bill.get("id") %></td>
                <td><%= bill.get("item") %></td>
                <td><%= bill.get("qty") %></td>
                <td>Rs. <%= bill.get("amount") %></td>
                <td><%= bill.get("date") %></td>
            </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>