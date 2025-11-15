package com.kat.os.query.service;

import com.kat.os.commonDTO.DegreeDTO;
import com.kat.os.commonDTO.TechnologyDTO;
import com.kat.os.commonDTO.WorkOfferTDO;
import com.kat.os.mappers.DegreeMapper;
import com.kat.os.mappers.OfferMapper;
import com.kat.os.mappers.TechSkillMapper;
import com.kat.os.query.repository.DegreeRepository;
import com.kat.os.query.repository.TechSkillRepository;
import com.kat.os.query.repository.WorkOfferRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import java.util.List;
@Service
@Transactional
public class WorkOfferServiceImpl  implements WorkOfferService{

    @Autowired
    private WorkOfferRepository workOfferRepository;
    @Autowired
    private OfferMapper offerMapper;
    @Autowired
    private DegreeMapper degreeMapper;
    @Autowired
    private TechSkillMapper techSkillMapper;
    @Autowired
    private DegreeRepository degreeRepository;
    @Autowired
    private TechSkillRepository techSkillRepository;

    @Override
    public List<WorkOfferTDO> getAllWorkOffers()
    {
        return offerMapper.toTDO(workOfferRepository.findAll());
    }

    @Override
    public WorkOfferTDO getOneWorkOffer(String id) {
        return this.offerMapper.toTDO(this.workOfferRepository.getById(id));
    }


    @Override
    public WorkOfferTDO addOfferWork(WorkOfferTDO offerTDO) {
       return this.offerMapper.toTDO(
               this.workOfferRepository.save(this.offerMapper.toEntity(offerTDO)));
    }

    @Override
    public List<WorkOfferTDO> findByKeyWord(String keyWord) {
        return this.offerMapper.toTDO(this.workOfferRepository.findOfferKeyWord(keyWord));
    }

    @Override
    public void updateOneOfferWork(WorkOfferTDO workOffer) {
        this.workOfferRepository.save(this.offerMapper.toEntity(workOffer));
    }




}
