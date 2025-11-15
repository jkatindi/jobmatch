package com.kat.os.mappers;

import com.kat.os.commonDTO.InfoGeneralDTO;
import com.kat.os.query.entity.InfoGeneral;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface InfoGeneralMapper  extends  EntityMapper<InfoGeneralDTO,InfoGeneral>{
}
