package model;

import java.sql.Timestamp;

public class AccountActivationToken {
    private int tokenId;
    private int userId;
    private String token;
    private Timestamp expiresAt;
    private boolean isUsed;

    public AccountActivationToken() {
    }

    public AccountActivationToken(int tokenId, int userId, String token, Timestamp expiresAt, boolean isUsed) {
        this.tokenId = tokenId;
        this.userId = userId;
        this.token = token;
        this.expiresAt = expiresAt;
        this.isUsed = isUsed;
    }

    public int getTokenId() {
        return tokenId;
    }

    public void setTokenId(int tokenId) {
        this.tokenId = tokenId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isUsed() {
        return isUsed;
    }

    public void setUsed(boolean used) {
        isUsed = used;
    }
}
