package model;

import java.sql.Timestamp;

public class ProductReview {
    private int reviewId;
    private int productId;
    private int userId;
    private int rating;
    private String comment;
    private Timestamp createdAt;
    private String status;
    private Integer moderatedBy;
    private Timestamp moderatedAt;
    
    // For joining with the User table to display their name
    private String userFullName;

    public ProductReview() {}

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

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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

    public Timestamp getModeratedAt() {
        return moderatedAt;
    }

    public void setModeratedAt(Timestamp moderatedAt) {
        this.moderatedAt = moderatedAt;
    }

    public String getUserFullName() {
        return userFullName;
    }

    public void setUserFullName(String userFullName) {
        this.userFullName = userFullName;
    }
}
