package pms.model;

public class ItemDTO {

    int itemID;
    String itemName;
    String itemType;
    int stockQuantity;

    public ItemDTO(int itemID, String itemName, String itemType, int stockQuantity) {
        this.itemID = itemID;
        this.itemName = itemName;
        this.itemType = itemType;
        this.stockQuantity = stockQuantity;
    }

    public ItemDTO() {
    }

    public int getItemID() {
        return itemID;
    }

    public String getItemName() {
        return itemName;
    }

    public String getItemType() {
        return itemType;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setItemID(int itemID) {
        this.itemID = itemID;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

}
