<%@ page import="java.sql.*, com.pahanaedu.util.DBUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String customerId = request.getParameter("id");
    if (customerId == null || customerId.trim().isEmpty()) {
        out.println("Invalid request. Customer ID is missing.");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String accNo = "", name = "", address = "", phone = "", username = "", email = "";

    try {
        conn = DBUtil.getConnection();
        ps = conn.prepareStatement("SELECT * FROM customer WHERE customer_id = ?");
        ps.setInt(1, Integer.parseInt(customerId));
        rs = ps.executeQuery();

        if (rs.next()) {
            accNo = rs.getString("account_number");
            name = rs.getString("name");
            address = rs.getString("address");
            phone = rs.getString("telephone");
            username = rs.getString("username");
            email = rs.getString("email");
        } else {
            out.println("Customer not found.");
            return;
        }

    } catch (Exception e) {
        out.println("Error fetching customer details: " + e.getMessage());
        return;
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Edit Customer</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
    <style>
        /* Your original full CSS starts here */
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
        input[type="password"],
        input[type="email"] {
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
        input[type="password"]:focus,
        input[type="email"]:focus {
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
            input[type="password"],
            input[type="email"] {
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
        }
    </style>
</head>
<body>

<div class="form-container">
    <div class="page-header">
        <h2><i class='bx bxs-user-detail header-icon'></i>Edit Customer</h2>
        <p class="subtitle">Update the details for Customer ID: **<%= customerId %>**</p>
    </div>

    <% String message = (String) request.getAttribute("message");
       if (message != null) { %>
        <div class="error-message">
            <i class='bx bx-error-circle'></i> <%= message %>
        </div>
    <% } %>

    <form action="update-customer" method="post">
        <input type="hidden" name="customer_id" value="<%= customerId %>" />

        <label for="accountNumber">Account Number</label>
        <input type="text" name="accountNumber" id="accountNumber" value="<%= accNo %>" required />

        <label for="name">Full Name</label>
        <input type="text" name="name" id="name" value="<%= name %>" required />

        <label for="address">Address</label>
        <input type="text" name="address" id="address" value="<%= address %>" required />

        <label for="telephone">Telephone</label>
        <input type="text" name="telephone" id="telephone" value="<%= phone %>" required />

        <label for="email">Email</label>
        <input type="email" name="email" id="email" value="<%= email %>" required />

        <label for="username">Username</label>
        <input type="text" name="username" id="username" value="<%= username %>" required />

        <label for="password">Password (leave blank to keep current)</label>
        <input type="password" name="password" id="password" value="" />

        <button type="submit"><i class='bx bxs-save'></i> Update Customer</button>
    </form>
</div>

</body>
</html>
