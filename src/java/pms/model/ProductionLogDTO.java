package pms.model;

public class ProductionLogDTO {
    private int logId;
    private int workOrderId;
    private int stepId;
    private int quantityDone;
    private int quantityDefective;
    private int defectId;
    private String logDate;
    
    // Hai trường này dùng để hiển thị Tên lên bảng cho Sếp xem
    private String stepName;
    private String defectName;

    public ProductionLogDTO() {}

    public ProductionLogDTO(int logId, int workOrderId, int stepId, int quantityDone, int quantityDefective, int defectId, String logDate) {
        this.logId = logId;
        this.workOrderId = workOrderId;
        this.stepId = stepId;
        this.quantityDone = quantityDone;
        this.quantityDefective = quantityDefective;
        this.defectId = defectId;
        this.logDate = logDate;
    }

    // Getters và Setters (Phải có đầy đủ)
    public int getLogId() { return logId; }
    public void setLogId(int logId) { this.logId = logId; }
    public int getWorkOrderId() { return workOrderId; }
    public void setWorkOrderId(int workOrderId) { this.workOrderId = workOrderId; }
    public int getStepId() { return stepId; }
    public void setStepId(int stepId) { this.stepId = stepId; }
    public int getQuantityDone() { return quantityDone; }
    public void setQuantityDone(int quantityDone) { this.quantityDone = quantityDone; }
    public int getQuantityDefective() { return quantityDefective; }
    public void setQuantityDefective(int quantityDefective) { this.quantityDefective = quantityDefective; }
    public int getDefectId() { return defectId; }
    public void setDefectId(int defectId) { this.defectId = defectId; }
    public String getLogDate() { return logDate; }
    public void setLogDate(String logDate) { this.logDate = logDate; }
    public String getStepName() { return stepName; }
    public void setStepName(String stepName) { this.stepName = stepName; }
    public String getDefectName() { return defectName; }
    public void setDefectName(String defectName) { this.defectName = defectName; }
}