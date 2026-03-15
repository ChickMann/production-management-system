/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pms.model;

/**
 *
 * @author BAO
 */
public class ItemDTO {
    int itemID;
    String itemCode;
    String name;
    String type;
    double standardCost;
    int stockQuantity;

    public ItemDTO(int itemID, String itemCode, String name, String type, double standardCost) {
        this.itemID = itemID;
        this.itemCode = itemCode;
        this.name = name;
        this.type = type;
        this.standardCost = standardCost;
        this.stockQuantity = 0;
    }

    public ItemDTO(int itemID, String itemCode, String name, String type, double standardCost, int stockQuantity) {
        this.itemID = itemID;
        this.itemCode = itemCode;
        this.name = name;
        this.type = type;
        this.standardCost = standardCost;
        this.stockQuantity = stockQuantity;
    }

    public ItemDTO() {
    }

    public int getItemID() {
        return itemID;
    }

    public String getItemCode() {
        return itemCode;
    }

    public String getName() {
        return name;
    }

    public String getType() {
        return type;
    }

    public double getStandardCost() {
        return standardCost;
    }

    public void setItemID(int itemID) {
        this.itemID = itemID;
    }

    public void setItemCode(String itemCode) {
        this.itemCode = itemCode;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setStandardCost(double standardCost) {
        this.standardCost = standardCost;
    }
    
    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }
    
        
}
