/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author NC
 */
public class ProductReview {
    private int reviewId;
    private int productId;
    private String productName;    // Tên sản phẩm hiển thị
    private int userId;
    private String userName;        // Tên khách hàng đánh giá (reviewer)
    private int rating;
    private String comment;
    private Timestamp createdAt;
    private String status;          // pending, approved, hidden
    private Integer moderatedBy;
    private String moderatorName;   // Tên nhân viên duyệt
    private Timestamp moderatedAt;
    
    // Các trường phục vụ chức năng Trả lời (Reply)
    private String replyContent;
    private Integer repliedBy;
    private String replierName;     // Tên nhân viên trả lời
    private Timestamp repliedAt;

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
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

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getModeratedBy() {
        return moderatedBy;
    }

    public void setModeratedBy(Integer moderatedBy) {
        this.moderatedBy = moderatedBy;
    }

    public String getModeratorName() {
        return moderatorName;
    }

    public void setModeratorName(String moderatorName) {
        this.moderatorName = moderatorName;
    }

    public Timestamp getModeratedAt() {
        return moderatedAt;
    }

    public void setModeratedAt(Timestamp moderatedAt) {
        this.moderatedAt = moderatedAt;
    }

    public String getReplyContent() {
        return replyContent;
    }

    public void setReplyContent(String replyContent) {
        this.replyContent = replyContent;
    }

    public Integer getRepliedBy() {
        return repliedBy;
    }

    public void setRepliedBy(Integer repliedBy) {
        this.repliedBy = repliedBy;
    }

    public String getReplierName() {
        return replierName;
    }

    public void setReplierName(String replierName) {
        this.replierName = replierName;
    }

    public Timestamp getRepliedAt() {
        return repliedAt;
    }

    public void setRepliedAt(Timestamp repliedAt) {
        this.repliedAt = repliedAt;
    }

    public ProductReview() {
    }

    public ProductReview(int reviewId, int productId, String productName, int userId, String userName, int rating, String comment, Timestamp createdAt, String status, Integer moderatedBy, String moderatorName, Timestamp moderatedAt, String replyContent, Integer repliedBy, String replierName, Timestamp repliedAt) {
        this.reviewId = reviewId;
        this.productId = productId;
        this.productName = productName;
        this.userId = userId;
        this.userName = userName;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
        this.status = status;
        this.moderatedBy = moderatedBy;
        this.moderatorName = moderatorName;
        this.moderatedAt = moderatedAt;
        this.replyContent = replyContent;
        this.repliedBy = repliedBy;
        this.replierName = replierName;
        this.repliedAt = repliedAt;
    }
    
}
