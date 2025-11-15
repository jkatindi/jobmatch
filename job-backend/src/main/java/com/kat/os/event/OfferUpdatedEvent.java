package com.kat.os.event;

import com.kat.os.commonDTO.*;

import java.util.List;

public class OfferUpdatedEvent extends BaseEvent<String>{
    private String title;
    private InfoGeneralDTO generalInfo;
    private String  positionHeld;
    private String  generalProfile;
    private List<TechnologyDTO> requiredTechs;
    private List<DegreeDTO>  requiredDegrees;
    private int experMin;
    private int availablePlace;

    public OfferUpdatedEvent(String id, String title, InfoGeneralDTO generalInfo, String positionHeld, String generalProfile, List<TechnologyDTO> requiredTechs, List<DegreeDTO> requiredDegrees, int experMin, int availablePlace) {
        super(id);
        this.title = title;
        this.generalInfo = generalInfo;
        this.positionHeld = positionHeld;
        this.generalProfile = generalProfile;
        this.requiredTechs = requiredTechs;
        this.requiredDegrees = requiredDegrees;
        this.experMin = experMin;
        this.availablePlace = availablePlace;
    }

    public String getTitle() {
        return title;
    }

    public InfoGeneralDTO getGeneralInfo() {
        return generalInfo;
    }

    public String getPositionHeld() {
        return positionHeld;
    }

    public String getGeneralProfile() {
        return generalProfile;
    }

    public List<TechnologyDTO> getRequiredTechs() {
        return requiredTechs;
    }

    public List<DegreeDTO> getRequiredDegrees() {
        return requiredDegrees;
    }

    public int getExperMin() {
        return experMin;
    }

    public int getAvailablePlace() {
        return availablePlace;
    }
}
