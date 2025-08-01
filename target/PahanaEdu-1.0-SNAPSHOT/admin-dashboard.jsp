<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>
    <%
        // --- Session and Role Check ---
        String user = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");
        if (user == null || !"admin".equals(role)) {
            response.sendRedirect("login.jsp");
            return; // Important to stop further processing
        }
    %>


    <%@ page contentType="text/html;charset=UTF-8" %>
    <%@ page session="true" %>
    <%
        // Assuming 'user' and 'role' are session attributes set after successful login.
        Object userObj = session.getAttribute("username");
        Object roleObj = session.getAttribute("userRole");

        if (userObj == null || !"admin".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>PahanaEdu Admin Panel</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-blue-dark: #2c3e50; /* Darker blue for primary elements like header, sidebar */
                --primary-blue-light: #34495e; /* Slightly lighter shade for hover/active backgrounds */
                --accent-purple: #7f8c8d; /* A more subdued, elegant purple */
                --accent-teal: #00cec9; /* Original vibrant teal for highlights */
                --background-body: #f0f2f5; /* Very light grey for the overall body background */
                --background-content: #ffffff; /* Pure white for main content area */
                --text-dark: #2c3e50;
                --text-light: #ecf0f1;
                --border-light: #e0e0e0;
                --shadow-subtle: rgba(0, 0, 0, 0.05);
                --shadow-medium: rgba(0, 0, 0, 0.1);
                --shadow-strong: rgba(0, 0, 0, 0.2);
                --gradient-1-start: #6c5ce7;
                --gradient-1-end: #8e44ad;
                --gradient-2-start: #00cec9;
                --gradient-2-end: #00b894;
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
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                overflow-x: hidden;
            }

            /* Header Styling */
            header {
                background: var(--primary-blue-dark);
                color: var(--text-light);
                padding: 18px 40px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                box-shadow: 0 4px 20px var(--shadow-strong);
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            .header-left {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .logo {
                font-size: 1.9em;
                font-weight: 800;
                color: var(--accent-teal);
                letter-spacing: -0.5px;
                text-shadow: 0 2px 5px rgba(0,0,0,0.3);
            }

            .welcome {
                font-size: 1.15em;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .welcome i {
                color: var(--accent-teal);
                font-size: 1.3em;
            }

            .welcome span {
                color: var(--accent-teal);
                font-weight: 600;
            }

            .logout-btn {
                background: linear-gradient(45deg, var(--gradient-2-start), var(--gradient-2-end));
                padding: 10px 24px;
                border-radius: 28px;
                color: var(--text-light);
                font-weight: 600;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1); /* More pleasing animation */
                box-shadow: 0 6px 15px rgba(0, 206, 201, 0.4);
            }

            .logout-btn:hover {
                transform: translateY(-4px) scale(1.02);
                box-shadow: 0 10px 20px rgba(0, 206, 201, 0.5);
                filter: brightness(1.15);
            }

            /* Main Container Layout */
            .container {
                display: flex;
                flex: 1;
                padding: 20px; /* Overall padding for the content area */
                gap: 20px; /* Space between sidebar and main content */
            }

            /* Sidebar Styling */
            .sidebar {
                width: 280px;
                background: var(--primary-blue-dark);
                border-radius: 12px; /* Rounded corners for the sidebar */
                padding: 25px 0;
                display: flex;
                flex-direction: column;
                box-shadow: 0 6px 20px var(--shadow-medium);
                flex-shrink: 0;
                overflow: hidden; /* For rounded corners */
            }

            .sidebar a {
                color: var(--text-light);
                padding: 18px 35px;
                font-weight: 500;
                font-size: 1rem;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 18px;
                transition: all 0.3s ease;
                position: relative; /* For the active indicator */
                overflow: hidden; /* For hover effect */
            }

            .sidebar a::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 5px;
                height: 100%;
                background: var(--accent-teal);
                transform: translateX(-100%);
                transition: transform 0.3s ease;
                border-top-right-radius: 4px;
                border-bottom-right-radius: 4px;
            }

            .sidebar a:hover {
                background-color: var(--primary-blue-light);
                transform: translateX(3px); /* Subtle shift on hover */
            }

            .sidebar a.active {
                background-color: var(--primary-blue-light);
                color: var(--accent-teal);
                font-weight: 600;
            }

            .sidebar a.active::before {
                transform: translateX(0); /* Show indicator on active */
            }

            .sidebar a i {
                font-size: 1.4em;
                color: var(--text-light); /* Default icon color */
                transition: color 0.3s ease;
            }

            .sidebar a.active i,
            .sidebar a:hover i {
                color: var(--accent-teal); /* Active/hover icon color */
            }

            /* Main Content Styling */
            .main-content {
                flex: 1;
                background: var(--background-content);
                border-radius: 12px; /* Rounded corners for main content */
                box-shadow: 0 6px 20px var(--shadow-medium);
                overflow: hidden; /* For rounded corners of the iframe inside */
            }

            iframe {
                width: 100%;
                height: 100%; /* Make iframe fill the main-content area */
                border: none; /* No border needed as parent has rounded corners/shadow */
                background-color: var(--background-content);
            }

            /* Footer Styling */
            footer {
                background: var(--primary-blue-dark);
                text-align: center;
                padding: 20px 0;
                font-size: 0.9em;
                color: var(--text-light);
                box-shadow: 0 -4px 15px var(--shadow-strong);
                font-weight: 300;
                letter-spacing: 0.5px;
            }

            /* Responsive Design */
            @media (max-width: 992px) {
                header {
                    padding: 15px 30px;
                }
                .logo {
                    font-size: 1.7em;
                }
                .welcome {
                    font-size: 1em;
                    gap: 5px;
                }
                .welcome i {
                    font-size: 1.2em;
                }
                .logout-btn {
                    padding: 8px 20px;
                    font-size: 0.9em;
                }
                .container {
                    padding: 15px;
                    gap: 15px;
                }
                .sidebar {
                    width: 250px;
                    padding: 20px 0;
                }
                .sidebar a {
                    padding: 16px 30px;
                    font-size: 0.95rem;
                    gap: 15px;
                }
                .sidebar a i {
                    font-size: 1.3em;
                }
            }

            @media (max-width: 768px) {
                .container {
                    flex-direction: column;
                    padding: 10px;
                    gap: 10px;
                }
                .sidebar {
                    width: 100%;
                    flex-direction: row;
                    padding: 0;
                    border-radius: 8px; /* Slightly smaller radius for mobile */
                    overflow-x: auto;
                    justify-content: space-around; /* Distribute items */
                    box-shadow: 0 4px 15px var(--shadow-medium);
                }
                .sidebar a {
                    flex: 1;
                    justify-content: center;
                    padding: 15px 10px;
                    border-left: none;
                    border-bottom: 5px solid transparent;
                    white-space: nowrap; /* Prevent wrapping for labels */
                    flex-direction: column; /* Stack icon and text */
                    font-size: 0.8em;
                    gap: 5px;
                }
                .sidebar a i {
                    font-size: 1.5em; /* Make icons larger on mobile nav */
                }
                .sidebar a::before {
                    display: none; /* Hide left border indicator on mobile */
                }
                .sidebar a.active {
                    background-color: var(--primary-blue-light);
                    border-bottom: 5px solid var(--accent-teal);
                }
                .sidebar a:hover {
                    transform: none; /* Remove horizontal shift on mobile hover */
                }
                .main-content {
                    height: calc(100vh - 80px - 70px - 20px - 100px); /* Adjust height for stacked layout (header + footer + container padding + sidebar height) */
                    border-radius: 8px;
                }
                footer {
                    padding: 15px 0;
                }
            }

            @media (max-width: 480px) {
                header {
                    flex-direction: column;
                    gap: 10px;
                    padding: 15px;
                    align-items: stretch; /* Stretch items to fill width */
                }
                .header-left {
                    flex-direction: column;
                    gap: 5px;
                    align-items: center;
                }
                .logo {
                    font-size: 1.6em;
                }
                .welcome {
                    font-size: 0.9em;
                    text-align: center;
                }
                .logout-btn {
                    width: 100%;
                    justify-content: center;
                }
                .sidebar a {
                    padding: 12px 5px;
                    font-size: 0.75em;
                    min-width: 70px; /* Ensure links are wide enough */
                }
                .sidebar a i {
                    font-size: 1.3em;
                }
                .main-content {
                    height: calc(100vh - 80px - 70px - 20px - 150px); /* Further adjust height for very small screens */
                }
            }
        </style>
    </head>
    <body>

    <header>
        <div class="header-left">
            <div class="logo">PahanaEdu</div>
            <div class="welcome"><i class='bx bxs-star'></i> Welcome, <span><%= user %></span></div>
        </div>
        <a href="logout.jsp" class="logout-btn"><i class='bx bx-log-out'></i> Logout</a>
    </header>

    <div class="container">
        <nav class="sidebar">
            <a href="add-customer.jsp" target="content-frame" class="sidebar-link active"><i class='bx bx-user-plus'></i> Add Customer</a>
            <a href="edit-customer-list.jsp" target="content-frame" class="sidebar-link"><i class='bx bx-group'></i> Manage Customers</a>
            <a href="item-list.jsp" target="content-frame" class="sidebar-link"><i class='bx bx-box'></i> Manage Items</a>
            <a href="billing.jsp" target="content-frame" class="sidebar-link"><i class='bx bx-receipt'></i> Create Bill</a>
            <a href="view-bills.jsp" target="content-frame" class="sidebar-link"><i class='bx bx-list-ul'></i> View Bills</a>
        </nav>

        <main class="main-content">
            <iframe name="content-frame" id="content-frame" src="add-customer.jsp" frameborder="0"></iframe>
        </main>
    </div>

    <footer>
        &copy; <%= java.time.Year.now() %> PahanaEdu Admin Panel. Crafted with care for educational excellence.
    </footer>

    <script>
        const links = document.querySelectorAll('.sidebar-link');
        const contentFrame = document.getElementById('content-frame');

        links.forEach(link => {
            link.addEventListener('click', (event) => {
                event.preventDefault(); // Prevent default link behavior

                links.forEach(l => l.classList.remove('active')); // Remove 'active' from all
                link.classList.add('active'); // Add 'active' to clicked

                contentFrame.src = link.href; // Load content into iframe
            });
        });


    </script>

    </body>
    </html>