package model;

import java.time.LocalDateTime;

public class OrderItemSerial {
    private int orderItemSerialId;
    private int orderDetailId;
    private int itemId;
    private LocalDateTime assignedAt;

    public OrderItemSerial() {
    }

    public OrderItemSerial(int orderItemSerialId, int orderDetailId, int itemId, LocalDateTime assignedAt) {
        this.orderItemSerialId = orderItemSerialId;
        this.orderDetailId = orderDetailId;
        this.itemId = itemId;
        this.assignedAt = assignedAt;
    }

    public int getOrderItemSerialId() {
        return orderItemSerialId;
    }

    public void setOrderItemSerialId(int orderItemSerialId) {
        this.orderItemSerialId = orderItemSerialId;
    }

    public int getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public LocalDateTime getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(LocalDateTime assignedAt) {
        this.assignedAt = assignedAt;
    }
}
