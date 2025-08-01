
<%@page import="com.pahanaedu.dao.ItemDAO"%>
<%@page import="com.pahanaedu.model.Item"%>
<!--
<%@ page import="java.sql.*, com.pahanaedu.util.DBUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="com.pahanaedu.model.Customer, com.pahanaedu.dao.CustomerDAO" %>
<%
    int billId = Integer.parseInt(request.getParameter("bill_id"));

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    int customerId = 0, itemId = 0, quantity = 0;
    double totalAmount = 0;
    try {
        conn = DBUtil.getConnection();
        stmt = conn.prepareStatement("SELECT * FROM bill WHERE bill_id = ?");
        stmt.setInt(1, billId);
        rs = stmt.executeQuery();
        if (rs.next()) {
            customerId = rs.getInt("customer_id");
            itemId = rs.getInt("item_id");
            quantity = rs.getInt("quantity");
            totalAmount = rs.getDouble("total_amount");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Bill</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
        }
        h2 {
            color: #2c3e50;
        }
        form {
            max-width: 400px;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        label {
            display: block;
            margin-top: 15px;
        }
        input, select {
            width: 100%;
            padding: 6px;
            margin-top: 5px;
        }
        button {
            margin-top: 20px;
            padding: 10px;
            background-color: #2c3e50;
            color: white;
            border: none;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <h2>Edit Bill</h2>
    <form action="UpdateBillServlet" method="post">
         Hidden billId 
        <input type="hidden" name="billId" value="<%= billId %>" />

         Customer Dropdown 
        <label>Customer:</label>
        <select name="customerId" required>
            <%
                List<Customer> customers = new CustomerDAO().getAllCustomers();
                for (Customer c : customers) {
            %>
                <option value="<%= c.getCustomerId() %>" <%= (c.getCustomerId() == customerId ? "selected" : "") %>>
                    <%= c.getName() %>
                </option>
            <% } %>
        </select>

         Item Dropdown 
        <label>Item:</label>
        <select name="itemId" required>
            <%
                List<Item> items = new ItemDAO().getAllItems();
                for (Item i : items) {
            %>
                <option value="<%= i.getItemId() %>" <%= (i.getItemId() == itemId ? "selected" : "") %>>
                    <%= i.getItemName() %>
                </option>
            <% } %>
        </select>

         Quantity 
        <label>Quantity:</label>
        <input type="number" name="quantity" value="<%= quantity %>" min="1" required />

         Total Amount 
        <label>Total Amount:</label>
        <input type="number" name="totalAmount" step="0.01" value="<%= totalAmount %>" required />

        <button type="submit">Update Bill</button>
    </form>
</body>
</html>-->



<%@ page import="java.sql.*, com.pahanaedu.util.DBUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="com.pahanaedu.model.Customer, com.pahanaedu.dao.CustomerDAO" %>
<%@ page import="com.pahanaedu.dao.ItemDAO" %>
<%@ page import="com.pahanaedu.model.Item" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Bill</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-blue-dark: #2c3e50;
            --primary-blue-light: #34495e;
            --accent-teal: #00cec9;
            --accent-green: #00b894;
            --background-body: #f4f7f9;
            --background-content: #ffffff;
            --text-dark: #333;
            --text-light: #fdfdfd;
            --border-light: #e8ecef;
            --shadow-soft: rgba(44, 62, 80, 0.1);
            --shadow-lifted: rgba(44, 62, 80, 0.15);
            --button-gradient-start: #3498db;
            --button-gradient-end: #2980b9;
            --input-focus-shadow: rgba(0, 206, 201, 0.25);
            --error-background: #ffebee;
            --error-border: #ef9a9a;
            --error-text: #c62828;
            --label-color: #555;
            --link-color: #3498db;
            --link-hover-color: #2980b9;
        }

        @keyframes fade-in {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--background-body);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .form-container {
            width: 100%;
            max-width: 550px;
            background-color: var(--background-content);
            box-shadow: 0 10px 40px var(--shadow-soft);
            border-radius: 20px;
            padding: 50px;
            animation: fade-in 0.6s ease-out forwards;
            position: relative;
            overflow: hidden;
        }

        /* Subtle top bar accent */
        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 8px;
            background: linear-gradient(90deg, var(--accent-teal), var(--accent-green));
            border-top-left-radius: 20px;
            border-top-right-radius: 20px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .page-header h2 {
            color: var(--primary-blue-dark);
            font-size: 2.8em;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 8px;
            line-height: 1.2;
        }

        .page-header .header-icon {
            font-size: 1.2em;
            color: var(--accent-teal);
        }

        p.subtitle {
            font-size: 1.1em;
            color: #7f8c8d;
            margin-top: -15px;
        }

        label {
            display: block;
            margin-top: 25px;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--label-color);
            font-size: 1em;
        }

        input[type="number"],
        select {
            width: 100%;
            padding: 14px 18px;
            border: 1px solid var(--border-light);
            border-radius: 10px;
            font-family: 'Inter', sans-serif;
            font-size: 1.05em;
            color: var(--text-dark);
            transition: border-color 0.3s ease, box-shadow 0.3s ease, background-color 0.3s ease;
            background-color: #fcfcfc;
            appearance: none; /* Remove default select arrow */
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%232c3e50'%3e%3cpath d='M7 10l5 5 5-5z'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 18px center;
            background-size: 18px;
        }

        input[type="number"]:focus,
        select:focus {
            border-color: var(--accent-teal);
            box-shadow: 0 0 0 4px var(--input-focus-shadow);
            outline: none;
            background-color: var(--background-content);
        }

        button[type="submit"] {
            background: linear-gradient(45deg, var(--button-gradient-start), var(--button-gradient-end));
            color: var(--text-light);
            padding: 18px 30px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1.2em;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 0 6px 20px rgba(52, 152, 219, 0.3);
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            width: 100%;
            margin-top: 40px;
        }

        button[type="submit"]:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(52, 152, 219, 0.5);
            background: linear-gradient(45deg, var(--button-gradient-end), var(--button-gradient-start));
        }

        .error-message {
            text-align: center;
            padding: 20px;
            margin-top: 30px;
            background-color: var(--error-background);
            color: var(--error-text);
            border: 1px solid var(--error-border);
            border-radius: 10px;
            font-weight: 500;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            box-shadow: 0 2px 10px rgba(231, 76, 60, 0.1);
        }
        .error-message i {
            font-size: 1.5em;
            color: var(--error-text);
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 30px;
            font-size: 1em;
            color: var(--link-color);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease, transform 0.3s ease;
        }
        .back-link:hover {
            color: var(--link-hover-color);
            transform: translateY(-2px);
        }

        @media (max-width: 600px) {
            body {
                padding: 15px;
            }
            .form-container {
                margin: 0;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 5px 20px var(--shadow-soft);
            }
            .form-container::before {
                height: 6px;
            }
            .page-header {
                margin-bottom: 25px;
            }
            .page-header h2 {
                font-size: 2.2em;
                gap: 8px;
            }
            p.subtitle {
                font-size: 0.95em;
            }
            label {
                margin-top: 20px;
                font-size: 0.9em;
            }
            input[type="number"],
            select {
                padding: 12px 15px;
                font-size: 1em;
                border-radius: 8px;
            }
            button[type="submit"] {
                padding: 14px 25px;
                font-size: 1.1em;
                gap: 8px;
                margin-top: 30px;
            }
            .error-message {
                padding: 15px;
                margin-top: 20px;
                gap: 10px;
                font-size: 0.9em;
            }
            .error-message i {
                font-size: 1.3em;
            }
            .back-link {
                margin-top: 20px;
                font-size: 0.9em;
            }
        }
    </style>
