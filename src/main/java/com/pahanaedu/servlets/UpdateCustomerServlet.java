//package com.pahanaedu.servlets;
//
//import com.pahanaedu.util.DBUtil;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import org.mindrot.jbcrypt.BCrypt;
//
//import java.io.IOException;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.SQLIntegrityConstraintViolationException;
//
//@WebServlet("/update-customer")
//public class UpdateCustomerServlet extends HttpServlet {
//
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        int id = Integer.parseInt(request.getParameter("id"));
//        String accNo = request.getParameter("accountNumber");
//        String name = request.getParameter("name");
//        String address = request.getParameter("address");
//        String phone = request.getParameter("telephone");
//        String username = request.getParameter("username");
//        String newPassword = request.getParameter("password");
//
//        // Basic validation example (you can expand)
//        if (accNo == null || accNo.trim().isEmpty() ||
//            name == null || name.trim().isEmpty() ||
//            address == null || address.trim().isEmpty() ||
//            phone == null || phone.trim().isEmpty() ||
//            username == null || username.trim().isEmpty()) {
//            
//            request.setAttribute("message", "❌ All fields except password are required.");
//            request.getRequestDispatcher("edit-customer.jsp?id=" + id).forward(request, response);
//            return;
//        }
//
//        try (Connection conn = DBUtil.getConnection()) {
//
//            String sql;
//            PreparedStatement ps;
//
//            if (newPassword != null && !newPassword.trim().isEmpty()) {
//                // Hash the new password
//                String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
//
//                sql = "UPDATE customer SET account_number=?, name=?, address=?, telephone=?, username=?, password=? WHERE customer_id=?";
//                ps = conn.prepareStatement(sql);
//
//                ps.setString(1, accNo);
//                ps.setString(2, name);
//                ps.setString(3, address);
//                ps.setString(4, phone);
//                ps.setString(5, username);
//                ps.setString(6, hashedPassword);
//                ps.setInt(7, id);
//            } else {
//                // No password change
//                sql = "UPDATE customer SET account_number=?, name=?, address=?, telephone=?, username=? WHERE customer_id=?";
//                ps = conn.prepareStatement(sql);
//
//                ps.setString(1, accNo);
//                ps.setString(2, name);
//                ps.setString(3, address);
//                ps.setString(4, phone);
//                ps.setString(5, username);
//                ps.setInt(6, id);
//            }
//
//            ps.executeUpdate();
//
//            response.sendRedirect("edit-customer-list.jsp");
//
//        } catch (SQLIntegrityConstraintViolationException e) {
//            // Handle duplicate username/account number
//            request.setAttribute("message", "❌ Username or Account Number already exists.");
//            request.getRequestDispatcher("edit-customer.jsp?id=" + id).forward(request, response);
//        } catch (Exception e) {
//            throw new ServletException("Failed to update customer", e);
//        }
//    }
//}




package com.pahanaedu.servlets;

import com.pahanaedu.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLIntegrityConstraintViolationException;

@WebServlet("/update-customer")
public class UpdateCustomerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("customer_id");
        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("message", "❌ Customer ID is missing.");
            request.getRequestDispatcher("update-customer.jsp?id=" + idStr).forward(request, response);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            request.setAttribute("message", "❌ Invalid Customer ID.");
            request.getRequestDispatcher("update-customer.jsp?id=" + idStr).forward(request, response);
            return;
        }

        String accNo = request.getParameter("accountNumber");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("telephone");
        String username = request.getParameter("username");
        String newPassword = request.getParameter("password");
        String email = request.getParameter("email");

        if (accNo == null || accNo.trim().isEmpty() ||
            name == null || name.trim().isEmpty() ||
            address == null || address.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {

            request.setAttribute("message", "❌ All fields except password are required.");
            request.getRequestDispatcher("update-customer.jsp?id=" + id).forward(request, response);
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            String sql;
            PreparedStatement ps;

            if (newPassword != null && !newPassword.trim().isEmpty()) {
                String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

                sql = "UPDATE customer SET account_number=?, name=?, address=?, telephone=?, username=?, password=?, email=? WHERE customer_id=?";
                ps = conn.prepareStatement(sql);

                ps.setString(1, accNo);
                ps.setString(2, name);
                ps.setString(3, address);
                ps.setString(4, phone);
                ps.setString(5, username);
                ps.setString(6, hashedPassword);
                ps.setString(7, email);
                ps.setInt(8, id);

            } else {
                sql = "UPDATE customer SET account_number=?, name=?, address=?, telephone=?, username=?, email=? WHERE customer_id=?";
                ps = conn.prepareStatement(sql);

                ps.setString(1, accNo);
                ps.setString(2, name);
                ps.setString(3, address);
                ps.setString(4, phone);
                ps.setString(5, username);
                ps.setString(6, email);
                ps.setInt(7, id);
            }

            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("edit-customer-list.jsp?update=success");
            } else {
                request.setAttribute("message", "❌ Update failed. Customer not found.");
                request.getRequestDispatcher("update-customer.jsp?id=" + id).forward(request, response);
            }

        } catch (SQLIntegrityConstraintViolationException e) {
            request.setAttribute("message", "❌ Username or Account Number already exists.");
            request.getRequestDispatcher("update-customer.jsp?id=" + id).forward(request, response);
        } catch (Exception e) {
            throw new ServletException("❌ Failed to update customer", e);
        }
    }
}
