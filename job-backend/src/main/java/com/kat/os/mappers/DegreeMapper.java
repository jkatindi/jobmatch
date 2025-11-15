package com.kat.os.mappers;

import com.kat.os.commonDTO.DegreeDTO;
import com.kat.os.query.entity.Degree;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface  DegreeMapper  extends EntityMapper<DegreeDTO, Degree> {

}
