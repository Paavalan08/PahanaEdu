<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Item</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #28a745; /* Green for success/add */
            --primary-hover-color: #218838;
            --background-color: #f8f9fa;
            --container-bg-color: #ffffff;
            --text-color: #343a40;
            --input-border-color: #ced4da;
            --input-focus-color: #28a745;
            --link-color: #007bff;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--background-color);
            color: var(--text-color);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            width: 100%;
            max-width: 420px;
            background: var(--container-bg-color);
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            text-align: center;
        }

        .form-header {
            margin-bottom: 30px;
            font-size: 1.8em;
            font-weight: 600;
            color: var(--text-color);
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        label {
            display: block;
            font-weight: 500;
            margin-bottom: 8px;
            font-size: 0.9em;
        }
        
        input[type="text"],
        input[type="number"] {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--input-border-color);
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 1em;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        input[type="text"]:focus,
        input[type="number"]:focus {
            outline: none;
            border-color: var(--input-focus-color);
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.2);
        }

        .submit-btn {
            width: 100%;
            padding: 12px;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 1.1em;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-top: 10px;
        }

        .submit-btn:hover {
            background-color: var(--primary-hover-color);
        }
        
        .back-link {
            display: inline-block;
            margin-top: 25px;
            color: var(--link-color);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95em;
            transition: text-decoration 0.3s;
        }

        .back-link:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>

<div class="container">
    <h2 class="form-header">? Add New Item</h2>
    
    <form action="ItemServlet" method="post">
        <input type="hidden" name="action" value="add" />
        
        <div class="form-group">
            <label for="itemName">Item Name</label>
            <input type="text" id="itemName" name="itemName" placeholder="e.g., Organic Rice" required />
        </div>

        <div class="form-group">
            <label for="unitPrice">Unit Price (LKR)</label>
            <input type="number" id="unitPrice" step="0.01" name="unitPrice" placeholder="e.g., 450.00" required />
        </div>

        <div class="form-group">
            <label for="stock">Quantity in Stock</label>
            <input type="number" id="stock" name="stock" placeholder="e.g., 100" required />
        </div>
        
        <input type="submit" value="Add Item" class="submit-btn" />
    </form>
    
    <a href="item-list.jsp" class="back-link">? Back to Item List</a>
</div>

</body>
</html>