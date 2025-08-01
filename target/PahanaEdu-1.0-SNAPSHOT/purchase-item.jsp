<%@ page session="true" %>
<%@ page import="java.sql.*, com.pahanaedu.util.DBUtil" %>

<%
    Integer customerId = (Integer) session.getAttribute("customerId");
    if (customerId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int itemId = Integer.parseInt(request.getParameter("item_id"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            PreparedStatement ps1 = conn.prepareStatement("SELECT unit_price, stock FROM item WHERE item_id = ?");
            ps1.setInt(1, itemId);
            ResultSet rs1 = ps1.executeQuery();

            if (rs1.next()) {
                double unitPrice = rs1.getDouble("unit_price");
                int currentStock = rs1.getInt("stock");

                if (quantity <= currentStock) {
                    double totalAmount = unitPrice * quantity;

                    PreparedStatement ps2 = conn.prepareStatement(
                        "INSERT INTO bill (customer_id, item_id, quantity, total_amount, bill_date) VALUES (?, ?, ?, ?, NOW())"
                    );
                    ps2.setInt(1, customerId);
                    ps2.setInt(2, itemId);
                    ps2.setInt(3, quantity);
                    ps2.setDouble(4, totalAmount);
                    ps2.executeUpdate();

                    PreparedStatement ps3 = conn.prepareStatement("UPDATE item SET stock = stock - ? WHERE item_id = ?");
                    ps3.setInt(1, quantity);
                    ps3.setInt(2, itemId);
                    ps3.executeUpdate();

                    conn.commit();

                    // Redirect back to dashboard with success message (optional)
                    response.sendRedirect("customer-dashboard.jsp?purchase=success");
                    return;
                } else {
                    conn.rollback();
                    out.println("<script>alert('Not enough stock available!'); window.history.back();</script>");
                    return;
                }
            } else {
                conn.rollback();
                out.println("<script>alert('Item not found!'); window.history.back();</script>");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Purchase failed: " + e.getMessage() + "'); window.history.back();</script>");
            return;
        }
    } else {
        response.sendRedirect("customer-dashboard.jsp");
    }
%>
