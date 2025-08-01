package com.pahanaedu.servlets;

import com.pahanaedu.util.DBUtil;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/UpdateBillServlet")
public class UpdateBillServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Use correct field names from JSP
        int billId = Integer.parseInt(request.getParameter("billId"));
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE bill SET customer_id=?, item_id=?, quantity=?, total_amount=? WHERE bill_id=?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, customerId);
            stmt.setInt(2, itemId);
            stmt.setInt(3, quantity);
            stmt.setDouble(4, totalAmount);
            stmt.setInt(5, billId);
            stmt.executeUpdate();

            // Redirect back to bill list page
            response.sendRedirect("view-bills.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to update bill.");
            request.getRequestDispatcher("edit-bill.jsp?bill_id=" + billId).forward(request, response);
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}