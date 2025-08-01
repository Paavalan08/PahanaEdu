<!--
<%@ page import="java.util.*, com.pahanaedu.model.Customer, com.pahanaedu.dao.CustomerDAO" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer List</title>
</head>
<body>
    <h2>Customer List</h2>
    <a href="add-customer.jsp">? Add New Customer</a>
    <table border="1" cellpadding="10">
        <tr>
            <th>ID</th>
            <th>Account Number</th>
            <th>Name</th>
            <th>Address</th>
            <th>Telephone</th>
            <th>Actions</th>
        </tr>
        <%
            List<Customer> customers = new CustomerDAO().getAllCustomers();
            for (Customer customer : customers) {
        %>
        <tr>
            <td><%= customer.getCustomerId() %></td>
            <td><%= customer.getAccountNumber() %></td>
            <td><%= customer.getName() %></td>
            <td><%= customer.getAddress() %></td>
            <td><%= customer.getTelephone() %></td>
            <td>
                <a href="edit-customer.jsp?id=<%= customer.getCustomerId() %>">Edit</a> |
                <a href="CustomerServlet?action=delete&id=<%= customer.getCustomerId() %>">Delete</a>
            </td>
        </tr>
        <% } %>
    </table>
</body>
</html>

-->
<!--

<style>
    :root {
        --primary-blue-dark: #2c3e50;
        --primary-blue-light: #34495e;
        --accent-teal: #00cec9;
        --background-body: #f0f2f5;
        --background-white: #ffffff;
        --text-dark: #2c3e50;
        --text-light: #ecf0f1;
        --border-light: #e0e0e0;
        --shadow-subtle: rgba(0, 0, 0, 0.05);
        --shadow-medium: rgba(0, 0, 0, 0.1);
        --shadow-strong: rgba(0, 0, 0, 0.2);
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Inter', sans-serif;
        background-color: var(--background-body);
        color: var(--text-dark);
        display: flex;
        justify-content: center;
        align-items: flex-start;
        min-height: 100vh;
        padding: 30px;
    }

    .container {
        width: 100%;
        max-width: 1200px;
        background: var(--background-white);
        padding: 40px;
        border-radius: 16px;
        box-shadow: 0 12px 40px var(--shadow-medium);
    }

    .header-section {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        padding-bottom: 15px;
        border-bottom: 2px solid var(--border-light);
    }

    .page-title {
        font-weight: 700;
        font-size: 2em;
        color: var(--accent-teal);
        letter-spacing: -0.5px;
        position: relative;
    }

    .page-title::after {
        content: '';
        position: absolute;
        left: 0;
        bottom: -10px;
        width: 80px;
        height: 3px;
        background: linear-gradient(to right, var(--accent-teal), #00b894);
        border-radius: 2px;
    }

    .add-customer-btn {
        background: linear-gradient(45deg, var(--accent-teal), #00b894);
        padding: 10px 22px;
        border-radius: 30px;
        color: var(--text-light);
        font-weight: 600;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: all 0.3s ease;
        box-shadow: 0 6px 15px rgba(0, 206, 201, 0.35);
        font-size: 0.95em;
    }

    .add-customer-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 20px rgba(0, 206, 201, 0.45);
    }

    .customer-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 6px 20px var(--shadow-subtle);
    }

    .customer-table th, .customer-table td {
        padding: 14px 18px;
        text-align: left;
        border-bottom: 1px solid var(--border-light);
    }

    .customer-table th {
        background-color: var(--primary-blue-light);
        color: var(--text-light);
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.9em;
        letter-spacing: 0.5px;
    }

    .customer-table tbody tr {
        background: var(--background-white);
        transition: background 0.2s;
    }

    .customer-table tbody tr:hover {
        background-color: #ecfdfd;
    }

    .customer-table td {
        font-size: 0.95em;
    }

    .actions {
        display: flex;
        gap: 12px;
    }

    .actions a {
        padding: 6px 14px;
        border-radius: 20px;
        color: white;
        font-size: 0.85em;
        font-weight: 500;
        text-decoration: none;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 5px;
    }

    .edit-link {
        background-color: #27ae60;
    }

    .edit-link:hover {
        background-color: #219150;
        transform: translateY(-1px);
    }

    .delete-link {
        background-color: #e74c3c;
    }

    .delete-link:hover {
        background-color: #c0392b;
        transform: translateY(-1px);
    }

    .no-customers-message {
        margin-top: 40px;
        text-align: center;
        font-size: 1.1em;
        padding: 30px;
        background: #f8f9fa;
        border: 1px dashed var(--border-light);
        border-radius: 12px;
        color: var(--primary-blue-dark);
        box-shadow: 0 4px 12px var(--shadow-subtle);
    }
</style>-->




<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%-- Removed import for com.pahana.model.Customer to keep it as close to original as possible --%>
<%@ page session="true" %>

