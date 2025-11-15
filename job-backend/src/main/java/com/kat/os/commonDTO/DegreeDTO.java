package com.kat.os.commonDTO;

import java.io.Serializable;

public class DegreeDTO implements Serializable {
    private Long id;
    private String degreeName;

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
}
