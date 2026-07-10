package model;

import java.sql.Timestamp;

public class ChatbotSecurityLogDTO {
    private int logId;
    private int userId;
    private String userName;
    private String userEmail;
    private String sessionId;
    private String violationType;
    private String violatedMessage;
    private Timestamp createdAt;
    private String status;
    private boolean isUserBlocked; // Trạng thái chặn hiện tại của user này

    public ChatbotSecurityLogDTO() {}

    public int getLogId() { return logId; }
    public void setLogId(int logId) { this.logId = logId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public String getViolationType() { return violationType; }
    public void setViolationType(String violationType) { this.violationType = violationType; }

    public String getViolatedMessage() { return violatedMessage; }
    public void setViolatedMessage(String violatedMessage) { this.violatedMessage = violatedMessage; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isUserBlocked() { return isUserBlocked; }
    public void setUserBlocked(boolean userBlocked) { isUserBlocked = userBlocked; }
}
