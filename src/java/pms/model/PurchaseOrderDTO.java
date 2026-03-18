package pms.model;

import java.util.Date;

public class PurchaseOrderDTO {

    private int poId;
    private int itemId;
    private int supplierId;
    private int requiredQuantity;
    private Date alertDate;
    private String status;

    public PurchaseOrderDTO() {
    }

    public PurchaseOrderDTO(int poId, int itemId, int supplierId, int requiredQuantity, Date alertDate, String status) {
        this.poId = poId;
        this.itemId = itemId;
        this.supplierId = supplierId;
        this.requiredQuantity = requiredQuantity;
        this.alertDate = alertDate;
        this.status = status;
    }

    public int getPoId() {
        return poId;
    }

    public void setPoId(int poId) {
        this.poId = poId;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public int getRequiredQuantity() {
        return requiredQuantity;
    }

    public void setRequiredQuantity(int requiredQuantity) {
        this.requiredQuantity = requiredQuantity;
    }

    public Date getAlertDate() {
        return alertDate;
    }

    public void setAlertDate(Date alertDate) {
        this.alertDate = alertDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
