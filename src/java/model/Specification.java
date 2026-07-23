package model;

public class Specification {
    private int specificationId;
    private String specificationName;

    public Specification() {
    }

    public Specification(int specificationId, String specificationName) {
        this.specificationId = specificationId;
        this.specificationName = specificationName;
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
}
