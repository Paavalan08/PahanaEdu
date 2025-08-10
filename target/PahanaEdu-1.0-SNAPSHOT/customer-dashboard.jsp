<%@ page session="true" %>
<%@ page import="java.sql.*, com.pahanaedu.util.DBUtil, java.util.*" %>

<%
    Integer customerId = (Integer) session.getAttribute("customerId");
    if (customerId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String name = "", address = "", telephone = "", password = "", email = "";

    String purchaseMessage = null; // to hold success/error messages

    // --- HANDLE PURCHASE POST ---
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            int itemId = Integer.parseInt(request.getParameter("item_id"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            try (Connection conn = DBUtil.getConnection()) {
                conn.setAutoCommit(false);

                PreparedStatement ps1 = conn.prepareStatement("SELECT unit_price, stock FROM item WHERE item_id = ?");
                ps1.setInt(1, itemId);
                ResultSet rs1 = ps1.executeQuery();

                if (rs1.next()) {
                    double unitPrice = rs1.getDouble("unit_price");
                    int currentStock = rs1.getInt("stock");

                    if (quantity <= currentStock) {
                        double totalAmount = unitPrice * quantity;

                        PreparedStatement ps2 = conn.prepareStatement(
                            "INSERT INTO bill (customer_id, item_id, quantity, total_amount, bill_date) VALUES (?, ?, ?, ?, NOW())"
                        );
                        ps2.setInt(1, customerId);
                        ps2.setInt(2, itemId);
                        ps2.setInt(3, quantity);
                        ps2.setDouble(4, totalAmount);
                        ps2.executeUpdate();

                        PreparedStatement ps3 = conn.prepareStatement("UPDATE item SET stock = stock - ? WHERE item_id = ?");
                        ps3.setInt(1, quantity);
                        ps3.setInt(2, itemId);
                        ps3.executeUpdate();

                        conn.commit();

                        purchaseMessage = "Purchase completed successfully!";
                    } else {
                        conn.rollback();
                        purchaseMessage = "Not enough stock available!";
                    }
                } else {
                    conn.rollback();
                    purchaseMessage = "Item not found!";
                }
            }
        } catch (Exception e) {
            purchaseMessage = "Purchase failed: " + e.getMessage();
        }
    }

    // --- LOAD CUSTOMER DETAILS ---
    if (username != null) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT * FROM customer WHERE username = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
                address = rs.getString("address");
                telephone = rs.getString("telephone");
                password = rs.getString("password");
                email = rs.getString("email"); // Added email load
            }
        } catch (Exception e) {
            out.println("Error loading customer details: " + e.getMessage());
        }
    }

    // --- LOAD BILLS ---
    List<Map<String, String>> bills = new ArrayList<>();
    try (Connection conn = DBUtil.getConnection()) {
        PreparedStatement stmt = conn.prepareStatement(
            "SELECT b.bill_id, i.item_name, b.quantity, b.total_amount, b.bill_date FROM bill b JOIN item i ON b.item_id = i.item_id WHERE b.customer_id = ? ORDER BY b.bill_date DESC");
        stmt.setInt(1, customerId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> bill = new HashMap<>();
            bill.put("id", rs.getString("bill_id"));
            bill.put("item", rs.getString("item_name"));
            bill.put("qty", rs.getString("quantity"));
            bill.put("amount", rs.getString("total_amount"));
            bill.put("date", rs.getString("bill_date"));
            bills.add(bill);
        }
    } catch (Exception e) {
        out.println("Error loading bills.");
    }

    // --- LOAD AVAILABLE ITEMS ---
    List<Map<String, Object>> items = new ArrayList<>();
    try (Connection conn = DBUtil.getConnection()) {
        String sql = "SELECT * FROM item WHERE stock > 0";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("item_id", rs.getInt("item_id"));
            item.put("item_name", rs.getString("item_name"));
            item.put("unit_price", rs.getDouble("unit_price"));
            item.put("stock", rs.getInt("stock"));
            items.add(item);
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error loading available items: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Customer Dashboard - Pahana Edu</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300,400,500,600,700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <link rel="stylesheet" href="style.css" /> <%-- Your external CSS --%>

    <script>
        function showSection(id) {
            const sections = document.querySelectorAll(".content-section");
            sections.forEach((s) => s.classList.remove("active"));
            document.getElementById(id).classList.add("active");

            const links = document.querySelectorAll("nav.sidebar a");
            links.forEach((link) => link.classList.remove("active"));
            document.querySelector('nav.sidebar a[data-target="' + id + '"]').classList.add("active");

            const toggleCheckbox = document.getElementById("sidebarToggle");
            if (window.innerWidth <= 768 && toggleCheckbox.checked) {
                toggleCheckbox.checked = false; // Close sidebar on mobile after selection
            }
        }

        window.onload = function () {
            showSection("dashboardOverview");
        };

        function validateForm() {
            const phone = document.getElementById("telephone").value.trim();
            if (!phone.match(/^\d{7,15}$/)) {
                alert("Please enter a valid telephone number (7-15 digits).");
                return false;
            }
            return true;
        }

        function filterTable(inputId, tableId) {
            var input, filter, table, tr, i;
            input = document.getElementById(inputId);
            filter = input.value.toUpperCase();
            table = document.getElementById(tableId);
            tr = table.getElementsByTagName("tr");

            for (i = 0; i < tr.length; i++) {
                if (tr[i].getElementsByTagName("th").length > 0) {
                    continue;
                }

                if (tableId === "itemsTable") {
                    var idCell = tr[i].getElementsByTagName("td")[0];
                    var nameCell = tr[i].getElementsByTagName("td")[1];

                    if (idCell && nameCell) {
                        var idTxtValue = idCell.textContent || idCell.innerText;
                        var nameTxtValue = nameCell.textContent || nameCell.innerText;

                        if (
                            idTxtValue.toUpperCase().indexOf(filter) > -1 ||
                            nameTxtValue.toUpperCase().indexOf(filter) > -1
                        ) {
                            tr[i].style.display = "";
                        } else {
                            tr[i].style.display = "none";
                        }
                    }
                } else if (tableId === "billsTable") {
                    var billIdCell = tr[i].getElementsByTagName("td")[0];
                    var itemBillNameCell = tr[i].getElementsByTagName("td")[1];
                    var dateTimeCell = tr[i].getElementsByTagName("td")[4];

                    if (billIdCell && itemBillNameCell) {
                        var billIdTxtValue = billIdCell.textContent || billIdCell.innerText;
                        var itemBillNameTxtValue = itemBillNameCell.textContent || itemBillNameCell.innerText;
                        var dateTimeTxtValue = dateTimeCell ? dateTimeCell.textContent || dateTimeCell.innerText : "";

                        if (
                            billIdTxtValue.toUpperCase().indexOf(filter) > -1 ||
                            itemBillNameTxtValue.toUpperCase().indexOf(filter) > -1 ||
                            dateTimeTxtValue.toUpperCase().indexOf(filter) > -1
                        ) {
                            tr[i].style.display = "";
                        } else {
                            tr[i].style.display = "none";
                        }
                    }
                }
            }
        }
    </script>
</head>
<body>
    <header>
        <label for="sidebarToggle" class="menu-icon" title="Toggle Menu" aria-label="Toggle Sidebar Menu">
            <span></span>
            <span></span>
            <span></span>
        </label>
        <h1>Pahana Edu</h1>
        <div class="header-user-info">
            <span>Welcome, <strong><%= username != null ? username : "Guest" %></strong></span>
        </div>
    </header>

    <input
        type="checkbox"
        id="sidebarToggle"
        aria-controls="sidebar-nav"
        aria-expanded="false"
    />

    <nav class="sidebar" id="sidebar-nav" aria-label="Sidebar Navigation">
        <div class="sidebar-header">
            <i class="fas fa-graduation-cap"></i>
            <h2>Pahana Edu</h2>
        </div>
        <ul>
            <li>
                <a
                    data-target="dashboardOverview"
                    onclick="showSection('dashboardOverview')"
                    class="active"
                    ><i class="fas fa-th-large"></i> Dashboard</a
                >
            </li>
            <li>
                <a data-target="availableItems" onclick="showSection('availableItems')"
                    ><i class="fas fa-book"></i> Available Books</a
                >
            </li>
            <li>
                <a data-target="myAccount" onclick="showSection('myAccount')"
                    ><i class="fas fa-user-circle"></i> My Account</a
                >
            </li>
            <li>
                <a data-target="myBills" onclick="showSection('myBills')"
                    ><i class="fas fa-receipt"></i> My Bills</a
                >
            </li>
            <li>
                <a data-target="helpSection" onclick="showSection('helpSection')"
                    ><i class="fas fa-question-circle"></i> Help</a
                >
            </li>
            <li>
                <a href="logout.jsp" target="_top"
                    ><i class="fas fa-sign-out-alt"></i> Logout</a
                >
            </li>
        </ul>
    </nav>

    <main class="content" role="main">
        <% if (purchaseMessage != null) { %>
        <script>
purchaseMessage.replace("\"", "\\\"")
        </script>
        <% } %>

        <section id="dashboardOverview" class="content-section active">
            <h2>Welcome, <%= name != null && !name.isEmpty() ? name : "Customer" %>!</h2>

            <div class="dashboard-cards">
                <div class="card card-total-bills">
                    <div class="card-icon"><i class="fas fa-file-invoice"></i></div>
                    <div class="card-content">
                        <h3>Total Bills</h3>
                        <p class="card-value"><%= bills.size() %></p>
                    </div>
                </div>
                <div class="card card-total-spent">
                    <div class="card-icon"><i class="fas fa-wallet"></i></div>
                    <div class="card-content">
                        <h3>Total Amount Spent</h3>
                        <p class="card-value">
                            <%
                                double totalAmount = 0;
                                for (Map<String, String> b : bills) {
                                    totalAmount += Double.parseDouble(b.get("amount"));
                                }
                                out.print(String.format("Rs. %.2f", totalAmount));
                            %>
                        </p>
                    </div>
                </div>
                <div class="card card-available-books">
                    <div class="card-icon"><i class="fas fa-book-reader"></i></div>
                    <div class="card-content">
                        <h3>Available Books</h3>
                        <p class="card-value"><%= items.size() %></p>
                    </div>
                </div>
                <div class="card card-last-purchase">
                    <div class="card-icon"><i class="fas fa-history"></i></div>
                    <div class="card-content">
                        <h3>Last Purchase</h3>
                        <p class="card-value card-smaller-text">
                            <%
                                if (!bills.isEmpty()) {
                                    Map<String, String> lastBill = bills.get(0);
                                    out.print(lastBill.get("item") + "<br>on " + lastBill.get("date"));
                                } else {
                                    out.print("No purchases yet");
                                }
                            %>
                        </p>
                    </div>
                </div>
            </div>

            <h3>Recent Bills</h3>
            <div class="table-container glass-effect">
                <table>
                    <thead>
                        <tr>
                            <th>Bill ID</th>
                            <th>Item</th>
                            <th>Quantity</th>
                            <th>Total</th>
                            <th>Date &amp; Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int maxBills = 5;
                            for (int i = 0; i < Math.min(bills.size(), maxBills); i++) {
                                Map<String, String> b = bills.get(i);
                        %>
                        <tr>
                            <td><%= b.get("id") %></td>
                            <td><%= b.get("item") %></td>
                            <td><%= b.get("qty") %></td>
                            <td>Rs. <%= b.get("amount") %></td>
                            <td><%= b.get("date") %></td>
                        </tr>
                        <% } %>
                        <% if (bills.isEmpty()) { %>
                        <tr>
                            <td colspan="5">No bills found.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div class="dashboard-actions">
                <button onclick="showSection('myAccount')" class="btn-dashboard">
                    <i class="fas fa-user-edit"></i> Edit Profile
                </button>
                <button onclick="showSection('myBills')" class="btn-dashboard">
                    <i class="fas fa-list-alt"></i> View All Bills
                </button>
                <button onclick="showSection('availableItems')" class="btn-dashboard">
                    <i class="fas fa-search"></i> Browse Books
                </button>
            </div>
        </section>

        <section id="availableItems" class="content-section">
            <h2>Available Books / Items</h2>

            <div class="search-container glass-effect">
                <input
                    type="text"
                    id="itemSearchInput"
                    onkeyup="filterTable('itemSearchInput', 'itemsTable')"
                    placeholder="Search for books by name or ID..."
                    aria-label="Search available books"
                />
                <i class="fas fa-search search-icon"></i>
            </div>

            <div class="table-container glass-effect">
                <table id="itemsTable">
                    <thead>
                        <tr>
                            <th>Item ID</th>
                            <th>Name</th>
                            <th>Price (LKR)</th>
                            <th>Available Stock</th>
                            <th>Buy</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (items.isEmpty()) { %>
                        <tr>
                            <td colspan="5">No available items.</td>
                        </tr>
                        <% } else {
                            for (Map<String, Object> item : items) {
                        %>
                        <tr>
                            <td><%= item.get("item_id") %></td>
                            <td><%= item.get("item_name") %></td>
                            <td>Rs. <%= String.format("%.2f", item.get("unit_price")) %></td>
                            <td><%= item.get("stock") %></td>
                            <td>
                                <form method="post" class="buy-form">
                                    <input type="hidden" name="item_id" value="<%= item.get("item_id") %>" />
                                    <input
                                        type="number"
                                        name="quantity"
                                        min="1"
                                        max="<%= item.get("stock") %>"
                                        value="1"
                                        required
                                        aria-label="Quantity"
                                    />
                                    <button type="submit" class="btn-buy">
                                        <i class="fas fa-shopping-cart"></i> Buy
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <%  }
                            } %>
                    </tbody>
                </table>
            </div>
        </section>

        <section id="myAccount" class="content-section">
            <h2>My Account Details</h2>
            <div class="account-details glass-effect">
                <p><strong>Username:</strong> <%= username != null ? username : "N/A" %></p>
                <p><strong>Name:</strong> <%= name %></p>
                <p><strong>Address:</strong> <%= address %></p>
                <p><strong>Telephone:</strong> <%= telephone %></p>
                <p><strong>Email:</strong> <%= email != null && !email.isEmpty() ? email : "N/A" %></p> <%-- Added email display --%>
                <p>
                    <strong>Password:</strong> <%= password.replaceAll(".", "*") %>
                    <small>(For security, showing asterisks)</small>
                </p>
                <p>
                    <a href="#" onclick="showSection('editAccount'); return false;" class="btn-link"
                        ><i class="fas fa-edit"></i> Edit My Account</a
                    >
                </p>
            </div>
        </section>

        <section id="editAccount" class="content-section">
            <h2>Edit Account</h2>
            <form method="post" action="UpdateMyAccountServlet" onsubmit="return validateForm();" class="edit-account-form glass-effect">
                <input type="hidden" name="customer_id" value="<%= customerId %>" />

                <div class="form-group">
                    <label for="name"><i class="fas fa-user"></i> Name:</label>
                    <input type="text" id="name" name="name" value="<%= name %>" required />
                </div>

                <div class="form-group">
                    <label for="address"><i class="fas fa-map-marker-alt"></i> Address:</label>
                    <input type="text" id="address" name="address" value="<%= address %>" required />
                </div>

                <div class="form-group">
                    <label for="telephone"><i class="fas fa-phone"></i> Telephone:</label>
                    <input type="text" id="telephone" name="telephone" value="<%= telephone %>" required />
                </div>

                <div class="form-group">
                    <label for="email"><i class="fas fa-envelope"></i> Email:</label>
                    <input type="email" id="email" name="email" value="<%= email %>" required />
                </div>

                <div class="form-group">
                    <label for="password"><i class="fas fa-lock"></i> Password:</label>
                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Leave blank to keep current password"
                    />
                    <small style="color: gray; font-size: 0.85em;">
                        Leave blank if you don't want to change your password.
                    </small>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Save Changes</button>
                    <button type="button" onclick="showSection('myAccount')" class="btn-secondary">
                        <i class="fas fa-times-circle"></i> Cancel
                    </button>
                </div>
            </form>
        </section>

       <section id="myBills" class="content-section">
    <h2>All Bills</h2>
    <div class="search-container glass-effect">
        <input
            type="text"
            id="billSearchInput"
            onkeyup="filterTable('billSearchInput', 'billsTable')"
            placeholder="Search for bills by item, Bill ID, or date/time..."
            aria-label="Search my bills"
        />
        <i class="fas fa-search search-icon"></i>
    </div>

    <div class="table-container glass-effect">
        <table id="billsTable">
            <thead>
                <tr>
                    <th>Bill ID</th>
                    <th>Item</th>
                    <th>Quantity</th>
                    <th>Total (LKR)</th>
                    <th>Date &amp; Time</th>
                    <th>Download</th> <!-- new column -->
                </tr>
            </thead>
            <tbody>
                <% if (bills.isEmpty()) { %>
                <tr>
                    <td colspan="6">No bills found.</td> <!-- colspan updated -->
                </tr>
                <% } else {
                    for (Map<String, String> b : bills) {
                %>
                <tr>
                    <td><%= b.get("id") %></td>
                    <td><%= b.get("item") %></td>
                    <td><%= b.get("qty") %></td>
                    <td>Rs. <%= b.get("amount") %></td>
                    <td><%= b.get("date") %></td>
                    <td>
                        <a 
                          href="DownloadBillPDFServlet?bill_id=<%= b.get("id") %>" 
                          class="button"
                          style="padding: 6px 12px; font-size: 0.85em; border-radius: 6px; background: #3498db; color: white; text-decoration: none;"
                          target="_blank" 
                          rel="noopener noreferrer"
                        >
                            <i class="fas fa-file-pdf"></i> PDF
                        </a>
                    </td>
                </tr>
                <%  }
                   } %>
            </tbody>
        </table>
    </div>
</section>


        <section id="helpSection" class="content-section">
            <h2>Help / FAQ</h2>
            <div class="help-content glass-effect">
                <p>Welcome to the help section. Here are some frequently asked questions:</p>
                <ul>
                    <li><strong>How to buy items?</strong> Browse the "Available Books" section, enter quantity, and click "Buy". The system will check for stock availability.</li>
                    <li><strong>How to edit my account?</strong> Go to "My Account" and click "Edit My Account" to update your personal details and password.</li>
                    <li><strong>Who to contact for support?</strong> For any issues or further assistance, please reach out to our support team at <a href="mailto:support@pahanaedu.lk">support@pahanaedu.lk</a>.</li>
                </ul>
                <p>Our team is dedicated to providing you with the best experience.</p>
            </div>
        </section>
    </main>

    <footer>
        &copy; 2025 Pahana Edu. All rights reserved.
    </footer>
</body>
</html>
