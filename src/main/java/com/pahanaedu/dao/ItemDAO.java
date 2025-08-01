package com.pahanaedu.dao;

import com.pahanaedu.model.Item;
import com.pahanaedu.util.DBUtil;
import java.sql.*;
import java.util.*;
import com.pahanaedu.model.Item;

public class ItemDAO {

    public static List<Item> getAllItems() {
        List<Item> itemList = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT * FROM item";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setItemName(rs.getString("item_name"));
                item.setUnitPrice(rs.getDouble("unit_price"));
                item.setStock(rs.getInt("stock"));
                itemList.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return itemList;
    }

    public static void addItem(Item item) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "INSERT INTO item (item_name, unit_price, stock) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, item.getItemName());
            stmt.setDouble(2, item.getUnitPrice());
            stmt.setInt(3, item.getStock());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
//
//    public static Item getItemById(int id) {
//        Item item = new Item();
//        try (Connection conn = DBUtil.getConnection()) {
//            String sql = "SELECT * FROM item WHERE item_id=?";
//            PreparedStatement stmt = conn.prepareStatement(sql);
//            stmt.setInt(1, id);
//            ResultSet rs = stmt.executeQuery();
//            if (rs.next()) {
//                item.setItemId(rs.getInt("item_id"));
//                item.setItemName(rs.getString("item_name"));
//                item.setUnitPrice(rs.getDouble("unit_price"));
//                item.setStock(rs.getInt("stock"));
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return item;
//    }
    
      public static Item getItemById(int id) {
        Item item = null; // Return null if not found
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT * FROM item WHERE item_id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setItemName(rs.getString("item_name"));
                item.setUnitPrice(rs.getDouble("unit_price"));
                item.setStock(rs.getInt("stock"));
            }
            rs.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return item;
    }

    public static void updateItem(Item item) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "UPDATE item SET item_name=?, unit_price=?, stock=? WHERE item_id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, item.getItemName());
            stmt.setDouble(2, item.getUnitPrice());
            stmt.setInt(3, item.getStock());
            stmt.setInt(4, item.getItemId());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void deleteItem(int id) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "DELETE FROM item WHERE item_id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // ItemDAO.java

public boolean reduceStock(int itemId, int quantity) {
    boolean updated = false;
    try (Connection conn = DBUtil.getConnection()) {
        String sql = "UPDATE item SET stock = stock - ? WHERE item_id = ? AND stock >= ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, quantity);
        stmt.setInt(2, itemId);
        stmt.setInt(3, quantity);

        int rows = stmt.executeUpdate();
        updated = rows > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return updated;
}

public static List<Item> searchItemsByName(String name) {
    List<Item> itemList = new ArrayList<>();
    try (Connection conn = DBUtil.getConnection()) {
        String sql = "SELECT * FROM item WHERE LOWER(item_name) LIKE ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, "%" + name.toLowerCase() + "%");
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            Item item = new Item();
            item.setItemId(rs.getInt("item_id"));
            item.setItemName(rs.getString("item_name"));
            item.setUnitPrice(rs.getDouble("unit_price"));
            item.setStock(rs.getInt("stock"));
            itemList.add(item);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return itemList;
}


}
