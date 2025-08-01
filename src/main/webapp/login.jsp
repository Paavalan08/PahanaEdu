<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Prevent caching of this page
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Redirect if user is already logged in
    if (session.getAttribute("username") != null) {
        String role = (String) session.getAttribute("role");
        if ("admin".equals(role)) {
            response.sendRedirect("admin-dashboard.jsp");
        } else if ("customer".equals(role)) {
            response.sendRedirect("customer-dashboard.jsp");
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pahana Edu - Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-blue-dark: #2c3e50;
            --primary-blue-light: #34495e;
            --accent-teal: #00cec9;
            --background-content: #ffffff;
            --text-dark: #333;
            --text-light: #fdfdfd;
            --border-light: #e8ecef;
            --input-focus-shadow: rgba(0, 206, 201, 0.25);
            --error-background: #ffebee;
            --error-border: #ef9a9a;
            --error-text: #c62828;
            --form-bg-opacity: 0.95;
            --form-shadow-strength: 0.15;
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
            background: linear-gradient(135deg, var(--primary-blue-dark), var(--primary-blue-light));
            background-image: url('images/bg.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            display: flex;
            justify-content: flex-start;
            align-items: center;
            min-height: 100vh;
            padding-left: 20%;
            position: relative;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.3);
            z-index: 0;
        }

        .container {
            position: relative;
            z-index: 1;
            max-width: 550px;
            background: rgba(255, 255, 255, var(--form-bg-opacity));
            border-radius: 16px;
            box-shadow: 0 15px 50px rgba(0, 0, 0, var(--form-shadow-strength));
            padding: 50px 40px;
            text-align: center;
            animation: fade-in 0.8s ease-out forwards;
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        h2 {
            color: var(--primary-blue-dark);
            margin-bottom: 30px;
            font-size: 2.5em;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .header-icon {
            font-size: 1.2em;
            color: var(--accent-teal);
        }

        label {
            display: block;
            text-align: left;
            margin-top: 20px;
            margin-bottom: 8px;
            color: #555;
            font-weight: 600;
        }

        input[type="text"],
        input[type="password"],
        select {
            width: 100%;
            padding: 14px 18px;
            margin-bottom: 20px;
            border: 1px solid var(--border-light);
            border-radius: 10px;
            font-size: 1em;
            background-color: #fcfcfc;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        input:focus,
        select:focus {
            border-color: var(--accent-teal);
            outline: none;
            box-shadow: 0 0 0 4px var(--input-focus-shadow);
            background-color: var(--background-content);
        }

        button {
            background: linear-gradient(45deg, #3498db, #2980b9);
            color: var(--text-light);
            padding: 16px 25px;
            border: none;
            border-radius: 50px;
            width: 100%;
            font-size: 1.15em;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
        }

        button:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(52, 152, 219, 0.5);
            background: linear-gradient(45deg, #2980b9, #3498db);
        }

        button:active {
            transform: translateY(0);
            box-shadow: 0 4px 10px rgba(52, 152, 219, 0.2);
        }

        .error-message {
            color: var(--error-text);
            background-color: var(--error-background);
            border: 1px solid var(--error-border);
            border-radius: 8px;
            padding: 12px 15px;
            text-align: center;
            margin-top: 25px;
            font-size: 0.9em;
            font-weight: 500;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            animation: fade-in 0.5s ease-out forwards;
            animation-delay: 0.8s;
        }

        .error-message i {
            font-size: 1.1em;
        }

        @media (max-width: 768px) {
            body {
                justify-content: center;
                padding-left: 0;
            }
            .container {
                max-width: 90%;
                padding: 30px 25px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h2><i class='bx bxs-user-circle header-icon'></i>Pahana Edu - Login</h2>
    <form action="login" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required autocomplete="username" />

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required autocomplete="current-password" />

        <label for="role">Login As:</label>
        <select id="role" name="role" required>
            <option value="admin">Admin</option>
            <option value="customer">Customer</option>
        </select>

        <button type="submit"><i class='bx bxs-log-in'></i>Login</button>
        <div class="link">
    Don't have an account? <a href="register.jsp">Register</a>
</div>


        <% String errorMessage = (String) request.getAttribute("error");
           if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <p class="error-message"><i class='bx bx-error-circle'></i> <%= errorMessage %></p>
        <% } %>
    </form>
</div>
</body>
</html>
