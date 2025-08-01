package com.pahanaedu.servlets;

import com.pahanaedu.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;

@WebServlet("/BuyItemServlet")
public class BuyItemServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int itemId = Integer.parseInt(request.getParameter("item_id"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customerId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int customerId = (int) session.getAttribute("customerId");

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            PreparedStatement checkStmt = conn.prepareStatement("SELECT stock, unit_price FROM item WHERE item_id = ?");
            checkStmt.setInt(1, itemId);
            ResultSet rs = checkStmt.executeQuery();

            if (!rs.next() || rs.getInt("stock") < quantity) {
                response.getWriter().println("Not enough stock.");
                return;
            }

            double unitPrice = rs.getDouble("unit_price");
            int stock = rs.getInt("stock");
            double totalAmount = unitPrice * quantity;

            // 1. Update stock
            PreparedStatement updateStock = conn.prepareStatement("UPDATE item SET stock = ? WHERE item_id = ?");
            updateStock.setInt(1, stock - quantity);
            updateStock.setInt(2, itemId);
            updateStock.executeUpdate();

            // 2. Insert into bill
            PreparedStatement insertBill = conn.prepareStatement(
                "INSERT INTO bill (customer_id, item_id, quantity, total_amount, bill_date) VALUES (?, ?, ?, ?, ?)");
            insertBill.setInt(1, customerId);
            insertBill.setInt(2, itemId);
            insertBill.setInt(3, quantity);
            insertBill.setDouble(4, totalAmount);
            insertBill.setDate(5, Date.valueOf(LocalDate.now()));
            insertBill.executeUpdate();

            conn.commit();

            response.sendRedirect("customer-bill.jsp");

        } catch (Exception e) {
            throw new ServletException("Buying failed", e);
        }
    }
} 