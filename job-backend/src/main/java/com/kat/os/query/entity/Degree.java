package com.kat.os.query.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;


@Entity
@Table
public class Degree implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String degreeName;
    @JsonBackReference
    @ManyToMany(targetEntity = WorkOffer.class,
            mappedBy = "requiredDegrees",cascade = CascadeType.ALL)
    private List<WorkOffer> workOffers=new ArrayList<>();

    public Degree(String degreeName) {
        this.degreeName = degreeName;
    }

    public Degree() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getDegreeName() {
        return degreeName;
    }

    public void setDegreeName(String degreeName) {
        this.degreeName = degreeName;
    }

    public List<WorkOffer> getWorkOffers() {
        return workOffers;
    }

    public void setWorkOffers(List<WorkOffer> workOffers) {
        this.workOffers = workOffers;
    }
}
