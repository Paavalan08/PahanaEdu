<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, com.pahanaedu.util.DBUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Manage Customers - PahanaEdu Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
    <style>
        :root {
            --primary-blue-dark: #2c3e50;
            --primary-blue-light: #34495e;
            --accent-teal: #00cec9;
            --background-body: #f4f7f9;
            --background-content: #ffffff;
            --text-dark: #333;
            --text-light: #fdfdfd;
            --border-light: #e8ecef;
            --shadow-soft: rgba(44, 62, 80, 0.1);
            --shadow-lifted: rgba(44, 62, 80, 0.15);
            --gradient-edit-start: #00cec9;
            --gradient-edit-end: #00b894;
            --gradient-delete-start: #e74c3c;
            --gradient-delete-end: #c0392b;
        }

        @keyframes row-fade-in {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--background-body);
            color: var(--text-dark);
            min-height: 100vh;
        }

        .container {
            width: 100%;
            max-width: 1500px; /* Set a max-width for better layout */
            margin: 40px auto;
            padding: 10px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .page-header h2 {
            color: var(--primary-blue-dark);
            font-size: 2.5em;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 15px;
        }

        .page-header i {
            font-size: 0.9em;
            color: var(--accent-teal);
        }

        /* NEW: Container for the table to handle scrolling */
        .table-container {
            width: 100%;
            max-width: 100%;
            overflow-x: auto; /* This is the key change for horizontal scroll */
            background-color: var(--background-content);
            box-shadow: 0 8px 30px var(--shadow-soft);
            border-radius: 16px;
            padding: 0;
        }
        
        table {
            width: 100%;
            min-width: 900px; /* Enforce a minimum width to trigger the scrollbar */
            border-collapse: separate;
            border-spacing: 0;
            background-color: transparent;
            overflow: hidden;
        }

        th, td {
            padding: 20px 25px;
            text-align: left;
            border-bottom: 1px solid var(--border-light);
            vertical-align: middle;
            word-break: break-word;
            white-space: nowrap; /* Prevent wrapping in desktop view */
        }
        
        th:last-child, td:last-child {
            white-space: nowrap; /* Keep action buttons from wrapping */
            text-align: right;
        }

        th {
            background-color: var(--primary-blue-dark);
            color: var(--text-light);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9em;
            letter-spacing: 0.8px;
            position: sticky; /* Keep header visible when scrolling */
            top: 0;
            z-index: 10;
        }

        tbody tr {
            opacity: 0;
            animation: row-fade-in 0.5s ease-out forwards;
        }

        <% for(int i=1; i<=10; i++) { %>
            tbody tr:nth-child(<%= i %>) { animation-delay: <%= i * 0.05 %>s; }
        <% } %>

        tbody tr:last-child td { border-bottom: none; }
        tbody tr:nth-child(even) { background-color: #fcfdfe; }

        tbody tr:hover {
            box-shadow: 0 12px 35px var(--shadow-lifted);
            transform: translateY(-4px);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
        }

        .action-buttons {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .button, .button-delete {
            padding: 12px 32px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.9em;
            color: var(--text-light);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .button {
            background: linear-gradient(45deg, var(--gradient-edit-start), var(--gradient-edit-end));
        }

        .button:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 20px rgba(0, 206, 201, 0.35);
        }

        .button-delete {
            background: linear-gradient(45deg, var(--gradient-delete-start), var(--gradient-delete-end));
        }

        .button-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 20px rgba(231, 76, 60, 0.35);
        }

        .no-customers-message, .error-message {
            text-align: center;
            padding: 50px;
            font-size: 1.2em;
        }

        .no-customers-message {
            font-style: italic;
            color: #7f8c8d;
        }

        .error-message {
            color: var(--gradient-delete-start);
            background-color: rgba(231, 76, 60, 0.05);
            font-weight: 500;
        }

        @media (max-width: 768px) {
            .container { width: 100%; margin: 20px auto; }
            .table-container { 
                overflow-x: auto; /* Make sure the scrollbar is active on mobile */
                box-shadow: none; /* Remove shadow to avoid clipping issues */
                border-radius: 0;
            }
            table {
                min-width: unset; /* Let the table shrink on mobile */
            }
            table, thead, tbody, th, td, tr { display: block; }
            thead { display: none; }
            tr {
                margin: 15px;
                border: 1px solid var(--border-light);
                border-top: 4px solid var(--accent-teal);
                border-radius: 10px;
                background-color: var(--background-content);
                box-shadow: 0 5px 20px var(--shadow-soft);
            }
            td {
                padding: 15px 20px 15px 45%;
                text-align: right;
                border-bottom: 1px solid var(--border-light);
                position: relative;
                font-size: 0.95em;
                word-break: break-word;
                white-space: normal; /* Allow text to wrap on mobile */
            }
            td::before {
                content: attr(data-label);
                position: absolute;
                left: 20px;
                font-weight: 600;
                color: var(--primary-blue-dark);
                text-align: left;
                width: calc(45% - 30px);
            }
            .action-buttons {
                justify-content: flex-end;
                padding: 10px 0;
            }
            th:last-child, td:last-child {
                text-align: right;
            }
        }
    </style>
</head>
<body>
    <main class="container">
        <div class="page-header">
            <h2><i class='bx bxs-group'></i>Manage Customers</h2>
        </div>

        <div class="table-container"> <table>
                <thead>
                    <tr>
                        <th>Account No</th>
                        <th>Name</th>
                        <th>Address</th>
                        <th>Phone</th>
                        <th>Email</th>
                        <th>Username</th>
                        <th>Password</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        boolean hasCustomers = false;

                        try {
                            conn = DBUtil.getConnection();
                            String query = "SELECT customer_id, account_number, name, address, telephone, email, username, password FROM customer ORDER BY name ASC";
                            ps = conn.prepareStatement(query);
                            rs = ps.executeQuery();

                            while (rs.next()) {
                                hasCustomers = true;
                    %>
                        <tr>
                            <td data-label="Account No"><%= rs.getString("account_number") %></td>
                            <td data-label="Name"><%= rs.getString("name") %></td>
                            <td data-label="Address"><%= rs.getString("address") %></td>
                            <td data-label="Phone"><%= rs.getString("telephone") %></td>
                            <td data-label="Email"><%= rs.getString("email") %></td>
                            <td data-label="Username"><%= rs.getString("username") %></td>
                            <td data-label="Password"><%= rs.getString("password") %></td>
                            <td data-label="Action">
                                <div class="action-buttons">
                                    <a class="button" href="edit-customer.jsp?id=<%= rs.getInt("customer_id") %>"><i class='bx bxs-edit-alt'></i>Edit</a>
                                    <a class="button-delete" href="DeleteCustomerServlet?id=<%= rs.getInt("customer_id") %>" onclick="return confirm('Are you sure you want to delete this customer?');"><i class='bx bxs-trash-alt'></i>Delete</a>
                                </div>
                            </td>
                        </tr>
                    <%
                            }

                            if (!hasCustomers) {
                    %>
                        <tr>
                            <td colspan="8" class="no-customers-message">No customers found in the database.</td>
                        </tr>
                    <%
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                    %>
                        <tr>
                            <td colspan="8" class="error-message">Error: Could not load customer list. Please check server logs.</td>
                        </tr>
                    <%
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                            if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
                            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                        }
                    %>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>