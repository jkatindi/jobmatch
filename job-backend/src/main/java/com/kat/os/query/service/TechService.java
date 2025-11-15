package com.kat.os.query.service;

import com.kat.os.commonDTO.TechnologyDTO;

import java.util.List;

public interface TechService {
    TechnologyDTO addOneTechnology(String tech);
    List<TechnologyDTO> getTechnologies();
    TechnologyDTO getOneTechnology(Long id);
}
