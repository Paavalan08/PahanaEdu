<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register - Pahana Edu</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
    <style>
        :root {
            --primary: #2c3e50;
            --secondary: #34495e;
            --accent: #00cec9;
            --bg: #ffffff;
            --input-border: #ccc;
            --input-focus: rgba(0, 206, 201, 0.25);
            --error-color: #e74c3c;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px 60px;
            border-radius: 16px;
            width: 100%;
            max-width: 550px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(8px);
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: var(--primary);
            font-weight: 700;
        }

        label {
            display: block;
            margin: 15px 0 5px;
            font-weight: 600;
        }

        input {
            width: 100%;
            padding: 14px;
            border: 1px solid var(--input-border);
            border-radius: 8px;
            font-size: 1em;
            background: #f9f9f9;
        }

        input:focus {
            border-color: var(--accent);
            outline: none;
            background-color: #fff;
            box-shadow: 0 0 0 4px var(--input-focus);
        }

        button {
            width: 100%;
            margin-top: 25px;
            padding: 15px;
            background: linear-gradient(45deg, var(--accent), #00b894);
            color: white;
            font-size: 1.1em;
            font-weight: bold;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            transition: 0.3s ease;
        }

        button:hover {
            box-shadow: 0 10px 25px rgba(0, 206, 201, 0.5);
        }

        .link {
            margin-top: 20px;
            text-align: center;
        }

        .link a {
            color: var(--accent);
            text-decoration: none;
            font-weight: 600;
        }

        .link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <h2><i class='bx bxs-user-plus'></i> Customer Registration</h2>
<form action="register-customer" method="post">

        <label for="accountNumber">Account Number</label>
        <input type="text" id="accountNumber" name="accountNumber" required pattern="\d+" title="Only numbers allowed" />

        <label for="name">Full Name</label>
        <input type="text" id="name" name="name" required />

        <label for="address">Address</label>
        <input type="text" id="address" name="address" required />

        <label for="telephone">Telephone</label>
        <input type="text" id="telephone" name="telephone" required />

        <label for="email">Email</label>
        <input type="email" id="email" name="email" required />

        <label for="username">Username</label>
        <input type="text" id="username" name="username" required />

        <label for="password">Password</label>
        <input type="password" id="password" name="password"
       required
       pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}"
       title="At least 1 uppercase, 1 lowercase, 1 number, and 6 characters" />


        <button type="submit"><i class='bx bx-user-plus'></i> Register</button>

        <div class="link">
            Already have an account? <a href="login.jsp">Login</a>
        </div>

        <%-- SweetAlert feedback --%>
        <%
            String message = (String) request.getAttribute("message");
            if (message != null && !message.isEmpty()) {
                boolean isSuccess = message.startsWith("✅");
        %>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                Swal.fire({
                    icon: '<%= isSuccess ? "success" : "error" %>',
                    title: '<%= isSuccess ? "Registration Successful" : "Error" %>',
                    text: '<%= message.replace("✅", "").replace("❌", "").trim() %>',
                    confirmButtonColor: '<%= isSuccess ? "#00b894" : "#e74c3c" %>'
                }).then((result) => {
                    if (result.isConfirmed && <%= isSuccess %>) {
                        window.location.href = "login.jsp";
                    }
                });
            });
        </script>
        <%
            }
        %>

    </form>
</div>

</body>
</html>
