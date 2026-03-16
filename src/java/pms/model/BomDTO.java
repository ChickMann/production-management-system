/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pms.model;

/**
 *
 * @author BAO
 */
public class BomDTO {
    int bomID, parentItemID, ChildItemID;
    float quantity;

    public BomDTO() {
    }

    public BomDTO(int bomID, int parentItemID, int ChildItemID, float quantity) {
        this.bomID = bomID;
        this.parentItemID = parentItemID;
        this.ChildItemID = ChildItemID;
        this.quantity = quantity;
    }

    public int getBomID() {
        return bomID;
    }

    public int getParentItemID() {
        return parentItemID;
    }

    public int getChildItemID() {
        return ChildItemID;
    }

    public float getQuantity() {
        return quantity;
    }

    public void setBomID(int bomID) {
        this.bomID = bomID;
    }

    public void setParentItemID(int parentItemID) {
        this.parentItemID = parentItemID;
    }

    public void setChildItemID(int ChildItemID) {
        this.ChildItemID = ChildItemID;
    }

    public void setQuantity(float quantity) {
        this.quantity = quantity;
    }
    
    
}
