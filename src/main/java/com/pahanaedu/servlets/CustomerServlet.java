package com.pahanaedu.servlets;

import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/CustomerServlet")
public class CustomerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        CustomerDAO dao = new CustomerDAO();

        if ("add".equals(action)) {
            Customer customer = new Customer();
            customer.setAccountNumber(request.getParameter("accountNumber"));
            customer.setName(request.getParameter("name"));
            customer.setAddress(request.getParameter("address"));
            customer.setTelephone(request.getParameter("telephone"));
            customer.setUsername(request.getParameter("username"));
            customer.setPassword(request.getParameter("password"));
            customer.setEmail(request.getParameter("email")); // ✅ Added email field

            if (dao.addCustomer(customer)) {
                response.sendRedirect("customer-list.jsp");
            } else {
                response.sendRedirect("add-customer.jsp");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        CustomerDAO dao = new CustomerDAO();

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.deleteCustomer(id)) {
                response.sendRedirect("customer-list.jsp");
            } else {
                response.sendRedirect("customer-list.jsp");
            }
        }
    }
}
