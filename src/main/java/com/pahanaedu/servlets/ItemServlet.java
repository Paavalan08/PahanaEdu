package com.pahanaedu.servlets;

import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.model.Item;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/item")
public class ItemServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add":
                    String name = request.getParameter("itemName");
                    double price = Double.parseDouble(request.getParameter("unitPrice"));
                    int stock = Integer.parseInt(request.getParameter("stock"));

                    Item newItem = new Item();
                    newItem.setItemName(name);
                    newItem.setUnitPrice(price);
                    newItem.setStock(stock);
                    ItemDAO.addItem(newItem);
                    response.sendRedirect("item-list.jsp");
                    break;

                case "update":
                    int id = Integer.parseInt(request.getParameter("itemId"));
                    String itemName = request.getParameter("itemName");
                    double itemPrice = Double.parseDouble(request.getParameter("unitPrice"));
                    int itemStock = Integer.parseInt(request.getParameter("stock"));

                    Item updatedItem = new Item(id, itemName, itemPrice, itemStock);
                    ItemDAO.updateItem(updatedItem);
                    response.sendRedirect("item-list.jsp");
                    break;

                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.getWriter().println("Error: Invalid number format. " + e.getMessage());
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            ItemDAO.deleteItem(id);
            response.sendRedirect("item-list.jsp");
        }
    }
}
