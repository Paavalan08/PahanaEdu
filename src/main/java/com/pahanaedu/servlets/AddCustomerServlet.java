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
//
//@WebServlet("/add-customer")
//public class AddCustomerServlet extends HttpServlet {
//
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // Read and trim inputs
//        String accNo = trimParam(request.getParameter("accountNumber"));
//        String name = trimParam(request.getParameter("name"));
//        String address = trimParam(request.getParameter("address"));
//        String phone = trimParam(request.getParameter("telephone"));
//        String username = trimParam(request.getParameter("username"));
//        String password = trimParam(request.getParameter("password"));
//
//        // Basic null/empty check
//        if (isNullOrEmpty(accNo) || isNullOrEmpty(name) || isNullOrEmpty(address) ||
//            isNullOrEmpty(phone) || isNullOrEmpty(username) || isNullOrEmpty(password)) {
//            forwardWithMessage(request, response, "❌ All fields are required.");
//            return;
//        }
//
//        // Regex patterns for validation
//        String accountNumberPattern = "\\d+";
//        String passwordPattern = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$";
//        String telephonePattern = "^\\+?\\d[\\d\\s-]{7,15}$";
//
//        // Validate account number (digits only)
//        if (!accNo.matches(accountNumberPattern)) {
//            forwardWithMessage(request, response, "❌ Account Number must contain digits only.");
//            return;
//        }
//
//        // Validate password complexity
//        if (!password.matches(passwordPattern)) {
//            forwardWithMessage(request, response,
//                "❌ Password must contain at least one number, one uppercase letter, one lowercase letter, and minimum 6 characters.");
//            return;
//        }
//
//        // Validate telephone number format
//        if (!phone.matches(telephonePattern)) {
//            forwardWithMessage(request, response, "❌ Telephone number is invalid.");
//            return;
//        }
//
//        try (Connection conn = DBUtil.getConnection()) {
//
//            // Check if username or account number already exists
//            String checkSql = "SELECT COUNT(*) FROM customer WHERE username = ? OR account_number = ?";
//            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
//                checkStmt.setString(1, username);
//                checkStmt.setString(2, accNo);
//                try (var rs = checkStmt.executeQuery()) {
//                    if (rs.next() && rs.getInt(1) > 0) {
//                        forwardWithMessage(request, response, "❌ Username or Account Number already exists.");
//                        return;
//                    }
//                }
//            }
//
//            // Insert new customer
//            String insertSql = "INSERT INTO customer (account_number, name, address, telephone, username, password) VALUES (?, ?, ?, ?, ?, ?)";
//            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
//                String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
//
//                ps.setString(1, accNo);
//                ps.setString(2, name);
//                ps.setString(3, address);
//                ps.setString(4, phone);
//                ps.setString(5, username);
//                ps.setString(6, hashedPassword);
//
//                int result = ps.executeUpdate();
//
//                if (result > 0) {
//                    forwardWithMessage(request, response, "✅ Customer added successfully!");
//                } else {
//                    forwardWithMessage(request, response, "❌ Failed to add customer.");
//                }
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            forwardWithMessage(request, response, "❌ An unexpected error occurred. Please try again.");
//        }
//    }
//
//    // Helper to trim input safely
//    private String trimParam(String param) {
//        return (param == null) ? null : param.trim();
//    }
//
//    // Helper to check null or empty
//    private boolean isNullOrEmpty(String str) {
//        return (str == null || str.isEmpty());
//    }
//
//    // Helper to set message attribute and forward to JSP
//    private void forwardWithMessage(HttpServletRequest request, HttpServletResponse response, String message)
//            throws ServletException, IOException {
//        request.setAttribute("message", message);
//        request.getRequestDispatcher("add-customer.jsp").forward(request, response);
//    }
//}




package com.pahanaedu.servlets;

import com.pahanaedu.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/add-customer")
public class AddCustomerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read and trim inputs
        String accNo = trimParam(request.getParameter("accountNumber"));
        String name = trimParam(request.getParameter("name"));
        String address = trimParam(request.getParameter("address"));
        String phone = trimParam(request.getParameter("telephone"));
        String username = trimParam(request.getParameter("username"));
        String password = trimParam(request.getParameter("password"));
        String email = trimParam(request.getParameter("email")); // ✅ New line

        // Basic null/empty check
        if (isNullOrEmpty(accNo) || isNullOrEmpty(name) || isNullOrEmpty(address) ||
            isNullOrEmpty(phone) || isNullOrEmpty(username) || isNullOrEmpty(password) || isNullOrEmpty(email)) {
            forwardWithMessage(request, response, "❌ All fields are required.");
            return;
        }

        // Regex patterns for validation
        String accountNumberPattern = "\\d+";
        String passwordPattern = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$";
        String telephonePattern = "^\\+?\\d[\\d\\s-]{7,15}$";
        String emailPattern = "^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$"; // ✅ Email validation

        // Validate account number
        if (!accNo.matches(accountNumberPattern)) {
            forwardWithMessage(request, response, "❌ Account Number must contain digits only.");
            return;
        }

        // Validate password
        if (!password.matches(passwordPattern)) {
            forwardWithMessage(request, response,
                "❌ Password must contain at least one number, one uppercase letter, one lowercase letter, and minimum 6 characters.");
            return;
        }

        // Validate telephone
        if (!phone.matches(telephonePattern)) {
            forwardWithMessage(request, response, "❌ Telephone number is invalid.");
            return;
        }

        // Validate email
        if (!email.matches(emailPattern)) {
            forwardWithMessage(request, response, "❌ Email format is invalid.");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {

            // Check if username or account number already exists
            String checkSql = "SELECT COUNT(*) FROM customer WHERE username = ? OR account_number = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, username);
                checkStmt.setString(2, accNo);
                try (var rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        forwardWithMessage(request, response, "❌ Username or Account Number already exists.");
                        return;
                    }
                }
            }

            // Insert new customer
            String insertSql = "INSERT INTO customer (account_number, name, address, telephone, username, password, email) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

                ps.setString(1, accNo);
                ps.setString(2, name);
                ps.setString(3, address);
                ps.setString(4, phone);
                ps.setString(5, username);
                ps.setString(6, hashedPassword);
                ps.setString(7, email); // ✅ New line

                int result = ps.executeUpdate();

                if (result > 0) {
                    forwardWithMessage(request, response, "✅ Customer added successfully!");
                } else {
                    forwardWithMessage(request, response, "❌ Failed to add customer.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            forwardWithMessage(request, response, "❌ An unexpected error occurred. Please try again.");
        }
    }

    private String trimParam(String param) {
        return (param == null) ? null : param.trim();
    }

    private boolean isNullOrEmpty(String str) {
        return (str == null || str.isEmpty());
    }

    private void forwardWithMessage(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("message", message);
        request.getRequestDispatcher("add-customer.jsp").forward(request, response);
    }
}
