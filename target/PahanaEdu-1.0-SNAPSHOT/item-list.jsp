<%@ page import="java.util.List" %>
<%@ page import="com.pahanaedu.model.Item" %>
<%@ page import="com.pahanaedu.dao.ItemDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    List<Item> items = ItemDAO.getAllItems();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Items - Admin</title>
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

        .add-new-button {
            background: linear-gradient(45deg, var(--accent-teal), var(--accent-green));
            color: var(--text-light);
            padding: 12px 25px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(0, 206, 201, 0.25);
            transition: all 0.3s ease;
        }

        .add-new-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 7px 20px rgba(0, 206, 201, 0.4);
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

        <% for(int i=1; i<=10; i++) { %>
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

        .no-items-message {
            text-align: center;
            padding: 50px;
            font-size: 1.2em;
            font-style: italic;
            color: #7f8c8d;
        }

        @media (max-width: 768px) {
            .container { width: 100%; margin: 20px auto; }
            .page-header { flex-direction: column; align-items: stretch; }
            .page-header h2 { font-size: 2em; }
            .add-new-button { justify-content: center; }
            table, thead, tbody, th, td, tr { display: block; }
            table { box-shadow: none; background: none; border-radius: 0; }
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
        <h2><i class='bx bxs-package header-icon'></i>Manage Items</h2>
        <a href="add-item.jsp" class="add-new-button"><i class='bx bx-plus'></i>Add New Item</a>
    </div>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Price (LKR)</th>
                <th>Stock</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                if (items == null || items.isEmpty()) {
            %>
                <tr>
                    <td colspan="5" class="no-items-message">
                        No items found. Click 'Add New Item' to get started.
                    </td>
                </tr>
            <%
                } else {
                    for (Item item : items) {
            %>
                <tr>
                    <td data-label="ID"><%= item.getItemId() %></td>
                    <td data-label="Name"><%= item.getItemName() %></td>
                    <td data-label="Price (LKR)"><%= String.format("%,.2f", item.getUnitPrice()) %></td>
                    <td data-label="Stock"><%= item.getStock() %></td>
                    <td data-label="Actions">
                        <div class="action-buttons">
                            <a class="button" href="edit-item.jsp?id=<%= item.getItemId() %>"><i class='bx bxs-edit-alt'></i>Edit</a>
                            <a class="button-delete" href="item?action=delete&id=<%= item.getItemId() %>" onclick="return confirm('Are you sure you want to delete this item?');"><i class='bx bxs-trash-alt'></i>Delete</a>
                        </div>
                    </td>
                </tr>
            <%
                    }
                }
            %>
        </tbody>
    </table>
</main>
</body>
</html>
