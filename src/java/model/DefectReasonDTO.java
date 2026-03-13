/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author se193234_TranGiaBao
 */
public class DefectReasonDTO {
    private int defectId;
    private String reasonName;

    public DefectReasonDTO() {
    }

    public DefectReasonDTO(int defectId, String reasonName) {
        this.defectId = defectId;
        this.reasonName = reasonName;
    }

    public int getDefectId() {
        return defectId;
    }

    public void setDefectId(int defectId) {
        this.defectId = defectId;
    }

    public String getReasonName() {
        return reasonName;
    }

    public void setReasonName(String reasonName) {
        this.reasonName = reasonName;
    }
    
    
}
