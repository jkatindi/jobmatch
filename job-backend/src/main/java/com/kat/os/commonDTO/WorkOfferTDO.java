package com.kat.os.commonDTO;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class WorkOfferTDO implements Serializable {
    private String id;
    private String title;
    private InfoGeneralDTO generalInfo;
    private String  positionHeld;
    private String  generalProfile;
    private List<TechnologyDTO> requiredTechs;
    private List<DegreeDTO>  requiredDegrees;
    private int experMin;
    private int availablePlace;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public InfoGeneralDTO getGeneralInfo() {
        return generalInfo;
    }

    public void setGeneralInfo(InfoGeneralDTO generalInfo) {
        this.generalInfo = generalInfo;
    }

    public String getPositionHeld() {
        return positionHeld;
    }

    public void setPositionHeld(String positionHeld) {
        this.positionHeld = positionHeld;
    }

    public String getGeneralProfile() {
        return generalProfile;
    }

    public void setGeneralProfile(String generalProfile) {
        this.generalProfile = generalProfile;
    }

    public List<TechnologyDTO> getRequiredTechs() {
        return requiredTechs;
    }

    public void setRequiredTechs(List<TechnologyDTO> requiredTechs) {
        this.requiredTechs = requiredTechs;
    }

    public List<DegreeDTO> getRequiredDegrees() {
        return requiredDegrees;
    }

    public void setRequiredDegrees(List<DegreeDTO> requiredDegrees) {
        this.requiredDegrees = requiredDegrees;
    }

    public int getExperMin() {
        return experMin;
    }

    public void setExperMin(int experMin) {
        this.experMin = experMin;
    }

    public int getAvailablePlace() {
        return availablePlace;
    }

    public void setAvailablePlace(int availablePlace) {
        this.availablePlace = availablePlace;
    }
}
