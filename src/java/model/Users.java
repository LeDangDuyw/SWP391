/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author LUCTVHE201874
 * @author AI One
 */
public class Users {
    public int userId;
    public String userName,email,phone,password;
    public String status;
    public boolean status;
    public int roleId;
    public String avatarUrl;

    public Users() {
    }

    public Users(int userId, String userName, String email, String phone, String password, String status, int roleId) {
    public Users(int userId, String userName, String email, String phone, String password, boolean status, int roleId) {
        this.userId = userId;
        this.userName = userName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.status = status;
        this.roleId = roleId;
    }

    public Users(int userId, String userName, String email, String phone, String password, String status, int roleId, String avatarUrl) {
        this.userId = userId;
        this.userName = userName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.status = status;
        this.roleId = roleId;
        this.avatarUrl = avatarUrl;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isStatus() {
        return "active".equalsIgnoreCase(status);
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public int getRoleId() {
        return roleId;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public java.sql.Timestamp createdAt;
    public java.sql.Timestamp updatedAt;
    public java.sql.Timestamp lastLoginAt;

    public java.sql.Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.sql.Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public java.sql.Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(java.sql.Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public java.sql.Timestamp getLastLoginAt() {
        return lastLoginAt;
    }

    public void setLastLoginAt(java.sql.Timestamp lastLoginAt) {
        this.lastLoginAt = lastLoginAt;
    }
}
