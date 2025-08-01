<%@ page import="java.sql.*, com.pahanaedu.util.DBUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View All Bills - Admin</title>
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
            --gradient-edit-start: #3498db;
            --gradient-edit-end: #2980b9;
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
            width: 95%;
            max-width: 1400px;
            margin: 40px auto;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            flex-wrap: wrap;
            gap: 20px;
        }

        .page-header h2 {
            color: var(--primary-blue-dark);
            font-size: 2.5em;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 15px;
        }

        .page-header .header-icon {
            font-size: 0.9em;
            color: var(--accent-teal);
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background-color: var(--background-content);
            box-shadow: 0 8px 30px var(--shadow-soft);
            border-radius: 16px;
            overflow: hidden;
        }

        th, td {
            padding: 20px 30px;
            text-align: left;
            border-bottom: 1px solid var(--border-light);
        }

        th {
            background-color: var(--primary-blue-dark);
            color: var(--text-light);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9em;
            letter-spacing: 0.8px;
        }

        tbody tr {
            opacity: 0;
            animation: row-fade-in 0.5s ease-out forwards;
        }

        <% for(int i=1; i<=20; i++) { %>
            tbody tr:nth-child(<%= i %>) { animation-delay: <%= i * 0.05 %>s; }
        <% } %>

        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 35px var(--shadow-lifted);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            z-index: 10;
            position: relative;
        }

        .action-buttons {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .button, .button-delete {
            padding: 10px 22px;
            text-decoration: none;
            border: none;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.9em;
            color: var(--text-light);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            justify-content: center;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            cursor: pointer;
        }

        .button i, .button-delete i { font-size: 1.1em; }

        .button {
            background: linear-gradient(45deg, var(--gradient-edit-start), var(--gradient-edit-end));
        }

        .button:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 20px rgba(52, 152, 219, 0.35);
        }

        .button-delete {
            background: linear-gradient(45deg, var(--gradient-delete-start), var(--gradient-delete-end));
        }

        .button-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 20px rgba(231, 76, 60, 0.35);
        }

        .no-records-message, .error-message {
            text-align: center;
            padding: 50px;
            font-size: 1.2em;
            font-style: italic;
            color: #7f8c8d;
        }

        .error-message {
            color: #e74c3c;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .container { width: 100%; margin: 20px auto; }
            .page-header { flex-direction: column; align-items: stretch; }
            .page-header h2 { font-size: 2em; }
            table, thead, tbody, th, td, tr { display: block; }
            thead { display: none; }
            tr {
                margin: 0 15px 20px 15px;
                border: 1px solid var(--border-light);
                border-top: 4px solid var(--accent-teal);
                border-radius: 10px;
                background-color: var(--background-content);
                box-shadow: 0 5px 20px var(--shadow-soft);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                overflow: hidden;
            }
            tr:hover { transform: translateY(-5px); box-shadow: 0 10px 25px var(--shadow-lifted); }
            td {
                border: none;
                border-bottom: 1px solid var(--border-light);
                position: relative;
                padding: 15px 20px 15px 45%;
                text-align: right;
                font-size: 0.95em;
            }
            td:last-child { border-bottom: 0; }
            td::before {
                content: attr(data-label);
                position: absolute;
                left: 20px;
                width: calc(45% - 30px);
                text-align: left;
                font-weight: 600;
                color: var(--primary-blue-dark);
            }
            .action-buttons {
                justify-content: flex-end;
                padding: 10px 0;
            }
        }
    </style>
</head>
<body>

<main class="container">
    <div class="page-header">
        <h2><i class='bx bxs-spreadsheet header-icon'></i>All Billing Records</h2>
    </div>

    <table>
        <thead>
            <tr>
                <th>Bill ID</th>
                <th>Account Number</th>
                <th>Item ID</th>
                <th>Quantity</th>
                <th>Total Amount (LKR)</th>
                <th>Bill Date</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;
                boolean hasRecords = false;

                try {
                    conn = DBUtil.getConnection();
                    String sql = "SELECT b.bill_id, c.account_number, b.item_id, b.quantity, b.total_amount, b.bill_date " +
                                 "FROM bill b " +
                                 "JOIN customer c ON b.customer_id = c.customer_id " +
                                 "ORDER BY b.bill_date DESC";
                    stmt = conn.prepareStatement(sql);
                    rs = stmt.executeQuery();

                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

                    while (rs.next()) {
                        hasRecords = true;
                        int billId = rs.getInt("bill_id");
                        String accountNumber = rs.getString("account_number");
                        int itemId = rs.getInt("item_id");
                        int quantity = rs.getInt("quantity");
                        double totalAmount = rs.getDouble("total_amount");
                        Timestamp billDate = rs.getTimestamp("bill_date");
            %>
            <tr>
                <td data-label="Bill ID"><%= billId %></td>
                <td data-label="Account Number"><%= accountNumber %></td>
                <td data-label="Item ID"><%= itemId %></td>
                <td data-label="Quantity"><%= quantity %></td>
                <td data-label="Total Amount (LKR)"><%= String.format("%,.2f", totalAmount) %></td>
                <td data-label="Bill Date"><%= sdf.format(billDate) %></td>
                <td data-label="Actions">
                    <div class="action-buttons">
                        <a class="button" href="edit-bill.jsp?bill_id=<%= billId %>"><i class='bx bxs-edit-alt'></i>Edit</a>
                        <a class="button-delete" href="DeleteBillServlet?bill_id=<%= billId %>" onclick="return confirm('Are you sure you want to delete bill ID: <%= billId %>?');"><i class='bx bxs-trash-alt'></i>Delete</a>
                    </div>
                </td>
            </tr>
            <%
                    }

                    if (!hasRecords) {
            %>
            <tr>
                <td colspan="7" class="no-records-message">No billing records found.</td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
            <tr>
                <td colspan="7" class="error-message">
                    <i class='bx bx-error-circle'></i> An error occurred while loading billing records. Please try again later.
                </td>
            </tr>
            <%
                } finally {
                    try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
        </tbody>
    </table>
</main>

</body>
</html>
