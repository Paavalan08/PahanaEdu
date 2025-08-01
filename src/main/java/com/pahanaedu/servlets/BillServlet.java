package com.pahanaedu.servlets;

import com.pahanaedu.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/BillServlet")
public class BillServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String customerId = request.getParameter("customerId");
        String itemId = request.getParameter("itemId");
        String quantityStr = request.getParameter("quantity");

        if (customerId != null && itemId != null && quantityStr != null) {
            int customerIdInt = Integer.parseInt(customerId);
            int itemIdInt = Integer.parseInt(itemId);
            int quantity = Integer.parseInt(quantityStr);

            double totalAmount = 0;
            double unitPrice = 0;

            try (Connection conn = DBUtil.getConnection()) {

                // Step 1: Fetch item price and check available stock
                String itemQuery = "SELECT unit_price, stock FROM item WHERE item_id = ?";
                PreparedStatement itemStmt = conn.prepareStatement(itemQuery);
                itemStmt.setInt(1, itemIdInt);
                ResultSet rs = itemStmt.executeQuery();

                if (rs.next()) {
                    unitPrice = rs.getDouble("unit_price");
                    int stockAvailable = rs.getInt("stock");

                    if (stockAvailable < quantity) {
                        // Not enough stock
                        response.sendRedirect("error.jsp?msg=Not enough stock available");
                        return;
                    }

                    totalAmount = unitPrice * quantity;

                    // Step 2: Insert bill
                    String insertQuery = "INSERT INTO bill (customer_id, item_id, quantity, total_amount) VALUES (?, ?, ?, ?)";
                    PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                    insertStmt.setInt(1, customerIdInt);
                    insertStmt.setInt(2, itemIdInt);
                    insertStmt.setInt(3, quantity);
                    insertStmt.setDouble(4, totalAmount);

                    int result = insertStmt.executeUpdate();

                    if (result > 0) {
                        // Step 3: Reduce stock
                        String updateStockQuery = "UPDATE item SET stock = stock - ? WHERE item_id = ?";
                        PreparedStatement updateStmt = conn.prepareStatement(updateStockQuery);
                        updateStmt.setInt(1, quantity);
                        updateStmt.setInt(2, itemIdInt);
                        updateStmt.executeUpdate();

                        response.sendRedirect("view-bills.jsp"); // Success
                    } else {
                        response.sendRedirect("error.jsp?msg=Failed to create bill");
                    }
                } else {
                    response.sendRedirect("error.jsp?msg=Item not found");
                }

            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("error.jsp?msg=Database error");
            }

        } else {
            response.sendRedirect("error.jsp?msg=Missing form data");
        }
    }
}