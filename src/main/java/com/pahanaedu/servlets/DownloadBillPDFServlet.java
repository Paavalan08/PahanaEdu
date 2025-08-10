package com.pahanaedu.servlets;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import com.pahanaedu.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;

@WebServlet("/DownloadBillPDFServlet")
public class DownloadBillPDFServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // Read bill_id parameter
        String billIdParam = request.getParameter("bill_id");
        if (billIdParam == null || billIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing bill_id parameter.");
            return;
        }

        int billId;
        try {
            billId = Integer.parseInt(billIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid bill_id parameter.");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        // Set response headers for PDF download
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=bill_" + billId + ".pdf");

        Document document = new Document(PageSize.A4, 36, 36, 54, 36);

        try {
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Title
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.BLACK);
            Paragraph title = new Paragraph("Billing Record - Bill ID: " + billId, titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            // Query DB for the single bill
            conn = DBUtil.getConnection();
            String sql = "SELECT b.bill_id, c.account_number, b.item_id, b.quantity, b.total_amount, b.bill_date " +
                         "FROM bill b JOIN customer c ON b.customer_id = c.customer_id WHERE b.bill_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, billId);
            rs = stmt.executeQuery();

            if (!rs.next()) {
                // No record found, write message to PDF
                Font msgFont = FontFactory.getFont(FontFactory.HELVETICA, 12, BaseColor.RED);
                document.add(new Paragraph("No billing record found for Bill ID: " + billId, msgFont));
                return; // end PDF here
            }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Font labelFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.DARK_GRAY);
            Font valueFont = FontFactory.getFont(FontFactory.HELVETICA, 12, BaseColor.BLACK);

            // Add bill info as paragraphs
            document.add(new Paragraph("Account Number: " + rs.getString("account_number"), labelFont));
            document.add(new Paragraph("Item ID: " + rs.getInt("item_id"), labelFont));
            document.add(new Paragraph("Quantity: " + rs.getInt("quantity"), labelFont));
            document.add(new Paragraph(String.format("Total Amount (LKR): %, .2f", rs.getDouble("total_amount")), labelFont));
            document.add(new Paragraph("Bill Date: " + sdf.format(rs.getTimestamp("bill_date")), labelFont));

            // Or you can add a table if you want, but for one bill, paragraphs are clean

        } catch (Exception e) {
            e.printStackTrace();
            try {
                document.add(new Paragraph("Error generating PDF: " + e.getMessage()));
            } catch (DocumentException de) {
                de.printStackTrace();
            }
        } finally {
            document.close();

            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
