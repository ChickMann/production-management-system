package pms.model;

public class ItemDTO {

    int itemID;
    String itemName;
    String itemType;
    int stockQuantity;
    String imageBase64;

    public ItemDTO(int itemID, String itemName, String itemType, int stockQuantity) {
        this.itemID = itemID;
        this.itemName = itemName;
        this.itemType = itemType;
        this.stockQuantity = stockQuantity;
    }

    public ItemDTO(int itemID, String itemName, String itemType, int stockQuantity, String imageBase64) {
        this.itemID = itemID;
        this.itemName = itemName;
        this.itemType = itemType;
        this.stockQuantity = stockQuantity;
        this.imageBase64 = imageBase64;
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

    public String getImageBase64() {
        return imageBase64;
    }

    public void setImageBase64(String imageBase64) {
        this.imageBase64 = imageBase64;
    }

}
