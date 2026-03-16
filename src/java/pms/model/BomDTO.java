package pms.model;

public class BOMDTO {

    private int bomId;
    private int productItemId;
    private int materialItemId;
    private int quantityRequired;

    public BOMDTO() {
    }

    public BOMDTO(int bomId, int productItemId, int materialItemId, int quantityRequired) {
        this.bomId = bomId;
        this.productItemId = productItemId;
        this.materialItemId = materialItemId;
        this.quantityRequired = quantityRequired;
    }

    public int getBomId() {
        return bomId;
    }

    public void setBomId(int bomId) {
        this.bomId = bomId;
    }

    public int getProductItemId() {
        return productItemId;
    }

    public void setProductItemId(int productItemId) {
        this.productItemId = productItemId;
    }

    public int getMaterialItemId() {
        return materialItemId;
    }

    public void setMaterialItemId(int materialItemId) {
        this.materialItemId = materialItemId;
    }

    public int getQuantityRequired() {
        return quantityRequired;
    }

    public void setQuantityRequired(int quantityRequired) {
        this.quantityRequired = quantityRequired;
    }

}