</head>
<body>
<%
 
    String errorMessage = null;

    try {
        String billIdParam = request.getParameter("bill_id");
        if (billIdParam == null || billIdParam.isEmpty()) {
            errorMessage = "Bill ID is missing. Cannot load bill details.";
        } else {
            billId = Integer.parseInt(billIdParam);

          
            try {
                conn = DBUtil.getConnection();
                stmt = conn.prepareStatement("SELECT customer_id, item_id, quantity, total_amount FROM bill WHERE bill_id = ?");
                stmt.setInt(1, billId);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    customerId = rs.getInt("customer_id");
                    itemId = rs.getInt("item_id");
                    quantity = rs.getInt("quantity");
                    totalAmount = rs.getDouble("total_amount");
                } else {
                    errorMessage = "Bill with ID " + billId + " not found.";
                }
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    } catch (NumberFormatException e) {
        errorMessage = "Invalid Bill ID format. It must be a number.";
        e.printStackTrace();
    } catch (Exception e) { // Catch any other exceptions
        errorMessage = "An unexpected error occurred while loading bill details: " + e.getMessage();
        e.printStackTrace();
    }

    // Fetch lists for dropdowns outside the main try-catch for bill details,
    // so they are available even if bill details fail to load.
  
    try {
        customers = new CustomerDAO().getAllCustomers();
        items = new ItemDAO().getAllItems();
    } catch (Exception e) {
        // Log this error, but don't prevent the form from showing if bill details loaded
        System.err.println("Error loading customers or items for dropdowns: " + e.getMessage());
        // Potentially add a specific error message for dropdowns if needed
    }
%>

<div class="form-container">
    <div class="page-header">
        <h2><i class='bx bxs-receipt header-icon'></i>Edit Bill</h2>
        <p class="subtitle">Update the details for Bill ID: **<%= billId != 0 ? billId : "N/A" %>**</p>
    </div>

    <% if (errorMessage != null) { %>
        <div class="error-message">
            <i class='bx bx-error-circle'></i> <%= errorMessage %>
        </div>
    <% } else { %>
        <form action="UpdateBillServlet" method="post">
            <input type="hidden" name="billId" value="<%= billId %>" />

            <label for="customerId">Customer:</label>
            <select name="customerId" id="customerId" required>
                <% if (customers.isEmpty()) { %>
                    <option value="" disabled>No customers available</option>
                <% } else { %>
                    <% for (Customer c : customers) { %>
                        <option value="<%= c.getCustomerId() %>" <%= (c.getCustomerId() == customerId ? "selected" : "") %>>
                            <%= c.getName() %>
                        </option>
                    <% } %>
                <% } %>
            </select>

            <label for="itemId">Item:</label>
            <select name="itemId" id="itemId" required>
                <% if (items.isEmpty()) { %>
                    <option value="" disabled>No items available</option>
                <% } else { %>
                    <% for (Item i : items) { %>
                        <option value="<%= i.getItemId() %>" <%= (i.getItemId() == itemId ? "selected" : "") %>>
                            <%= i.getItemName() %>
                        </option>
                    <% } %>
                <% } %>
            </select>

            <label for="quantity">Quantity:</label>
            <input type="number" name="quantity" id="quantity" value="<%= quantity %>" min="1" required />

            <label for="totalAmount">Total Amount (LKR):</label>
            <input type="number" name="totalAmount" id="totalAmount" step="0.01" value="<%= totalAmount %>" required />

            <button type="submit"><i class='bx bxs-save'></i>Update Bill</button>
        </form>
    <% } %>

    <a href="view-bills.jsp" class="back-link">
        <i class='bx bx-arrow-back'></i> Back to All Bills
    </a>
</div>
</body>
</html>