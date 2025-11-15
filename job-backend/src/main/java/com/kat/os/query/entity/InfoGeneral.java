package com.kat.os.query.entity;

import  com.kat.os.query.entity.WorkOffer;
import org.hibernate.annotations.Type;


import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name="infoGeneral")
public class InfoGeneral implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private String localisation;
    @Column(columnDefinition = "TEXT",length = 65535)
    private String companyDescription;
    private String companyName;
    @OneToOne(mappedBy = "generalInfo")
    private WorkOffer workOffer;

    public InfoGeneral(String localisation,String companyDescription, String companyName) {
        this.localisation = localisation;
        this.companyDescription = companyDescription;
        this.companyName = companyName;
    }
    public InfoGeneral(){}

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getLocalisation() {
        return localisation;
    }

    public void setLocalisation(String localisation) {
        this.localisation = localisation;
    }

    public String getCompanyDescription() {
        return companyDescription;
    }

    public void setCompanyDescription(String companyDescription) {
        this.companyDescription = companyDescription;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }
}
