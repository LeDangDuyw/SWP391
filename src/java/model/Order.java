package model;

import java.math.BigDecimal;

public class Order {
    private int orderId;
    private BigDecimal totalAmount;
    private BigDecimal shippingFee;
    private String orderStatus;
    private String shippingReceiver;
    private String shippingPhone;
    private String shippingAddress;
    private String orderCode;
    private Integer userId;
    private Integer voucherId;

    public Order() {
    }

    public Order(int orderId, BigDecimal totalAmount, BigDecimal shippingFee, String orderStatus,
                 String shippingReceiver, String shippingPhone, String shippingAddress, String orderCode,
                 Integer userId, Integer voucherId) {
        this.orderId = orderId;
        this.totalAmount = totalAmount;
        this.shippingFee = shippingFee;
        this.orderStatus = orderStatus;
        this.shippingReceiver = shippingReceiver;
        this.shippingPhone = shippingPhone;
        this.shippingAddress = shippingAddress;
        this.orderCode = orderCode;
        this.userId = userId;
        this.voucherId = voucherId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(BigDecimal shippingFee) {
        this.shippingFee = shippingFee;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getShippingReceiver() {
        return shippingReceiver;
    }

    public void setShippingReceiver(String shippingReceiver) {
        this.shippingReceiver = shippingReceiver;
    }

    public String getShippingPhone() {
        return shippingPhone;
    }

    public void setShippingPhone(String shippingPhone) {
        this.shippingPhone = shippingPhone;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(Integer voucherId) {
        this.voucherId = voucherId;
    }
}
