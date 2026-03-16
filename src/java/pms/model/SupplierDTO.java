package pms.model;

public class SupplierDTO {

    private int supplierId;
    private String supplierName;
    private String contactPhone;

    public SupplierDTO() {
    }

    public SupplierDTO(int supplierId, String supplierName, String contactPhone) {
        this.supplierId = supplierId;
        this.supplierName = supplierName;
        this.contactPhone = contactPhone;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

}
