package com.pahanaedu.model;

public class Item {
    private int itemId;
    private String itemName;
    private double unitPrice;
    private int stock;

    // Constructor
    public Item() {}

    public Item(int itemId, String itemName, double unitPrice, int stock) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.unitPrice = unitPrice;
        this.stock = stock;
    }

    // Getters
    public int getItemId() { return itemId; }
    public String getItemName() { return itemName; }
    public double getUnitPrice() { return unitPrice; }
    public int getStock() { return stock; }

    // Setters
    public void setItemId(int itemId) { this.itemId = itemId; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }
    public void setStock(int stock) { this.stock = stock; }
}
