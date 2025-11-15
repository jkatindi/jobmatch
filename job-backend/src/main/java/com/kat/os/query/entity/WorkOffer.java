package com.kat.os.query.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.kat.os.commonDTO.InfoGeneralDTO;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table
public class WorkOffer implements Serializable {
    @Id
    private String id;
    private String title;
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name="fk_Info")
    private InfoGeneral generalInfo;
    @Column(columnDefinition = "LONGTEXT",length = 75535)
    private String  positionHeld;
    @Column(columnDefinition = "TEXT",length = 65535)
    private String  generalProfile;

    @JsonManagedReference
    @ManyToMany(targetEntity =TechSkill.class)
    private List<TechSkill> requiredTechs=new ArrayList<>();

    @JsonManagedReference
    @ManyToMany(targetEntity =Degree.class)
    private List<Degree> requiredDegrees=new ArrayList<>();
    private int  experMin;
    private int availablePlace;

    public WorkOffer(String title, InfoGeneral generalInfo, String positionHeld, String generalProfile, List<TechSkill> requiredTechs, List<Degree> requiredDegrees, int experMin, int availablePlace) {
        this.title = title;
        this.generalInfo = generalInfo;
        this.positionHeld = positionHeld;
        this.generalProfile = generalProfile;
        this.requiredTechs = requiredTechs;

        this.requiredDegrees = requiredDegrees;
        this.experMin = experMin;
        this.availablePlace = availablePlace;
    }

    public WorkOffer(){}

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

    public InfoGeneral getGeneralInfo() {
        return generalInfo;
    }

    public void setGeneralInfo(InfoGeneral generalInfo) {
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

    public List<TechSkill> getRequiredTechs() {
        return requiredTechs;
    }

    public void setRequiredTechs(List<TechSkill> requiredTechs) {
        this.requiredTechs = requiredTechs;
    }

    public List<Degree> getRequiredDegrees() {
        return requiredDegrees;
    }

    public void setRequiredDegrees(List<Degree> requiredDegrees) {
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
