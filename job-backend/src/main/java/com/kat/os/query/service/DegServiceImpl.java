package com.kat.os.query.service;

import com.kat.os.commonDTO.DegreeDTO;
import com.kat.os.mappers.DegreeMapper;
import com.kat.os.query.entity.Degree;
import com.kat.os.query.repository.DegreeRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class DegServiceImpl implements DegreeService{
    private final DegreeRepository degreeRepository;
    private final DegreeMapper degreeMapper;
    private DegreeDTO  degreeDTO;
    public DegServiceImpl(DegreeRepository degreeRepository, DegreeMapper degreeMapper) {
        this.degreeRepository = degreeRepository;
        this.degreeMapper = degreeMapper;
    }

    @Override
    public DegreeDTO addOneDegree(String dg) {
        DegreeDTO degree=new DegreeDTO();
        degree.setDegreeName(dg);
        Optional<List<Degree>> optional=Optional.of(this.degreeRepository.findAll());
        if(optional.isPresent()){
           List<String> degrees=optional.get().stream().
                   map(deg->deg.getDegreeName()).
                   collect(Collectors.toList());
           if(!degrees.contains(degree.getDegreeName()))
               degreeDTO=  this.degreeMapper.
                       toTDO(this.degreeRepository.save(this.degreeMapper.toEntity(degree)));
        }
        else{
            degreeDTO=  this.degreeMapper.
                    toTDO(this.degreeRepository.save(this.degreeMapper.toEntity(degree)));
        }
        return  degreeDTO;
    }

    @Override
    public List<DegreeDTO> getAllDegrees() {
        return this.degreeMapper.toTDO(this.degreeRepository.findAll());
    }

    @Override
    public DegreeDTO getOneDegree(Long id) {
        return null;
    }
}
