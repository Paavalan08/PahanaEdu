//package com.pahanaedu.dao;
//
//import com.pahanaedu.model.Customer;
//import com.pahanaedu.util.DBUtil;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//
//public class CustomerDAO {
//
//    public List<Customer> getAllCustomers() {
//        List<Customer> customers = new ArrayList<>();
//        String sql = "SELECT * FROM customer";
//        try (Connection conn = DBUtil.getConnection();
//             Statement stmt = conn.createStatement();
//             ResultSet rs = stmt.executeQuery(sql)) {
//            while (rs.next()) {
//                Customer customer = new Customer();
//                customer.setCustomerId(rs.getInt("customer_id"));
//                customer.setAccountNumber(rs.getString("account_number"));
//                customer.setName(rs.getString("name"));
//                customer.setAddress(rs.getString("address"));
//                customer.setTelephone(rs.getString("telephone"));
//                customer.setUsername(rs.getString("username"));
//                customer.setPassword(rs.getString("password"));
//                customers.add(customer);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return customers;
//    }
//
//    public boolean addCustomer(Customer customer) {
//        String sql = "INSERT INTO customer (account_number, name, address, telephone, username, password) VALUES (?, ?, ?, ?, ?, ?)";
//        try (Connection conn = DBUtil.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setString(1, customer.getAccountNumber());
//            stmt.setString(2, customer.getName());
//            stmt.setString(3, customer.getAddress());
//            stmt.setString(4, customer.getTelephone());
//            stmt.setString(5, customer.getUsername());
//            stmt.setString(6, customer.getPassword());
//            return stmt.executeUpdate() > 0;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//
//    public Customer getCustomerById(int id) {
//        Customer customer = null;
//        String sql = "SELECT * FROM customer WHERE customer_id = ?";
//        try (Connection conn = DBUtil.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setInt(1, id);
//            ResultSet rs = stmt.executeQuery();
//            if (rs.next()) {
//                customer = new Customer();
//                customer.setCustomerId(rs.getInt("customer_id"));
//                customer.setAccountNumber(rs.getString("account_number"));
//                customer.setName(rs.getString("name"));
//                customer.setAddress(rs.getString("address"));
//                customer.setTelephone(rs.getString("telephone"));
//                customer.setUsername(rs.getString("username"));
//                customer.setPassword(rs.getString("password"));
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return customer;
//    }
//
//    public boolean updateCustomer(Customer customer) {
//        String sql = "UPDATE customer SET account_number = ?, name = ?, address = ?, telephone = ?, username = ?, password = ? WHERE customer_id = ?";
//        try (Connection conn = DBUtil.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setString(1, customer.getAccountNumber());
//            stmt.setString(2, customer.getName());
//            stmt.setString(3, customer.getAddress());
//            stmt.setString(4, customer.getTelephone());
//            stmt.setString(5, customer.getUsername());
//            stmt.setString(6, customer.getPassword());
//            stmt.setInt(7, customer.getCustomerId());
//            return stmt.executeUpdate() > 0;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//
//    public boolean deleteCustomer(int id) {
//        String sql = "DELETE FROM customer WHERE customer_id = ?";
//        try (Connection conn = DBUtil.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setInt(1, id);
//            return stmt.executeUpdate() > 0;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//}



package com.pahanaedu.dao;

import com.pahanaedu.model.Customer;
import com.pahanaedu.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customer";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setAccountNumber(rs.getString("account_number"));
                customer.setName(rs.getString("name"));
                customer.setAddress(rs.getString("address"));
                customer.setTelephone(rs.getString("telephone"));
                customer.setUsername(rs.getString("username"));
                customer.setPassword(rs.getString("password"));
                customer.setEmail(rs.getString("email")); // new line
                customers.add(customer);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return customers;
    }

    public boolean addCustomer(Customer customer) {
        String sql = "INSERT INTO customer (account_number, name, address, telephone, username, password, email) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, customer.getAccountNumber());
            stmt.setString(2, customer.getName());
            stmt.setString(3, customer.getAddress());
            stmt.setString(4, customer.getTelephone());
            stmt.setString(5, customer.getUsername());
            stmt.setString(6, customer.getPassword());
            stmt.setString(7, customer.getEmail()); // new line
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Customer getCustomerById(int id) {
        Customer customer = null;
        String sql = "SELECT * FROM customer WHERE customer_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setAccountNumber(rs.getString("account_number"));
                customer.setName(rs.getString("name"));
                customer.setAddress(rs.getString("address"));
                customer.setTelephone(rs.getString("telephone"));
                customer.setUsername(rs.getString("username"));
                customer.setPassword(rs.getString("password"));
                customer.setEmail(rs.getString("email")); // new line
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return customer;
    }

    public boolean updateCustomer(Customer customer) {
        String sql = "UPDATE customer SET account_number = ?, name = ?, address = ?, telephone = ?, username = ?, password = ?, email = ? WHERE customer_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, customer.getAccountNumber());
            stmt.setString(2, customer.getName());
            stmt.setString(3, customer.getAddress());
            stmt.setString(4, customer.getTelephone());
            stmt.setString(5, customer.getUsername());
            stmt.setString(6, customer.getPassword());
            stmt.setString(7, customer.getEmail()); // new line
            stmt.setInt(8, customer.getCustomerId());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteCustomer(int id) {
        String sql = "DELETE FROM customer WHERE customer_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
