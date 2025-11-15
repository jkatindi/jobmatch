package com.kat.os.query.service;

import com.kat.os.commonDTO.DegreeDTO;
import com.kat.os.commonDTO.TechnologyDTO;
import com.kat.os.commonDTO.WorkOfferTDO;

import java.util.List;

public interface WorkOfferService {
    List<WorkOfferTDO> getAllWorkOffers();
    WorkOfferTDO getOneWorkOffer(String id);
    WorkOfferTDO addOfferWork(WorkOfferTDO offerTDO);
    List<WorkOfferTDO> findByKeyWord(String  keyWord);
    void updateOneOfferWork(WorkOfferTDO workOffer);

}

