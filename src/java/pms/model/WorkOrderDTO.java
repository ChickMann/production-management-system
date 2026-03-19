package pms.model;

public class WorkOrderDTO {
    private int workOrderID;
    private int customerID;
    private int productItemID;
    private int routingID;
    private int quantity;
    private String status;
    private String orderDate;

    public WorkOrderDTO() {
    }

    // Constructor đầy đủ tham số để Controller gọi được
    public WorkOrderDTO(int workOrderID, int customerID, int productItemID, int routingID, int quantity, String status, String orderDate) {
        this.workOrderID = workOrderID;
        this.customerID = customerID;
        this.productItemID = productItemID;
        this.routingID = routingID;
        this.quantity = quantity;
        this.status = status;
        this.orderDate = orderDate;
    }

    // Getters and Setters
    public int getWorkOrderID() { return workOrderID; }
    public void setWorkOrderID(int workOrderID) { this.workOrderID = workOrderID; }
    public int getCustomerID() { return customerID; }
    public void setCustomerID(int customerID) { this.customerID = customerID; }
    public int getProductItemID() { return productItemID; }
    public void setProductItemID(int productItemID) { this.productItemID = productItemID; }
    public int getRoutingID() { return routingID; }
    public void setRoutingID(int routingID) { this.routingID = routingID; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getOrderDate() { return orderDate; }
    public void setOrderDate(String orderDate) { this.orderDate = orderDate; }
}