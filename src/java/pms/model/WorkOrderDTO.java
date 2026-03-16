/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pms.model;

/**
 *
 * @author HP
 */
public class WorkOrderDTO {
    private int wo_id;
    private int product_item_id;
    private int routing_id;
    private int order_quantity;
    private String status;

    public WorkOrderDTO() {
    }

    public WorkOrderDTO(int wo_id, int product_item_id, int routing_id, int order_quantity, String status) {
        this.wo_id = wo_id;
        this.product_item_id = product_item_id;
        this.routing_id = routing_id;
        this.order_quantity = order_quantity;
        this.status = status;
    }

    public int getWo_id() {
        return wo_id;
    }

    public void setWo_id(int wo_id) {
        this.wo_id = wo_id;
    }

    public int getProduct_item_id() {
        return product_item_id;
    }

    public void setProduct_item_id(int product_item_id) {
        this.product_item_id = product_item_id;
    }

    public int getRouting_id() {
        return routing_id;
    }

    public void setRouting_id(int routing_id) {
        this.routing_id = routing_id;
    }

    public int getOrder_quantity() {
        return order_quantity;
    }

    public void setOrder_quantity(int order_quantity) {
        this.order_quantity = order_quantity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
