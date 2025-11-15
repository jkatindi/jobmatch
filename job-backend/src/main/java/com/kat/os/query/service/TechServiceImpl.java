package com.kat.os.query.service;

import com.kat.os.commonDTO.TechnologyDTO;
import com.kat.os.mappers.TechSkillMapper;
import com.kat.os.query.entity.Degree;
import com.kat.os.query.entity.TechSkill;
import com.kat.os.query.repository.TechSkillRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class TechServiceImpl implements TechService{
    private final TechSkillMapper techSkillMapper;
    private  final TechSkillRepository techRepository;
    TechnologyDTO  degreeDTO;
    public TechServiceImpl(TechSkillMapper techSkillMapper, TechSkillRepository techRepository) {
        this.techSkillMapper = techSkillMapper;
        this.techRepository = techRepository;
    }

    @Override
    public TechnologyDTO addOneTechnology(String skill) {
        TechnologyDTO tech=new TechnologyDTO();
        tech.setTechnology(skill);
        Optional<List<TechSkill>> optional=Optional.of(this.techRepository.findAll());
        if(optional.isPresent()){
            List<String> techs=optional.get().stream().
                    map(techno->techno.getTechnology()).
                    collect(Collectors.toList());
            if(!techs.contains(tech.getTechnology()))
                degreeDTO=  this.techSkillMapper.
                        toTDO(this.techRepository.save(this.techSkillMapper.toEntity(tech)));
        }
        else{
            degreeDTO=  this.techSkillMapper.
                    toTDO(this.techRepository.save(this.techSkillMapper.toEntity(tech)));
        }
        return  degreeDTO;
    }

    @Override
    public List<TechnologyDTO> getTechnologies() {
        return this.techSkillMapper.toTDO(this.techRepository.findAll());
    }

    @Override
    public TechnologyDTO getOneTechnology(Long id) {
        return null;
    }
}
