/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pms.model;

/**
 *
 * @author se193234_TranGiaBao
 */
public class RoutingDTO {
    private int routingId;
    private String routingName;

    public RoutingDTO() {
    }

    public RoutingDTO(int routingId, String routingName) {
        this.routingId = routingId;
        this.routingName = routingName;
    }

    public int getRoutingId() {
        return routingId;
    }

    public void setRoutingId(int routingId) {
        this.routingId = routingId;
    }

    public String getRoutingName() {
        return routingName;
    }

    public void setRoutingName(String routingName) {
        this.routingName = routingName;
    }
    
    
}
