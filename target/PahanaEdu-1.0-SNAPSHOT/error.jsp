<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fbeaea;
            color: #b00020;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .error-container {
            padding: 30px;
            background-color: #fff3f3;
            border: 1px solid #e0b4b4;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(255, 0, 0, 0.1);
        }
        h1 {
            color: #b00020;
            margin-bottom: 10px;
        }
        p {
            font-size: 16px;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #fff;
            background-color: #b00020;
            padding: 10px 15px;
            border-radius: 5px;
        }
        a:hover {
            background-color: #d32f2f;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>❌ An Error Occurred</h1>
        <p><%= request.getParameter("msg") != null ? request.getParameter("msg") : "Something went wrong." %></p>
        <a href="javascript:history.back()">⬅️ Go Back</a>
    </div>
</body>
</html>
