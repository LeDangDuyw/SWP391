package model;

import java.sql.Timestamp;

public class ChatbotFeedbackDTO {
    private int feedbackId;
    private int userId;
    private String userName;
    private String userEmail;
    private String sessionId;
    private int rating;
    private String comment;
    private String aiQuestion;
    private String aiAnswer;
    private Timestamp createdAt;

    public ChatbotFeedbackDTO() {}

    public int getFeedbackId() { return feedbackId; }
    public void setFeedbackId(int feedbackId) { this.feedbackId = feedbackId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public String getAiQuestion() { return aiQuestion; }
    public void setAiQuestion(String aiQuestion) { this.aiQuestion = aiQuestion; }

    public String getAiAnswer() { return aiAnswer; }
    public void setAiAnswer(String aiAnswer) { this.aiAnswer = aiAnswer; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
