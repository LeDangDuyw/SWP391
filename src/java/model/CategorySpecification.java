package model;

public class CategorySpecification {
    private int categoryId;
    private int specificationId;
    private String specificationName;
    private int displayOrder;

    public CategorySpecification() {
    }

    public CategorySpecification(int categoryId, int specificationId, String specificationName, int displayOrder) {
        this.categoryId = categoryId;
        this.specificationId = specificationId;
        this.specificationName = specificationName;
        this.displayOrder = displayOrder;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
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

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }
}
