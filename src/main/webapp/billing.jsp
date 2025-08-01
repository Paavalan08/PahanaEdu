<%@page import="com.pahanaedu.dao.ItemDAO"%>
<%@page import="com.pahanaedu.model.Item"%>
<%@ page import="com.pahanaedu.dao.CustomerDAO" %>
<%@ page import="com.pahanaedu.model.Customer" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>

<%
    // This logic is unchanged.
    // We assume CustomerDAO and ItemDAO are available and working.
    // In a real application, you might add error handling here.
    List<Customer> customers = null;
    List<Item> items = null;
    try {
        CustomerDAO customerDAO = new CustomerDAO();
        customers = customerDAO.getAllCustomers();

        ItemDAO itemDAO = new ItemDAO();
        items = itemDAO.getAllItems();
    } catch (Exception e) {
        // Basic error handling for display
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Bill</title>
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
            --button-gradient-start: #3498db;
            --button-gradient-end: #2980b9;
            --input-focus-shadow: rgba(0, 206, 201, 0.25);
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

        /* Updated to include select and number inputs */
        input[type="text"],
        input[type="number"],
        select {
            width: 100%;
            padding: 14px 18px;
            border: 1px solid var(--border-light);
            border-radius: 10px;
            font-family: 'Inter', sans-serif;
            font-size: 1.05em;
            color: var(--text-dark);
            transition: border-color 0.3s ease, box-shadow 0.3s ease, background-color 0.3s ease;
            background-color: #fcfcfc;
            /* For consistent appearance on different browsers */
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
        }
        
        select {
            background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%232c3e50%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E');
            background-repeat: no-repeat;
            background-position: right 18px top 50%;
            background-size: .65em auto;
        }


        input:disabled {
            background-color: var(--background-body);
            cursor: not-allowed;
            color: #7f8c8d;
        }

        /* Updated to include select and number inputs */
        input[type="text"]:focus,
        input[type="number"]:focus,
        select:focus {
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
        
        /* Responsive styles from the previous example */
        @media (max-width: 600px) {
            body { padding: 15px; }
            .form-container { padding: 30px; }
            .page-header h2 { font-size: 2.2em; }
            p.subtitle { font-size: 0.95em; }
            input[type="text"], input[type="number"], select { padding: 12px 15px; }
            button[type="submit"] { padding: 14px 25px; font-size: 1.1em; }
        }
    </style>
</head>
<body>

<div class="form-container">
    <div class="page-header">
        <h2><i class='bx bxs-receipt header-icon'></i>Create Bill</h2>
        <p class="subtitle">Select customer and item to generate an invoice</p>
    </div>

    <% if (customers == null || items == null) { %>
        <p style="color: red; text-align: center;">Error: Could not load customer or item data.</p>
    <% } else { %>
        <form action="BillServlet" method="post">
            <label for="customerId">Customer</label>
            <select name="customerId" id="customerId" required>
                <option value="" disabled selected>Select a Customer...</option>
                <% for (Customer customer : customers) { %>
                    <option value="<%= customer.getCustomerId() %>"><%= customer.getName() %></option>
                <% } %>
            </select>

            <label for="itemId">Item</label>
            <select name="itemId" id="itemId" required>
                <option value="" disabled selected>Select an Item...</option>
                <% for (Item item : items) { %>
                    <option value="<%= item.getItemId() %>" data-price="<%= item.getUnitPrice() %>">
                        <%= item.getItemName() %> - Available: <%= item.getStock() %>
                    </option>
                <% } %>
            </select>

            <label for="quantity">Quantity</label>
            <input type="number" name="quantity" id="quantity" min="1" value="1" required />

            <label for="totalAmount">Total Amount</label>
            <input type="text" id="totalAmount" disabled placeholder="LKR 0.00" />
            
            <input type="hidden" name="totalAmount" id="hiddenTotalAmount" />

            <button type="submit"><i class='bx bxs-paper-plane'></i>Generate Bill</button>
        </form>
    <% } %>
</div>

<script>
    // This JavaScript logic is unchanged.
    const itemSelect = document.getElementById('itemId');
    const quantityInput = document.getElementById('quantity');
    const totalAmountInput = document.getElementById('totalAmount');
    const hiddenTotalInput = document.getElementById('hiddenTotalAmount');

    function updateTotal() {
        const selectedOption = itemSelect.options[itemSelect.selectedIndex];
        if (!selectedOption || !selectedOption.dataset.price || selectedOption.value === "") {
            totalAmountInput.value = '';
            hiddenTotalInput.value = '';
            return;
        }
        
        const unitPrice = parseFloat(selectedOption.dataset.price);
        const quantity = parseInt(quantityInput.value, 10);

        if (!isNaN(unitPrice) && !isNaN(quantity) && quantity > 0) {
            const total = unitPrice * quantity;
            totalAmountInput.value = 'LKR ' + total.toFixed(2);
            hiddenTotalInput.value = total.toFixed(2); // Set value for form submission
        } else {
            totalAmountInput.value = '';
            hiddenTotalInput.value = '';
        }
    }

    itemSelect.addEventListener('change', updateTotal);
    quantityInput.addEventListener('input', updateTotal);

    // Initial update call in case the form has pre-filled values (though unlikely here)
    document.addEventListener('DOMContentLoaded', updateTotal);
</script>

</body>
</html>