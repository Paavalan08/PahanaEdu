//package com.pahanaedu.servlets;
//
//import com.pahanaedu.util.DBUtil;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
//import java.io.IOException;
//import java.sql.*;
//
//@WebServlet("/login")
//public class LoginServlet extends HttpServlet {
//
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String username = request.getParameter("username");
//        String password = request.getParameter("password");
//        String role = request.getParameter("role");
//
//        try (Connection conn = DBUtil.getConnection()) {
//            String query = "";
//            if ("admin".equals(role)) {
//                query = "SELECT * FROM admin WHERE username = ? AND password = ?";
//            } else if ("customer".equals(role)) {
//                query = "SELECT * FROM customer WHERE username = ? AND password = ?";
//            }
//
//            PreparedStatement stmt = conn.prepareStatement(query);
//            stmt.setString(1, username);
//            stmt.setString(2, password);
//
//            ResultSet rs = stmt.executeQuery();
//
//            if (rs.next()) {
//                HttpSession session = request.getSession();
//                session.setAttribute("username", username);
//                session.setAttribute("role", role);
//
//                if ("admin".equals(role)) {
//                    response.sendRedirect("admin-dashboard.jsp");
//                } else {
//                    // Fetch full name and customer ID for session
//                    String fullName = rs.getString("name");
//                    int customerId = rs.getInt("customer_id");
//
//                    session.setAttribute("name", fullName);
//                    session.setAttribute("customerId", customerId);
//
//                    response.sendRedirect("customer-dashboard.jsp");
//                }
//
//            } else {
//                request.setAttribute("error", "Invalid username or password.");
//                request.getRequestDispatcher("login.jsp").forward(request, response);
//            }
//        } catch (Exception e) {
//            throw new ServletException("Login failed", e);
//        }
//    }
//}



package com.pahanaedu.servlets;

import com.pahanaedu.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try (Connection conn = DBUtil.getConnection()) {
            String query;
            if ("admin".equals(role)) {
                query = "SELECT * FROM admin WHERE username = ?";
            } else if ("customer".equals(role)) {
                query = "SELECT * FROM customer WHERE username = ?";
            } else {
                request.setAttribute("error", "Invalid role selected.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String hashedPassword = rs.getString("password");

                // Compare input password with stored hashed password
                if (BCrypt.checkpw(password, hashedPassword)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    session.setAttribute("role", role);

                    if ("admin".equals(role)) {
                        response.sendRedirect("admin-dashboard.jsp");
                    } else {
                        // Fetch full name and customer ID for session
                        String fullName = rs.getString("name");
                        int customerId = rs.getInt("customer_id");

                        session.setAttribute("name", fullName);
                        session.setAttribute("customerId", customerId);

                        response.sendRedirect("customer-dashboard.jsp");
                    }
                } else {
                    // Password incorrect
                    request.setAttribute("error", "Invalid username or password.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }

            } else {
                // No such user
                request.setAttribute("error", "Invalid username or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException("Login failed", e);
        }
    }
}
