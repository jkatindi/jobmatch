package com.kat.os.commonDTO;

import java.io.Serializable;

public class TechnologyDTO implements Serializable {
    private Long id;
    private String technology;

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
}
