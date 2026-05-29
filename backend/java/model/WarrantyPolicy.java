/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Lenovo
 */
public class WarrantyPolicy {
    private int policyId;
    private String policyName;
    private String description;
    private int warrantyMonths;

    public WarrantyPolicy() {
    }

    public WarrantyPolicy(int policyId, String policyName, String description, int warrantyMonths) {
        this.policyId = policyId;
        this.policyName = policyName;
        this.description = description;
        this.warrantyMonths = warrantyMonths;
    }

    public int getPolicyId() {
        return policyId;
    }

    public void setPolicyId(int policyId) {
        this.policyId = policyId;
    }

    public String getPolicyName() {
        return policyName;
    }

    public void setPolicyName(String policyName) {
        this.policyName = policyName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getWarrantyMonths() {
        return warrantyMonths;
    }

    public void setWarrantyMonths(int warrantyMonths) {
        this.warrantyMonths = warrantyMonths;
    }
    
    
}
