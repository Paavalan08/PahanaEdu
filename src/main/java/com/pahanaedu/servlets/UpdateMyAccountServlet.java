//package com.pahanaedu.servlets;
//
//import com.pahanaedu.util.DBUtil;
//import org.mindrot.jbcrypt.BCrypt;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//
//import java.io.IOException;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//
//@WebServlet("/UpdateMyAccountServlet")
//public class UpdateMyAccountServlet extends HttpServlet {
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        int customerId = Integer.parseInt(request.getParameter("customer_id"));
//        String name = request.getParameter("name");
//        String address = request.getParameter("address");
//        String telephone = request.getParameter("telephone");
//        String password = request.getParameter("password");
//
//        try (Connection conn = DBUtil.getConnection()) {
//            String updateQuery;
//            PreparedStatement stmt;
//
//            if (password != null && !password.trim().isEmpty()) {
//                // Password is filled -> hash and update it
//                String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
//                updateQuery = "UPDATE customer SET name = ?, address = ?, telephone = ?, password = ? WHERE customer_id = ?";
//                stmt = conn.prepareStatement(updateQuery);
//                stmt.setString(1, name);
//                stmt.setString(2, address);
//                stmt.setString(3, telephone);
//                stmt.setString(4, hashedPassword);
//                stmt.setInt(5, customerId);
//            } else {
//                // Password not filled -> do not update it
//                updateQuery = "UPDATE customer SET name = ?, address = ?, telephone = ? WHERE customer_id = ?";
//                stmt = conn.prepareStatement(updateQuery);
//                stmt.setString(1, name);
//                stmt.setString(2, address);
//                stmt.setString(3, telephone);
//                stmt.setInt(4, customerId);
//            }
//
//            stmt.executeUpdate();
//            response.sendRedirect("customer-dashboard.jsp");
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendRedirect("error.jsp");
//        }
//    }
//}





package com.pahanaedu.servlets;

import com.pahanaedu.util.DBUtil;
import org.mindrot.jbcrypt.BCrypt;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/UpdateMyAccountServlet")
public class UpdateMyAccountServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get user inputs
            int customerId = Integer.parseInt(request.getParameter("customer_id"));
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String telephone = request.getParameter("telephone");
            String email = request.getParameter("email"); // Added email parameter
            String password = request.getParameter("password");

            // Establish connection
            try (Connection conn = DBUtil.getConnection()) {
                String updateQuery;
                PreparedStatement stmt;

                // Check if password is filled
                if (password != null && !password.trim().isEmpty()) {
                    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
                    updateQuery = "UPDATE customer SET name = ?, address = ?, telephone = ?, email = ?, password = ? WHERE customer_id = ?";
                    stmt = conn.prepareStatement(updateQuery);
                    stmt.setString(1, name);
                    stmt.setString(2, address);
                    stmt.setString(3, telephone);
                    stmt.setString(4, email);
                    stmt.setString(5, hashedPassword);
                    stmt.setInt(6, customerId);
                } else {
                    updateQuery = "UPDATE customer SET name = ?, address = ?, telephone = ?, email = ? WHERE customer_id = ?";
                    stmt = conn.prepareStatement(updateQuery);
                    stmt.setString(1, name);
                    stmt.setString(2, address);
                    stmt.setString(3, telephone);
                    stmt.setString(4, email);
                    stmt.setInt(5, customerId);
                }

                // Execute update
                int rowsUpdated = stmt.executeUpdate();

                if (rowsUpdated > 0) {
                    // Optionally update session if you store user details in session
                    HttpSession session = request.getSession(false);
                    if (session != null) {
                        session.setAttribute("name", name);
                        session.setAttribute("address", address);
                        session.setAttribute("telephone", telephone);
                        session.setAttribute("email", email);
                    }
                    response.sendRedirect("customer-dashboard.jsp?update=success");
                } else {
                    response.sendRedirect("customer-dashboard.jsp?update=fail");
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=update_error");
        }
    }
}
