<%--<%@ page import="dao.ItemDAO" %>
<%@ page import="model.Item" %>
<%@ page contentType="text/plain;charset=UTF-8" %>
<%
    String itemId = request.getParameter("itemId");
    String quantityStr = request.getParameter("quantity");

    if (itemId != null && quantityStr != null) {
        int itemIdInt = Integer.parseInt(itemId);
        int quantity = Integer.parseInt(quantityStr);

        // Fetch item details from database
        Item item = new ItemDAO().getItemById(itemIdInt); // Assuming you have this method

        if (item != null) {
            double totalAmount = item.getUnitPrice() * quantity;
            out.print(totalAmount); // Output the calculated total
        } else {
            out.print("0"); // If no item is found
        }
    } else {
        out.print("0"); // If itemId or quantity is missing
    }
%>--%>

<%@ page import="com.pahanaedu.dao.ItemDAO" %>
<%@ page import="com.pahanaedu.model.Item" %>
<%@ page contentType="text/plain;charset=UTF-8" %>
<%
    String itemId = request.getParameter("itemId");
    String quantityStr = request.getParameter("quantity");

    try {
        if (itemId != null && quantityStr != null) {
            int itemIdInt = Integer.parseInt(itemId);
            int quantity = Integer.parseInt(quantityStr);

            if (quantity > 0) {
                Item item = ItemDAO.getItemById(itemIdInt);
                if (item != null) {
                    double totalAmount = item.getUnitPrice() * quantity;
                    out.print(totalAmount);
                } else {
                    out.print("0"); // No item found
                }
            } else {
                out.print("0"); // Quantity invalid
            }
        } else {
            out.print("0"); // Missing parameters
        }
    } catch (NumberFormatException e) {
        out.print("0"); // Invalid number format
    } catch (Exception e) {
        e.printStackTrace();
        out.print("0"); // Other errors
    }
%>
