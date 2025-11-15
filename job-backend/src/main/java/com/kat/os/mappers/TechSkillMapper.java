package com.kat.os.mappers;

import com.kat.os.commonDTO.TechnologyDTO;
import com.kat.os.query.entity.TechSkill;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface TechSkillMapper  extends EntityMapper<TechnologyDTO, TechSkill>{


}
