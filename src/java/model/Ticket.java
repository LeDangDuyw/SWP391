package model;

import java.time.LocalDateTime;
import java.util.List;

public class Ticket {
    private int ticketId;
    private String title;
    private String status;
    private String reason;
    private int createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    private List<TicketDetail> details;

    public Ticket() {
    }

    public Ticket(int ticketId, String title, String status, String reason, int createdBy, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.ticketId = ticketId;
        this.title = title;
        this.status = status;
        this.reason = reason;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getTicketId() {
        return ticketId;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<TicketDetail> getDetails() {
        return details;
    }

    public void setDetails(List<TicketDetail> details) {
        this.details = details;
    }

    public java.math.BigDecimal getTotalValue() {
        java.math.BigDecimal total = java.math.BigDecimal.ZERO;
        if (details != null) {
            for (TicketDetail d : details) {
                if (d.getExpectedPrice() != null) {
                    total = total.add(d.getExpectedPrice().multiply(new java.math.BigDecimal(d.getQuantity())));
                }
            }
        }
        return total;
    }
}
