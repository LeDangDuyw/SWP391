package model;

public class VariantSpecification {
    private int variantSpecificationId;
    private int variantId;
    private int specificationId;
    private String specificationName;
    private String value;

    public VariantSpecification() {
    }

    public VariantSpecification(int variantSpecificationId, int variantId, int specificationId, String specificationName, String value) {
        this.variantSpecificationId = variantSpecificationId;
        this.variantId = variantId;
        this.specificationId = specificationId;
        this.specificationName = specificationName;
        this.value = value;
    }

    public int getVariantSpecificationId() {
        return variantSpecificationId;
    }

    public void setVariantSpecificationId(int variantSpecificationId) {
        this.variantSpecificationId = variantSpecificationId;
    }

    public int getVariantId() {
        return variantId;
    }

    public void setVariantId(int variantId) {
        this.variantId = variantId;
    }

    public int getSpecificationId() {
        return specificationId;
    }

    public void setSpecificationId(int specificationId) {
        this.specificationId = specificationId;
    }

    public String getSpecificationName() {
        return specificationName;
    }

    public void setSpecificationName(String specificationName) {
        this.specificationName = specificationName;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
