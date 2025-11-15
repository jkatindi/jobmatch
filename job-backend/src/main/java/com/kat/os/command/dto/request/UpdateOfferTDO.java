package com.kat.os.command.dto.request;

import com.kat.os.commonDTO.DegreeDTO;
import com.kat.os.commonDTO.InfoGeneralDTO;
import com.kat.os.commonDTO.TechnologyDTO;

import java.util.List;

public class UpdateOfferTDO {
    private String id;
    private String title;

    public String getId() {
        return id;
    }

    private InfoGeneralDTO generalInfo;
    private String  positionHeld;
    private String  generalProfile;
    private List<TechnologyDTO> requiredTechs;
    private List<DegreeDTO>  requiredDegrees;
    private int experMin;
    private int availablePlace;

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
