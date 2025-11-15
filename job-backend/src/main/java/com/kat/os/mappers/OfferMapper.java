package com.kat.os.mappers;

import com.kat.os.commonDTO.WorkOfferTDO;
import com.kat.os.query.entity.WorkOffer;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;

import jakarta.transaction.Transactional;
import java.util.List;

@Mapper(componentModel = "spring",uses = {DegreeMapper.class,
        TechSkillMapper.class,InfoGeneralMapper.class})
public interface OfferMapper extends EntityMapper<WorkOfferTDO,WorkOffer> {

}
