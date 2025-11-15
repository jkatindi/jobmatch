package com.kat.os.query.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;


@Entity
@Table
public class TechSkill implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String technology;

    @JsonBackReference
    @ManyToMany(targetEntity =WorkOffer.class ,mappedBy = "requiredTechs",
            cascade =CascadeType.ALL )
    private List<WorkOffer> workOffers=new ArrayList<>();

    public TechSkill(String technology) {
        this.technology = technology;
    }

    public TechSkill() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTechnology() {
        return technology;
    }

    public void setTechnology(String technology) {
        this.technology = technology;
    }

    public List<WorkOffer> getWorkOffers() {
        return workOffers;
    }

    public void setWorkOffers(List<WorkOffer> workOffers) {
        this.workOffers = workOffers;
    }
}
