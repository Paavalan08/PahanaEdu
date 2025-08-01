//package com.pahanaedu.model;
//
//public class Customer {
//    private int customerId;
//    private String accountNumber;
//    private String name;
//    private String address;
//    private String telephone;
//    private String username;
//    private String password;
//
//    // Getters and Setters
//    public int getCustomerId() { return customerId; }
//    public void setCustomerId(int customerId) { this.customerId = customerId; }
//
//    public String getAccountNumber() { return accountNumber; }
//    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }
//
//    public String getName() { return name; }
//    public void setName(String name) { this.name = name; }
//
//    public String getAddress() { return address; }
//    public void setAddress(String address) { this.address = address; }
//
//    public String getTelephone() { return telephone; }
//    public void setTelephone(String telephone) { this.telephone = telephone; }
//
//    public String getUsername() { return username; }
//    public void setUsername(String username) { this.username = username; }
//
//    public String getPassword() { return password; }
//    public void setPassword(String password) { this.password = password; }
//}





package com.pahanaedu.model;

public class Customer {
    private int customerId;
    private String accountNumber;
    private String name;
    private String address;
    private String telephone;
    private String username;
    private String password;
    private String email; // ✅ New field added

    // Getters and Setters
    public int getCustomerId() {
        return customerId;
    }
    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getAccountNumber() {
        return accountNumber;
    }
    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }

    public String getTelephone() {
        return telephone;
    }
    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() { // ✅ New getter
        return email;
    }
    public void setEmail(String email) { // ✅ New setter
        this.email = email;
    }
}
