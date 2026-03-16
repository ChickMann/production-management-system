/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pms.model;

import java.sql.Date;

/**
 *
 * @author HP
 */
public class ProductionLogDTO {
     private int logId;
    private int woId;
    private int stepId;
    private int workerUserId;
    private int producedQuantity;
    private Integer defectId; 
    private Date logDate;

    public ProductionLogDTO() {
    }

    public ProductionLogDTO(int logId, int woId, int stepId, int workerUserId, int producedQuantity, Integer defectId, Date logDate) {
        this.logId = logId;
        this.woId = woId;
        this.stepId = stepId;
        this.workerUserId = workerUserId;
        this.producedQuantity = producedQuantity;
        this.defectId = defectId;
        this.logDate = logDate;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getWoId() {
        return woId;
    }

    public void setWoId(int woId) {
        this.woId = woId;
    }

    public int getStepId() {
        return stepId;
    }

    public void setStepId(int stepId) {
        this.stepId = stepId;
    }

    public int getWorkerUserId() {
        return workerUserId;
    }

    public void setWorkerUserId(int workerUserId) {
        this.workerUserId = workerUserId;
    }

    public int getProducedQuantity() {
        return producedQuantity;
    }

    public void setProducedQuantity(int producedQuantity) {
        this.producedQuantity = producedQuantity;
    }

    public Integer getDefectId() {
        return defectId;
    }

    public void setDefectId(Integer defectId) {
        this.defectId = defectId;
    }

    public Date getLogDate() {
        return logDate;
    }

    public void setLogDate(Date logDate) {
        this.logDate = logDate;
    }
}
