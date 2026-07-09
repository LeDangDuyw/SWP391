package model;

import java.sql.Timestamp;

public class StudentVerification {
    private int verificationId;
    private int userId;
    private String studentCardImage;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String staffNote;

    // Join data for user info display
    private String userName;
    private String userEmail;
    private String userPhone;

    public StudentVerification() {
    }

    public StudentVerification(int verificationId, int userId, String studentCardImage, String status, Timestamp createdAt, Timestamp updatedAt, String staffNote) {
        this.verificationId = verificationId;
        this.userId = userId;
        this.studentCardImage = studentCardImage;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.staffNote = staffNote;
    }

    public int getVerificationId() {
        return verificationId;
    }

    public void setVerificationId(int verificationId) {
        this.verificationId = verificationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getStudentCardImage() {
        return studentCardImage;
    }

    public void setStudentCardImage(String studentCardImage) {
        this.studentCardImage = studentCardImage;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getStaffNote() {
        return staffNote;
    }

    public void setStaffNote(String staffNote) {
        this.staffNote = staffNote;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getUserPhone() {
        return userPhone;
    }

    public void setUserPhone(String userPhone) {
        this.userPhone = userPhone;
    }
}