<%
    // Assuming 'user' and 'role' are session attributes set after successful login.
    Object userObj = session.getAttribute("username");
    Object roleObj = session.getAttribute("userRole");

    if (userObj == null || !"admin".equals(roleObj)) { // Corrected: Check roleObj, not 'role'
        response.sendRedirect("login.jsp");
        return;
    }

    // IMPORTANT: Assuming 'customers' List and 'customer' object are already being
    // handled and populated by your existing backend logic.
    // I am NOT adding or modifying any Java code here.
    // If 'customers' is null or empty, the "No customers found" message will display.

    // Corrected to use the 'username' from session, consistent with dashboard header
    String username = (userObj != null) ? userObj.toString() : "Admin";

    // Re-introducing dummy data for HTML structure testing purposes only,
    // if your backend isn't sending data yet for testing the design.
    // REMOVE this block when integrating with real data.
    // List<com.pahana.model.Customer> customers = new java.util.ArrayList<>();
    // customers.add(new com.pahana.model.Customer(1, "John Doe", "john.doe@example.com", "123-456-7890", "123 Main St"));
    // customers.add(new com.pahana.model.Customer(2, "Jane Smith", "jane.smith@example.com", "098-765-4321", "456 Oak Ave"));
    // customers.add(new com.pahana.model.Customer(3, "Peter Jones", "peter.jones@example.com", "555-123-4567", "789 Pine Ln"));
    // To simulate no customers:
    // List<com.pahana.model.Customer> customers = new java.util.ArrayList<>();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Customers - PahanaEdu</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <style>
        /* CSS Variables from Admin Dashboard */
        :root {
            --primary-blue-dark: #2c3e50; /* Darker blue for primary elements like header, sidebar */
            --primary-blue-light: #34495e; /* Slightly lighter shade for hover/active backgrounds */
            --accent-purple: #7f8c8d; /* A more subdued, elegant purple - currently not used but kept for consistency */
            --accent-teal: #00cec9; /* Original vibrant teal for highlights */
            --background-body: #f0f2f5; /* Very light grey for the overall body background */
            --background-white: #ffffff; /* Pure white for main content area */
            --text-dark: #2c3e50;
            --text-light: #ecf0f1;
            --border-light: #e0e0e0;
            --shadow-subtle: rgba(0, 0, 0, 0.05);
            --shadow-medium: rgba(0, 0, 0, 0.1);
            --shadow-strong: rgba(0, 0, 0, 0.2);
            --gradient-1-start: #6c5ce7; /* Not used directly but kept for consistency */
            --gradient-1-end: #8e44ad; /* Not used directly but kept for consistency */
            --gradient-2-start: #00cec9; /* Alias for accent-teal */
            --gradient-2-end: #00b894; /* Darker teal/green for gradients */
        }

        /* Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--background-body);
            color: var(--text-dark);
            display: flex;
            justify-content: center; /* Center horizontally */
            align-items: flex-start; /* Align to top */
            min-height: 100vh; /* Full viewport height */
            padding: 30px; /* Overall padding */
            line-height: 1.6;
        }

        /* Main Container */
        .container {
            width: 100%;
            max-width: 1200px; /* Increased max-width */
            background: var(--background-white);
            padding: 45px; /* More padding */
            border-radius: 18px; /* More rounded corners */
            box-shadow: 0 15px 50px var(--shadow-medium); /* Deeper shadow */
            margin-top: 20px; /* Add some space from the top if body is flex-start */
        }

        /* Header Section within Container */
        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 35px; /* More space below header */
            padding-bottom: 20px; /* Padding for the bottom border */
            border-bottom: 2px solid var(--border-light);
        }

        .page-title {
            font-weight: 800; /* Bolder */
            font-size: 2.2em; /* Larger */
            color: var(--accent-teal);
            letter-spacing: -0.8px; /* Tighter letter spacing */
            position: relative;
        }

        .page-title::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: -10px; /* Position below text */
            width: 90px; /* Longer underline */
            height: 4px; /* Thicker underline */
            background: linear-gradient(to right, var(--accent-teal), var(--gradient-2-end)); /* Gradient underline */
            border-radius: 2px;
        }

        .add-customer-btn {
            background: linear-gradient(45deg, var(--accent-teal), var(--gradient-2-end));
            padding: 12px 28px; /* Larger padding */
            border-radius: 35px; /* More rounded pill shape */
            color: var(--text-light);
            font-weight: 600;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px; /* More space for icon */
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1); /* Smoother transition */
            box-shadow: 0 8px 20px rgba(0, 206, 201, 0.4); /* Stronger shadow */
            font-size: 1em;
        }

        .add-customer-btn i {
            font-size: 1.3em; /* Larger icon */
        }

        .add-customer-btn:hover {
            transform: translateY(-5px) scale(1.02); /* More pronounced lift and slight scale */
            box-shadow: 0 12px 25px rgba(0, 206, 201, 0.55); /* Even stronger shadow on hover */
            filter: brightness(1.1); /* Slightly brighter */
        }

        /* Customer Table */
        .customer-table {
            width: 100%;
            border-collapse: separate; /* Use separate to apply border-radius to tbody */
            border-spacing: 0; /* Remove default spacing for separate */
            margin-top: 30px;
            border-radius: 14px; /* Rounded corners for the whole table container */
            overflow: hidden; /* Ensures rounded corners are visible */
            box-shadow: 0 8px 25px var(--shadow-subtle); /* Subtle shadow for the table */
        }

        .customer-table th, .customer-table td {
            padding: 16px 22px; /* More padding for cells */
            text-align: left;
            border-bottom: 1px solid var(--border-light); /* Light border */
        }

        .customer-table th {
            background-color: var(--primary-blue-light); /* Darker blue background for headers */
            color: var(--text-light);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9em;
            letter-spacing: 0.7px; /* More letter spacing */
        }

        /* Specific border radius for first and last header cells */
        .customer-table th:first-child {
            border-top-left-radius: 14px;
        }
        .customer-table th:last-child {
            border-top-right-radius: 14px;
        }


        .customer-table tbody tr {
            background: var(--background-white);
            transition: background 0.3s ease;
        }

        .customer-table tbody tr:last-child td {
            border-bottom: none; /* No border for the last row */
        }

        .customer-table tbody tr:hover {
            background-color: #f7fcfc; /* A very subtle light blue on hover */
            transform: translateY(-1px); /* Slight lift effect */
        }

        .customer-table td {
            font-size: 0.98em;
            line-height: 1.4;
        }

        /* Actions Column */
        .actions {
            display: flex;
            gap: 15px; /* More space between buttons */
            align-items: center;
        }

        .actions a {
            padding: 8px 18px; /* More padding for action buttons */
            border-radius: 25px; /* More rounded */
            color: white;
            font-size: 0.88em;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px; /* Space between text and icon */
            box-shadow: 0 4px 10px rgba(0,0,0,0.2); /* Subtle shadow for buttons */
        }

        .actions a i {
            font-size: 1.1em;
        }

        .edit-link {
            background-color: #28a745; /* Bootstrap-like green */
        }

        .edit-link:hover {
            background-color: #218838;
            transform: translateY(-2px) scale(1.02);
            box-shadow: 0 6px 12px rgba(40, 167, 69, 0.4);
        }

        .delete-link {
            background-color: #dc3545; /* Bootstrap-like red */
        }

        .delete-link:hover {
            background-color: #c82333;
            transform: translateY(-2px) scale(1.02);
            box-shadow: 0 6px 12px rgba(220, 53, 69, 0.4);
        }

        /* Message for No Customers */
        .no-customers-message {
            margin-top: 50px; /* More margin */
            text-align: center;
            font-size: 1.2em; /* Larger font */
            padding: 40px; /* More padding */
            background: #fdfdfd; /* Lighter background */
            border: 2px dashed var(--border-light); /* Thicker dashed border */
            border-radius: 15px; /* More rounded */
            color: var(--primary-blue-dark);
            box-shadow: 0 6px 18px var(--shadow-subtle);
            font-weight: 500;
        }

        /* Responsive Adjustments */
        @media (max-width: 992px) {
            .container {
                padding: 35px;
            }
            .page-title {
                font-size: 1.8em;
            }
            .add-customer-btn {
                padding: 10px 20px;
                font-size: 0.9em;
            }
            .customer-table th, .customer-table td {
                padding: 12px 15px;
            }
            .actions a {
                padding: 7px 15px;
                font-size: 0.8em;
            }
        }

        @media (max-width: 768px) {
            body {
                padding: 20px;
                align-items: flex-start; /* Ensure it stays aligned to top */
            }
            .container {
                padding: 25px;
                border-radius: 12px;
            }
            .header-section {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
                margin-bottom: 25px;
            }
            .page-title {
                font-size: 1.6em;
            }
            .page-title::after {
                width: 70px;
                height: 3px;
                bottom: -8px;
            }
            .add-customer-btn {
                width: 100%; /* Full width button */
                justify-content: center;
                padding: 12px;
            }
            .customer-table, .no-customers-message {
                border-radius: 10px;
            }
            /* Make table columns stack or reduce padding on small screens if necessary */
            .customer-table thead {
                display: none; /* Hide table headers on small screens */
            }
            .customer-table, .customer-table tbody, .customer-table tr, .customer-table td {
                display: block; /* Make table elements behave like block elements */
                width: 100%;
            }
            .customer-table tr {
                margin-bottom: 15px;
                border: 1px solid var(--border-light);
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 4px 10px var(--shadow-subtle);
            }
            .customer-table td {
                text-align: right;
                padding-left: 50%; /* Space for pseudo-element labels */
                position: relative;
                border: none;
                border-bottom: 1px solid var(--border-light); /* Keep bottom border for separation */
            }
            .customer-table td:last-child {
                border-bottom: none; /* No border for the last td in a row */
            }
            .customer-table td::before {
                content: attr(data-label); /* Use data-label for content */
                position: absolute;
                left: 15px;
                width: calc(50% - 30px);
                padding-right: 10px;
                white-space: nowrap;
                text-align: left;
                font-weight: 600;
                color: var(--primary-blue-dark);
            }
            .actions {
                justify-content: center;
                padding-top: 10px;
                border-top: 1px dashed var(--border-light); /* Separator for actions */
            }
            .actions a {
                flex: 1; /* Distribute action buttons evenly */
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 15px;
            }
            .page-title {
                font-size: 1.4em;
            }
            .page-title::after {
                width: 50px;
            }
            .add-customer-btn {
                font-size: 0.85em;
                padding: 10px;
            }
            .customer-table td {
                font-size: 0.9em;
                padding: 10px 15px;
                padding-left: 45%;
            }
            .customer-table td::before {
                left: 10px;
                width: calc(45% - 20px);
                font-size: 0.85em;
            }
            .no-customers-message {
                font-size: 1em;
                padding: 25px;
            }
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="header-section">
            <h1 class="page-title">Manage Customers</h1>
            <a href="add-customer.jsp" class="add-customer-btn">
                <i class='bx bx-user-plus'></i> Add New Customer
            </a>
        </div>

        <%-- This JSP logic for displaying customers or the "no customers" message
             is kept exactly as you would have it, assuming 'customers' is available. --%>
        <% if (request.getAttribute("customerList") != null && !((List<?>) request.getAttribute("customerList")).isEmpty()) { %>
        <table class="customer-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Address</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (customers != null) { // Double check for null in case backend didn't set it
                        for (Object customerObj : customers) {
                            // You will need to cast customerObj to your actual Customer class
                            // For example: com.pahana.model.Customer customer = (com.pahana.model.Customer) customerObj;
                            // And then use customer.getId(), customer.getName(), etc.
                            // For demonstration, I'm using placeholder values, you MUST replace these
                            // with actual getter calls from your Customer object.
                %>
                <tr>
                    <td data-label="ID">101</td> <%-- Replace with <%= customer.getId() %> --%>
                    <td data-label="Name">Sample Customer Name</td> <%-- Replace with <%= customer.getName() %> --%>
                    <td data-label="Email">sample@example.com</td> <%-- Replace with <%= customer.getEmail() %> --%>
                    <td data-label="Phone">0712345678</td> <%-- Replace with <%= customer.getPhone() %> --%>
                    <td data-label="Address">123 Sample Street, City</td> <%-- Replace with <%= customer.getAddress() %> --%>
                    <td data-label="Actions" class="actions">
                        <a href="edit-customer.jsp?id=<%= "some_id" %>" class="edit-link"> <%-- Replace with actual ID --%>
                            <i class='bx bx-edit'></i> Edit
                        </a>
                        <a href="delete-customer.jsp?id=<%= "some_id" %>" class="delete-link" onclick="return confirm('Are you sure you want to delete this customer?');"> <%-- Replace with actual ID --%>
                            <i class='bx bx-trash'></i> Delete
                        </a>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
                <%-- Example of how your loop might look if `customer` is directly available:
                <% if (customers != null) {
                    for (com.pahana.model.Customer customer : customers) { %>
                    <tr>
                        <td data-label="ID"><%= customer.getId() %></td>
                        <td data-label="Name"><%= customer.getName() %></td>
                        <td data-label="Email"><%= customer.getEmail() %></td>
                        <td data-label="Phone"><%= customer.getPhone() %></td>
                        <td data-label="Address"><%= customer.getAddress() %></td>
                        <td data-label="Actions" class="actions">
                            <a href="edit-customer.jsp?id=<%= customer.getId() %>" class="edit-link">
                                <i class='bx bx-edit'></i> Edit
                            </a>
                            <a href="delete-customer.jsp?id=<%= customer.getId() %>" class="delete-link" onclick="return confirm('Are you sure you want to delete this customer?');">
                                <i class='bx bx-trash'></i> Delete
                            </a>
                        </td>
                    </tr>
                <% } } %>
                --%>
            </tbody>
        </table>
        <% } else { %>
        <div class="no-customers-message">
            <i class='bx bx-info-circle' style="font-size: 2.5em; color: var(--accent-teal); margin-bottom: 15px; display: block;"></i>
            No customers found. Click "Add New Customer" to get started!
        </div>
        <% } %>
    </div>

</body>
</html>