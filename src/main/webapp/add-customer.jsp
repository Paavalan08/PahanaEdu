<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Add New Customer</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
    <style>
        :root {
            --primary-accent-color: #00cec9; /* Vibrant Teal from admin panel */
            --secondary-dark-color: #2c3e50; /* Dark Blue from admin panel */
            --background-light-grey: #f0f2f5; /* Light grey from admin panel */
            --background-white: #ffffff;
            --text-dark: #34495e; /* Slightly softer dark text */
            --text-medium: #555; /* For labels */
            --border-light: #e0e0e0;
            --input-bg-focus: #eaf8f8; /* Very light teal for input focus background */
            --button-gradient-start: #00cec9;
            --button-gradient-end: #00b894;
            --shadow-light: rgba(0, 0, 0, 0.08);
            --shadow-medium: rgba(0, 0, 0, 0.15);
            --success-bg: #e6ffed; /* Softer success green background */
            --success-border: #b2dfdb; /* Border color derived from primary accent */
            --success-text: #1a7a40; /* Darker green text for readability */
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--background-light-grey);
            color: var(--text-dark);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 25px;
        }

        .container {
            width: 100%;
            max-width: 650px;
            background: var(--background-white);
            padding: 45px;
            border-radius: 16px;
            box-shadow: 0 12px 40px var(--shadow-medium);
            transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
        }

        .container:hover {
            transform: translateY(-7px);
            box-shadow: 0 18px 50px rgba(0, 0, 0, 0.2);
        }

        .form-header {
            text-align: center;
            margin-bottom: 40px;
            color: var(--secondary-dark-color);
            font-weight: 700;
            font-size: 2.2em;
            letter-spacing: -0.5px;
            position: relative;
            padding-bottom: 15px;
        }

        .form-header::after {
            content: '';
            position: absolute;
            left: 50%;
            bottom: 0;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(to right, var(--primary-accent-color), #4CAF50);
            border-radius: 2px;
        }

        .form-group {
            margin-bottom: 30px;
        }

        label {
            display: block;
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 0.98em;
            color: var(--text-medium);
            transition: color 0.2s ease;
        }

        input[type="text"],
        input[type="password"],
        input[type="email"] {
            width: 100%;
            padding: 15px;
            border: 1px solid var(--border-light);
            border-radius: 10px;
            font-family: 'Poppins', sans-serif;
            font-size: 1em;
            color: var(--text-dark);
            transition: border-color 0.3s, box-shadow 0.3s, background-color 0.3s;
            background-color: var(--background-white);
            box-shadow: inset 0 1px 3px var(--shadow-light);
        }

        input[type="text"]::placeholder,
        input[type="password"]::placeholder,
        input[type="email"]::placeholder {
            color: #a0a0a0;
            font-weight: 300;
        }

        input[type="text"]:focus,
        input[type="password"]:focus,
        input[type="email"]:focus {
            outline: none;
            border-color: var(--primary-accent-color);
            box-shadow: 0 0 0 5px rgba(0, 206, 201, 0.25), inset 0 1px 3px rgba(0, 0, 0, 0.1);
            background-color: var(--input-bg-focus);
        }

        button[type="submit"] {
            width: 100%;
            padding: 16px;
            background: linear-gradient(45deg, var(--button-gradient-start), var(--button-gradient-end));
            color: var(--background-white);
            border: none;
            border-radius: 10px;
            font-family: 'Poppins', sans-serif;
            font-size: 1.18em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            letter-spacing: 0.5px;
            box-shadow: 0 8px 20px rgba(0, 206, 201, 0.35);
        }

        button[type="submit"]:hover {
            transform: translateY(-4px) scale(1.01);
            box-shadow: 0 12px 25px rgba(0, 206, 201, 0.45);
            filter: brightness(1.1);
        }

        button[type="submit"]:active {
            transform: translateY(0);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            filter: brightness(1.0);
        }

        .success-message {
            margin-top: 35px;
            padding: 20px;
            background-color: var(--success-bg);
            border: 1px solid var(--success-border);
            color: var(--success-text);
            text-align: center;
            border-radius: 10px;
            font-size: 1.05em;
            font-weight: 500;
            line-height: 1.6;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .success-message i {
            font-size: 1.6em;
            color: var(--success-text);
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .container {
                padding: 30px;
                border-radius: 12px;
                max-width: 90%;
            }
            .form-header {
                font-size: 1.8em;
                margin-bottom: 30px;
            }
            input[type="text"],
            input[type="password"],
            input[type="email"] {
                padding: 12px;
                border-radius: 8px;
            }
            button[type="submit"] {
                padding: 14px;
                font-size: 1.1em;
                border-radius: 8px;
            }
            .success-message {
                padding: 15px;
                font-size: 0.95em;
                border-radius: 8px;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 15px;
            }
            .container {
                padding: 25px;
                border-radius: 10px;
            }
            .form-header {
                font-size: 1.5em;
                margin-bottom: 25px;
            }
            .form-group {
                margin-bottom: 20px;
            }
            label {
                font-size: 0.9em;
                margin-bottom: 8px;
            }
            input[type="text"],
            input[type="password"],
            input[type="email"] {
                padding: 10px;
                font-size: 0.9em;
            }
            button[type="submit"] {
                padding: 12px;
                font-size: 1em;
            }
            .success-message {
                font-size: 0.85em;
                padding: 12px;
            }
            .success-message i {
                font-size: 1.3em;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h2 class="form-header">Add New Customer</h2>
    <form action="add-customer" method="post">

        <div class="form-group">
            <label for="accountNumber">Account Number</label>
            <input
                type="text"
                id="accountNumber"
                name="accountNumber"
                placeholder="e.g., 1234567890"
                required
                pattern="\d+"
                title="Only numbers are allowed"
                oninput="this.value = this.value.replace(/[^0-9]/g, '')"
            />
        </div>

        <div class="form-group">
            <label for="name">Full Name</label>
            <input type="text" id="name" name="name" placeholder="e.g., Jane Doe" required />
        </div>

        <div class="form-group">
            <label for="address">Address</label>
            <input
                type="text"
                id="address"
                name="address"
                placeholder="e.g., 456 Oak Ave, City, Country"
                required
            />
        </div>

        <div class="form-group">
            <label for="telephone">Telephone</label>
            <input type="text" id="telephone" name="telephone" placeholder="e.g., +94 71 234 5678" required />
        </div>

        <div class="form-group">
            <label for="email">Email Address</label>
            <input
                type="email"
                id="email"
                name="email"
                placeholder="e.g., jane.doe@example.com"
                required
                pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                title="Enter a valid email address"
            />
        </div>

        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" placeholder="e.g., janedoe_customer" required />
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input
                type="password"
                id="password"
                name="password"
                placeholder="Enter a secure password"
                required
                pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}"
                title="Must contain at least one number, one uppercase and lowercase letter, and at least 6 or more characters"
            />
        </div>

        <button type="submit">Create Customer Account</button>

        <%-- Conditionally display the success or error message --%>
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
                    title: '<%= isSuccess ? "Success" : "Error" %>',
                    text: '<%= message.replace("✅", "").replace("❌", "").trim() %>',
                    confirmButtonColor: '<%= isSuccess ? "#00b894" : "#e74c3c" %>'
                }).then((result) => {
                    if (result.isConfirmed && <%= isSuccess %>) {
                        // Optionally clear the form or redirect
                        window.location.href = "add-customer.jsp";
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
