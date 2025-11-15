package com.kat.os.query.service;

import com.kat.os.commonDTO.DegreeDTO;

import java.util.List;

public interface DegreeService {
    DegreeDTO addOneDegree(String degree);
    List<DegreeDTO> getAllDegrees();
    DegreeDTO getOneDegree(Long id);
}
