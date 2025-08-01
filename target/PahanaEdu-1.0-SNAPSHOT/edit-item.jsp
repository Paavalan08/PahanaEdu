<%@ page import="com.pahanaedu.dao.ItemDAO" %>
<%@ page import="com.pahanaedu.model.Item" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Edit Item</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
    <style>
        /* Your CSS here exactly as you wrote it */
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
        input[type="text"],
        input[type="number"] {
            width: 100%;
            padding: 14px 18px;
            border: 1px solid var(--border-light);
            border-radius: 10px;
            font-family: 'Inter', sans-serif;
            font-size: 1.05em;
            color: var(--text-dark);
            transition: border-color 0.3s ease, box-shadow 0.3s ease, background-color 0.3s ease;
            background-color: #fcfcfc;
        }
        input[type="text"]:focus,
        input[type="number"]:focus {
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
            input[type="text"],
            input[type="number"] {
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
    int itemId = -1;
    Item item = null;
    String errorMessage = null;

    try {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            errorMessage = "Item ID is missing. Cannot load item details.";
        } else {
            itemId = Integer.parseInt(idParam);
            item = ItemDAO.getItemById(itemId);
            if (item == null) {
                errorMessage = "Item with ID " + itemId + " not found.";
            }
        }
    } catch (NumberFormatException e) {
        errorMessage = "Invalid Item ID format. It must be a number.";
        e.printStackTrace();
    } catch (Exception e) {
        errorMessage = "An unexpected error occurred while loading item details: " + e.getMessage();
        e.printStackTrace();
    }
%>

<div class="form-container">
    <div class="page-header">
        <h2><i class='bx bxs-box header-icon'></i>Edit Item</h2>
        <p class="subtitle">Update the details for Item ID: <%= (itemId != -1 ? itemId : "N/A") %></p>
    </div>

    <% if (errorMessage != null) { %>
        <div class="error-message">
            <i class='bx bx-error-circle'></i> <%= errorMessage %>
        </div>
    <% } else { %>
        <form action="ItemServlet" method="post">
            <input type="hidden" name="action" value="update" />
            <input type="hidden" name="itemId" value="<%= item.getItemId() %>" />

            <label for="itemName">Item Name</label>
            <input type="text" id="itemName" name="itemName" value="<%= item.getItemName() %>" required />

            <label for="unitPrice">Unit Price (LKR)</label>
            <input type="number" step="0.01" id="unitPrice" name="unitPrice" value="<%= item.getUnitPrice() %>" required />

            <label for="stock">Current Stock</label>
            <input type="number" id="stock" name="stock" value="<%= item.getStock() %>" required />

            <button type="submit"><i class='bx bxs-save'></i> Update Item</button>
        </form>
    <% } %>

    <a href="item-list.jsp" class="back-link"><i class='bx bx-arrow-back'></i> Back to Item List</a>
</div>
</body>
</html>
